import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database/firebase_helper/place.dart';

class LazyLoadingProvider with ChangeNotifier {
  List<Place> _Places = [];
  List<Place> get places => _Places;
  int _currentPage = 1;
  int _perPage = 10;

  Future<List<Place>> fetchPlaces({String? categoryId}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Places')
          .where('categoryId', isEqualTo: categoryId)
          .limit(_perPage)
          .get();
      _Places = snapshot.docs.map((doc) => Place.fromJson(doc.data())).toList();
      notifyListeners();
      return _Places;
    } catch (error) {
      debugPrint('Error fetching places: $error');
      return [];
    } 
  }

  Future<List<Place>> fetchMorePlaces({String? categoryId}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Places')
          .where('categoryId', isEqualTo: categoryId)
          .startAfterDocument(_Places.last as DocumentSnapshot<Object?>)
          .limit(_perPage)
          .get();
      if (snapshot.docs.isNotEmpty) {
        _currentPage++;
        _Places.addAll(
            snapshot.docs.map((doc) => Place.fromJson(doc.data())).toList());
        notifyListeners();
      }

      return _Places;
    } catch (error) {
      debugPrint('Error fetching more places: $error');
      return [];
    }
  }
}
