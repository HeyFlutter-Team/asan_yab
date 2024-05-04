import 'package:asan_yab/domain/riverpod/data/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_data.dart';
import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:asan_yab/presentation/widgets/message/app_bar_chat_details.dart';
import 'package:asan_yab/presentation/widgets/message/chat_messages.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji_gif_picker/flutter_emoji_gif_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../data/models/message/message.dart';
import '../../../data/models/message/textfield_message.dart';
import '../../../data/repositoris/message/message_repo.dart';
import '../../../domain/riverpod/config/message_notification_repo.dart';
import '../../../domain/riverpod/data/message/chat_details_page_riv.dart';
import '../../../domain/riverpod/data/profile_data_provider.dart';
import '../../widgets/message/chat_details_page_widgets/chat_background_widget.dart';
import '../../widgets/message/chat_details_page_widgets/chat_text_field_widget.dart';
import '../../widgets/message/chat_details_page_widgets/editing_container_widget.dart';
import '../../widgets/message/chat_details_page_widgets/emoji_button_widget.dart';
import '../../widgets/message/chat_details_page_widgets/gif_button_widget.dart';
import '../../widgets/message/chat_details_page_widgets/reply_container_widget.dart';
import '../../widgets/message/chat_details_page_widgets/send_message_button_widget.dart';
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
    final isMessageText = ref.watch(replayProvider).contains('giphy.com');
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
      canPop: ref.watch(emojiShowingProvider) || ref.watch(gifShowingProvider) ? false : true,
      child: GestureDetector(
        onTap: () {
          ref.read(emojiShowingProvider.notifier).state = false;
          ref.read(gifShowingProvider.notifier).state = false;
          SystemChannels.textInput
              .invokeMethod(
              'TextInput.hide');
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
              ChatBackgroundWidget(ref: ref),
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
                              : ReplyContainerWidget(ref: ref, newProfileUser: newProfileUser, isMessageText: isMessageText),
                          (ref.watch(replayProvider) == ''
                              ? const SizedBox()
                              : const SizedBox(
                                  height: 10,
                                )),
                          ref.watch(editingMessageDetails).content != ''
                              ? ref.watch(replayProvider) == ''
                                  ? ref.watch(isMessageEditing)
                                      ? EditingContainerWidget(ref: ref)
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
                                  const SizedBox(width: 10),
                                  EmojiButtonWidget(themDark: themDark, ref: ref),
                                  const SizedBox(width: 10),

                                  ChatTextFieldWidget(themDark: themDark, ref: ref),

                                  const SizedBox(width: 10),
                                  !ref.watch(hasTextFieldValueProvider)?
                                  GifButtonWidget(themDark: themDark, ref: ref):
                                  SendMessageButtonWidget(themDark: themDark, ref: ref, profileDetails: profileDetails!, newProfileUser: newProfileUser, widget: widget),
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
                                Expanded(
                                  child: Offstage(
                                    offstage: !ref.watch(emojiShowingProvider),
                                    child:
                                    EmojiPicker(
                                      onEmojiSelected: (category, emoji) {
                                        ref.read(hasTextFieldValueProvider.notifier).state=true;
                                      },
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
                                //gif
                          SizedBox(
                            height: !ref.watch(gifShowingProvider)?20 : 300,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Offstage(
                                    offstage: !ref.watch(gifShowingProvider),
                                    child:
                                    EmojiGifMenuLayout(
                                      child: EmojiGifPickerIcon(
                                        id: "1",
                                        onGifSelected: (gif) async{
                                          if(mounted) {
                                            ref.read(localMessagesProvider.notifier)
                                                .addMessage(
                                                MessageModel(
                                                    senderId: FirebaseAuth.instance.currentUser!.uid,
                                                    receiverId:newProfileUser.uid! ,
                                                    content:ref
                                                        .watch(messageProfileProvider
                                                        .notifier)
                                                        .textController.text ,
                                                    sentTime: DateTime.now().toUtc() ,
                                                    messageType: MessageType.text,
                                                    replayMessage:ref.watch(replayProvider),
                                                    isSeen:false ,
                                                    replayMessageIndex:ref.watch(
                                                        messageIndexProvider)+1 ,
                                                    replayIsMine:  ref.watch(
                                                        replayIsMineProvider),
                                                    isMessageEdited:ref.watch(
                                                        messageEditedProvider
                                                    ) ,
                                                    replayMessageTime: ref.watch(replayMessageTimeProvider)
                                                )
                                            );
                                            ref
                                                .read(messageProfileProvider
                                                .notifier)
                                                .sendSticker(
                                                receiverId: newProfileUser.uid!,
                                                context: context,
                                                currentUserCoinCount: 0,
                                                scrollPositioned: 0,
                                                gifUrl: '${gif?.images
                                                    ?.fixedHeight?.url}'
                                            ).whenComplete((){
                                              MessageNotification
                                                  .sendPushNotificationMessage(
                                                  newProfileUser,
                                                  ref
                                                      .read(messageProfileProvider
                                                      .notifier)
                                                      .textController
                                                      .text,
                                                  ref.watch(
                                                      userDetailsProvider)!);
                                            });
                                          }
                                        },
                                        fromStack: false,
                                        hoveredBackgroundColor: Colors.black,
                                        backgroundColor: Colors.black,
                                        controller: ref
                                            .watch(
                                            messageProfileProvider.notifier)
                                            .textController ,
                                        viewEmoji: false,
                                        viewGif: true,
                                        keyboardIcon: const Icon(Icons.gif_box_outlined
                                          ,color: Colors.red,),
                                        icon: const Icon(
                                          Icons.gif_box_outlined
                                          ,color: Colors.red,
                                          size: 80,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: ref.watch(emojiShowingProvider) ||ref.watch(gifShowingProvider)||
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







