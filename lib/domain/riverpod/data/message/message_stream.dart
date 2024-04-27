import 'dart:async';
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
          if (FirebaseAuth.instance.currentUser != null && context.mounted) {
            // print('myTest1');
             ref.watch(seenMassageProvider.notifier).isNewMassage();
            // // print('myTest2');
             ref.watch(messageHistory.notifier).getMessageHistory();
            // // print('myTest3');
             ref.watch(messageNotifierProvider.notifier).fetchMessage();
            // print('myTest4');
             ref
                .watch(userDetailsProvider.notifier)
                .getCurrentUserFollowCounts();
            // print('myTest5');
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
