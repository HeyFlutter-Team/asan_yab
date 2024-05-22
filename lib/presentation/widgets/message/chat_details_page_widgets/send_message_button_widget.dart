import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/message/message.dart';
import '../../../../data/models/message/textfield_message.dart';
import '../../../../data/models/users.dart';
import '../../../../domain/riverpod/config/message_notification_repo.dart';
import '../../../../domain/riverpod/data/message/delete_message.dart';
import '../../../../domain/riverpod/data/message/message.dart';
import '../../../../domain/riverpod/data/profile_data_provider.dart';
import '../../../pages/message_page/chat_details_page.dart';

class SendMessageButtonWidget extends StatelessWidget {
  const SendMessageButtonWidget({
    super.key,
    required this.themDark,
    required this.ref,
    required this.profileDetails,
    required this.newProfileUser,
    required this.widget,
  });

  final bool themDark;
  final WidgetRef ref;
  final Users profileDetails;
  final Users newProfileUser;
  final ChatDetailPage widget;

  @override
  Widget build(BuildContext context) {
    final replyMessageTime = ref.watch(replayMessageTimeProvider);
    final isMessageOnEdit = ref.watch(messageEditedProvider);
    final isReplyMine = ref.watch(replayIsMineProvider);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: themDark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
          elevation: 0,
          shape: const CircleBorder(),
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 10)),
      onPressed: ref.watch(isMessageEditing)
          ? () async {
        ref
            .read(isMessageEditing.notifier)
            .state = false;
        ref
            .read(
            hasTextFieldValueProvider
                .notifier)
            .state = false;
        await ref
            .read(deleteEditMessagesProvider
            .notifier)
            .editMessage(
            '${profileDetails.uid}',
            ref
                .watch(
                editingMessageDetails)
                .receiverId,
            ref
                .watch(
                editingMessageDetails)
                .content,
            ref
                .watch(
                messageProfileProvider
                    .notifier)
                .textController
                .text,
            '${ref.watch(editingMessageDetails).sentTime}')
            .whenComplete(() => ref
            .read(messageProfileProvider
            .notifier)
            .textController
            .clear());
      }
          : () async {
        if(ref.watch(messageProfileProvider.notifier).textController.text.isNotEmpty){
          ref.read(localMessagesProvider.notifier)
              .addMessage(
              MessageModel(
                  senderId: FirebaseAuth.instance.currentUser!.uid,
                  receiverId:newProfileUser.uid! ,
                  content:ref
                      .watch(messageProfileProvider
                      .notifier)
                      .textController.text ,
                  sentTime: DateTime.now().toUtc() ,
                  messageType: MessageType.text,
                  replayMessage:ref.watch(replayProvider),
                  isSeen:false ,
                  replayMessageIndex:ref.watch(
                      messageIndexProvider)+1 ,
                  replayIsMine:  isReplyMine,
                  isMessageEdited:isMessageOnEdit,
                  replayMessageTime: replyMessageTime
              )
          );
          MessageNotification
              .sendPushNotificationMessage(
              newProfileUser,
              ref
                  .read(messageProfileProvider
                  .notifier)
                  .textController
                  .text,
              ref.watch(
                  userDetailsProvider)!);
          print('hold check 1');
          ref
              .read(
              hasTextFieldValueProvider
                  .notifier)
              .state = false;
          ref
              .read(
              messageProfileProvider
                  .notifier)
              .sendText(
              receiverId:
              newProfileUser
                  .uid!,
              context: context,
              replayMessage:
              ref.watch(
                  replayProvider),
              replayMessageIndex:
              ref.watch(messageIndexProvider) +
                  1,
              ref: ref,
              replayIsMine:isReplyMine,
              messageEditedProvider:isMessageOnEdit,
              users:
              newProfileUser,
              replayMessageTime:
              replyMessageTime)
              .whenComplete(() {
            print('hold check 2');
            ref
                .read(replayProvider
                .notifier)
                .state = '';
            ref
                .read(
                textFieldMessagesListPro
                    .notifier)
                .state
                .removeWhere(
                    (element) =>
                element
                    .userId ==
                    widget.uid);
            ref
                .read(
                replayIsMineProvider
                    .notifier)
                .state = false;

            ref
                .read(
                messageProfileProvider
                    .notifier)
                .textController
                .clear();

          });
        }
      },
      child: Icon(
        ref.watch(isMessageEditing)
            ? Icons.check
            : Icons.send,
        color: Colors.blue.shade200,
        size: 24,
      ),
    );
  }
}
