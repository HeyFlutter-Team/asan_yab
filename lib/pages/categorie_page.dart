// ignore_for_file: prefer_const_constructors

import 'package:easy_finder/pages/details_page.dart';
import 'package:flutter/material.dart';
import '../model/categories.dart';

class CategoriePage extends StatelessWidget {
  const CategoriePage({super.key});

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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(),
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.green,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            items.iconProduct,
                            size: 40.0,
                            color: Colors.white,
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            items.titleProduct,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            items.subtitleProduct,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
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
