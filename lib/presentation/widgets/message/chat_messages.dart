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
        ? const Center(
            child: Text(
                'No Message'))
        : Padding(
          padding: const EdgeInsets.only(bottom: 75),
          child: ListView.builder(
            controller:
                ref.watch(messageProvider.notifier).scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              if (index < 0 || index >= messages.length) {
                // Return an empty container or handle this case appropriately
                return Container();
              }
              final isTextMessage =
                  messages[index].messageType == MessageType.text;

              final isMe = receiverId != messages[index].senderId;
              return isTextMessage
                  ? MessageBubble(
                      replayMessage: messages[index].replayMessage,
                      urlImage: urlImage,
                      isMe: isMe,
                      message: messages[index],
                      isImage: false,
                    )
                  : MessageBubble(
                      replayMessage: messages[index].replayMessage,
                      urlImage: urlImage,
                      isMe: isMe,
                      message: messages[index],
                      isImage: true,
                    );
            },
          ),
        );
  }
}
