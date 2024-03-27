import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_data.dart';
import 'package:asan_yab/presentation/widgets/message/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ChatMessages extends ConsumerStatefulWidget {
  const ChatMessages(
      {super.key,
      required this.receiverId,
      required this.urlImage,
      required this.friendName});
  final String receiverId;
  final String urlImage;
  final String friendName;

  @override
  ConsumerState<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<ChatMessages> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(messageProvider);
      ref.read(messageProvider.notifier).scrollDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        controller: ref.watch(messageProvider.notifier).scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          if (index < 0 || index >= messages.length) {
            return Container();
          }
          final isTextMessage = messages[index].messageType == MessageType.text;

          final isMe = widget.receiverId != messages[index].senderId;
          return isTextMessage
              ? MessageBubble(
                  replayMessage: messages[index].replayMessage,
                  urlImage: widget.urlImage,
                  isMe: isMe,
                  message: messages[index],
                  isImage: false,
                  friendName: widget.friendName,
                )
              : MessageBubble(
                  replayMessage: messages[index].replayMessage,
                  urlImage: widget.urlImage,
                  isMe: isMe,
                  message: messages[index],
                  isImage: true,
                  friendName: widget.friendName,
                );
        },
      ),
    );
  }
}
