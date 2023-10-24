import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationUpdate {
  void saveToken(String? token) async {
    debugPrint('tokken  Fcm ${token}');
    await FirebaseFirestore.instance.collection('UserToken').doc('$token').set({
      "Token": token,
    });
  }
}
