import 'dart:io';
import '../pages/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'about_us_page.dart';
import 'home_page.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final pages = [const HomePage(), const SuggestionPage(), const AboutUsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 20.0,
          unselectedFontSize: 16.0,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.red,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => selectedIndex = index),
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
              label: 'در باره ما',
              icon: Icon(Icons.person),
            ),
          ],
        ),
      body: UpgradeAlert(
        upgrader: Upgrader(
          shouldPopScope: () => true,
          canDismissDialog: false,
          durationUntilAlertAgain: const Duration(days: 1),
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
        ),
        child: pages[selectedIndex],
      ),
    );
  }
}
