import 'package:asan_yab/domain/riverpod/data/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_data.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_history.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_seen.dart';
import 'package:asan_yab/domain/riverpod/data/message/messages_notifier.dart';
import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:asan_yab/presentation/widgets/message/app_bar_chat_details.dart';
import 'package:asan_yab/presentation/widgets/message/chat_messages.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  const ChatDetailPage({super.key, this.uid});
  final String? uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    // ref.read(messageProfileProvider.notifier)..getUserById(widget.uid);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messageProvider.notifier).getMessages(widget.uid!);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newProfileUser = ref.watch(otherUserProvider);
    return WillPopScope(
        onWillPop: () async {
          ref.read(messageProvider.notifier).clearState();
          ref.read(messageNotifierProvider.notifier).fetchMessage();
          ref.read(messageHistory.notifier).getMessageHistory();
          ref
              .read(seenMassageProvider.notifier)
              .messageIsSeen(
                  newProfileUser.uid!, FirebaseAuth.instance.currentUser!.uid)
              .whenComplete(
                  () => ref.read(seenMassageProvider.notifier).isNewMassage());

          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white70.withOpacity(0.95),
          appBar: AppBarChatDetails(
              userId: newProfileUser!.uid!,
              employee: newProfileUser.userType,
              name: newProfileUser.name,
              isOnline: newProfileUser.isOnline,
              urlImage: newProfileUser.imageUrl),
          body: Stack(
            fit: StackFit.expand,
            children: [
              ref.watch(messageLoadingProvider)
                  ? const SizedBox()
                  : ChatMessages(
                      receiverId: newProfileUser.uid!,
                      urlImage: newProfileUser.imageUrl),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
                  height: !ref.watch(emojiShowingProvider)
                      ? (ref.watch(replayProvider) == '' ? 64 : 100)
                      : 350,
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ref.watch(replayProvider) == ''
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Text(
                                        'Replay: ${ref.watch(replayProvider)}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(emojiShowingProvider.notifier)
                                      .state = !ref.watch(emojiShowingProvider);
                                  if (ref.watch(emojiShowingProvider)) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                },
                                child: Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: ref.watch(emojiShowingProvider)
                                      ? Colors.red
                                      : Colors.black45,
                                ),
                              ),
                            ],
                          ),

                          ///
                          ///
                          // GestureDetector(
                          //   onTap: () {
                          //     sendImage();
                          //   },
                          //   child: Container(
                          //     height: 30,
                          //     width: 30,
                          //     decoration: BoxDecoration(
                          //       color: Colors.lightBlue,
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //     child: const Icon(
                          //       Icons.add,
                          //       color: Colors.white,
                          //       size: 20,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 15,
                          // ),

                          Expanded(
                            child: TextField(
                              onTap: () {
                                ref.read(emojiShowingProvider.notifier).state =
                                    false;
                              },
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 7),
                                hintText: "Say Something ... ",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none,
                              ),
                              controller: ref
                                  .watch(messageProfileProvider.notifier)
                                  .textController,
                            ),
                          ),
                          const SizedBox(width: 15),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                            onPressed: () {
                              ref
                                  .read(messageProfileProvider.notifier)
                                  .sendText(
                                      receiverId: newProfileUser.uid!,
                                      context: context,
                                      replayMessage: ref.watch(replayProvider));
                              ref.read(replayProvider.notifier).state = '';
                              ref
                                  .read(messageProfileProvider.notifier)
                                  .textController
                                  .clear();
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.blue.shade200,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            // Flexible(
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceAround,
                            //     children: [
                            //       const Stickers(),
                            //       GestureDetector(
                            //         onTap: () {
                            //           ref
                            //                   .read(emojiShowingProvider.notifier)
                            //                   .state =
                            //               !ref.watch(emojiShowingProvider);
                            //           if (ref.watch(emojiShowingProvider)) {
                            //             FocusManager.instance.primaryFocus
                            //                 ?.unfocus();
                            //           }
                            //
                            //           print('TAPPED ON EMOJI');
                            //         },
                            //         child: Icon(
                            //           Icons.emoji_emotions_outlined,
                            //           color: ref.watch(emojiShowingProvider)
                            //               ? Colors.red
                            //               : Colors.black45,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Offstage(
                              offstage: !ref.watch(emojiShowingProvider),
                              child: SizedBox(
                                height: 250,
                                child: EmojiPicker(
                                  textEditingController: ref
                                      .watch(messageProfileProvider.notifier)
                                      .textController,
                                  onBackspacePressed: ref
                                      .read(messageProfileProvider.notifier)
                                      .onBackspacePressed(),
                                  config: Config(
                                    columns: 7,
                                    // Issue: https://github.com/flutter/flutter/issues/28894
                                    emojiSizeMax: 32 *
                                        (foundation.defaultTargetPlatform ==
                                                TargetPlatform.iOS
                                            ? 1.30
                                            : 1.0),
                                    verticalSpacing: 0,
                                    horizontalSpacing: 0,
                                    gridPadding: EdgeInsets.zero,
                                    initCategory: Category.RECENT,
                                    bgColor: const Color(0xFFF2F2F2),
                                    indicatorColor: Colors.blue,
                                    iconColor: Colors.grey,
                                    iconColorSelected: Colors.blue,
                                    backspaceColor: Colors.blue,
                                    skinToneDialogBgColor: Colors.white,
                                    skinToneIndicatorColor: Colors.grey,
                                    enableSkinTones: true,
                                    recentTabBehavior: RecentTabBehavior.RECENT,
                                    recentsLimit: 28,
                                    replaceEmojiOnLimitExceed: false,
                                    noRecents: Text(
                                      'لا توجد رموز تعبيرية حديثة',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black26),
                                      textAlign: TextAlign.center,
                                    ),
                                    loadingIndicator: const SizedBox.shrink(),
                                    tabIndicatorAnimDuration:
                                        kTabScrollDuration,
                                    categoryIcons: const CategoryIcons(),
                                    buttonMode: ButtonMode.MATERIAL,
                                    checkPlatformCompatibility: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
