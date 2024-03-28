import 'package:asan_yab/data/models/message/message_model.dart';
import 'package:asan_yab/domain/riverpod/data/message/delete_messages.dart';
import 'package:asan_yab/domain/riverpod/data/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:timeago/timeago.dart' as timeago;

class MessageBubbleWidget extends ConsumerStatefulWidget {
  const MessageBubbleWidget({
    super.key,
    required this.isMe,
    required this.message,
    required this.isImage,
    required this.urlImage,
    this.isGift = false,
    required this.replayMessage,
  });
  final bool isMe;
  final bool isImage;
  final MessageModel message;
  final String urlImage;
  final bool isGift;
  final String replayMessage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubbleWidget> {
  late Offset tapXY;
  late RenderBox overlay;

  @override
  Widget build(BuildContext context) {
    final themDark = Theme.of(context).brightness == Brightness.dark;

    overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final profileDetails = ref.watch(profileDetailsProvider);
    return Align(
      alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
      child: Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.isMe == false)
            Container(
              margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
              child: widget.urlImage != ''
                  ? CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(widget.urlImage),
                      maxRadius: 20,
                    )
                  : const CircleAvatar(
                      backgroundImage: AssetImage('assets/avatar.jpg'),
                      maxRadius: 20,
                    ),
            ),
          Flexible(
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: widget.isMe
                    ? themDark
                        ? Colors.white70
                        : Colors.black12
                    : Colors.brown.shade300,
                borderRadius: widget.isMe
                    ? const BorderRadius.only(
                        topRight: Radius.circular(22),
                        topLeft: Radius.circular(22),
                        bottomLeft: Radius.circular(22),
                      )
                    : const BorderRadius.only(
                        topRight: Radius.circular(22),
                        topLeft: Radius.circular(22),
                        bottomRight: Radius.circular(22),
                      ),
              ),
              margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: widget.isMe
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  widget.isImage
                      ? Column(
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(widget
                                        .message.content
                                        .split(' ')
                                        .first),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTapDown: getPosition,
                          onLongPress: () => showMenu(
                              context: context,
                              position: relRectSize,
                              items: [
                                PopupMenuItem(
                                  onTap: () {
                                    if (widget.isMe) {
                                      ref
                                          .read(deleteMessagesProvider.notifier)
                                          .deleteSingleMessage(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              widget.message.receiverId,
                                              widget.message.content);
                                    }
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Deleted',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () => ref
                                      .read(replayProvider.notifier)
                                      .state = widget.message.content,
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Replay',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                          child: Column(
                            children: [
                              widget.replayMessage == ''
                                  ? const SizedBox()
                                  : Text(
                                      "replay to: ${widget.message.replayMessage}",
                                      style: TextStyle(
                                          color: widget.isMe
                                              ? Colors.black
                                              : Colors.black),
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(widget.message.content,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: widget.isMe
                                        ? Colors.black
                                        : Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 50),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
          if (widget.isMe == true)
            Container(
              margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
              child: profileDetails!.imageUrl.isEmpty
                  ? const CircleAvatar(
                      backgroundImage: AssetImage('assets/avatar.jpg'),
                      maxRadius: 20,
                    )
                  : CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(profileDetails.imageUrl),
                      maxRadius: 20,
                    ),
            ),
        ],
      ),
    );
  }

  RelativeRect get relRectSize =>
      RelativeRect.fromSize(tapXY & const Size(40, 40), overlay.size);

  void getPosition(TapDownDetails detail) => tapXY = detail.globalPosition;
}
