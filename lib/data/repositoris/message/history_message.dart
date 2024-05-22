import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class HistoryMessage {
  final fireStore = FirebaseFirestore.instance;
  List<String> usersId = [];
  List<bool> isNewMessage = [];
  Future<List<String>> getOtherUserId() async {
    List<Users> data = [];
    try {
      final data = await fireStore
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
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
        } else {
          print('Document with ID $uid does not exist.');
          // Handle this case if needed (e.g., add a placeholder user or skip this ID).
        }
      }

      return data;
    } catch (e) {
      print('Error fetching user data: ${e.toString()}');
      // Rethrow the exception if needed, or handle it accordingly.
      rethrow;
    }
  }

  Future<List<MessageModel>> getLastMessage(List<String> uidList) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Current user is null');
      }

      List<MessageModel> data = [];

      for (final uid in uidList) {
        final messageSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(currentUser.uid)
            .collection('chat')
            .doc(uid)
            .collection('messages')
            .orderBy('sentTime', descending: true)
            .limit(1)
            .get();

        if (messageSnapshot.docs.isNotEmpty) {
          final messageData =
              MessageModel.fromJson(messageSnapshot.docs.first.data());
          data.add(messageData);
        }
      }

      return data;
    } catch (e) {
      debugPrint('Error fetching last messages: $e');
      rethrow; // Rethrow the error to handle it in the calling code
    }
  }
}
