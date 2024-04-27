import 'package:asan_yab/domain/riverpod/config/message_notification_repo.dart';
import 'package:asan_yab/domain/riverpod/data/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_data.dart';
import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:asan_yab/presentation/widgets/message/app_bar_chat_details.dart';
import 'package:asan_yab/presentation/widgets/message/chat_messages.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../data/models/message/textfield_message.dart';
import '../../../data/repositoris/message/message_repo.dart';
import '../../../domain/riverpod/data/message/chat_details_page_riv.dart';
import '../../../domain/riverpod/data/message/delete_message.dart';
import '../../../domain/riverpod/data/profile_data_provider.dart';
import '../themeProvider.dart';
import 'dart:ui' as ui;

class ChatDetailPage extends ConsumerStatefulWidget {
  const ChatDetailPage({super.key, this.uid});
  final String? uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            ref.read(activeChatIdProvider.notifier).state = '${widget.uid}';
            final messages = ref.watch(textFieldMessagesListPro);
            final userMessages = messages
                .where((element) => element.userId == widget.uid)
                .toList();

            if (userMessages.isNotEmpty) {
              final textFieldMessage = userMessages.first.textFieldMessage;
              final replayText = userMessages.first.replayText;
              final editingMessage = userMessages.first.editingMessage;
              if ('$textFieldMessage'.isNotEmpty) {
                ref.read(messageProfileProvider.notifier).textController.text =
                    '$textFieldMessage';
              }
              if ('$replayText'.isNotEmpty) {
                ref.read(replayProvider.notifier).state = '$replayText';
              }
              if ('$editingMessage'.isNotEmpty) {
                ref.read(isMessageEditing.notifier).state = true;
                ref
                    .read(editingMessageDetails.notifier)
                    .setContent('$editingMessage');
              }
            }
            if (mounted) {
              await MessageRepo()
                  .markMessageAsSeen('${ref.watch(otherUserProvider)?.uid}');
            }
          } catch (e) {
            print('Error fetching messages: $e');
          }

        },
      );
  }


  @override
  Widget build(BuildContext context) {
    final themeModel = ref.watch(themeModelProvider);
    final newProfileUser = ref.watch(otherUserProvider);
    final themDark = Theme.of(context).brightness == Brightness.dark;
    final languageText = AppLocalizations.of(context);
    final profileDetails = ref.watch(userDetailsProvider);
    return PopScope(
      onPopInvoked: (didPop) async {
        await ref
            .read(handleWillPopProvider.notifier)
            .handleWillPop(context, ref, '${widget.uid}');
      },
      canPop: ref.watch(emojiShowingProvider) ? false : true,
      child: GestureDetector(
        onTap: () {
          ref.read(emojiShowingProvider.notifier).state = false;
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 10) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBarChatDetails(
            userId: newProfileUser!.uid!,
            employee: newProfileUser.userType,
            name: newProfileUser.name,
            isOnline: newProfileUser.isOnline,
            urlImage: newProfileUser.imageUrl,
            user: newProfileUser,
          ),
          body: Stack(
            children: [
              Container(height: double.infinity,width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image:AssetImage(ref.watch(wallpaperStateNotifierProvider)),fit: BoxFit.cover )
              ),
              ),
              Column(
                children: [
                  ref.watch(messageLoadingProvider)
                      ? const SizedBox()
                      : Expanded(
                          child: ChatMessages(
                            receiverId: newProfileUser.uid!,
                            urlImage: newProfileUser.imageUrl,
                            friendName: newProfileUser.name,
                            user: newProfileUser,
                          ),
                        ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.zero,
                      width: double.infinity,
                      child: Column(
                        children: [
                          ref.watch(replayProvider) == ''
                              ? const SizedBox()
                              : InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    ref
                                        .read(replayPositionProvider.notifier)
                                        .scrollItemByTime(ref,
                                            DateTime.parse(ref.watch(replayMessageTimeProvider)));

                                  },
                                  child: Container(
                                    height: 60,
                                    color:
                                        Colors.grey.shade300.withOpacity(0.7),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: double.infinity,
                                              width: 4,
                                              color: ref.watch(
                                                      replayIsMineProvider)
                                                  ? Colors.purple.shade700
                                                  : Colors.blue,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    ref.watch(
                                                            replayIsMineProvider)
                                                        ? 'You'
                                                        : newProfileUser.name,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      color: ref.watch(
                                                              replayIsMineProvider)
                                                          ? Colors
                                                              .purple.shade700
                                                          : Colors
                                                              .blue,
                                                    ),
                                                  ),
                                                  Text(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    ref
                                                            .watch(
                                                                replayProvider)
                                                            .isNotEmpty
                                                        ? ref
                                                            .watch(
                                                                replayProvider)
                                                            .substring(
                                                                0,
                                                                ref.watch(replayProvider).length >
                                                                        20
                                                                    ? 19
                                                                    : ref
                                                                        .watch(
                                                                            replayProvider)
                                                                        .length)
                                                        : '',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                ref
                                                    .read(
                                                        replayProvider.notifier)
                                                    .state = '';
                                                SystemChannels.textInput
                                                    .invokeMethod(
                                                        'TextInput.hide');
                                                ref
                                                    .read(replayIsMineProvider
                                                        .notifier)
                                                    .state = false;
                                              },
                                              child: const Icon(
                                                Icons.cancel_outlined,
                                                size: 31,
                                                color: Colors.blue,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                          (ref.watch(replayProvider) == ''
                              ? const SizedBox()
                              : const SizedBox(
                                  height: 10,
                                )),
                          ref.watch(editingMessageDetails).content != ''
                              ? ref.watch(replayProvider) == ''
                                  ? ref.watch(isMessageEditing)
                                      ? InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {


                                            ref
                                                .read(replayPositionProvider.notifier)
                                                .scrollItemByTime(ref,
                                                DateTime.parse(ref.watch(replayMessageTimeProvider)));

                                          },
                                          child: Container(
                                            height: 60,
                                            color: Colors.grey.shade300
                                                .withOpacity(0.7),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: Icon(
                                                        Icons
                                                            .edit_calendar_outlined,
                                                        color: Colors
                                                            .purple.shade700,
                                                        size: 35,
                                                      ),
                                                    ),
                                                    Container(
                                                        height: double.infinity,
                                                        width: 4,
                                                        color: Colors
                                                            .purple.shade700),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Editing Message',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .purple
                                                                    .shade700),
                                                          ),
                                                          Text(
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            ref
                                                                .watch(
                                                                    editingMessageDetails)
                                                                .content
                                                                .substring(
                                                                    0,
                                                                    ref.watch(editingMessageDetails).content.length >
                                                                            20
                                                                        ? 19
                                                                        : ref
                                                                            .watch(editingMessageDetails)
                                                                            .content
                                                                            .length),
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                                isMessageEditing
                                                                    .notifier)
                                                            .state = false;
                                                        ref
                                                            .read(
                                                                messageProfileProvider
                                                                    .notifier)
                                                            .textController
                                                            .clear();
                                                        ref
                                                            .read(replayProvider
                                                                .notifier)
                                                            .state = '';
                                                        SystemChannels.textInput
                                                            .invokeMethod(
                                                                'TextInput.hide');
                                                        ref
                                                            .read(
                                                                replayIsMineProvider
                                                                    .notifier)
                                                            .state = false;
                                                      },
                                                      child: const Icon(
                                                        Icons.cancel_outlined,
                                                        size: 31,
                                                        color: Colors.blue,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox(
                                          height: 0,
                                        )
                                  : const SizedBox()
                              : const SizedBox(),
                          ref.watch(replayProvider) == ''
                              ? ref.watch(isMessageEditing)
                                  ? const SizedBox(
                                      height: 10,
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: Row(
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: themDark
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade300,
                                        elevation: 0,
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10)),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                      await Future.delayed(
                                          const Duration(milliseconds: 100));
                                      ref
                                              .read(emojiShowingProvider.notifier)
                                              .state =
                                          !ref.watch(emojiShowingProvider);
                                      if (ref.watch(emojiShowingProvider)) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    child: Icon(
                                      Icons.emoji_emotions_outlined,
                                      size: 24,
                                      color: ref.watch(emojiShowingProvider)
                                          ? Colors.blue.shade200
                                          : themDark
                                              ? Colors.white
                                              : Colors.black45,
                                    ),
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
                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(40),
                                        color: themDark
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade300,
                                      ),
                                      child: TextField(
                                        autocorrect: true,
                                        minLines: 1,
                                        maxLines: 5,
                                        focusNode:ref
                                            .watch(
                                            messageProfileProvider.notifier)
                                            .focusNode ,
                                        onTap: () {
                                          ref
                                              .read(emojiShowingProvider.notifier)
                                              .state = false;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 13.0,
                                            horizontal: 15.0,
                                          ),
                                          hintText:
                                              '   ${languageText?.chat_message}',
                                          border: InputBorder.none,
                                        ),
                                        controller: ref
                                            .watch(
                                                messageProfileProvider.notifier)
                                            .textController,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: themDark
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade300,
                                        elevation: 0,
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10)),
                                    onPressed: ref.watch(isMessageEditing)
                                        ? () async {
                                            ref
                                                .read(isMessageEditing.notifier)
                                                .state = false;
                                            await ref
                                                .read(deleteEditMessagesProvider
                                                    .notifier)
                                                .editMessage(
                                                    '${profileDetails?.uid}',
                                                    ref
                                                        .watch(
                                                            editingMessageDetails)
                                                        .receiverId,
                                                    ref
                                                        .watch(
                                                            editingMessageDetails)
                                                        .content,
                                                    ref
                                                        .watch(
                                                            messageProfileProvider
                                                                .notifier)
                                                        .textController
                                                        .text,
                                                    '${ref.watch(editingMessageDetails).sentTime}')
                                                .whenComplete(() => ref
                                                    .read(messageProfileProvider
                                                        .notifier)
                                                    .textController
                                                    .clear());
                                          }
                                        : () async {
                                     if(ref.watch(messageProfileProvider.notifier).textController.text.isNotEmpty){
                                       // if(!Utils.netIsConnected(ref)){
                                       //   ref.read(localMessagesProvider.notifier)
                                       //       .state.addAll(
                                       //     [
                                       //       MessageModel(
                                       //           senderId: FirebaseAuth.instance.currentUser!.uid,
                                       //           receiverId:newProfileUser.uid! ,
                                       //           content:ref
                                       //               .watch(messageProfileProvider
                                       //               .notifier)
                                       //               .textController.text ,
                                       //           sentTime: DateTime.now().toUtc() ,
                                       //           messageType: MessageType.text,
                                       //           replayMessage:ref.watch(replayProvider),
                                       //           isSeen:false ,
                                       //           replayMessageIndex:ref.watch(
                                       //               messageIndexProvider)+1 ,
                                       //           replayIsMine:  ref.watch(
                                       //               replayIsMineProvider),
                                       //           isMessageEdited:ref.watch(
                                       //               messageEditedProvider
                                       //           ) ,
                                       //           replayMessageTime: ref.watch(replayMessageTimeProvider)
                                       //       )]
                                       //
                                       //
                                       //   );
                                       // }
                                       MessageNotification.sendPushNotificationMessage(newProfileUser,
                                           ref
                                               .read(messageProfileProvider
                                               .notifier)
                                               .textController.text,ref.watch(userDetailsProvider)!);
                                       print('hold check 1');
                                       ref
                                           .read(messageProfileProvider
                                           .notifier)
                                           .sendText(
                                           receiverId:
                                           newProfileUser.uid!,
                                           context: context,
                                           replayMessage:
                                           ref.watch(replayProvider),
                                           replayMessageIndex: ref.watch(
                                               messageIndexProvider)+1,
                                           ref: ref,
                                           replayIsMine: ref.watch(
                                               replayIsMineProvider),
                                           messageEditedProvider: ref.watch(
                                               messageEditedProvider
                                           ),
                                           users: newProfileUser,
                                           replayMessageTime: ref.watch(replayMessageTimeProvider)

                                       )
                                           .whenComplete((){
                                         print('hold check 2');
                                         ref
                                             .read(replayProvider.notifier)
                                             .state = '';
                                         ref.read(localMessagesProvider.notifier)
                                             .state.clear();

                                         ref
                                             .read(textFieldMessagesListPro
                                             .notifier)
                                             .state
                                             .removeWhere((element) =>
                                         element.userId == widget.uid);
                                         ref
                                             .read(
                                             replayIsMineProvider.notifier)
                                             .state = false;

                                         ref
                                             .read(messageProfileProvider
                                             .notifier)
                                             .textController
                                             .clear();
                                       });
                                     }
                                          },
                                    child: Icon(
                                      ref.watch(isMessageEditing)
                                          ? Icons.check
                                          : Icons.send,
                                      color: Colors.blue.shade200,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: !ref.watch(emojiShowingProvider) ? 20 : 350,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 9,
                                ),
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
                                Expanded(
                                  child: Offstage(
                                    offstage: !ref.watch(emojiShowingProvider),
                                    child: EmojiPicker(
                                      textEditingController: ref
                                          .watch(
                                              messageProfileProvider.notifier)
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
                                        bgColor: (themeModel.currentThemeMode ==
                                                ThemeMode.dark)
                                            ? Colors.black
                                            : Colors.white,
                                        indicatorColor: Colors.red,
                                        iconColor: Colors.grey,
                                        iconColorSelected: Colors.red,
                                        backspaceColor: Colors.red,
                                        skinToneDialogBgColor: Colors.white,
                                        skinToneIndicatorColor: Colors.grey,
                                        enableSkinTones: true,
                                        recentTabBehavior:
                                            RecentTabBehavior.RECENT,
                                        recentsLimit: 28,
                                        replaceEmojiOnLimitExceed: false,
                                        noRecents: Text(
                                          '${languageText?.emoji_recent}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black26),
                                          textAlign: TextAlign.center,
                                        ),
                                        loadingIndicator:
                                            const SizedBox.shrink(),
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
            ],
          ),
          floatingActionButton: ref.watch(emojiShowingProvider) ||
                  ref.watch(isMessageEditing) ||ref.watch(messageProvider).length<13
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: 0,
                      right: 0,
                      bottom: ref.watch(replayProvider) == '' ? 80 : 140),
                  child: Visibility(
                    visible: !ref.watch(isToEndProvider),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        ref
                            .read(replayPositionProvider.notifier)
                            .scrollItem(ref, 0);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: themDark
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black.withOpacity(0.6),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32))),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: themDark
                              ? Colors.black.withOpacity(0.6)
                              : Colors.white,
                          size: 37,
                        ),
                      ),
                    ),
                  ),
                  // ),
                ),
        ),
      ),
    );
  }
}
