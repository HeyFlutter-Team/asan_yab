import 'package:asan_yab/domain/riverpod/data/categories_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

import '../../core/res/colors.dart';
import 'list_category_item.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(categoriesProvider.notifier).getCategories();
    final category = ref.watch(categoriesProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'دسته بندی ها',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
        ),
      ),
      body: category.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: Colors.blueGrey,
              ),
            )
          : ListView(
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
                          debugPrint('the id is : ${category[index].id}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListCategoryItem(
                                catId: category[index].id,
                                categoryName: category[index].categoryName,
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
                                IconData(
                                  int.parse(category[index].iconCode),
                                  fontFamily: 'MaterialIcons',
                                ),
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
            ),
    );
  }
}
