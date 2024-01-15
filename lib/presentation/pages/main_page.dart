import 'package:asan_yab/domain/riverpod/config/notification_repo.dart';
import 'package:asan_yab/presentation/pages/message_page/message_home.dart';
import 'package:asan_yab/presentation/pages/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/config/internet_connectivity_checker.dart';
import '../../domain/riverpod/screen/botton_navigation_provider.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'suggestion.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();
    ref
        .read(internetConnectivityCheckerProvider.notifier)
        .startStremaing(context);
    FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
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
              ? const AuthPage()
              : const MessageHome(),
          FirebaseAuth.instance.currentUser == null
              ? const AuthPage()
              : const ProfilePage(),
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
        ],
      );
}
