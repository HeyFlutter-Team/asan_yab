import 'dart:async';
import 'package:asan_yab/domain/riverpod/data/message/seen_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'message_history.dart';
import 'messages_notifier.dart';

class MessageSuspend {
  final WidgetRef ref;
  late StreamController<int> _streamController;
  late StreamSubscription<int> _streamSubscription;

  MessageSuspend(this.ref);

  Future<void> suspendUser(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      _streamController = StreamController<int>();
      _streamSubscription = _streamController.stream.listen((_) async {
        if (context.mounted && FirebaseAuth.instance.currentUser != null) {
          ref.watch(messageHistory.notifier).getMessageHistory();
          ref.watch(messageNotifierProvider.notifier).fetchMessage();
          ref.watch(seenMassageProvider.notifier).isNewMassage();
        }
      });

      Timer.periodic(const Duration(seconds: 1), (_) {
        if (_streamController.isClosed == false) {
          _streamController.add(1);
        }
      });
    }
  }

  void dispose() {
    _streamController.close();
    _streamSubscription.cancel();
  }
}
