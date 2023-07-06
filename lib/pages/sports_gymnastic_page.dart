// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../widgets/reuseable_popular_widget.dart';
import '../widgets/search_widget.dart';

class SportsGymnasticPage extends StatelessWidget {
  const SportsGymnasticPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sports Gymnastic',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const searchWidget(
            Search: 'Search Your Sports Gymnastic',
          ),
          ReuseablePopularWidget(
              screenHeight: screenHeight, screenWidth: screenWidth)
        ],
      ),
    );
  }
}
