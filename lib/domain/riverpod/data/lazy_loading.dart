import 'package:asan_yab/domain/riverpod/data/categories_items_provider.dart';
import 'package:asan_yab/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catLazyLoading = StateNotifierProvider((ref) => CatLazyLoading(ref, ref));

class CatLazyLoading extends StateNotifier {
  final Ref ref;
  final scrollController = ScrollController();

  CatLazyLoading(super.state, this.ref);

  Future<void> loadMoreData(
    BuildContext context,
  ) async {
    scrollController.addListener(() async {
      // Check if the user has reached the end of the ListView
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // Call your method here
        if (ref.watch(hasMore)) {
          print('loading more is wotking');
          await ref
              .read(categoriesItemsProvider.notifier)
              .getPlaces(ref.watch(idProvider));
        }
      }
    });
  }
}

final loadingCircorile = StateProvider((ref) => false);
