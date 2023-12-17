import 'package:asan_yab/data/repositoris/local_rep/notification.dart';
import 'package:asan_yab/presentation/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/config/internet_connectivity_checker.dart';

import '../../domain/riverpod/screen/botton_navigation_provider.dart';
import 'suggestion.dart';
import 'package:flutter/material.dart';

import 'about_us_page.dart';
import 'home_page.dart';

// String? notifTitle, notifBody;

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
//   @override
//   void initState() {
//     super.initState();
// if(FirebaseAuth.instance.currentUser != null){
//   ref
//       .read(internetConnectivityCheckerProvider.notifier)
//       .startStremaing(context);
// }
//
//   }

  final pages = [const HomePage(), const SuggestionPage(), const ProfilePage()];
  // @override
  // void dispose() {
  //   if(FirebaseAuth.instance.currentUser != null){
  //   ref
  //       .read(internetConnectivityCheckerProvider.notifier)
  //       .subscription
  //       .cancel();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(buttonNavigationProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: buildBottomNavigationBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePage(
              isConnected: ref
                  .watch(internetConnectivityCheckerProvider.notifier)
                  .isConnected),
          const SuggestionPage(),
          const ProfilePage()
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() => BottomNavigationBar(
        selectedFontSize: 20.0,
        unselectedFontSize: 16.0,
        currentIndex: ref.watch(buttonNavigationProvider),
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          FocusScope.of(context).unfocus();
          ref.read(buttonNavigationProvider.notifier).selectedIndex(index);
        },
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            label: 'خانه',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: ' مکان جدید',
            icon: Icon(Icons.place),
          ),
          BottomNavigationBarItem(
            label: 'پروفایل',
            icon: Icon(Icons.person),
          ),
        ],
      );
}
