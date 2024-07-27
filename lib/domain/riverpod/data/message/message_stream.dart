import 'dart:async';
import 'package:asan_yab/core/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../isOnline.dart';
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
      if (context.mounted) {
        ref.watch(isDisposedProvider).streamController =
            StreamController<int>();
        ref.watch(isDisposedProvider).streamSubscription = ref
            .watch(isDisposedProvider)
            .streamController
            ?.stream
            .listen((_) async {
          if (FirebaseAuth.instance.currentUser != null && context.mounted && Utils.netIsConnected(ref)) {
             ref.watch(seenMassageProvider.notifier).isNewMassage();
             ref.watch(messageHistory.notifier).getMessageHistory();
             ref.watch(messageNotifierProvider.notifier).fetchMessage();
             ref
                .watch(userDetailsProvider.notifier)
                .getCurrentUserFollowCounts();
          }
        });

        ref.read(isDisposedProvider.notifier).periodicTimer =
            Timer.periodic(const Duration(seconds: 1), (Timer t) {
              if(ref.context.mounted){
              if (ref
                  .watch(isDisposedProvider)
                  .streamController
                  ?.isClosed ==
                  false) {
                ref
                    .read(isDisposedProvider.notifier)
                    .streamController
                    ?.add(1);
              }
            } });
      }
    } catch (e) {
      debugPrint('Error suspending user: $e');
      // Handle error accordingly
    }
  }
}
