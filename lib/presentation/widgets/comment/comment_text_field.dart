import 'package:asan_yab/data/models/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui' as ui;
import '../../../data/repositoris/language_repository.dart';
import '../../../domain/riverpod/data/comments/comment_provider.dart';
import '../../../domain/riverpod/data/message/message.dart';
import '../../pages/themeProvider.dart';

class CommentTextField extends ConsumerStatefulWidget {
  final AnimationController? controller;
  final String postId;
  const CommentTextField({super.key, this.controller, required this.postId});

  @override
  ConsumerState<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends ConsumerState<CommentTextField> {
  @override
  Widget build(BuildContext context) {
    final isReplyOpened = ref.watch(commentProvider).isReplyOpened;
    final themeModel = ref.watch(themeModelProvider);
    final languageText = AppLocalizations.of(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';

    final themDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        ref.watch(replyCommentProvider) || ref.watch(commentProvider).isEditMode
            ? Container(
                height: 60,
                color: Colors.grey.shade300.withOpacity(0.7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: double.infinity,
                          width: 4,
                          color: Colors.blue,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ref.watch(commentProvider).name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                textDirection: ui.TextDirection.ltr,
                                ref.watch(commentProvider).replyText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            ref.read(isReplyModeProvider.notifier).state =
                                false;
                            ref
                                .read(commentProvider.notifier)
                                .controller
                                .clear();
                            ref.read(commentProvider.notifier).isEditMode =
                                false;
                            ref.watch(replyCommentProvider.notifier).state =
                                false;
                            ref.read(commentIdProvider.notifier).state = '';
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            size: 31,
                            color: Colors.blue,
                          )),
                    )
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
              ),
        const SizedBox(height: 10),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    elevation: 0,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10)),
                onPressed: () {
                  if (widget.controller != null) {
                    widget.controller?.animateTo(1.0);
                  }
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
                  padding: const EdgeInsets.symmetric(horizontal: 7),
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
                      final controllerNotifier = ref.watch(commentProvider);
                      return SizedBox(
                        child: Directionality(
                          textDirection:
                              isRTL ? TextDirection.rtl : TextDirection.ltr,
                          child: TextField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            cursorHeight: 20,
                            onTap: () {
                              if (widget.controller != null) {
                                widget.controller?.animateTo(1.0);
                              }

                              ref.read(emojiShowingProvider.notifier).state =
                                  false;
                            },
                            maxLines:
                                ref.watch(commentProvider).calculateMaxLines(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(6),
                              hintStyle: TextStyle(
                                color: (themeModel.currentThemeMode ==
                                        ThemeMode.dark)
                                    ? Colors.grey[500]
                                    : Colors.black,
                              ),
                              hintText: '${languageText!.add_a_comment}...',
                              border: InputBorder.none,
                            ),
                            controller: controllerNotifier.controller,
                            onChanged: controllerNotifier.setText,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    elevation: 0,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10)),
                onPressed: () {
                  for (int i = 0; i < isReplyOpened.length; i++) {
                    isReplyOpened[i] = false;
                  }
                  if (ref.watch(commentProvider).isEditMode) {
                    ref.read(commentProvider.notifier).updateCommentAndReply(
                        ref.watch(commentProvider).controller.text,
                        context,
                        ref,
                        widget.postId);
                  } else {
                    ref.read(commentProvider.notifier).submitComment(
                        ref.watch(commentProvider).controller.text,
                        context,
                        ref,
                        widget.postId);
                  }
                },
                child: Icon(
                  ref.watch(commentProvider).isEditMode
                      ? Icons.check
                      : Icons.send,
                  color: Colors.blue.shade200,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
