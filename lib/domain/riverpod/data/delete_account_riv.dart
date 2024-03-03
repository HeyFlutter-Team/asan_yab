import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteAccountProvider = ChangeNotifierProvider.autoDispose((ref) => AccountDeletionNotifier());

class AccountDeletionNotifier extends ChangeNotifier {
  Future<void> deleteAccount(String email, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        print('younis');
        print('user data deleted');
      }
    } catch (e) {
      print('Failed to delete account: $e');
    }
    notifyListeners();
  }


  Future<void> deleteUserDocument(String uid) async {
    try {
      final user = FirebaseFirestore.instance.collection('User').doc(uid);
      await user.delete();
      print('younis');
      print('user deleted');
    } catch (e) {
      print('Error deleting user document: $e');
    }
    notifyListeners();
  }
}
