import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/domain/riverpod/data/comment_provider.dart';
import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:asan_yab/domain/riverpod/screen/check_follower.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/comment.dart';
import '../../data/models/users.dart';

class CommentTileWidget extends ConsumerStatefulWidget {
  final Comment comment;
  final VoidCallback onDelete;

  const CommentTileWidget({
    Key? key,
    required this.comment,
    required this.onDelete,
  }) : super(key: key);

  @override
  ConsumerState<CommentTileWidget> createState() => _CommentTileState();
}

class _CommentTileState extends ConsumerState<CommentTileWidget> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner =
        currentUser != null && widget.comment.uid == currentUser.uid;

    return Card(
      elevation: 10,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                widget.comment.imageUrl != ""
                    ? GestureDetector(
                        onTap: () async {
                          final snapshot = await FirebaseFirestore.instance
                              .collection('User')
                              .doc(widget.comment.uid)
                              .get();
                          if (snapshot.exists) {
                            final myUser = Users.fromMap(
                                snapshot.data() as Map<String, dynamic>);
                            ref
                                .read(otherUserDataProvider.notifier)
                                .setDataUser(myUser);
                            ref
                                .read(checkFollowerProvider.notifier)
                                .followOrUnFollow(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.comment.uid);
                            if (context.mounted) {
                              context.pushNamed(Routes.otherProfile);
                            }
                          }
                        },
                        child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.comment.imageUrl)),
                      )
                    : GestureDetector(
                        onTap: () async {
                          debugPrint('1');
                          final snapshot = await FirebaseFirestore.instance
                              .collection('User')
                              .doc(widget.comment.uid)
                              .get();
                          debugPrint('2');
                          if (snapshot.exists) {
                            final myUser = Users.fromMap(
                                snapshot.data() as Map<String, dynamic>);
                            debugPrint('3');
                            ref
                                .read(otherUserDataProvider.notifier)
                                .setDataUser(myUser);
                            debugPrint('4');
                            ref
                                .read(checkFollowerProvider.notifier)
                                .followOrUnFollow(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.comment.uid);
                            debugPrint('5');
                            if (context.mounted) {
                              context.pushNamed(Routes.otherProfile);
                            }
                            debugPrint('7');
                          }
                        },
                        child: const CircleAvatar(
                          backgroundImage: AssetImage('assets/Avatar.png'),
                        ),
                      ),
                SizedBox(width: 8.0.w),
                GestureDetector(
                  onTap: () async {
                    debugPrint('1');
                    final snapshot = await FirebaseFirestore.instance
                        .collection('User')
                        .doc(widget.comment.uid)
                        .get();
                    debugPrint('2');
                    if (snapshot.exists) {
                      final myUser = Users.fromMap(
                          snapshot.data() as Map<String, dynamic>);
                      debugPrint('3');
                      ref
                          .read(otherUserDataProvider.notifier)
                          .setDataUser(myUser);
                      debugPrint('4');
                      ref.read(checkFollowerProvider.notifier).followOrUnFollow(
                          FirebaseAuth.instance.currentUser!.uid,
                          widget.comment.uid);
                      debugPrint('5');
                      if (context.mounted) {
                        context.pushNamed(Routes.otherProfile);
                      }
                      debugPrint('6');
                    }
                  },
                  child: Text(widget.comment.name),
                ),
              ],
            ),
            SizedBox(height: 4.0.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(widget.comment.text),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            ref
                .read(commentProvider.notifier)
                .showOptionsBottomSheet(context, isOwner, widget.onDelete);
          },
        ),
      ),
    );
  }
}
