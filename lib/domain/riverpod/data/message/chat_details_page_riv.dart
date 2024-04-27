import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/message/textfield_message.dart';
import 'message.dart';
import 'message_data.dart';
import 'message_history.dart';
import 'message_seen.dart';
import 'messages_notifier.dart';

final handleWillPopProvider =
StateNotifierProvider<HandleWillPopNotifier, bool>((ref) {
  return HandleWillPopNotifier();
});

class HandleWillPopNotifier extends StateNotifier<bool> {
  HandleWillPopNotifier() : super(true);

  Future<void> handleWillPop(BuildContext context,WidgetRef ref,String userId) async {
    ref.read(activeChatIdProvider.notifier).state='';
    if (ref.watch(emojiShowingProvider)) {
      ref.read(emojiShowingProvider.notifier).state = false;
    } else {
      FocusScope.of(context).unfocus();
      if (ref
          .watch(messageProfileProvider.notifier)
          .textController
          .text
          .isNotEmpty ||
          ref.watch(replayProvider.notifier).state.isNotEmpty) {
        ref.read(textFieldMessagesListPro.notifier).state.add(
          TextFieldMessage(
              userId: userId,
              textFieldMessage: ref
                  .watch(messageProfileProvider.notifier)
                  .textController
                  .text,
              replayText: ref.watch(replayProvider),
              editingMessage: ref.watch(editingMessageDetails).content

          ),
        );
      } else {
        ref
            .read(textFieldMessagesListPro.notifier)
            .state
            .removeWhere((element) => element.userId == userId);
      }
      if (ref.watch(replayProvider.notifier).state.isNotEmpty) {
        ref.read(replayProvider.notifier).state = '';
      }
      ref.read(messageProfileProvider.notifier).textController.clear();
      if(ref.watch(editingMessageDetails).content.isNotEmpty){
        ref.read(editingMessageDetails.notifier).setContent('');
      }

      if (ref.watch(emojiShowingProvider)) {
        ref.read(emojiShowingProvider.notifier).state = false;
      }
      if (FirebaseAuth.instance.currentUser != null) {
        ref.read(messageNotifierProvider.notifier).fetchMessage();
        ref.read(messageHistory.notifier).getMessageHistory();
        ref
            .read(seenMassageProvider.notifier)
            .messageIsSeen(
            userId, FirebaseAuth.instance.currentUser!.uid)
            .whenComplete(() async {
          if (context.mounted) {
            await ref.read(seenMassageProvider.notifier).isNewMassage();
          }
        });
      }
    }
    ref
        .read(isMessageEditing.notifier)
        .state = false;
    print('younis method call and work');
  }
}
