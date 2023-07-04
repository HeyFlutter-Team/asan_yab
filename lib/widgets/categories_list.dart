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

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
  });

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
                child: Container(
                  height: 130.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey,
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
