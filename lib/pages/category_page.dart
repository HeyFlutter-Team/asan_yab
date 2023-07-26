import 'package:asan_yab/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';

import 'package:flutter/material.dart';

import '../constants/kcolors.dart';
import 'list_category_item.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
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
      body: FutureBuilder(
        future: Provider.of<CategoriesProvider>(context, listen: false)
            .getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          } else if (snapshot.hasData) {
            final category = snapshot.data ?? [];
            return ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      mainAxisExtent: 200.0,
                    ),
                    itemCount: category.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListCategoryItem(
                                categoryNameCollection:
                                    category[index].categoryName,
                                catId: category[index].id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: tempName(tempColor: category[index].color),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconData(int.parse(category[index].iconCode),
                                    fontFamily: 'MaterialIcons'),
                                size: 40.0,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                category[index].categoryName,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          } else {
            return const SizedBox(height: 0);
          }
        },
      ),
    );
  }
}
