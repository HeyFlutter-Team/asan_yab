import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_data.dart';
import 'package:asan_yab/presentation/widgets/message/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessages extends ConsumerWidget {
  const ChatMessages(
      {super.key, required this.receiverId, required this.urlImage});
  final String receiverId;
  final String urlImage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageProvider);
    return messages.isEmpty
        ? Container(
            decoration: const BoxDecoration(color: Colors.white70),
            child: Center(
                child: Text(
                    'No Message')), //AppLocalizations.of(context)?.noMessage ??
          )
        : Container(
            decoration: const BoxDecoration(color: Colors.white12),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 75),
              child: ListView.builder(
                controller:
                    ref.watch(messageProvider.notifier).scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final isTextMessage =
                      messages[index].messageType == MessageType.text;

                  final isMe = receiverId != messages[index].senderId;
                  return isTextMessage
                      ? MessageBubble(
                          urlImage: urlImage,
                          isMe: isMe,
                          message: messages[index],
                          isImage: false,
                        )
                      : MessageBubble(
                          urlImage: urlImage,
                          isMe: isMe,
                          message: messages[index],
                          isImage: true,
                        );
                },
              ),
            ),
          );
  }
}
