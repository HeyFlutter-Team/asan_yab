import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../database/firebase_helper/place.dart';

class LazyLoadingProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;

  Future<List<Place>> fetchDataFromFirebase(String id) async {
    try {
      final querySnapshot = await database
          .collection('Places')
          .where('categoryId', isEqualTo: id)
          .get();
      return querySnapshot.docs.map((doc) {
        return Place.fromJson(doc.data());
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
