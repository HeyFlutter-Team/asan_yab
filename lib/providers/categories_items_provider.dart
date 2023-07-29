import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database/firebase_helper/place.dart';
import '../repositories/categories_items_rep.dart';

class CategoriesItemsProvider with ChangeNotifier{
  final placeRepository = CategoriesItemsRepository();
  final List<Place> _places = [];
  List<Place> get places => _places;
  bool hasMore = true;
  bool _isLoading = false;
  bool get isLoading=> _isLoading;
  
  DocumentSnapshot? lastItem;

  Future<void> getPlaces( String id) async {
    if (_isLoading || !hasMore) {
      return;
    }

    final placesReponse = await placeRepository.fetchPlaces(lastItem: lastItem,id: id);


    if (placesReponse != null) {
      _places.addAll(placesReponse.docs);
      lastItem = placesReponse.lastItem;
      if (placesReponse.totalItem <= _places.length) {
        hasMore = false;
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getInitPlaces(String id) async {
    lastItem = null;
    hasMore = true;
    _places.clear();
    _isLoading = false;
    notifyListeners();
    await getPlaces(id);
  }
 
}