import 'package:asan_yab/data/repositoris/categories_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/place.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'categories_items.g.dart';

@riverpod
class CategoriesItems extends _$CategoriesItems {
  final categoriesRepo = CategoriesRepo();
  DocumentSnapshot? lastItem;
  @override
  List<Place> build() => [];
  Future<void> getPlaces(String id) async {
    final placesResponse =
        await categoriesRepo.fetchPlaces(lastItem: lastItem, id: id);

    try {
      ref.read(loadingDataProvider.notifier).state = true;
      if (placesResponse != null) {
        state.addAll(placesResponse.docs);
        lastItem = placesResponse.lastItem;

        if (placesResponse.totalItem <= state.length) {
          ref.read(hasMore.notifier).state = false;
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      ref.read(loadingDataProvider.notifier).state = false;
    }
  }

  Future<void> getInitPlaces(String id) async {
    lastItem = null;
    ref.read(hasMore.notifier).state = true;
    state.clear();
    await getPlaces(id);
  }
}

final hasMore = StateProvider<bool>((ref) => true);
final loadingDataProvider = StateProvider<bool>((ref) => false);
