import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteAccountProvider =
    ChangeNotifierProvider.autoDispose((ref) => AccountDeletionNotifier());

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
      user.collection('chat');
      await user.delete();
      print('younis');
      print('user deleted');
      notifyListeners();
    } catch (e) {
      print('Error deleting user document: $e');
    }
  }

  Future<void> deleteUserComments(String uid) async {
    List<String> placesId = [];
    try {
      final docRef = FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .collection('comments')
          .doc('commentsList');

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['CommentsId'] != null) {
          placesId = List<String>.from(data['CommentsId']);
          docRef.delete();
          print('Comments retrieved successfully:');
          print(placesId);
          // Now you can delete or manipulate the list as needed
        } else {
          print('Comments data is null or CommentsId field is missing');
        }
      } else {
        print('Comments document does not exist');
      }
    } catch (e) {
      print('Error retrieving user comments: $e');
    }
    for (int i = 0; i < placesId.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Places')
          .doc(placesId[i])
          .collection('postComments')
          .where('uid', isEqualTo: uid)
          .get();
      for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.delete();
        print('younis yaser done1');
      }
      print('younis yaser done2');
    }
    print('younis yaser done3');
  }

  Future<void> deleteChatCollection(String userId) async {
    try {
      final chatCollectionRef = FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('chat');
      final chatSnapshot = await chatCollectionRef.get();
      for (QueryDocumentSnapshot chatDoc in chatSnapshot.docs) {
        // Delete the messages subcollection for each chat
        await chatCollectionRef
            .doc(chatDoc.id)
            .collection('messages')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Delete the chat document itself
        await chatCollectionRef.doc(chatDoc.id).delete();
        final docRef = FirebaseFirestore.instance.collection('User').doc(userId);
        QuerySnapshot followSnapshot = await docRef.collection('Follow').get();

        for (QueryDocumentSnapshot followDoc in followSnapshot.docs) {
          await followDoc.reference.delete();
        }
      }
    } catch (e) {
      print('Error deleting collection: $e');
    }
  }
}
