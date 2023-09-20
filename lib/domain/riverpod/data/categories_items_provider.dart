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
    final placesReponse =
        await placeRepository.fetchPlaces(lastItem: lastItem, id: id);

    if (placesReponse != null) {
      state.addAll(placesReponse.docs);
      lastItem = placesReponse.lastItem;

      if (placesReponse.totalItem <= state.length) {
        ref.read(hasMore.notifier).state = false;
      }
    }
  }

  Future<void> getInitPlaces(String id) async {
    lastItem = null;
    ref.read(hasMore.notifier).state = true;
    state.clear();
    // _isLoading = false;
    // places();
    // notifyListeners();
    await getPlaces(id);
  }
}

final hasMore = StateProvider<bool>((ref) {
  return true;
});
