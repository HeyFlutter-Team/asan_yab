import 'package:flutter/material.dart';
import '../model/category.dart';
import '../pages/details_page.dart';
import '../utils/kcolors.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.2,
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
                    MaterialPageRoute(builder: (context) => const DetailsPage()));
              },
              child: Container(
                height: screenHeight * 0.2,
                width: screenWidth * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.teal,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(items.icon, color: kPrimaryColor, size: 45.0),
                    const SizedBox(height: 4),
                    Text(items.title, style: TextStyle(color: kPrimaryColor)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
