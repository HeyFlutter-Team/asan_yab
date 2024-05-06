import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchRepo {
  Future<List<Users>> getSearchedUser(String? id) async {
    final firebase = FirebaseFirestore.instance;
    try {
      final query = await firebase.collection('User')
          .where('id', isGreaterThanOrEqualTo: id)
          .where('id', isLessThanOrEqualTo: id! + '\uf8ff')
          .get();
      var userProfile = query.docs.map((doc) => Users.fromMap(doc.data())).toList();

      return userProfile;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<Users>> getSearchedUserByName(String? name) async {
    final firebase = FirebaseFirestore.instance;
    try {
      final query = await firebase.collection('User')
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThanOrEqualTo: name! + '\uf8ff')
          .get();
      var userProfile = query.docs.map((doc) => Users.fromMap(doc.data())).toList();

      return userProfile;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

}
