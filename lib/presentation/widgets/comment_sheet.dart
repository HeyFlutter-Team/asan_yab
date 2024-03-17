import 'package:asan_yab/data/models/language.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:core';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/comment_provider.dart';
import '../../domain/riverpod/data/message/message.dart';

import '../../domain/riverpod/screen/botton_navigation_provider.dart';
import '../../domain/riverpod/screen/loading_circularPRI_provider.dart';
import '../pages/themeProvider.dart';
import 'comment_tile.dart';
import 'package:flutter/foundation.dart' as foundation;

class CommentSheet extends ConsumerStatefulWidget {
  final String postId;

  const CommentSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(commentProvider.notifier).setComments([]);
      ref.read(commentProvider.notifier).fetchMoreData(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final verticalData = ref.watch(commentProvider).comments;
    final isLoading = verticalData.isEmpty;
    final themeModel = ref.watch(themeModelProvider);
    final languageText = AppLocalizations.of(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final themDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: Stack(children: [
        Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: (themeModel.currentThemeMode == ThemeMode.dark)
                      ? Colors.black38
                      : (FirebaseAuth.instance.currentUser != null)
                          ? Colors.white70
                          : Colors.brown[700],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(28),
                      topLeft: Radius.circular(28)),
                ),
                child: (FirebaseAuth.instance.currentUser != null)
                    ? Row(
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
                                borderRadius: BorderRadius.circular(20),
                                color: themDark ? Colors.grey.shade800 : null,
                              ),
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final controllerNotifier =
                                      ref.watch(commentProvider);
                                  return SizedBox(
                                    child: TextField(
                                      cursorHeight: 20,
                                      onTap: () {
                                        ref
                                            .read(emojiShowingProvider.notifier)
                                            .state = false;
                                      },
                                      maxLines: ref
                                          .watch(commentProvider)
                                          .calculateMaxLines(),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(6),
                                        hintStyle: TextStyle(
                                          color: (themeModel.currentThemeMode ==
                                                  ThemeMode.dark)
                                              ? Colors.grey[500]
                                              : Colors.black,
                                        ),
                                        hintText:
                                            '${languageText!.add_a_comment}...',
                                        border: InputBorder.none,
                                      ),
                                      controller: controllerNotifier.controller,
                                      onChanged: controllerNotifier.setText,
                                    ),
                                  );
                                },
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
                              ref.read(commentProvider.notifier).submitComment(
                                  ref.watch(commentProvider).controller.text,
                                  context,
                                  ref,
                                  widget.postId);
                              ref
                                  .read(commentProvider.notifier)
                                  .controller
                                  .clear();
                              ref.read(emojiShowingProvider.notifier).state =
                                  false;
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.blue.shade200,
                              size: 24,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isRTL
                              ? Text(
                                  languageText!.for_add_comment,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              : const SizedBox(height: 0),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              ref.read(loadingProvider.notifier).state =
                                  !ref.watch(loadingProvider);
                              ref
                                  .read(buttonNavigationProvider.notifier)
                                  .selectedIndex(3);
                            },
                            child: Text(
                              languageText!.log_in,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          isRTL
                              ? const SizedBox(height: 0)
                              : Text(
                                  languageText.for_add_comment,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                        ],
                      )),
            const SizedBox(height: 20.0),
            Expanded(
              child: LazyLoadScrollView(
                isLoading: isLoading,
                onEndOfPage: () => ref
                    .read(commentProvider.notifier)
                    .fetchMoreData(widget.postId),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ref.watch(commentProvider).comments.length + 1,
                  itemBuilder: (context, index) {
                    final myComment = ref.watch(commentProvider).comments;
                    if (index < myComment.length) {
                      return CommentTile(
                        comment: myComment[index],
                        onDelete: () {
                          ref.read(commentProvider.notifier).deleteComment(
                              myComment[index], ref, widget.postId);
                        },
                      );
                    }

                    return ref.watch(commentProvider).isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox(height: 0);
                  },
                ),
              ),
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            height: !ref.watch(emojiShowingProvider) ? 0 : 250,
            width: double.infinity,
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
                                  ),
                                ),
                              ),
                            ],
                          )
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
                            textEditingController:
                                ref.watch(commentProvider.notifier).controller,
                            onBackspacePressed: ref
                                .read(commentProvider.notifier)
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
                              noRecents: const Text(
                                'لا توجد رموز تعبيرية حديثة',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black26),
                                textAlign: TextAlign.center,
                              ),
                              loadingIndicator: const SizedBox.shrink(),
                              tabIndicatorAnimDuration: kTabScrollDuration,
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
      ]),
    );
  }
}
