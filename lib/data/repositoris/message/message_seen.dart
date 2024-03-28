import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firebase_collection_names.dart';

class MessageSeen {
  MessageSeen();
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  Future<List<bool>> newMessage() async {
    try {
      final documentSnapshot = await firestore
          .collection(FirebaseCollectionNames.user)
          .doc(firebaseAuth!.uid)
          .collection(FirebaseCollectionNames.chat)
          .orderBy('times', descending: true)
          .get();
      final data = documentSnapshot.docs
          .map((e) => e.data()['last_message'] as bool)
          .toList();
      debugPrint("Last Message: $data");
      return data;
    } catch (e) {
      debugPrint("Error retrieving document: $e");
      rethrow;
    }
  }

  Future<void> updateSeenMessage(String receiverId, String uid) async {
    debugPrint("receiverId:$receiverId and uid:$uid");
    await firestore
        .collection(FirebaseCollectionNames.user)
        .doc(uid)
        .collection(FirebaseCollectionNames.chat)
        .doc(receiverId)
        .update({'last_message': false});
  }
}
