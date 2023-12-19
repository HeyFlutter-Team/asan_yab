import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationUpdate {
  void saveToken(String? token) async {
    debugPrint('tokken  Fcm $token');
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('UserToken')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "Token": token,
      });
    }
  }
}
