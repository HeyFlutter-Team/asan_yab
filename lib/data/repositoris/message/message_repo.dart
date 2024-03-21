import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    await firestore
        .collection('User')
        .doc(firebaseAuth!.uid)
        .collection('chat')
        .doc(receiverId)
        .set({
      'uid': receiverId,
      'times': Timestamp.now(),
      "last_message": true
    });
    await firestore
        .collection('User')
        .doc(firebaseAuth!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await firestore
        .collection('User')
        .doc(receiverId)
        .collection('chat')
        .doc(firebaseAuth!.uid)
        .set({
      'uid': firebaseAuth!.uid,
      'times': Timestamp.now(),
      'last_message': true,
    });
    await firestore
        .collection('User')
        .doc(receiverId)
        .collection('chat')
        .doc(firebaseAuth!.uid)
        .collection('messages')
        .add(message.toJson());
  }
}
