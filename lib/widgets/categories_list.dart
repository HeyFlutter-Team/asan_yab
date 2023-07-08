// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:easy_finder/pages/details_page.dart';
import 'package:flutter/material.dart';
import '../model/categories.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.0,
      width: 150.0,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listOfCategories.length,
          itemBuilder: (context, index) {
            final items = listOfCategories[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailsPage()));
                },
                child: Container(
                  height: 130.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items.iconProduct,
                        color: Colors.white,
                        size: 35.0,
                      ),
                      Text(
                        items.titleProduct,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        items.subtitleProduct,
                        style: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
