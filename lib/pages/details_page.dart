// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../widgets/popular_widget.dart';

import '../widgets/search_style_widget.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'محصول  ',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SearchStyle(),
          PopularWidget(screenHeight: screenHeight, screenWidth: screenWidth)
        ],
      ),
    );
  }
}
