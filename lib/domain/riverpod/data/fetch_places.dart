import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firebase_collection_names.dart';
import '../../../data/models/place.dart';
import '../../../data/repositoris/places_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../presentation/widgets/category_item_widget.dart';
import 'categories_items.dart';
part 'fetch_places.g.dart';

final loadingCircle = StateProvider((ref) => false);

@riverpod
class FetchPlaces extends _$FetchPlaces {
  final placeRepository = PlacesRepo();
  final scrollController = ScrollController();
  bool canLoadMoreData = true;
  @override
  List<Place> build() => [];

  Future<List<Place>> getPlaces() async {
    final newPlaces = await placeRepository.fetchPlaces();
    state = newPlaces;
    return state;
  }

  Future<Place?> fetchSinglePlace(String id) async {
    final database = FirebaseFirestore.instance;
    try {
      final querySnapshot = await database
          .collection(FirebaseCollectionNames.places)
          .doc(id)
          .get();
      final place = Place.fromJson(querySnapshot.data()!);
      return place;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

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
