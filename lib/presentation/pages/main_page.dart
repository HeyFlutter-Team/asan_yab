import 'package:asan_yab/domain/riverpod/config/notification_repo.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_stream.dart';
import 'package:asan_yab/presentation/pages/message_page/message_home.dart';
import 'package:asan_yab/presentation/pages/profile/profile_page.dart';
import 'package:asan_yab/presentation/widgets/message/message_check_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/utils.dart';
import '../../domain/riverpod/config/internet_connectivity_checker.dart';
import '../../domain/riverpod/data/message/message.dart';
import '../../domain/riverpod/data/message/message_stream_riv.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus(true);
    print('younis main page init called');
    ref
        .read(internetConnectivityCheckerProvider.notifier)
        .startStremaing(context);
    FirebaseAuth.instance.currentUser;
  }

  void setStatus(bool status) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(currentUser.uid)
              .update({'isOnline': status, 'fcmToken': token});
        } else {
          print('FCM token is null');
        }
      } catch (e) {
        print('Firestore update error: $e');
      }
    } else {
      print('User is not authenticated');
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(buttonNavigationProvider);
    print(selectedIndex);
    FirebaseApi().initInfo(ref);
    FirebaseApi().getToken();
    FirebaseApi().initialize(context,ref);
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePage(
              isConnected: Utils.netIsConnected(ref)),
          const SuggestionPage(),
          FirebaseAuth.instance.currentUser == null
              ? const MessageCheckUser()
              : const MessageHome(),
          FirebaseAuth.instance.currentUser == null
              ? const AuthPage()
              : const ProfilePage()
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
        onTap: (index) async{
          FocusScope.of(context).unfocus();
          ref.read(buttonNavigationProvider.notifier).selectedIndex(index);
          if(index==3){
            await ref.read(isDisposedProvider.notifier).disposeStream();
            print('younis stream disposed');
          }else{
            ref.read(activeChatIdProvider.notifier).state='';
            Suspend(ref).suspendUser(context);
            print('younis stream start again');
          }
        },
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
            icon: Stack(
              children: [
                const Icon(Icons.message),
                if(ref.watch(isUnreadMessageProvider))
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          color: Colors
                              .blue.shade600,
                          borderRadius:
                          const BorderRadius
                              .all(
                              Radius.circular(
                                  32))),
                  ),
                )
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.buttonNvB_4,
            icon: const Icon(Icons.person),
          ),
        ],
      );
}
