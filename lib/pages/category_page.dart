import 'package:flutter/material.dart';
import '../model/category.dart';
import '../utils/kcolors.dart';
import 'details_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'دسته بندی ها',
          style: TextStyle(color: kSecodaryColor),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailsPage()),
                  ),
                  child: Card(
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items.icon,
                          size: 40.0,
                          color: kPrimaryColor,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          items.title,
                          style:
                              TextStyle(color: kPrimaryColor, fontSize: 16.0),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          items.subtitle,
                          style: TextStyle(
                            color: kPrimaryColor,
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
