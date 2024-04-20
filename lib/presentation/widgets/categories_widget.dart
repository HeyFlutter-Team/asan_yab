import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../data/models/category.dart';
import '../../core/extensions/language.dart';
import '../../data/repositoris/language_repo.dart';
import '../../domain/riverpod/data/categories.dart';

class CategoriesWidget extends ConsumerWidget {
  final RefreshCallback onRefresh;
  const CategoriesWidget({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ref.read(categoriesProvider.notifier).getCategories();
    List<Category> category = ref.watch(categoriesProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final text = texts(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: category.isEmpty
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.redAccent, size: 60),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        text.category_title,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 20.0),
                      ),
                      IconButton(
                        onPressed: () => context.pushNamed(Routes.category),
                        icon: Icon(
                          isRTL
                              ? Icons.arrow_circle_left_outlined
                              : Icons.arrow_circle_right_outlined,
                          size: 32.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.2.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: category.length >= 6 ? 6 : category.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => context.pushNamed(Routes.listOfCategory,
                              pathParameters: {
                                'Id': category[index].id,
                                'name': isRTL
                                    ? category[index].name
                                    : category[index].enCategoryName!,
                              }),
                          child: Container(
                            height: screenHeight * 0.2,
                            width: screenWidth * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(
                                int.parse(
                                  (category[index]
                                      .color
                                      .replaceAll('#', '0xff')),
                                ),
                              ).withOpacity(0.6),
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
                                SizedBox(height: 4.h),
                                Text(
                                  isRTL
                                      ? category[index].name
                                      : category[index].enCategoryName!,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
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
