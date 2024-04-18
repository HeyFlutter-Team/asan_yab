import 'package:asan_yab/domain/riverpod/screen/circular_loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/routes.dart';
import '../widgets/category_item_widget.dart';

class ListCategoryItem extends ConsumerWidget {
  final String catId;
  final String categoryName;

  const ListCategoryItem({
    super.key,
    required this.catId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('is exist $catId');
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () => context.pushNamed(Routes.searchBar),
              icon: const Icon(
                Icons.search,
                size: 25,
              ),
            )
          ],
          leading: IconButton(
            onPressed: () {
              context.pop();
              ref
                  .read(circularLoadingProvider.notifier)
                  .toggleCircularLoading();
            },
            icon: const Icon(Icons.arrow_back, size: 25.0),
          ),
        ),
        body: CategoryItemWidget(id: catId),
      ),
    );
  }
}
