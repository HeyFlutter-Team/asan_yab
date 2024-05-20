import 'package:asan_yab/domain/riverpod/config/notification_repo.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/presentation/pages/management.dart';
import 'package:asan_yab/presentation/pages/message_page/message_home.dart';
import 'package:asan_yab/presentation/pages/profile/profile_page.dart';
import 'package:asan_yab/presentation/widgets/message/message_check_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/config/internet_connectivity_checker.dart';
import '../../domain/riverpod/data/comments/comment_provider.dart';
import '../../domain/riverpod/data/comments/management_provider.dart';
import '../../domain/riverpod/screen/botton_navigation_provider.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'suggestion.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with WidgetsBindingObserver {
  bool isBusiness = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final users =
          await ref.watch(commentProvider).getUserInfo(currentUser.uid);
      isBusiness = (users.userType == 'Business');
    });

    WidgetsBinding.instance.addObserver(this);
    setStatus(true);
    ref
        .read(internetConnectivityCheckerProvider.notifier)
        .startStremaing(context);
    FirebaseAuth.instance.currentUser;
  }

  void setStatus(bool status) async {
    if (FirebaseAuth.instance.currentUser != null) {
      final token = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'isOnline': status, 'fcmToken': token});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus(true);
    } else {
      setStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailsProvider);
    final selectedIndex = ref.watch(buttonNavigationProvider);

    FirebaseApi().initInfo();
    FirebaseApi().getToken();
    FirebaseApi().initialize(context);
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePage(
              isConnected: ref
                  .watch(internetConnectivityCheckerProvider.notifier)
                  .isConnected),
          const SuggestionPage(),
          FirebaseAuth.instance.currentUser == null
              ? const MessageCheckUser()
              : const MessageHome(),
          FirebaseAuth.instance.currentUser == null
              ? const AuthPage()
              : const ProfilePage(),
          if (isBusiness) const Management()
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() => BottomNavigationBar(
        selectedFontSize: 18.0,
        unselectedFontSize: 14.0,
        currentIndex: ref.watch(buttonNavigationProvider),
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 4) {
            ref.read(managementProvider.notifier).getInfo();
          }
          FocusScope.of(context).unfocus();
          ref.read(buttonNavigationProvider.notifier).selectedIndex(index);
        },
        // backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.buttonNvB_1,
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.buttonNvB_2,
            icon: const Icon(Icons.place),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.buttonNvB_3,
            icon: const Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.buttonNvB_4,
            icon: const Icon(Icons.person),
          ),
          if (isBusiness)
            BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.buttonNvB_5,
              icon: const Icon(Icons.notifications),
            ),
        ],
      );
}
