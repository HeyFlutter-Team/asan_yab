import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../profile_data_provider.dart';
import 'message_history.dart';
import 'message_seen.dart';
import 'message_stream_riv.dart';
import 'messages_notifier.dart';

class Suspend {
  final WidgetRef ref;


  Suspend(this.ref);

  Future<void> suspendUser(BuildContext context) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (context.mounted) {
        ref.watch(isDisposedProvider).streamController = StreamController<int>();
        ref.watch(isDisposedProvider).streamSubscription = ref.watch(isDisposedProvider).streamController?.stream.listen((_) async {
          if (FirebaseAuth.instance.currentUser != null && context.mounted) {
            await ref.read(messageHistory.notifier).getMessageHistory();
            await ref.read(messageNotifierProvider.notifier).fetchMessage();
            await ref.read(seenMassageProvider.notifier).isNewMassage();
            await ref
                .read(userDetailsProvider.notifier)
                .getCurrentUserFollowCounts();
          }
        });

        ref.read(isDisposedProvider.notifier).periodicTimer =
            Timer.periodic(const Duration(seconds: 1), (Timer t) {
          if (ref.watch(isDisposedProvider).streamController?.isClosed == false) {
            ref.read(isDisposedProvider.notifier).streamController?.add(1);
          }
        });
      }
    } catch (e) {
      debugPrint('Error suspending user: $e');
      // Handle error accordingly
    }
  }

}
