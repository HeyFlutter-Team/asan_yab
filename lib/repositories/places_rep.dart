import 'package:asan_yab/database/firebase_helper/place.dart';
import 'package:asan_yab/database/firebase_helper/place_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PlacesRepository {
  final firebase = FirebaseFirestore.instance;
  final _path = 'Places';
  final pageSize = 10;

  Future<PlaceReponse?> fetchPlaces({DocumentSnapshot? lastItem}) async {
    try {
      final countItem = await firebase.collection(_path).count().get();
      var query = firebase.collection(_path).limit(pageSize);
      if (lastItem != null) {
        query = query.startAfterDocument(lastItem);
      }

      final data = await query.get();
      final categories =
          data.docs.map((doc) => Place.fromJson(doc.data())).toList();
      return PlaceReponse(
          docs: categories,
          lastItem: data.docs.last,
          totalItem: countItem.count);
    } catch (e) {
      debugPrint('error of place $e');
    }
    return null;
  }
}
