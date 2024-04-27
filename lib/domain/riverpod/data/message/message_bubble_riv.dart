import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:popover/popover.dart';

import '../../../../data/models/message/message.dart';
import '../profile_data_provider.dart';
import 'delete_message.dart';
import 'message.dart';

//first
final handleOnHorizontalDragEndProvider =
    StateNotifierProvider<HandleOnHorizontalDragEndNotifier, bool>((ref) {
  return HandleOnHorizontalDragEndNotifier();
});

class HandleOnHorizontalDragEndNotifier extends StateNotifier<bool> {
  HandleOnHorizontalDragEndNotifier() : super(true);

  Future<void> handleOnHorizontalDragEnd(
      {required WidgetRef ref,
      required BuildContext context,
      required MessageModel message,
      required int replayMessageIndex,
      required AnimationController controller,
      required Animation<double> animation,
      required DragEndDetails details,
      required void Function(DragEndDetails) onHorizontalDragEnd,
      required void Function() startAnimation,
      required double dragEndX,
      required double dragStartX}) async {
    double distance = dragEndX - dragStartX;
    if (distance.abs() > 50) {
      startAnimation();
    } else {
      controller.reverse(from: animation.value);
    }
    if (details.primaryVelocity! < 20) {
      ref.read(emojiShowingProvider.notifier).state = false;
      ref.read(replayProvider.notifier).state = message.content;
      ref.read(replayMessageTimeProvider.notifier).state =
          '${message.sentTime}';

      if (ref.watch(emojiShowingProvider)) {
        FocusScope.of(context).unfocus();
      }
      SystemChannels.textInput.invokeMethod('TextInput.show');
      ref.read(messageProfileProvider.notifier).focusNode.requestFocus();
    }
    onHorizontalDragEnd(details);
    if (ref.watch(editingMessageDetails).content.isNotEmpty) {
      ref.read(isMessageEditing.notifier).state = false;
      ref.read(messageProfileProvider.notifier).textController.clear();
      ref.read(replayProvider.notifier).state = '';
      ref.read(replayIsMineProvider.notifier).state = false;
      ref.read(replayIsMineProvider.notifier).state = false;
      ref.read(messageIndexProvider.notifier).state = replayMessageIndex;
      ref.read(emojiShowingProvider.notifier).state = false;
      ref.read(replayProvider.notifier).state = message.content;
      ref.read(replayMessageTimeProvider.notifier).state =
          '${message.sentTime}';
      if (message.senderId == FirebaseAuth.instance.currentUser?.uid) {
        ref.read(replayIsMineProvider.notifier).state = true;
      }

      if (ref.watch(emojiShowingProvider)) {
        FocusScope.of(context).unfocus();
      }
    } else {
      ref.read(replayIsMineProvider.notifier).state = false;
      ref.read(messageIndexProvider.notifier).state = replayMessageIndex;
      ref.read(emojiShowingProvider.notifier).state = false;
      ref.read(replayProvider.notifier).state = message.content;
      ref.read(replayMessageTimeProvider.notifier).state =
          '${message.sentTime}';
      if (message.senderId == FirebaseAuth.instance.currentUser?.uid) {
        ref.read(replayIsMineProvider.notifier).state = true;
      }

      if (ref.watch(emojiShowingProvider)) {
        FocusScope.of(context).unfocus();
      }
      SystemChannels.textInput.invokeMethod('TextInput.show');
      ref.read(messageProfileProvider.notifier).focusNode.requestFocus();
    }
  }
}

//second
final messageOnLongPressProvider =
StateNotifierProvider<MessageOnLongPressNotifier, bool>((ref) {
  return MessageOnLongPressNotifier();
});

class MessageOnLongPressNotifier extends StateNotifier<bool>{
  MessageOnLongPressNotifier():super(true);

  Future<void> messageOnLongPress(
      BuildContext context,
      WidgetRef ref,
      int replayMessageIndex,
      MessageModel message,
      bool isMe,
      String userId,
      String friendName,
      bool themDark

      )async{
    showPopover(
        context: context,
        bodyBuilder: (context) => Column(children: [
          PopupMenuItem(
            onTap: () {
              if (ref
                  .watch(editingMessageDetails)
                  .content
                  .isNotEmpty) {
                ref
                    .read(isMessageEditing.notifier)
                    .state = false;
                ref
                    .read(messageProfileProvider.notifier)
                    .textController
                    .clear();
                ref.read(replayProvider.notifier).state =
                '';
                ref
                    .read(replayIsMineProvider.notifier)
                    .state = false;
                ref
                    .read(replayIsMineProvider.notifier)
                    .state = false;
                ref
                    .read(messageIndexProvider.notifier)
                    .state = replayMessageIndex;
                print(ref.watch(messageIndexProvider));
                print('on Tap replay ');
                ref
                    .read(emojiShowingProvider.notifier)
                    .state = false;
                ref.read(replayProvider.notifier).state =
                    message.content;
                ref.read(replayMessageTimeProvider.notifier).state =
                '${message.sentTime}';
                if (message.senderId ==
                    FirebaseAuth
                        .instance.currentUser?.uid) {
                  ref
                      .read(replayIsMineProvider.notifier)
                      .state = true;
                }


                if (ref.watch(emojiShowingProvider)) {
                  FocusScope.of(context).unfocus();
                }
                SystemChannels.textInput
                    .invokeMethod('TextInput.show');
                ref
                    .read(
                    messageProfileProvider.notifier)
                    .focusNode.requestFocus();
              } else {
                ref
                    .read(replayIsMineProvider.notifier)
                    .state = false;
                ref
                    .read(messageIndexProvider.notifier)
                    .state = replayMessageIndex;
                print(ref.watch(messageIndexProvider));
                print('on Tap replay ');
                ref
                    .read(emojiShowingProvider.notifier)
                    .state = false;
                ref.read(replayProvider.notifier).state =
                   message.content;
                ref.read(replayMessageTimeProvider.notifier).state =
                '${message.sentTime}';
                if (message.senderId ==
                    FirebaseAuth
                        .instance.currentUser?.uid) {
                  ref
                      .read(replayIsMineProvider.notifier)
                      .state = true;
                }

                if (ref.watch(emojiShowingProvider)) {
                  FocusScope.of(context).unfocus();
                }
                SystemChannels.textInput
                    .invokeMethod('TextInput.show');
                ref
                    .read(
                    messageProfileProvider.notifier)
                    .focusNode.requestFocus();
              }
            },
            child: const ListTile(
              title: Text(
                'Reply',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.white),
              ),
              trailing: Icon(
                Icons.reply,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          PopupMenuItem(
            onTap: () async {
              ref
                  .read(userDetailsProvider.notifier)
                  .copyToClipboard(
                  message.content);
              await Future.delayed(
                  const Duration(milliseconds: 500));
              Fluttertoast.showToast(
                msg: "Message copied to clipboard",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor:
                Colors.grey.withOpacity(0.7),
                textColor: Colors.black,
                fontSize: 16.0,
              );
            },
            child: const ListTile(
              title: Text(
                'Copy',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.white),
              ),
              trailing: Icon(
                Icons.copy,
                color: Colors.white,
              ),
            ),
          ),
          if (isMe)
            const Divider(
              color: Colors.grey,
            ),
          if (isMe)
            PopupMenuItem(
              onTap: () async {
                if (ref
                    .watch(replayProvider)
                    .isNotEmpty) {
                  ref
                      .read(replayProvider.notifier)
                      .state = '';
                  ref
                      .read(replayIsMineProvider.notifier)
                      .state = false;
                  ref
                      .read(messageIndexProvider.notifier)
                      .state =replayMessageIndex;
                  ref
                      .read(emojiShowingProvider.notifier)
                      .state = false;

                  if (ref.watch(emojiShowingProvider)) {
                    FocusScope.of(context).unfocus();
                  }
                  SystemChannels.textInput
                      .invokeMethod('TextInput.show');
                  ref
                      .read(
                      messageProfileProvider.notifier)
                      .focusNode.requestFocus();
                  ref
                      .read(isMessageEditing.notifier)
                      .state = true;
                  ref
                      .read(
                      messageProfileProvider.notifier)
                      .textController
                      .text =message.content;
                  ref
                      .read(
                      editingMessageDetails.notifier)
                      .state =message;
                } else {
                  ref
                      .read(messageIndexProvider.notifier)
                      .state = replayMessageIndex;
                  ref
                      .read(emojiShowingProvider.notifier)
                      .state = false;

                  if (ref.watch(emojiShowingProvider)) {
                    FocusScope.of(context).unfocus();
                  }
                  SystemChannels.textInput
                      .invokeMethod('TextInput.show');
                  ref
                      .read(
                      messageProfileProvider.notifier)
                      .focusNode.requestFocus();
                  ref
                      .read(isMessageEditing.notifier)
                      .state = true;
                  ref
                      .read(
                      messageProfileProvider.notifier)
                      .textController
                      .text = message.content;
                  ref.read(replayMessageTimeProvider.notifier).state =
                  '${message.sentTime}';
                  ref
                      .read(
                      editingMessageDetails.notifier)
                      .state = message;
                }
              },
              child: const ListTile(
                title: Text(
                  'Edit',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.white),
                ),
                trailing: Icon(
                  Icons.edit_calendar_sharp,
                  color: Colors.white,
                ),
              ),
            ),
          const Divider(
            color: Colors.grey,
          ),
          PopupMenuItem(
            onTap: () {
              showPopover(
                  context: context,
                  bodyBuilder: (context) =>
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            if (message.receiverId ==
                                userId)
                              PopupMenuItem(
                                  onTap: () {
                                    ref
                                        .read(
                                        deleteEditMessagesProvider
                                            .notifier)
                                        .deleteSingleMessageForAll(
                                        FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid,
                                        message
                                            .receiverId,
                                        message
                                            .content,
                                        '${message.sentTime}');
                                    ref
                                        .read(
                                        showMenuOpenedProvider
                                            .notifier)
                                        .state = false;
                                  },
                                  child: Text(
                                    'Delete for Me and ${friendName.length>9?friendName.substring(0,9):friendName}',
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight.w400,
                                        fontSize: 18,
                                        color: Colors.red,
                                        overflow: TextOverflow.fade
                                    ),
                                  )),
                            if (message.receiverId ==
                                userId)
                              const Divider(
                                color: Colors.grey,
                              ),
                            PopupMenuItem(
                                onTap: () {
                                  ref
                                      .read(
                                      deleteEditMessagesProvider
                                          .notifier)
                                      .deleteSingleMessageForMe(
                                      FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid,
                                      isMe
                                          ? message
                                          .receiverId
                                          : message
                                          .senderId,
                                      message
                                          .content,
                                      '${message.sentTime}');
                                  ref
                                      .read(
                                      showMenuOpenedProvider
                                          .notifier)
                                      .state = false;
                                },
                                child: const Text(
                                  'Delete for Me',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.red),
                                )),

                          ]),
                  onPop: () =>
                      print('Popover was popped!'),
                  direction: PopoverDirection.bottom,
                  backgroundColor: themDark
                      ? Colors.grey.shade600
                      .withOpacity(0.3)
                      : Colors.black12.withOpacity(0.5),
                  width:message.receiverId !=
                      userId? 140:250,
                  height: message.receiverId ==
                      userId
                      ? 140
                      : 60,

                  arrowHeight: 15,
                  arrowWidth: 30,
                  barrierColor: Colors.transparent
                      .withOpacity(0.8));
            },
            child: const ListTile(
              title: Text(
                'Delete',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.red),
              ),
              trailing: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ]),
        onPop: () => print('Popover was popped!'),
        direction: PopoverDirection.bottom,
        backgroundColor: themDark
            ? Colors.grey.shade600.withOpacity(0.3)
            : Colors.black12.withOpacity(0.5),
        width: 220,
        height: isMe ? 275 : 205,
        arrowHeight: 15,
        arrowWidth: 30,
      transition: PopoverTransition.other,
      transitionDuration: const Duration(milliseconds: 400),
      contentDxOffset: BorderSide.strokeAlignCenter,
      arrowDyOffset: BorderSide.strokeAlignCenter,
      contentDyOffset: BorderSide.strokeAlignCenter,
      arrowDxOffset: BorderSide.strokeAlignCenter,
      barrierColor: Colors.transparent.withOpacity(0.8),
      popoverTransitionBuilder: (animation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInCirc,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
            child: child,
          ),
        );
      },
    );
  }
}