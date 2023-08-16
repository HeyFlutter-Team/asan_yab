import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/firebase_helper/category.dart';
import '../pages/category_page.dart';
import '../pages/list_category_item.dart';
import '../constants/kcolors.dart';
import '../providers/categories_provider.dart';

class Categories extends StatelessWidget {
  final RefreshCallback onRefresh;
  const Categories({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: FutureBuilder(
          future: Provider.of<CategoriesProvider>(context, listen: false)
              .getCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueGrey,
                  strokeWidth: 5,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.blueGrey,
                strokeWidth: 5,
              ));
            }
            if (snapshot.hasData) {
              List<Category> category = snapshot.data ?? [];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'دسته بندی ها',
                          style:
                              TextStyle(color: kSecodaryColor, fontSize: 20.0),
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
                  SizedBox(
                    height: screenHeight * 0.2,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: category.length >= 6 ? 6 : category.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('Ramin: ${category[index].id}');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListCategoryItem(
                                      catId: category[index].id,
                                      categoryName:
                                          category[index].categoryName,
                                    ),
                                  ));
                            },
                            child: Container(
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(int.parse((category[index]
                                        .color
                                        .replaceAll('#', '0xff'))))
                                    .withOpacity(0.6),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      IconData(
                                          int.parse(category[index].iconCode),
                                          fontFamily: 'MaterialIcons'),
                                      color: kPrimaryColor,
                                      size: 45.0),
                                  const SizedBox(height: 4),
                                  Text(category[index].categoryName,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}