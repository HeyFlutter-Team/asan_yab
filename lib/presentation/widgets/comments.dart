import 'dart:core';
import 'package:asan_yab/domain/riverpod/data/comment_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/models/comment_model.dart';

class Comments extends ConsumerStatefulWidget {
  final String postId;
  const Comments({super.key, required this.postId});

  @override
  ConsumerState<Comments> createState() => _CommentsState();
}

class _CommentsState extends ConsumerState<Comments> {
  @override
  Widget build(BuildContext context) {
    final languageText = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        ref
            .read(commentProvider.notifier)
            .showCommentSheet(context, widget.postId);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageText!.comment,
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Places')
                              .doc(widget.postId)
                              .collection('postComments')
                              .orderBy("timestamp", descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text("${languageText.firstComment} !\n");
                            }

                            List<CommentM> comments = [];
                            for (var doc in snapshot.data!.docs) {
                              comments.add(CommentM.fromDocument(doc));
                            }
                            if (comments.isEmpty) {
                              return Text("${languageText.firstComment} !\n");
                            }
                            return Text(comments[0].text.length > 35
                                ? comments[0].text.substring(0, 35)
                                : comments[0].text);
                          }),
                      Text(
                        "${languageText.more}...",
                        style: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
