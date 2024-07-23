import 'package:asan_yab/data/models/language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:core';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../../data/repositoris/language_repository.dart';
import '../../../domain/riverpod/data/comments/comment_provider.dart';
import '../../../domain/riverpod/data/message/message.dart';

import '../../../domain/riverpod/screen/botton_navigation_provider.dart';
import '../../../domain/riverpod/screen/loading_circularPRI_provider.dart';
import '../../pages/themeProvider.dart';
import 'comment_text_field.dart';
import 'comment_tile.dart';
import 'package:flutter/foundation.dart' as foundation;

class CommentSheet extends ConsumerStatefulWidget {
  final String postId;

  const CommentSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool canDelete = false;
  List<String> placesId = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      ref.read(commentProvider.notifier).unSent(widget.postId);
      ref.read(commentProvider.notifier).setComments([]);
      ref.read(commentProvider.notifier).setIsReplyOpened([]);
      ref.read(commentProvider.notifier).fetchMoreData(widget.postId);
      final currentUser = FirebaseAuth.instance.currentUser!;
      final users =
          await ref.watch(commentProvider).getUserInfo(currentUser.uid);
      placesId.clear();
      placesId = users.owner;
      canDelete = users.userType == 'Admin' ||
          (users.userType == 'Business' && placesId.contains(widget.postId));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeCommentSheet(BuildContext context) {
    _controller.animateTo(0.0);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final verticalData = ref.watch(commentProvider).comments;
    final isLoading = verticalData.isEmpty;
    final themeModel = ref.watch(themeModelProvider);
    final languageText = AppLocalizations.of(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final themDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => FractionallySizedBox(
        heightFactor: _controller.value * 0.2 + 0.7,
        child: Column(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) {
                _controller.value -=
                    details.primaryDelta! / MediaQuery.of(context).size.height;
              },
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < -500) {
                  _controller.animateTo(1.0);
                } else if (details.primaryVelocity! > 500) {
                  _controller.animateTo(0.0);
                } else if (_controller.value < 0.5) {
                  _controller.animateTo(0.0);
                } else {
                  _controller.animateTo(1.0);
                }
                if (_controller.value == 0.0) {
                  _closeCommentSheet(context);
                }
              },
              child: Container(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.minimize),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text("${languageText?.comment}"),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
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
                          ),
                        )),
            ),
            Expanded(
              child: LazyLoadScrollView(
                isLoading: isLoading,
                onEndOfPage: () => ref
                    .read(commentProvider.notifier)
                    .fetchMoreData(widget.postId),
                child: SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ref.watch(commentProvider).comments.length + 1,
                    itemBuilder: (context, index) {
                      final myComment = ref.watch(commentProvider).comments;
                      if (index < myComment.length) {
                        return Directionality(
                          textDirection: TextDirection.ltr,
                          child: CommentTile(
                            index: index,
                            postId: widget.postId,
                            comment: myComment[index],
                            canDelete: canDelete,
                          ),
                        );
                      }

                      return ref.watch(commentProvider).isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.red,
                              )),
                            )
                          : const SizedBox(height: 0);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                      color: (themeModel.currentThemeMode == ThemeMode.dark)
                          ? Colors.black38
                          : Colors.white70),
                  child: CommentTextField(
                    postId: widget.postId,
                    controller: _controller,
                  )),
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
                                textEditingController: ref
                                    .watch(commentProvider.notifier)
                                    .controller,
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
          ],
        ),
      ),
    );
  }
}
