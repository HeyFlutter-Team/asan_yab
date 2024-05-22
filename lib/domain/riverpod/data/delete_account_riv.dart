import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/download_image.dart';
import '../../../data/models/place.dart';
import 'favorite_provider.dart';
import 'firbase_favorite_provider.dart';

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
        notifyListeners();
        print('user data deleted');
      }
    } catch (e) {
      print('Failed to delete account: $e');
    }
  }

  Future<void> deleteUserDocument(String uid) async {
    try {
      final user = FirebaseFirestore.instance.collection('User').doc(uid);
      user.collection('chat');
      await user.delete();
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
      }
    }
  }

  Future<void> deleteChatCollection(String userId) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('User').doc(userId);
      QuerySnapshot followSnapshot = await docRef.collection('Follow').get();

      for (QueryDocumentSnapshot followDoc in followSnapshot.docs) {
        await followDoc.reference.delete();
      }
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
      }
    } catch (e) {
      print('Error deleting collection: $e');
    }
  }

  Future<void> deleteFavorites(String uid) async {
    await FirebaseFirestore.instance.collection('Favorite').doc(uid).delete();
  }

  Future<void> deleteRating(String uid) async {
    final ratingsQuerySnapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('userId', isEqualTo: uid)
        .get();

    for (var doc in ratingsQuerySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteLocalFavorite(WidgetRef ref) async {
    List<String> firebaseId = ref.watch(getInformationProvider).favoriteList;
    for (int i = 0; i < firebaseId.length; i++) {
      final provider = ref.read(favoriteProvider.notifier);
      final places = Place(
        categoryId: '',
        category: '',
        addresses: [],
        id: firebaseId[i],
        logo: '',
        coverImage: '',
        name: '',
        description: '',
        gallery: [],
        createdAt: DateTime.now(),
        order: 1,
      );

      provider.toggleFavorite(
        firebaseId[i],
        places,
        [],
        [],
        DownloadImage.logo,
        DownloadImage.coverImage,
      );
    }
    notifyListeners();
  }
}
