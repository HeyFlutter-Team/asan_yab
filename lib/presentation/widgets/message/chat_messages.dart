import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_data.dart';
import 'package:asan_yab/presentation/widgets/message/message_bubble_widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../data/models/users.dart';
import '../../../data/repositoris/message/message_repo.dart';
import '../../../domain/riverpod/data/message/message.dart';
import '../../../domain/riverpod/data/other_user_data.dart';

const scrollPositionKey = PageStorageKey('scroll_position');

class ChatMessages extends ConsumerStatefulWidget {
  const ChatMessages(
      {super.key,
        required this.receiverId,
        required this.urlImage,
        required this.friendName,
        required this.user});
  final String receiverId;
  final String urlImage;
  final String friendName;
  final Users user;

  @override
  ConsumerState<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<ChatMessages> {

  @override
  void initState() {
    super.initState();
 WidgetsBinding.instance.addPostFrameCallback((_) async{
  ref.read(messageProvider.notifier).getMessages(widget.receiverId);
 if(mounted){
     ref.read(messageProvider.notifier).listenToScrollPosition();
 }
 });
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final firebaseMessages = ref.watch(messageProvider);
    final localMessages = ref.watch(localMessagesProvider);
    //
    final combinedMessages = [...firebaseMessages, ...localMessages];
    combinedMessages.sort((a, b) => b.sentTime.compareTo(a.sentTime));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: ScrollablePositionedList.builder(
        reverse: true,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: combinedMessages.length,
        key: scrollPositionKey,
        itemScrollController: ref.watch(messageProvider.notifier).scrollController,
        itemPositionsListener: ref.watch(messageProvider.notifier).itemPositionsListener,
        itemBuilder: (context, index) {
          final messages = [...combinedMessages];
          if (index < 0 || index >= messages.length) {
            return Container(
              height: 1,
            );
          }
           MessageRepo()
              .markMessageAsSeen('${ref.watch(otherUserProvider)?.uid}');
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
            isMessageSeen: messages[index].isSeen,
            userId: widget.receiverId,
            replayMessageIndex: index,
            user: widget.user,
            replayIsMine: messages[index].replayIsMine,
          )
              : MessageBubble(
            replayMessage: messages[index].replayMessage,
            urlImage: widget.urlImage,
            isMe: isMe,
            message: messages[index],
            isImage: true,
            friendName: widget.friendName,
            isMessageSeen: messages[index].isSeen,
            userId: widget.receiverId,
            replayMessageIndex: index,
            user: widget.user,
            replayIsMine: messages[index].replayIsMine,
          );
        },
      ),
    );
  }
}
