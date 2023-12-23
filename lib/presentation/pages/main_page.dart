import 'package:asan_yab/domain/riverpod/config/notification_repo.dart';
import 'package:asan_yab/presentation/pages/profile_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/riverpod/config/internet_connectivity_checker.dart';
import '../../domain/riverpod/screen/botton_navigation_provider.dart';
import 'home_page.dart';
import 'suggestion.dart';

// String? notifTitle, notifBody;

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      ref
          .read(internetConnectivityCheckerProvider.notifier)
          .startStremaing(context);
    }
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
    if (FirebaseAuth.instance.currentUser != null) {
      ref
          .read(internetConnectivityCheckerProvider.notifier)
          .subscription
          .cancel();
    }
  }

  final pages = [const HomePage(), const SuggestionPage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(buttonNavigationProvider);
    FirebaseApi().initInfo();
    FirebaseApi().getToken();
    FirebaseApi().initialize(context);
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
        items: [
          BottomNavigationBarItem(
            label: 'ButtonNvB_1'.tr(),
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'ButtonNvB_2'.tr(),
            icon: const Icon(Icons.place),
          ),
          BottomNavigationBarItem(
            label: 'ButtonNvB_3'.tr(),
            icon: const Icon(Icons.person),
          ),
        ],
      );
}
