import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserProvider = FutureProvider<Users>((ref) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  return await SingleUserRepo().getFetchUser(uid);
});

class SingleUserRepo {
  Future<Users> getFetchUser(String? uid) async {
    final firebase = FirebaseFirestore.instance;
    try {
      final query = await firebase.collection('User').doc(uid).get();
      final userProfile = Users.fromMap(query.data()!);

      return userProfile;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
