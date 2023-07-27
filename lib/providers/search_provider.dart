import 'package:asan_yab/database/firebase_helper/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;

  final search = TextEditingController();
  final firebaseDatabase = FirebaseFirestore.instance;
  String _searchQuery = '';
  List<Place> _searchResult = [];
  String get searchQuery => _searchQuery;
  List<Place> get searchResult => _searchResult;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> performSearch() async {
    final snapShot = await database
        .collection('Places')
        .where('name', isGreaterThanOrEqualTo: _searchQuery)
        .get();
    _searchResult =
        snapShot.docs.map((doc) => Place.fromJson(doc.data())).toList();
    notifyListeners();
  }

  
}
