import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/res/colors.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/categories_items_provider.dart';
import 'list_category_item.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRTL = ref.watch(languageProvider).code=='fa';
    final languageText=AppLocalizations.of(context);
    ref.read(categoriesProvider.notifier).getCategories();
    final category = ref.watch(categoriesProvider);
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 10) {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        }},
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0.0,
          // backgroundColor: Colors.white,
          title: Text(
            languageText!.category_title,
          ),
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, size: 25),
          ),
        ),
        body: category.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.red,
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
                            ref.read(categoriesItemsProvider).clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListCategoryItem(
                                  catId: category[index].id,
                                  categoryName:
                                  isRTL?
                                  category[index].name
                                  :category[index].enName!,
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
                                  isRTL?
                                  category[index].name
                                  :category[index].enName,
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
      ),
    );
  }
}
