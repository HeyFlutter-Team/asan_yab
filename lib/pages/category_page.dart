// ignore_for_file: prefer_const_constructors

import 'package:easy_finder/pages/details_page.dart';
import 'package:flutter/material.dart';
import '../model/category.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'دسته بندی ها',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                mainAxisExtent: 200.0,
              ),
              itemCount: listOfCategories.length,
              itemBuilder: (context, index) {
                final items = listOfCategories[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsPage()),
                  ),
                  child: Card(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items.icon,
                          size: 40.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          items.title,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          items.subtitle,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
