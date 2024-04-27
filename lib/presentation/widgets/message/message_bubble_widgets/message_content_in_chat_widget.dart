import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;
import '../../../../domain/riverpod/data/message/message_data.dart';

class MessageContentInChat extends ConsumerStatefulWidget {
  final bool Function() shouldHideDecoration;
  final String replayMessage;
  final bool isMe;
  final String urlImage;
  final bool isImage;
  final MessageModel message;
  final GlobalKey<State<StatefulWidget>> replayContainerKey;
  final bool replayIsMine;
  final String friendName;
  final bool isMessageSeen;
  final double Function(String) calculateFontSize;
  const MessageContentInChat(
      {super.key,
      required this.shouldHideDecoration,
      required this.message,
      required this.isMe,
      required this.friendName,
      required this.replayIsMine,
      required this.replayMessage,
      required this.isMessageSeen,
      required this.urlImage,
      required this.calculateFontSize,
      required this.isImage,
      required this.replayContainerKey});

  @override
  ConsumerState<MessageContentInChat> createState() =>
      _MessageContentInChatState();
}

class _MessageContentInChatState extends ConsumerState<MessageContentInChat> {
  @override
  Widget build(BuildContext context) {
    final themDark = Theme.of(context).brightness == Brightness.dark;
    final myDetails = ref.watch(userDetailsProvider);
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              widget.shouldHideDecoration() && widget.replayMessage == ''
                  ? widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start
                  : widget.isMe
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
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: CachedNetworkImage(
                            imageUrl: widget.urlImage,
                            placeholder: (context, url) =>
                                Image.asset('assets/Avatar.png'),
                            errorListener: (value) =>
                                Image.asset('assets/Avatar.png'),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      widget.replayMessage == ''
                          ? const SizedBox()
                          : KeyedSubtree(
                              key: widget.replayContainerKey,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final replayPositionNotifier =
                                      ref.read(replayPositionProvider.notifier);
                                  //
                                  if (mounted) {
                                    replayPositionNotifier.scrollItemByTime(
                                        ref,
                                        DateTime.parse(
                                            widget.message.replayMessageTime));

                                    print(widget.message.replayMessageIndex);
                                    print('on Tap replay 2');
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 8, right: 10, left: 10),
                                  padding: const EdgeInsets.only(
                                      right: 5, left: 5, bottom: 5),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  child: SizedBox(
                                    height: 60,
                                    child: ListTile(
                                      title: Text(
                                        widget.message.receiverId !=
                                                myDetails?.uid
                                            ? widget.replayIsMine
                                                ? 'You'
                                                : widget.friendName.length > 9
                                                    ? widget.friendName
                                                        .substring(0, 9)
                                                    : widget.friendName
                                            : widget.replayIsMine
                                                ? widget.friendName.length > 9
                                                    ? widget.friendName
                                                        .substring(0, 9)
                                                    : widget.friendName
                                                : 'You',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                      ),
                                      subtitle: Text(
                                        widget.message.replayMessage.isNotEmpty
                                            ? widget.message.replayMessage
                                                .substring(
                                                    0,
                                                    widget.message.replayMessage
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
                                          color: Colors.black.withOpacity(0.6),
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
                      Text(
                        widget.message.content,
                        style: TextStyle(
                          fontSize:
                              widget.calculateFontSize(widget.message.content),
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 50,
                      ),
                    ],
                  ),
            SizedBox(height: widget.shouldHideDecoration() ? 25 : 15),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Container(
              padding: widget.shouldHideDecoration()
                  ? const EdgeInsets.all(3)
                  : EdgeInsets.zero,
              constraints: BoxConstraints(
                  minWidth: 1,
                  maxWidth: widget.message.isMessageEdited == true
                      ? MediaQuery.of(context).size.width * 0.36
                      : MediaQuery.of(context).size.width * 0.24),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  color: widget.shouldHideDecoration()
                      ? themDark
                          ? Colors.black.withOpacity(0.4)
                          : Colors.black.withOpacity(0.2)
                      : null),
              child: Row(
                verticalDirection: VerticalDirection.down,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isMe && widget.isMessageSeen)
                    const Icon(
                      Icons.done_all,
                      color: Colors.blue,
                      size: 14,
                    ),
                  const SizedBox(width: 4),
                  if (widget.isMe && !widget.isMessageSeen)
                    Icon(
                      Icons.done,
                      color: widget.shouldHideDecoration()
                          ? Colors.white
                          : themDark
                              ? Colors.grey.shade800
                              : Colors.black45,
                      size: 14,
                    ),
                  const SizedBox(width: 2),
                  Text(
                    DateFormat('HH:mm').format(
                      widget.message.sentTime.toLocal(),
                    ),
                    style: TextStyle(
                        color: widget.shouldHideDecoration()
                            ? Colors.white
                            : themDark
                                ? Colors.grey.shade800
                                : Colors.black45,
                        fontSize: 11),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  if (widget.message.isMessageEdited)
                    Text(
                      'edited',
                      style: TextStyle(
                          color: widget.shouldHideDecoration()
                              ? Colors.white
                              : themDark
                                  ? Colors.grey.shade800
                                  : Colors.black45),
                    )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
