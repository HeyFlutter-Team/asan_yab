import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/delete_message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/riverpod/data/message/message_data.dart';
// import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends ConsumerStatefulWidget {
  const MessageBubble(
      {super.key,
      required this.isMe,
      required this.message,
      required this.isImage,
      required this.urlImage,
      this.isGift = false,
      required this.replayMessage,
      required this.friendName});
  final bool isMe;
  final bool isImage;
  final MessageModel message;
  final String urlImage;
  final bool isGift;
  final String replayMessage;
  final String friendName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  late Offset tapXY;
  late RenderBox overlay;
  final GlobalKey _replayContainerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final themDark = Theme.of(context).brightness == Brightness.dark;

    overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final profileDetails = ref.watch(userDetailsProvider);
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
              constraints: BoxConstraints(
                minWidth: 1,
                maxWidth: MediaQuery.of(context).size.width * 0.66,
              ),
              decoration: BoxDecoration(
                color: widget.isMe
                    ? themDark
                        ? Colors.white70
                        : Colors.black12
                    : Colors.brown.shade300,
                // color: widget.isMe ? Colors.purple : Colors.black,
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
              child: InkWell(
                onTapDown: getPosition,
                onLongPress: () =>
                    showMenu(context: context, position: relRectSize, items: [
                  if (widget.isMe)
                    PopupMenuItem(
                      onTap: () {
                        if (widget.isMe) {
                          ref
                              .read(deleteMessagesProvider.notifier)
                              .deleteSingleMessage(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  widget.message.receiverId,
                                  widget.message.content);
                        }
                      },
                      child: const Text(
                        'Deleted',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ),
                  PopupMenuItem(
                    onTap: () {
                      ref.read(replayProvider.notifier).state =
                          widget.message.content;
                      ref.read(emojiShowingProvider.notifier).state =
                      !ref.watch(emojiShowingProvider);
                      if (ref.watch(emojiShowingProvider)) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                      SystemChannels.textInput.invokeMethod('TextInput.show')
                      .whenComplete(() => ref.read(messageProvider.notifier).scrollDown());

                    },
                    child: const Text(
                      'Replay',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ),
                ]),
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
                        : Column(
                            children: [
                              widget.replayMessage == ''
                                  ? const SizedBox()
                                  : KeyedSubtree(
                                      key: _replayContainerKey,
                                      child: InkWell(
                                        onTap: () {
                                          RenderBox renderBox =
                                              _replayContainerKey
                                                      .currentContext!
                                                      .findRenderObject()
                                                  as RenderBox;
                                          double offset = renderBox
                                              .localToGlobal(Offset.zero)
                                              .dy;

                                          ref
                                              .read(messageProvider.notifier)
                                              .scrollController
                                              .animateTo(
                                                offset,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeInOut,
                                              );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 8, right: 10, left: 10),
                                          padding: const EdgeInsets.only(
                                              right: 5, left: 5, bottom: 5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                          child: SizedBox(
                                            height: 60,
                                            child: ListTile(
                                              title: Text(
                                                textDirection: widget.isMe
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                widget.isMe
                                                    ? widget.friendName
                                                    : '${profileDetails?.name}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                              subtitle: Text(
                                                textDirection: widget.isMe
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                widget.message.replayMessage
                                                        .isNotEmpty
                                                    ? widget
                                                        .message.replayMessage
                                                        .substring(
                                                            0,
                                                            widget
                                                                        .message
                                                                        .replayMessage
                                                                        .length >
                                                                    20
                                                                ? 19
                                                                : widget
                                                                    .message
                                                                    .replayMessage
                                                                    .length)
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                    // const SizedBox(height: 5),
                    // Text(timeago.format(message.sentTime.toLocal()))
                  ],
                ),
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

  // ↓ create the RelativeRect from size of screen and where you tapped
  RelativeRect get relRectSize =>
      RelativeRect.fromSize(tapXY & const Size(40, 40), overlay.size);

  // ↓ get the tap position Offset
  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }
}
