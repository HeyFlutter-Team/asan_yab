import 'package:asan_yab/domain/riverpod/data/categories_items_provider.dart';
import 'package:asan_yab/presentation/widgets/category_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lazyLoading = StateNotifierProvider((ref) => LazyLoading(ref, ref));

class LazyLoading extends StateNotifier {
  final Ref ref;
  final scrollController = ScrollController();
  bool canLoadMoreData = true;
  LazyLoading(super.state, this.ref);

  void loadMoreData() => scrollController.addListener(() {
        if (canLoadMoreData) {
          scrollListener();
        }
      });

  Future<void> scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        ref.watch(hasMore)) {
      canLoadMoreData = false;
      debugPrint('loading more is working ${ref.watch(loadingCircle)}');

      await ref
          .read(categoriesItemsProvider.notifier)
          .getPlaces(ref.watch(idProvider));

      canLoadMoreData = true;
    }
  }
}

final loadingCircle = StateProvider((ref) => false);
