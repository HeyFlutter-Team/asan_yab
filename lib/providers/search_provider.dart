import 'package:asan_yab/database/firebase_helper/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final search = TextEditingController();

  List<Place> _placesItems = [];
  List<Place> _searchedPlacesItems = [];
  List<Place> get searchedPlacesItems => _searchedPlacesItems;
  String? _serachQuery;
  String? get searchQuery => _serachQuery;
  set searchQuery(String? value) {
    if (value != searchQuery) {
      _serachQuery = value;
      notifyListeners();
    }
  }

  List<Place> get placesItems => _placesItems;
  Future<void> fetchAllPlaces() async {
    final QuerySnapshot snapshot = await database.collection('Places').get();
    _placesItems = snapshot.docs
        .map((doc) => Place.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  void performSearch(String query) {
    if (query.isEmpty) {
      return;
    }
    final filteredList = _placesItems.where((place) {
      return place.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    _searchedPlacesItems = filteredList;
    notifyListeners();
  }

  void resetSearch() {
    _searchedPlacesItems.clear();
    notifyListeners();
  }
}
