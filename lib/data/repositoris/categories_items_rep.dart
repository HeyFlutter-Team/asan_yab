import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../models/place_response.dart';

class CategoriesItemsRepository {
  final firebase = FirebaseFirestore.instance;
  final _path = 'Places';
  final pageSize = 10;
  Future<PlaceReponse?> fetchPlaces(
      {DocumentSnapshot? lastItem, String? id}) async {
    try {
      final countItem = await firebase
          .collection(_path)
          .where('categoryId', isEqualTo: id)
          .count()
          .get();
      var query = firebase
          .collection(_path)
          .where('categoryId', isEqualTo: id)
          .limit(pageSize);

      if (lastItem != null) {
        query = query.startAfterDocument(lastItem);
      }
      final data = await query.get();
      final places =
          data.docs.map((doc) => Place.fromJson(doc.data())).toList();
      return PlaceReponse(
        docs: places,
        lastItem: data.docs.last,
        totalItem: countItem.count,
      );
    } catch (e) {
      debugPrint('error of place $e');
    }
    return null;
  }
}
