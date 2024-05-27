import 'package:asan_yab/presentation/widgets/comment/comment_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:core';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../core/res/image_res.dart';
import '../../domain/riverpod/data/comments/comment_provider.dart';
import '../../domain/riverpod/data/message/message.dart';
import '../pages/themeProvider.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../widgets/comment/comment_tile.dart';

class ManageCommentsPage extends ConsumerStatefulWidget {
  final String postId;
  final String name;
  final String image;
  const ManageCommentsPage(
      {super.key,
      required this.postId,
      required this.name,
      required this.image});

  @override
  ConsumerState<ManageCommentsPage> createState() => _ManageCommentsPageState();
}

class _ManageCommentsPageState extends ConsumerState<ManageCommentsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        ref.read(commentProvider.notifier).unSent(widget.postId);
        ref.read(commentProvider.notifier).setComments([]);
        ref.read(commentProvider.notifier).fetchMoreData(widget.postId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final verticalData = ref.watch(commentProvider).comments;
    final isLoading = verticalData.isEmpty;
    final themeModel = ref.watch(themeModelProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.watch(replyCommentProvider.notifier).state = false;
        ref.read(commentIdProvider.notifier).state = '';
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width, // Use full width
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              ref.watch(replyCommentProvider.notifier).state =
                                  false;
                              ref.read(commentIdProvider.notifier).state = '';

                              Navigator.pop(context);
                              // Handle back button press
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 12.0, left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        Image.asset(ImageRes.asanYab),
                                    imageUrl: widget.image,
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.black.withOpacity(0.3),
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
          ],
        ),
        body: Column(
          children: [
            const Divider(),
            Expanded(
              child: LazyLoadScrollView(
                isLoading: isLoading,
                onEndOfPage: () {
                  ref
                      .read(commentProvider.notifier)
                      .fetchMoreData(widget.postId);
                },
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
                            canDelete: true,
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
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: (themeModel.currentThemeMode == ThemeMode.dark)
                          ? Colors.black38
                          : Colors.white70),
                  child: CommentTextField(postId: widget.postId)),
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
