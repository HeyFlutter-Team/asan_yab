import 'package:asan_yab/data/models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/firebase_collection_names.dart';

class PlacesRepo {
  PlacesRepo();
  final firestore = FirebaseFirestore.instance;

  Future<List<Place>> fetchPlaces() async {
    try {
      final data = await firestore
          .collection(FirebaseCollectionNames.places)
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
