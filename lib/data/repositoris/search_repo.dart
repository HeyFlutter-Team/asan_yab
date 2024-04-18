import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/constants/firebase_collection_names.dart';

class SearchRepo {
  const SearchRepo();

  Future<List<Users>> getSearchedUser(int? id) async {
    final firebase = FirebaseFirestore.instance;
    try {
      final query = await firebase
          .collection(FirebaseCollectionNames.user)
          .where('id', isGreaterThanOrEqualTo: id)
          .get();
      final userProfile =
          query.docs.map((doc) => Users.fromMap(doc.data())).toList();
      debugPrint('Sharif ${userProfile[0].id}');
      return userProfile;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
