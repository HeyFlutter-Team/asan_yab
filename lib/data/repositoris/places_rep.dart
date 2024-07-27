import 'package:asan_yab/data/models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class PlacesRepository {
  final firebase = FirebaseFirestore.instance;
  final _path = 'NewPlaces';
  Future<List<Place>> fetchPlaces() async {
    try {
      // Ensure Firebase initialization
      await Firebase.initializeApp();

      final data = await FirebaseFirestore.instance
          .collection(_path)
          .orderBy('order', descending: false)
          .get();

      if (data.docs.isEmpty) {
        return [];
      }

      final places =
          data.docs.map((doc) => Place.fromJson(doc.data())).toList();
      return places;
    } catch (e, stackTrace) {
      debugPrint('Fetching Places: Error: $e\n$stackTrace');
      return [];
    }
  }
}
