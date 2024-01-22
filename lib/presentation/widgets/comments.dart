import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/users_info.dart';
import '../../domain/riverpod/data/restricted_words.dart';
import 'comment_tile.dart';

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
        _showCommentSheet(context, widget.postId);
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
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text("${languageText.firstComment} !\n");
                            }

                            List<Comment> comments = [];
                            for (var doc in snapshot.data!.docs) {
                              comments.add(Comment.fromDocument(doc));
                            }

                            // Sort the comments based on the time difference from today
                            comments.sort((a, b) {
                              var now = DateTime.now();
                              var differenceA =
                                  now.difference(a.timestamp).abs();
                              var differenceB =
                                  now.difference(b.timestamp).abs();
                              return differenceA.compareTo(differenceB);
                            });
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }

  void _showCommentSheet(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommentSheet(postId: postId);
      },
    );
  }
}

class CommentSheet extends ConsumerStatefulWidget {
  final String postId;

  const CommentSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();
  late final CollectionReference commentsCollection;
  late final CollectionReference usersCollection;

  @override
  void initState() {
    super.initState();
    commentsCollection = FirebaseFirestore.instance.collection('Places');
    usersCollection = FirebaseFirestore.instance.collection('User');
  }

  @override
  Widget build(BuildContext context) {
    final languageText = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.70,
      child: Column(
        children: [
          Row(
            children: [
              //comment's textFiled
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: '${languageText!.add_a_comment}...',
                  ),
                ),
              ),
              //done icon
              IconButton(
                  onPressed: () {
                    _submitComment(_commentController.text, context);
                    _commentController.clear();
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: commentsCollection
                  .doc(widget.postId)
                  .collection('postComments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.grey,
                  ));
                }

                List<Comment> comments = [];
                for (var doc in snapshot.data!.docs) {
                  comments.add(Comment.fromDocument(doc));
                }

                // Sort the comments based on the time difference from today
                comments.sort((a, b) {
                  var now = DateTime.now();
                  var differenceA = now.difference(a.timestamp).abs();
                  var differenceB = now.difference(b.timestamp).abs();
                  return differenceA.compareTo(differenceB);
                });

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<UsersInfo>(
                      future: _getUserInfo(comments[index].uid),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(height: 0);
                        }

                        if (userSnapshot.hasError) {
                          return Text('Error: ${userSnapshot.error}');
                        }

                        final userInfo = userSnapshot.data;

                        return CommentTile(
                          comment: comments[index],
                          userInfo: userInfo,
                          onDelete: () {
                            _deleteComment(comments[index]);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _submitComment(String commentText, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      // Check if the comment is not empty
      if (commentText.trim().isEmpty) {
        // Show an error message or handle it as needed
        print('Comment cannot be empty.');
        return;
      }

      // List of restricted words
      List<String> restrictedWords = ref.watch(restrictedWord);

      // Check if the comment contains any restricted word
      if (restrictedWords.any((word) => commentText.contains(word))) {
        // Show a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please use good words"),
          ),
        );
        FocusScope.of(context).unfocus();
        return; // Stop further processing
      }

      commentsCollection.doc(widget.postId).collection('postComments').add({
        'text': commentText,
        'uid': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    _commentController.clear();
  }

  void _deleteComment(Comment comment) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null && comment.uid == uid) {
      await commentsCollection
          .doc(widget.postId)
          .collection('postComments')
          .doc(comment.commentId)
          .delete();
    }
  }

  Future<UsersInfo> _getUserInfo(String uid) async {
    var userDoc = await usersCollection.doc(uid).get();
    if (userDoc.exists) {
      return UsersInfo.fromDocument(userDoc);
    } else {
      // Return a default user info or handle it as needed
      return UsersInfo(name: "name", imageUrl: "imageUrl");
    }
  }
}
