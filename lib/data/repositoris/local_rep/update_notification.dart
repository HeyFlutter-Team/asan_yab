import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firebase_collection_names.dart';

class UpdateNotification {
  UpdateNotification();
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  void saveToken(String? token) async {
    debugPrint('tokKen  Fcm $token');
    if (firebaseAuth != null) {
      await firestore
          .collection(FirebaseCollectionNames.userToken)
          .doc(firebaseAuth!.uid)
          .set({"Token": token});
    }
  }
}
