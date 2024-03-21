import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryMessage {
  HistoryMessage();
  final fireStore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  List<String> usersId = [];
  List<bool> isNewMessage = [];
  Future<List<String>> getOtherUserId() async {
    List<Users> data = [];
    try {
      final data = await fireStore
          .collection('User')
          .doc(firebaseAuth!.uid)
          .get()
          .then((value) async => await value.reference
              .collection('chat')
              .orderBy('times', descending: true)
              .get());
      usersId = data.docs.map((e) => e.reference.id).toList();
      // print('not work ${data.size}');
      // print('uuuuuuu ${FirebaseAuth.instance.currentUser!.uid}');

      //
    } catch (e) {
      rethrow;
    } finally {
      // print('hhhhhhh ${usersId[0]} ${usersId[1]} ${usersId[2]}');
    }
    return usersId;
  }

  Future<List<Users>> getUser(List<String> uidList) async {
    try {
      List<Users> data = [];
      for (final uid in uidList) {
        final userDataSnapshot =
            await fireStore.collection('User').doc(uid).get();

        if (userDataSnapshot.exists) {
          final userData = Users.fromMap(userDataSnapshot.data()!);
          data.add(userData);
        }
      }
      return data;
    } catch (e) {
      debugPrint('history message ${e.toString()}');
      rethrow;
    }
  }

  Future<List<MessageModel>> getLastMessage(List<String> uidList) async {
    List<MessageModel> data = [];
    try {
      for (final uid in uidList) {
        if (firebaseAuth != null) {
          final userDataSnapshot = await fireStore
              .collection('User')
              .doc(firebaseAuth!.uid)
              .collection('chat')
              .doc(uid)
              .collection('messages')
              .orderBy('sentTime', descending: true)
              .limit(1)
              .get();
          final userData =
              MessageModel.fromJson(userDataSnapshot.docs.first.data());
          data.add(userData);
        }
      }
      return data;
    } catch (e) {
      debugPrint('history message ${e.toString()}');
      rethrow;
    }
  }
}
