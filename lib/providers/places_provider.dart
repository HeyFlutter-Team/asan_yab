
import 'package:flutter/material.dart';

import '../database/firebase_helper/place.dart';
import '../repositories/places_rep.dart';

class PlaceProvider with ChangeNotifier{
  final placeRepository =PlacesRepository();

  List<Place> _places = [];
  List<Place> get places => _places;
  set places(List<Place>places){
    _places = places;
    notifyListeners();
  }
  Future<List<Place>> getPlaces () async {
    final newCategories = await placeRepository.fetchPlaces();

    _places = newCategories;
    notifyListeners();
    return _places;
  }
}