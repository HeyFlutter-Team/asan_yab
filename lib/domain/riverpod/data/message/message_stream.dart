import 'dart:async';
import 'package:asan_yab/domain/riverpod/data/message/message_seen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile_data_provider.dart';
import 'message_history.dart';
import 'messages_notifier.dart';

class Suspend {
  final WidgetRef ref;
  late StreamController<int> _streamController;
  late StreamSubscription<int> _streamSubscription;

  Suspend(this.ref);

  Future<void> suspendUser(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      _streamController = StreamController<int>();
      _streamSubscription = _streamController.stream.listen((_) async {
        // Your code to be executed periodically
        if (context.mounted && FirebaseAuth.instance.currentUser != null) {
          ref.watch(messageHistory.notifier).getMessageHistory();
          ref.watch(messageNotifierProvider.notifier).fetchMessage();
          ref.watch(seenMassageProvider.notifier).isNewMassage();
          ref.watch(userDetailsProvider.notifier).getCurrentUserFollowCounts();
        }
      });

      Timer.periodic(const Duration(seconds: 1), (Timer t) {
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
