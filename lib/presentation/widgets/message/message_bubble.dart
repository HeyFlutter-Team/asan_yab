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
  bool isEmoji(String text) {
    final RegExp regexEmoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );

    return text.runes
        .every((rune) => regexEmoji.hasMatch(String.fromCharCode(rune)));
  }

  bool _shouldHideDecoration() {
    return isEmoji(widget.message.content);
  }

  double _calculateFontSize(String message) {
    final thresholds = [2, 4, 6, 8, 10, 12];
    final fontSizes = [60.0, 50.0, 40.0, 30.0, 25.0, 20.0];

    for (int i = 0; i < thresholds.length; i++) {
      if (message.length <= thresholds[i] && isEmoji(message)) {
        return fontSizes[i];
      }
    }
    return 16;
  }

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
                      maxRadius: 20,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        child: CachedNetworkImage(
                          imageUrl: widget.urlImage,
                          errorListener: (value) =>  Image.asset(
                              'assets/Avatar.png'),
                          placeholder: (context, url) =>  Image.asset(
                              'assets/Avatar.png'),
                        ),
                      ),
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
                color: _shouldHideDecoration() && widget.replayMessage == ''
                    ? Colors.transparent
                    : widget.isMe
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
              child: GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) {
                  if (details.primaryVelocity! < 20) {
                    ref.read(emojiShowingProvider.notifier).state = false;
                    ref.read(replayProvider.notifier).state =
                        widget.message.content;

                    if (ref.watch(emojiShowingProvider)) {
                      FocusScope.of(context).unfocus();
                    }
                    SystemChannels.textInput
                        .invokeMethod('TextInput.show')
                        .whenComplete(() =>
                        ref.read(messageProvider.notifier).scrollDown());                  }},
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
                        ref.read(replayPositionProvider.notifier).saveScrollPosition(ref);

                        ref.read(emojiShowingProvider.notifier).state = false;
                        ref.read(replayProvider.notifier).state =
                            widget.message.content;

                        if (ref.watch(emojiShowingProvider)) {
                          FocusScope.of(context).unfocus();
                        }
                        SystemChannels.textInput
                            .invokeMethod('TextInput.show')
                            .whenComplete(() =>
                                ref.read(messageProvider.notifier).scrollDown());
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
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.urlImage,
                                      placeholder: (context, url) =>  Image.asset(
                                          'assets/Avatar.png'),
                                      errorListener: (value) =>  Image.asset(
                                          'assets/Avatar.png'),
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
                                        key: _replayContainerKey,
                                        child: InkWell(
                                          onTap: () {


                                            ref.read(replayPositionProvider.notifier).setSavedScrollPosition(ref);
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
                                Text(
                                  widget.message.content,
                                  style: TextStyle(
                                    fontSize: _calculateFontSize(
                                        widget.message.content),
                                    color:
                                        widget.isMe ? Colors.black : Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 50,
                                ),
                              ],
                            ),
                      // const SizedBox(height: 5),
                      // Text(timeago.format(message.sentTime.toLocal()))
                    ],
                  ),
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
                      maxRadius: 20,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        child: CachedNetworkImage(
                          imageUrl: profileDetails.imageUrl,
                          errorListener: (value) =>
                              const AssetImage('assets/avatar.jpg'),
                          placeholder: (context, url) =>
                              Image.asset('assets/avatar.jpg'),
                        ),
                      ),
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
