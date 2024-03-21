import 'package:asan_yab/data/models/users.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(messageProvider.notifier).getMessages(widget.uid!));
  }

  Future<void> _onWillPop(Users newProfileUser) async {
    ref.read(messageProvider.notifier).clearState();
    ref.read(messageNotifierProvider.notifier).fetchMessage();
    ref.read(messageHistory.notifier).getMessageHistory();
    ref
        .read(seenMassageProvider.notifier)
        .messageIsSeen(
            newProfileUser.uid!, FirebaseAuth.instance.currentUser!.uid)
        .whenComplete(
            () => ref.read(seenMassageProvider.notifier).isNewMassage());
  }

  @override
  Widget build(BuildContext context) {
    final newProfileUser = ref.watch(otherUserProvider);
    final themDark = Theme.of(context).brightness == Brightness.dark;
    final languageText = AppLocalizations.of(context);
    final isMessageLoading = ref.watch(messageLoadingProvider);
    final isEmojiShowing = ref.watch(emojiShowingProvider);
    final replay = ref.watch(replayProvider);
    return WillPopScope(
        onWillPop: () async {
          await _onWillPop(newProfileUser);
          return true;
        },
        child: Scaffold(
          appBar: AppBarChatDetails(
            userId: newProfileUser!.uid!,
            employee: newProfileUser.userType,
            name: newProfileUser.name,
            isOnline: newProfileUser.isOnline,
            urlImage: newProfileUser.imageUrl,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              isMessageLoading
                  ? const SizedBox()
                  : ChatMessages(
                      receiverId: newProfileUser.uid!,
                      urlImage: newProfileUser.imageUrl,
                    ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
                  height: !isEmojiShowing ? (replay == '' ? 64 : 100) : 350,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          replay == ''
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Text(
                                        'Replay: $replay',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                        ),
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
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () {
                                    ref
                                            .read(emojiShowingProvider.notifier)
                                            .state =
                                        !ref.watch(emojiShowingProvider);
                                    if (ref.watch(emojiShowingProvider)) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    }
                                  },
                                  child: Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: ref.watch(emojiShowingProvider)
                                        ? Colors.red
                                        : themDark
                                            ? Colors.white
                                            : Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                color: themDark ? Colors.grey.shade800 : null,
                              ),
                              child: TextField(
                                onTap: () => ref
                                    .read(emojiShowingProvider.notifier)
                                    .state = false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: languageText?.chat_message,
                                  border: InputBorder.none,
                                ),
                                controller: ref
                                    .watch(messageProfileProvider.notifier)
                                    .textController,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    themDark ? Colors.grey.shade800 : null,
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
                                    noRecents: const Text(
                                      'لا توجد رموز تعبيرية حديثة',
                                      style: TextStyle(
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
