// ignore_for_file: prefer_const_constructors

import 'package:easy_finder/pages/computer_page.dart';
import 'package:easy_finder/pages/hospital_page.dart';
import 'package:easy_finder/pages/icecream_page.dart';
import 'package:easy_finder/pages/park_page.dart';
import 'package:easy_finder/pages/phone_shop_page.dart';
import 'package:easy_finder/pages/resturant_page.dart';
import 'package:easy_finder/pages/soccer_page.dart';
import 'package:easy_finder/pages/sports_gymnastic_page.dart';
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
          'Categories',
          style: TextStyle(
            color: Colors.grey,
          ),
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
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResturantPage(),
                          ),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HospitalPage(),
                          ),
                        );
                      } else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComputerPage(),
                          ),
                        );
                      } else if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IcecreamPage(),
                          ),
                        );
                      } else if (index == 4) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SportsGymnasticPage(),
                          ),
                        );
                      } else if (index == 5) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SoccerPage(),
                          ),
                        );
                      } else if (index == 6) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParkPage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhoneShopPage(),
                          ),
                        );
                      }
                    },
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.grey,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              items.iconProduct,
                              size: 40.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              items.titleProduct,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
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
                }),
          )
        ],
      ),
    );
  }
}
