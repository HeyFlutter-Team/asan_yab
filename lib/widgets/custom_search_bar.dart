// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';

import '../pages/search_bar_page.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      ),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.4),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            Text('جستجوی در آسان یاب', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
