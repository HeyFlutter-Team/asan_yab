import 'package:asan_yab/data/models/message/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/firebase_collection_names.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'fetch_message.g.dart';

@riverpod
class FetchMessage extends _$FetchMessage {
  final scrollController = ScrollController();
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  @override
  List<MessageModel> build() => [];
  List<MessageModel> getMessages(String receiverId) {
    try {
      ref.read(messageLoadingProvider.notifier).state = true;
      FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.user)
          .doc(firebaseAuth!.uid)
          .collection(FirebaseCollectionNames.chat)
          .doc(receiverId)
          .collection(FirebaseCollectionNames.message)
          .orderBy('sentTime', descending: false)
          .snapshots(includeMetadataChanges: true)
          .listen((messages) {
        state = messages.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList();
        scrollDown();
      });
      return state;
    } catch (e) {
      rethrow;
    } finally {
      ref.read(messageLoadingProvider.notifier).state = false;
    }
  }

  void clearState() => state.clear();

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}

final messageLoadingProvider = StateProvider((ref) => false);
