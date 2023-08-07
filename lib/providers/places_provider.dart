import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database/firebase_helper/place.dart';
import '../repositories/places_rep.dart';

class PlaceProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  final placeRepository = PlacesRepository();

  List<Place> _places = [];
  List<Place> get place => _places;
  set place(List<Place> place) {
    _places = place;
    notifyListeners();
  }

  Future<List<Place>> getplaces() async {
    final newPlaces = await placeRepository.fetchPlaces();
    _places = newPlaces;
    notifyListeners();
    return _places;
  }

  Future<Place?> fetchSinglePlace(String id) async {
    final database = FirebaseFirestore.instance;
    try {
      final querySnapshot = await database.collection('Places').doc(id).get();
      final place = Place.fromJson(querySnapshot.data()!);
      return place;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
