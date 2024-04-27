import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_bubble_riv.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/presentation/widgets/message/message_bubble_widgets/message_content_in_chat_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/users.dart';
import '../../../../domain/riverpod/data/message/message_data.dart';
import '../../../pages/profile/other_profile.dart';
import '../app_bar_chat_details.dart';
import 'dart:ui' as ui;

class MessageBubble extends ConsumerStatefulWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
    required this.isImage,
    required this.urlImage,
    this.isGift = false,
    required this.replayMessage,
    required this.isMessageSeen,
    required this.friendName,
    required this.userId,
    required this.replayMessageIndex,
    required this.user,
    required this.replayIsMine,
  });
  final bool isMe;
  final bool isImage;
  final MessageModel message;
  final String urlImage;
  final bool isGift;
  final String replayMessage;
  final String friendName;
  final bool isMessageSeen;
  final String userId;
  final int replayMessageIndex;
  final Users user;
  final bool replayIsMine;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble>
    with SingleTickerProviderStateMixin {
  late Offset tapXY;
  late RenderBox overlay;
  final GlobalKey _replayContainerKey = GlobalKey();
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragStartX = 0.0;
  double _dragEndX = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themDark = Theme.of(context).brightness == Brightness.dark;
    overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final profileDetails = ref.watch(userDetailsProvider);
    return Align(
      alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
      child: Transform.translate(
        offset: Offset(_animation.value, -10.0),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Row(
            mainAxisAlignment:
                widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (widget.isMe == false)
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    ref.read(loadingIconChat.notifier).state = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherProfile(
                          isFromChat: true,
                          uid: widget.userId,
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
                    child: widget.urlImage != ''
                        ? CircleAvatar(
                            maxRadius: 20,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              child: CachedNetworkImage(
                                imageUrl: widget.urlImage,
                                errorListener: (value) =>
                                    Image.asset('assets/Avatar.png'),
                                placeholder: (context, url) =>
                                    Image.asset('assets/Avatar.png'),
                              ),
                            ),
                          )
                        : const CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar.jpg'),
                            maxRadius: 20,
                          ),
                  ),
                ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: widget.message.isMessageEdited == true
                        ? MediaQuery.of(context).size.width * 0.36
                        : MediaQuery.of(context).size.width * 0.24,
                    maxWidth: MediaQuery.of(context).size.width * 0.66,
                  ),
                  decoration: BoxDecoration(
                    color: ref.watch(replayColor(widget.replayMessageIndex))
                        ? widget.isMe
                            ? Colors.grey.shade700
                            : Colors.brown.shade800
                        : _shouldHideDecoration() && widget.replayMessage == ''
                            ? Colors.transparent
                            : widget.isMe
                                ? themDark
                                    ? Colors.white
                                    : Colors.white
                                : Colors.brown.shade300,
                    borderRadius: widget.isMe
                        ? const BorderRadius.only(
                            topRight: Radius.circular(22),
                            topLeft: Radius.circular(22),
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(0))
                        : const BorderRadius.only(
                            topRight: Radius.circular(22),
                            topLeft: Radius.circular(22),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(22)),
                  ),
                  margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
                  padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      ref
                          .read(handleOnHorizontalDragEndProvider.notifier)
                          .handleOnHorizontalDragEnd(
                              ref: ref,
                              context: context,
                              message: widget.message,
                              replayMessageIndex: widget.replayMessageIndex,
                              controller: _controller,
                              animation: _animation,
                              details: details,
                              onHorizontalDragEnd: _onHorizontalDragEnd,
                              startAnimation: _startAnimation,
                              dragEndX: _dragEndX,
                              dragStartX: _dragStartX);
                      ref
                          .read(replayPositionProvider.notifier)
                          .scrollItemByTime(
                              ref,
                              DateTime.parse(
                                  ref.watch(replayMessageTimeProvider)));

                    },
                    onHorizontalDragUpdate: (details) {
                      _onHorizontalDragUpdate(details);
                    },
                    onHorizontalDragStart: _onHorizontalDragStart,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTapDown: getPosition,
                      onTap: () {
                        ref.read(showMenuOpenedProvider.notifier).state = false;
                      },
                      onLongPress: () {

                        ref
                            .read(messageOnLongPressProvider.notifier)
                            .messageOnLongPress(
                                context,
                                ref,
                                widget.replayMessageIndex,
                                widget.message,
                                widget.isMe,
                                widget.userId,
                                widget.friendName,
                                themDark);
                      },
                      child:
                      MessageContentInChat(shouldHideDecoration: _shouldHideDecoration,
                          message: widget.message,
                          isMe: widget.isMe,
                          friendName: widget.friendName,
                          replayIsMine: widget.replayIsMine,
                          replayMessage: widget.replayMessage,
                          isMessageSeen: widget.isMessageSeen,
                          urlImage: widget.urlImage,
                          calculateFontSize: _calculateFontSize,
                          isImage: widget.isImage,
                          replayContainerKey: _replayContainerKey)
                    ),
                  ),
                ),
              ),
              //my profile in chat
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
        ),
      ),
    );
  }

  RelativeRect get relRectSize =>
      RelativeRect.fromSize(tapXY & const Size(40, 40), overlay.size);

  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }

  void _startAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.forward(from: 0.0);
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    double dx = details.globalPosition.dx;
    if (dx < _dragStartX) {
      _dragEndX = dx;
      final animationValue = -(_dragEndX - _dragStartX).abs() /
          MediaQuery.of(context).size.width *
          70.0;
      _animation = Tween<double>(begin: animationValue, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ),
      );
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    double distance = _dragEndX - _dragStartX;
    if (distance.abs() > 50) {
      _startAnimation();
    } else {
      _controller.reset(); // Reset animation controller
    }
  }

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
    final fontSizes = [80.0, 70.0, 60.0, 40.0, 25.0, 20.0];

    for (int i = 0; i < thresholds.length; i++) {
      if (message.length <= thresholds[i] && isEmoji(message)) {
        return fontSizes[i];
      }
    }
    return 15;
  }
}
