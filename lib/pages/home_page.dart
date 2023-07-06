// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, sized_box_for_whitespace

import 'package:easy_finder/pages/categorie_page.dart';
import 'package:easy_finder/pages/favorite_page.dart';
import 'package:easy_finder/pages/search_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../model/categories.dart';
import '../model/popular.dart';
import '../widgets/carousel_widget.dart';
import '../widgets/categories_list.dart';
import '../widgets/popular_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/search_style_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'easy finder',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SearchStyle(),
          SizedBox(height: 15.0),
          CarouselWidget(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoriePage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    size: 30.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          CategoriesList(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10.0),
            child: Text(
              'Popular Deals',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20.0,
              ),
            ),
          ),
          PopularList(),
        ],
      ),
    );
  }
}
