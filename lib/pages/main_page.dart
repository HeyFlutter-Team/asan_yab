// ignore_for_file: unused_import, prefer_const_constructors, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables

import 'package:easy_finder/pages/favorite_page.dart';
import 'package:easy_finder/pages/home_page.dart';
import 'package:easy_finder/pages/about_us_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final pages = const [HomePage(), AboutUsPage(), FavoritePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20.0,
        unselectedFontSize: 16.0,
        currentIndex: selectedIndex,
        fixedColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => selectedIndex = index),
        backgroundColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            label: 'خانه',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'در باره ما',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'موارد دلخواه',
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
