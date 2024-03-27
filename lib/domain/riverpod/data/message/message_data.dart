import 'package:asan_yab/data/models/message/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider =
    StateNotifierProvider<MessageProvider, List<MessageModel>>(
        (ref) => MessageProvider([], ref));

class MessageProvider extends StateNotifier<List<MessageModel>> {
  final Ref ref;
  ScrollController scrollController = ScrollController();
  MessageProvider(super.state, this.ref);
  List<MessageModel> getMessages(String receiverId) {
    try {
      ref.read(messageLoadingProvider.notifier).state = true;
      FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chat')
          .doc(receiverId)
          .collection('messages')
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

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final maxScroll = scrollController.position.maxScrollExtent;
        scrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

final messageLoadingProvider = StateProvider((ref) => false);

class ReplayScroll extends ChangeNotifier {
  double savedScrollPosition = 0.0;
  void saveScrollPosition(WidgetRef ref) {
    savedScrollPosition =
        ref.read(messageProvider.notifier).scrollController.position.pixels;
    notifyListeners();
    print('savedScrool $savedScrollPosition');
  }

  void setSavedScrollPosition(WidgetRef ref) {
    ref
        .read(messageProvider.notifier)
        .scrollController
        .jumpTo(savedScrollPosition);
    notifyListeners();

  }
}


final replayPositionProvider = ChangeNotifierProvider<ReplayScroll>((ref) => ReplayScroll());