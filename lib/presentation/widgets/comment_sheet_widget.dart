import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/riverpod/screen/botton_navigation_provider.dart';
import 'package:asan_yab/domain/riverpod/screen/circular_loading_provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:core';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../data/repositoris/language_repo.dart';
import '../../domain/riverpod/data/comment_provider.dart';
import '../../domain/riverpod/data/message/message.dart';
import '../../data/repositoris/theme_Provider.dart';
import 'comment_tile_widget.dart';
import 'package:flutter/foundation.dart' as foundation;

class CommentSheetWidget extends ConsumerStatefulWidget {
  final String postId;

  const CommentSheetWidget({super.key, required this.postId});

  @override
  ConsumerState<CommentSheetWidget> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheetWidget> {
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
    final text = texts(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.70.h,
      child: Stack(children: [
        Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: (themeModel.currentThemeMode == ThemeMode.dark)
                      ? Colors.black38
                      : (FirebaseAuth.instance.currentUser != null)
                          ? Colors.white70
                          : Colors.brown[700],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(28),
                    topLeft: Radius.circular(28),
                  ),
                ),
                height: 80,
                child: (FirebaseAuth.instance.currentUser != null)
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: GestureDetector(
                              onTap: () {
                                ref.read(emojiShowingProvider.notifier).state =
                                    !ref.watch(emojiShowingProvider);
                                if (ref.watch(emojiShowingProvider)) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                              child: const Text(
                                "🙂",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: (40 +
                                    16 *
                                        ref
                                            .read(commentProvider.notifier)
                                            .calculateMaxLines())
                                .toDouble()
                                .h,
                            width: MediaQuery.of(context).size.width - 100,
                            child: Consumer(
                              builder: (context, watch, child) {
                                final controllerNotifier =
                                    ref.watch(commentProvider);
                                final themeModel =
                                    ref.watch(themeModelProvider);

                                return TextField(
                                  onTap: () {
                                    ref
                                        .read(emojiShowingProvider.notifier)
                                        .state = false;
                                  },
                                  controller: controllerNotifier.controller,
                                  maxLines:
                                      controllerNotifier.calculateMaxLines(),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: (themeModel.currentThemeMode ==
                                                ThemeMode.dark)
                                            ? Colors.black26
                                            : Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: '${text.add_a_comment}...',
                                    hintStyle: TextStyle(
                                      color: (themeModel.currentThemeMode ==
                                              ThemeMode.dark)
                                          ? Colors.grey[500]
                                          : Colors.black,
                                    ),
                                    fillColor: (themeModel.currentThemeMode ==
                                            ThemeMode.dark)
                                        ? Colors.grey[900]
                                        : Colors.grey[300],
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: (themeModel.currentThemeMode ==
                                                ThemeMode.dark)
                                            ? Colors.white10
                                            : Colors.black,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: (themeModel.currentThemeMode ==
                                                ThemeMode.dark)
                                            ? Colors.black38
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onChanged: controllerNotifier.setText,
                                );
                              },
                            ),
                          ),
                          IconButton(
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
                            icon: Icon(
                              Icons.send,
                              color: (themeModel.currentThemeMode ==
                                      ThemeMode.dark)
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isRTL
                              ? Text(
                                  text.for_add_comment,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              : SizedBox(height: 0.h),
                          TextButton(
                            onPressed: () {
                              context.pop();
                              context.pop();
                              context.pop();

                              ref
                                  .read(circularLoadingProvider.notifier)
                                  .toggleCircularLoading();
                              ref
                                  .read(
                                      stateButtonNavigationBarProvider.notifier)
                                  .selectedIndex(3);
                            },
                            child: Text(
                              text.log_in,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          isRTL
                              ? SizedBox(height: 0.h)
                              : Text(
                                  text.for_add_comment,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )
                        ],
                      )),
            SizedBox(height: 20.0.h),
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
                      return CommentTileWidget(
                        comment: myComment[index],
                        onDelete: () {
                          ref.read(commentProvider.notifier).deleteComment(
                              myComment[index], ref, widget.postId);
                        },
                      );
                    }

                    return ref.watch(commentProvider).isLoading
                        ? Center(
                            child: LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.redAccent, size: 60),
                          )
                        : SizedBox(height: 0.h);
                  },
                ),
              ),
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            height: !ref.watch(emojiShowingProvider) ? 0.h : 250.h,
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
                          height: 250.h,
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
