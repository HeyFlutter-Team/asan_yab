import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/constants/firebase_collection_names.dart';

class SearchRepo {
  SearchRepo();
  final firebase = FirebaseFirestore.instance;
  Future<List<Users>> getSearchedUser(int? id) async {
    try {
      final query = await firebase
          .collection(FirebaseCollectionNames.user)
          .where('id', isEqualTo: id)
          .get();
      final userProfile =
          query.docs.map((doc) => Users.fromMap(doc.data())).toList();
      return userProfile;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
