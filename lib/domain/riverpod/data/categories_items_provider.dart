import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/place.dart';
import '../../../data/repositoris/categories_items_rep.dart';

final categoriesItemsProvider =
    StateNotifierProvider<CategoriesItemsProvider, List<Place>>(
        (ref) => CategoriesItemsProvider([], ref));

class CategoriesItemsProvider extends StateNotifier<List<Place>> {
  final placeRepository = CategoriesItemsRepository();

  final Ref ref;

  CategoriesItemsProvider(super.state, this.ref);

  DocumentSnapshot? lastItem;

  Future<void> getPlaces(String id) async {
    final placesResponse = await placeRepository.fetchPlaces(
      lastItem: lastItem,
      id: id,
    );

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
