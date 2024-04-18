import 'dart:core';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/riverpod/data/comment_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/comment.dart';

class CommentsWidget extends ConsumerStatefulWidget {
  final String postId;
  const CommentsWidget({super.key, required this.postId});

  @override
  ConsumerState<CommentsWidget> createState() => _CommentsState();
}

class _CommentsState extends ConsumerState<CommentsWidget> {
  @override
  Widget build(BuildContext context) {
    final text = texts(context);
    return GestureDetector(
      onTap: () {
        ref
            .read(commentProvider.notifier)
            .showCommentSheet(context, widget.postId);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
        child: SizedBox(
          width: double.infinity.w,
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
                    text.comment,
                    style: const TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 3.h),
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
                              return Text("${text.firstComment} !\n");
                            }

                            List<Comment> comments = [];
                            for (var doc in snapshot.data!.docs) {
                              comments.add(Comment.fromDocument(doc));
                            }
                            if (comments.isEmpty) {
                              return Text("${text.firstComment} !\n");
                            }
                            return Text(comments[0].text.length > 35
                                ? comments[0].text.substring(0, 35)
                                : comments[0].text);
                          }),
                      Text(
                        "${text.more}...",
                        style: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
