import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/comments/comment_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/res/image_res.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/models/users.dart';
import '../../../data/repositoris/language_repository.dart';
import '../../../domain/riverpod/data/other_user_data.dart';
import '../../../domain/riverpod/screen/follow_checker.dart';
import '../../pages/profile/other_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentTile extends ConsumerStatefulWidget {
  final int index;
  final String postId;
  final CommentM comment;
  final bool canDelete;

  const CommentTile(
      {super.key,
      required this.index,
      required this.postId,
      required this.comment,
      required this.canDelete});

  @override
  ConsumerState<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends ConsumerState<CommentTile> {
  int replyCount = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageText = AppLocalizations.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final isOwner =
        currentUser != null && widget.comment.uid == currentUser.uid;

    return Padding(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: ref.watch(commentProvider).buildSlidableActions(
                null,
                widget.comment.commentId,
                widget.postId,
                context,
                isOwner,
                widget.canDelete,
                isRTL,
                ref,
                false,
                widget.comment),
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    widget.comment.imageUrl != ""
                        ? GestureDetector(
                            onTap: () async {
                              if (currentUser != null) {
                                DocumentSnapshot snapshot =
                                    await FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(widget.comment.uid)
                                        .get();
                                if (snapshot.exists) {
                                  Users myUser = Users.fromMap(
                                      snapshot.data() as Map<String, dynamic>);
                                  ref
                                      .read(otherUserProvider.notifier)
                                      .setDataUser(myUser);
                                  ref
                                      .read(followerProvider.notifier)
                                      .followOrUnFollow(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          widget.comment.uid);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtherProfile(
                                          user: myUser,
                                          uid: widget.comment.uid,
                                        ),
                                      ));
                                }
                              } else {
                                showDialogM(
                                    languageText!.you_are_not_logged_in);
                              }
                            },
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: CachedNetworkImage(
                                  imageUrl: widget.comment.imageUrl,
                                  placeholder: (context, url) => Image.asset(
                                    ImageRes.profileAvatar,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              if (currentUser != null) {
                                DocumentSnapshot snapshot =
                                    await FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(widget.comment.uid)
                                        .get();

                                if (snapshot.exists) {
                                  Users myUser = Users.fromMap(
                                      snapshot.data() as Map<String, dynamic>);
                                  ref
                                      .read(otherUserProvider.notifier)
                                      .setDataUser(myUser);
                                  ref
                                      .read(followerProvider.notifier)
                                      .followOrUnFollow(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          widget.comment.uid);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtherProfile(
                                          user: myUser,
                                          uid: widget.comment.uid,
                                        ),
                                      ));
                                }
                              } else {
                                showDialogM(
                                    languageText!.you_are_not_logged_in);
                              }
                            },
                            child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/Avatar.png')),
                          ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                        onTap: () async {
                          if (currentUser != null) {
                            DocumentSnapshot snapshot = await FirebaseFirestore
                                .instance
                                .collection('User')
                                .doc(widget.comment.uid)
                                .get();

                            if (snapshot.exists) {
                              Users myUser = Users.fromMap(
                                  snapshot.data() as Map<String, dynamic>);

                              ref
                                  .read(otherUserProvider.notifier)
                                  .setDataUser(myUser);

                              ref
                                  .read(followerProvider.notifier)
                                  .followOrUnFollow(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      widget.comment.uid);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtherProfile(
                                      uid: widget.comment.commentId,
                                      user: myUser,
                                    ),
                                  ));
                            }
                          } else {
                            showDialogM(languageText!.you_are_not_logged_in);
                          }
                        },
                        child: Text(widget.comment.name)),
                  ],
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(widget.comment.text),
                ),
              ],
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: !ref.watch(commentProvider).isReplyOpened[widget.index]
              ? InkWell(
                  onTap: () {
                    final list = ref.watch(commentProvider).isReplyOpened;
                    List<bool> newList = [];
                    for (int i = 0; i < list.length; i++) {
                      newList.add(false);
                    }

                    ref.read(commentProvider.notifier).fetchReplies(
                        ref, widget.postId, widget.comment.commentId);

                    newList[widget.index] = true;
                    ref
                        .read(commentProvider.notifier)
                        .setIsReplyOpened(newList);
                    print(newList);
                    print('newList');
                  },
                  child: !widget.comment.hasReply
                      ? const SizedBox()
                      : StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Places')
                              .doc(widget.postId)
                              .collection('postComments')
                              .doc(widget.comment.commentId)
                              .collection('reply')
                              .orderBy("timestamp", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              // If there's an error with the stream, handle it (e.g., show error message)
                              return const SizedBox(height: 0);
                            }

                            if (!snapshot.hasData) {
                              // If no data is available or the data list is empty, show appropriate message
                              return const SizedBox(height: 0);
                            }

                            // Data is available, process the documents
                            List<DocumentSnapshot> documents =
                                snapshot.data!.docs;
                            int replyCount = documents.length;

                            if (replyCount != 0) {
                              return Text(
                                "__View $replyCount more replies ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]),
                              );
                            }
                            // Return the widget displaying the number of replies

                            return const SizedBox(
                              height: 0,
                            );
                          },
                        ))
              : Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: !ref.watch(isReplyLoadedProvider)
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    ref.watch(commentProvider).replies.length,
                                itemBuilder: (context2, index) {
                                  final reply =
                                      ref.watch(commentProvider).replies[index];
                                  return Slidable(
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: ref
                                          .watch(commentProvider)
                                          .buildSlidableActions(
                                              widget.index,
                                              widget.comment.commentId,
                                              widget.postId,
                                              context,
                                              isOwner,
                                              widget.canDelete,
                                              isRTL,
                                              ref,
                                              true,
                                              reply),
                                    ),
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            child: Row(
                                              children: [
                                                widget.comment.imageUrl != ""
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          if (currentUser !=
                                                              null) {
                                                            DocumentSnapshot
                                                                snapshot =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'User')
                                                                    .doc(reply
                                                                        .uid)
                                                                    .get();
                                                            if (snapshot
                                                                .exists) {
                                                              Users myUser = Users
                                                                  .fromMap(snapshot
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>);
                                                              ref
                                                                  .read(otherUserProvider
                                                                      .notifier)
                                                                  .setDataUser(
                                                                      myUser);
                                                              ref
                                                                  .read(followerProvider
                                                                      .notifier)
                                                                  .followOrUnFollow(
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid,
                                                                      reply
                                                                          .uid);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            OtherProfile(
                                                                      user:
                                                                          myUser,
                                                                      uid: widget
                                                                          .comment
                                                                          .uid,
                                                                    ),
                                                                  ));
                                                            }
                                                          } else {
                                                            showDialogM(
                                                                languageText!
                                                                    .you_are_not_logged_in);
                                                          }
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                reply.imageUrl,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              ImageRes
                                                                  .profileAvatar,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          if (currentUser !=
                                                              null) {
                                                            DocumentSnapshot
                                                                snapshot =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'User')
                                                                    .doc(reply
                                                                        .uid)
                                                                    .get();

                                                            if (snapshot
                                                                .exists) {
                                                              Users myUser = Users
                                                                  .fromMap(snapshot
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>);
                                                              ref
                                                                  .read(otherUserProvider
                                                                      .notifier)
                                                                  .setDataUser(
                                                                      myUser);
                                                              ref
                                                                  .read(followerProvider
                                                                      .notifier)
                                                                  .followOrUnFollow(
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid,
                                                                      reply
                                                                          .uid);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            OtherProfile(
                                                                      user:
                                                                          myUser,
                                                                      uid: widget
                                                                          .comment
                                                                          .uid,
                                                                    ),
                                                                  ));
                                                            }
                                                          } else {
                                                            showDialogM(
                                                                languageText!
                                                                    .you_are_not_logged_in);
                                                          }
                                                        },
                                                        child: const CircleAvatar(
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/Avatar.png')),
                                                      ),
                                                const SizedBox(width: 8.0),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (currentUser != null) {
                                                        DocumentSnapshot
                                                            snapshot =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'User')
                                                                .doc(reply.uid)
                                                                .get();

                                                        if (snapshot.exists) {
                                                          Users myUser = Users
                                                              .fromMap(snapshot
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>);

                                                          ref
                                                              .read(
                                                                  otherUserProvider
                                                                      .notifier)
                                                              .setDataUser(
                                                                  myUser);

                                                          ref
                                                              .read(
                                                                  followerProvider
                                                                      .notifier)
                                                              .followOrUnFollow(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid,
                                                                  reply.uid);

                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OtherProfile(
                                                                  user: myUser,
                                                                  uid: widget
                                                                      .comment
                                                                      .uid,
                                                                ),
                                                              ));
                                                        }
                                                      } else {
                                                        showDialogM(languageText!
                                                            .you_are_not_logged_in);
                                                      }
                                                    },
                                                    child: Text(reply.name)),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: Text(reply.text),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              ))),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: InkWell(
                        onTap: () {
                          final list = ref.watch(commentProvider).isReplyOpened;
                          list[widget.index] = false;
                          ref
                              .read(commentProvider.notifier)
                              .setIsReplyOpened(list);
                        },
                        child: Text(
                          '___ Hide replies',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void showDialogM(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
        );
      },
    );
  }
}
