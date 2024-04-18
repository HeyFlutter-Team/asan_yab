import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/domain/riverpod/data/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/res/colors.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/translation_util.dart';
import '../../data/repositoris/language_repo.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final text = texts(context);
    ref.read(categoriesProvider.notifier).getCategories();
    final category = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(text.category_title),
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            context.pop();
          },
          icon: const Icon(Icons.arrow_back, size: 25),
        ),
      ),
      body: category.isEmpty
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.redAccent, size: 60),
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
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => context.pushNamed(
                        Routes.listOfCategory,
                        pathParameters: {
                          'Id': category[index].id,
                          'name': isRTL
                              ? category[index].name
                              : category[index].enCategoryName!,
                        },
                      ),
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
                            SizedBox(height: 16.0.h),
                            Text(
                              isRTL
                                  ? category[index].name
                                  : category[index].enCategoryName!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
