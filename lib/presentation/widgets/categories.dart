import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/category.dart';

import '../../domain/riverpod/data/categories_provider.dart';
import '../pages/category_page.dart';
import '../pages/list_category_item.dart';

class Categories extends ConsumerWidget {
  final RefreshCallback onRefresh;
  const Categories({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ref.read(categoriesProvider.notifier).getCategories();
    List<Category> category = ref.watch(categoriesProvider);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: category.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: Colors.blueGrey,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'دسته بندی ها',
                        style: TextStyle(color: Colors.grey, fontSize: 20.0),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CategoryPage()),
                        ),
                        icon: const Icon(
                          Icons.arrow_circle_left_outlined,
                          size: 32.0,
                          color: Colors.grey,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListCategoryItem(
                                    catId: category[index].id,
                                    categoryName: category[index].categoryName,
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
                                    color: Colors.white,
                                    size: 45.0),
                                const SizedBox(height: 4),
                                Text(category[index].categoryName,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
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
            ),
    );
  }
}
