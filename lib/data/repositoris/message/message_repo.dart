import 'package:asan_yab/data/models/message/message_model.dart';
import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firebase_collection_names.dart';

class MessageRepo {
  MessageRepo();

  final firebaseAuth = FirebaseAuth.instance.currentUser;
  final fireStore = FirebaseFirestore.instance;

  Users? user;
  Future<void> addTextMessage({
    required String content,
    required String receiverId,
    required String replayMessage,
  }) async {
    try {
      final message = MessageModel(
        senderId: firebaseAuth!.uid,
        receiverId: receiverId,
        content: content,
        sentTime: DateTime.now().toUtc(),
        messageType: MessageType.text,
        replayMessage: replayMessage,
      );
      await addMessageToChat(
        receiverId: receiverId,
        message: message,
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> addStickerMessage({
    required String content,
    required String receiverId,
    required int currentUserCoinCount,
    String? replayMessage,
  }) async {
    try {
      final message = MessageModel(
        senderId: firebaseAuth!.uid,
        receiverId: receiverId,
        content: content,
        sentTime: DateTime.now().toUtc(),
        messageType: MessageType.sticker,
        replayMessage: replayMessage ?? '',
      );
      await addMessageToChat(
        receiverId: receiverId,
        message: message,
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> addMessageToChat({
    required String receiverId,
    required MessageModel message,
  }) async {
    final userDocRef = fireStore
        .collection(FirebaseCollectionNames.user)
        .doc(firebaseAuth!.uid);
    final chatDocRef =
        userDocRef.collection(FirebaseCollectionNames.chat).doc(receiverId);
    await chatDocRef.set({
      'uid': receiverId,
      'times': Timestamp.now(),
      'last_message': true,
    });
    await chatDocRef
        .collection(FirebaseCollectionNames.message)
        .add(message.toJson());
    final receiverChatDocRef = fireStore
        .collection(FirebaseCollectionNames.user)
        .doc(receiverId)
        .collection(FirebaseCollectionNames.chat)
        .doc(firebaseAuth!.uid);
    await receiverChatDocRef.set({
      'uid': firebaseAuth!.uid,
      'times': Timestamp.now(),
      'last_message': true,
    });
    await receiverChatDocRef
        .collection(FirebaseCollectionNames.message)
        .add(message.toJson());
  }

  Future<void> deleteMessage(
    String uid,
    String receiverId,
    String messageContent,
  ) async {
    FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.user)
        .doc(uid)
        .collection(FirebaseCollectionNames.chat)
        .doc(receiverId)
        .collection(FirebaseCollectionNames.message)
        .where("content", isEqualTo: messageContent)
        .get()
        .then((query) {
      for (final docSnapshot in query.docs) {
        docSnapshot.reference.delete();
      }
    });
  }

  List<String> usersId = [];
  List<bool> isNewMessage = [];
  Future<List<String>> getOtherUserId() async {
    try {
      final data = await fireStore
          .collection(FirebaseCollectionNames.user)
          .doc(firebaseAuth!.uid)
          .get()
          .then((value) async => await value.reference
              .collection(FirebaseCollectionNames.chat)
              .orderBy('times', descending: true)
              .get());
      usersId = data.docs.map((e) => e.reference.id).toList();
    } catch (e) {
      rethrow;
    }
    return usersId;
  }

  Future<List<Users>> getUser(List<String> uidList) async {
    try {
      List<Users> data = [];
      for (final uid in uidList) {
        final userDataSnapshot = await fireStore
            .collection(FirebaseCollectionNames.user)
            .doc(uid)
            .get();

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
              .collection(FirebaseCollectionNames.user)
              .doc(firebaseAuth!.uid)
              .collection(FirebaseCollectionNames.chat)
              .doc(uid)
              .collection(FirebaseCollectionNames.message)
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

  Future<List<bool>> newMessage() async {
    try {
      final documentSnapshot = await fireStore
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
    await fireStore
        .collection(FirebaseCollectionNames.user)
        .doc(uid)
        .collection(FirebaseCollectionNames.chat)
        .doc(receiverId)
        .update({'last_message': false});
  }
}
