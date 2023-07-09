// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:easy_finder/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/favorite_item.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          const CustomSearchBar(),
          FavoriteItem(),
        ],
      ),
    );
  }
}
