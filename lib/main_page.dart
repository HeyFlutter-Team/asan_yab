// ignore_for_file: unused_import, prefer_const_constructors, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:easy_finder/pages/favorite_page.dart';
import 'package:easy_finder/pages/home_page.dart';
import 'package:easy_finder/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;
  Widget getIndex(int index) {
    switch (index) {
      case 0:
        return ProfilePage();
      case 1:
        return HomePage();
      case 2:
        return FavoritePage();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.green,
        buttonBackgroundColor: Colors.green,
        backgroundColor: Colors.transparent,
        height: 65.0,
        index: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          Icon(
            Icons.person,
            color: Colors.white,
          ),
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite,
            color: Colors.white,
          ),
        ],
      ),
      body: getIndex(_selectedIndex),
    );
  }
}
