import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/favorite_provider.dart';
import '../utils/kcolors.dart';
import '../widgets/new_places.dart';
import '../widgets/categories.dart';
import '../widgets/favorites.dart';

import '../widgets/custom_search_bar.dart';
import 'category_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        title: const CustomSearchBar(),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 16.0),
          const NewPlaces(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'دسته بندی ها',
                  style: TextStyle(color: kSecodaryColor, fontSize: 20.0),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoryPage()),
                  ),
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    size: 32.0,
                    color: kSecodaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Categories(),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 12.0),
            child: Text(
              'موارد دلخواه',
              style: TextStyle(color: kSecodaryColor, fontSize: 20.0),
            ),
          ),
          const Favorites(),
        ],
      ),
    );
  }
}
