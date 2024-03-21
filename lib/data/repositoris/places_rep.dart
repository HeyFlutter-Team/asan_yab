import 'package:asan_yab/data/models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PlacesRepository {
 PlacesRepository();
  final firestore = FirebaseFirestore.instance;
  final _path = 'Places';

  Future<List<Place>> fetchPlaces() async {
    try {
      final data = await firestore
          .collection(_path)
          .orderBy('order', descending: false)
          .get();
      final places =
          data.docs.map((doc) => Place.fromJson(doc.data())).toList();

      return places;
    } catch (e) {
      debugPrint('Fetching Places: Error: $e');
      return [];
    }
  }
}
