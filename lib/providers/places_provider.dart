
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database/firebase_helper/place.dart';
import '../repositories/places_rep.dart';

class PlaceProvider with ChangeNotifier {
  final placeRepository = PlacesRepository();
  final List<Place> _places = [];
  List<Place> get places => _places;


  bool hasMore = true;
  bool isLoading = false;
  DocumentSnapshot? lastItem;

  Future<void> getPlaces( String id) async {
    if (isLoading || !hasMore) {
      return;
    }

    final placesReponse = await placeRepository.fetchPlaces(lastItem: lastItem);


    if (placesReponse != null) {
      _places.addAll(placesReponse.docs);
      lastItem = placesReponse.lastItem;
      if (placesReponse.totalItem <= _places.length) {
        hasMore = false;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  void getInitPlaces(String id) {
    lastItem = null;
    hasMore = true;
    _places.clear();
    isLoading = false;
    notifyListeners();
    getPlaces(id);
  }
}
