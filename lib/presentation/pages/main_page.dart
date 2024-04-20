import 'package:asan_yab/domain/riverpod/config/check_internet_connectivity.dart';
import 'package:asan_yab/domain/riverpod/config/notification_repo.dart';
import 'package:asan_yab/domain/riverpod/screen/botton_navigation_provider.dart';
import 'package:asan_yab/presentation/pages/message_page/message_page.dart';
import 'package:asan_yab/presentation/pages/profile/profile_page.dart';
import 'package:asan_yab/presentation/widgets/message/check_user_message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/firebase_collection_names.dart';

import '../widgets/bottom_navigation_bar_widget.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'suggestion_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with WidgetsBindingObserver {
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus(true);
    ref
        .read(checkInternetConnectivityProvider.notifier)
        .startStreaming(context);
    firebaseAuth;
  }

  void setStatus(bool status) async {
    if (firebaseAuth != null) {
      final token = await FirebaseMessaging.instance.getToken();
      await firestore
          .collection(FirebaseCollectionNames.user)
          .doc(firebaseAuth!.uid)
          .update({
        'isOnline': status,
        'fcmToken': token,
      });
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
    final selectedIndex = ref.watch(stateButtonNavigationBarProvider);
    NotificationRepo().initInfo();
    NotificationRepo().getToken();
    NotificationRepo().initialize(context);
    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBarWidget(ref: ref, context: context),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePage(
              isConnected: ref
                  .watch(checkInternetConnectivityProvider.notifier)
                  .isConnected),
          const SuggestionPage(),
          FirebaseAuth.instance.currentUser == null
              ? const CheckUserMessageWidget()
              : const MessagePage(),
          FirebaseAuth.instance.currentUser == null
              ? const AuthPage()
              : const ProfilePage()
        ],
      ),
    );
  }
}
