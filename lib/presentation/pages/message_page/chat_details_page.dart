
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
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final canPopProvider = StateProvider((ref) => false);

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
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      ref.read(messageProvider.notifier).getMessages(widget.uid!);
ref.read(canPopProvider.notifier).state=true;
      await Future.delayed(const Duration(seconds: 2),);
      ref.read(canPopProvider.notifier).state=false;


    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newProfileUser = ref.watch(otherUserProvider);
    final themDark = Theme.of(context).brightness == Brightness.dark;
    final languageText = AppLocalizations.of(context);

    return PopScope(
        onPopInvoked: (didPop) {
if(ref.watch(canPopProvider)){
  return;
}else {
  ref.read(messageNotifierProvider.notifier).fetchMessage();
  ref.read(messageHistory.notifier).getMessageHistory();
  ref.read(messageProvider.notifier).clearState();
  ref
      .read(seenMassageProvider.notifier)
      .messageIsSeen(
      newProfileUser.uid!, FirebaseAuth.instance.currentUser!.uid);
}
            // return true;
        },
        canPop: ref.watch(canPopProvider)? false : true,
        child: Scaffold(
          appBar: AppBarChatDetails(
              userId: newProfileUser!.uid!,
              employee: newProfileUser.userType,
              name: newProfileUser.name,
              isOnline: newProfileUser.isOnline,
              urlImage: newProfileUser.imageUrl),
          body: Column(
            children: [
              ref.watch(messageLoadingProvider)
                  ? const SizedBox()
                  : Expanded(
                      child: ChatMessages(
                        receiverId: newProfileUser.uid!,
                        urlImage: newProfileUser.imageUrl,
                        friendName: newProfileUser.name,
                      ),
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 17.0, right: 12),
                        child: ref.watch(replayProvider) == ''
                            ? const SizedBox()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: Text(
                                      textDirection: TextDirection.ltr,
                                      ref.watch(replayProvider).isNotEmpty
                                          ? ref.watch(replayProvider).substring(
                                              0,
                                              ref.watch(replayProvider).length >
                                                      20
                                                  ? 19
                                                  : ref
                                                      .watch(replayProvider)
                                                      .length)
                                          : '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        ref
                                            .read(replayProvider.notifier)
                                            .state = '';
                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                      },
                                      child: const Icon(
                                        Icons.clear,
                                        size: 18,
                                      ))
                                ],
                              ),
                      ),
                      (ref.watch(replayProvider) == ''
                          ? const SizedBox()
                          : const SizedBox(
                              height: 10,
                            )),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
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
                              onPressed: () {
                                FocusScope.of(context).unfocus();

                                ref.read(emojiShowingProvider.notifier).state =
                                    !ref.watch(emojiShowingProvider);
                                if (ref.watch(emojiShowingProvider)) {
                                  FocusManager.instance.primaryFocus?.unfocus();
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
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
                                  minLines: 1,
                                  maxLines: 5,
                                  onTap: () {
                                    ref
                                        .read(emojiShowingProvider.notifier)
                                        .state = false;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 13.0, horizontal: 15.0),
                                    hintText:
                                        '   ${languageText?.chat_message}',
                                    border: InputBorder.none,
                                  ),
                                  controller: ref
                                      .watch(messageProfileProvider.notifier)
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
                              onPressed: () {
                                ref
                                    .read(messageProfileProvider.notifier)
                                    .sendText(
                                        receiverId: newProfileUser.uid!,
                                        context: context,
                                        replayMessage:
                                            ref.watch(replayProvider));
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
                                      '${languageText?.emoji_recent}',
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
        )
    );
  }

}
