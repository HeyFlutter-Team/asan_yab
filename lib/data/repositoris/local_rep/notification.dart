import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NotificationUpdate {
  Future<void> saveToken(String? token) async {
    try {
      // Ensure Firebase is initialized
      await Firebase.initializeApp();

      debugPrint('Token: $token');
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && token != null) {
        await FirebaseFirestore.instance
            .collection('UserToken')
            .doc(user.uid)
            .set({
          "Token": token,
        });
        debugPrint('Token saved successfully');
      } else {
        debugPrint('User or token is null');
      }
    } on FirebaseException catch (e) {
      debugPrint('Firebase Exception saving token: $e');
      // Handle Firebase related errors accordingly
    } catch (e, stackTrace) {
      debugPrint('Error saving token: $e\n$stackTrace');
      // Handle other errors accordingly
    }
  }
}
