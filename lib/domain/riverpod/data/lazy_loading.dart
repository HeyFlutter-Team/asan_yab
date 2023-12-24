import 'package:asan_yab/domain/riverpod/data/categories_items_provider.dart';
import 'package:asan_yab/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catLazyLoading = StateNotifierProvider((ref) => CatLazyLoading(ref, ref));

class CatLazyLoading extends StateNotifier {
  final Ref ref;
  final scrollController = ScrollController();
  bool canLoadMoreData = true;
  CatLazyLoading(super.state, this.ref);

  void loadMoreData() {
    scrollController.addListener(() {
      // Check if you can load more data
      if (canLoadMoreData) {
        scrollListener();
      }
    });
  }

  Future<void> scrollListener() async {
    // Check if the user has reached the end of the ListView
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        ref.watch(hasMore)) {
      // Call your method here
      canLoadMoreData = false;
      print('loading more is wotking ${ref.watch(loadingCircorile)}');

      await ref
          .read(categoriesItemsProvider.notifier)
          .getPlaces(ref.watch(idProvider));

      canLoadMoreData = true;
    }
  }
}

final loadingCircorile = StateProvider((ref) => false);
