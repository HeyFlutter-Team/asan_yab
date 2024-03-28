import 'package:asan_yab/data/models/message/message_model.dart';
import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firebase_collection_names.dart';

class MessageRepo {
  MessageRepo();
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance.currentUser;
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
    final userDocRef = firestore
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
    final receiverChatDocRef = firestore
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
}
