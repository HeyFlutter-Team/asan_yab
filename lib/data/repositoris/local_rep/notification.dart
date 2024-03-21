import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationUpdate {
  NotificationUpdate();
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  void saveToken(String? token) async {
    debugPrint('tokKen  Fcm $token');
    if (firebaseAuth != null) {
      await firestore
          .collection('UserToken')
          .doc(firebaseAuth!.uid)
          .set({"Token": token});
    }
  }
}
