// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, sized_box_for_whitespace

import 'package:easy_finder/pages/category_page.dart';
import 'package:easy_finder/pages/favorite_page.dart';
import 'package:easy_finder/pages/search_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../model/category.dart';
import '../model/favorite.dart';
import '../widgets/new_places.dart';
import '../widgets/categories.dart';
import '../widgets/favorites.dart';
import '../widgets/search_bar.dart';
import '../widgets/custom_search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('آسان یاب', style: TextStyle(color: Colors.grey)),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          CustomSearchBar(),
          SizedBox(height: 16.0),
          NewPlaces(),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'دسته بندی ها',
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage()),
                  ),
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    size: 32.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Categories(),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 12.0),
            child: Text(
              'موارد دلخواه',
              style: TextStyle(color: Colors.grey, fontSize: 20.0),
            ),
          ),
          Favorites(),
        ],
      ),
    );
  }
}
