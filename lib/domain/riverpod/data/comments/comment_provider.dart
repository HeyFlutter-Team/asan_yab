import 'dart:async';

import 'package:asan_yab/domain/riverpod/data/restricted_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../data/models/comment_model.dart';
import '../../../../data/models/unSent_Comment.dart';
import '../../../../data/models/users.dart';
import '../../../../presentation/widgets/comment/comment_sheet.dart';
import '../message/message.dart';

final commentProvider = ChangeNotifierProvider<VerticalDataNotifier>(
    (ref) => VerticalDataNotifier());

class VerticalDataNotifier extends ChangeNotifier {
  bool _isLoading = false;
  List<CommentM> _comments = [];
  List<bool> _isReplyOpened = [];
  List<bool> get isReplyOpened => _isReplyOpened;
  setIsReplyOpened(List<bool> newComments) {
    _isReplyOpened = newComments;
    notifyListeners();
  }

  List<UnsentComment> texts = [];

  List<CommentM> get comments => _comments;
  setComments(List<CommentM> newComments) {
    _comments = newComments;
    notifyListeners();
  }

  final TextEditingController _commentController = TextEditingController();

  TextEditingController get controller => _commentController;

  void setText(String text) {
    _commentController.text = text;
    notifyListeners();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Getter for isLoading
  bool get isLoading => _isLoading;

  // Setter for isLoading
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Notify listeners whenever isLoading changes
  }

  onBackspacePressed() {
    controller
      ..text = controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
  }

// Define a method to get the stream for reply documents
  int calculateMaxLines() {
    final text = _commentController.text;
    if (text.isEmpty) {
      return 1; // Default to 1 line when text is empty
    }
    int totalLines = (text.length / 24).ceil();

    return totalLines > 3 ? 3 : totalLines;
  }

  Future<void> fetchMoreData(String postId) async {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 1)).then((value) async {
      final lastTimestamp =
          comments.isNotEmpty ? comments.last.timestamp : DateTime.now();

      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('Places')
            .doc(postId)
            .collection('postComments')
            .orderBy("timestamp", descending: true)
            .startAfter([lastTimestamp]) // Start after the last loaded comment
            .limit(10) // Load next 3 comments
            .get();
        for (final doc in snapshot.docs) {
          _isReplyOpened.add(false);
          final userDoc = await FirebaseFirestore.instance
              .collection("User")
              .doc(CommentM.fromDocument(doc).uid)
              .get();

          final user = userDoc.exists
              ? Users.fromMap(userDoc.data() as Map<String, dynamic>)
              : Users(
                  id: '1',
                  name: 'name',
                  lastName: 'lastName',
                  email: 'email',
                  createdAt: Timestamp.now().toString(),
                  fcmToken: 'fcmToken',
                  isOnline: true,
                  imageUrl: '',
                  userType: 'normal');

          _comments.add(CommentM(
              text: CommentM.fromDocument(doc).text,
              uid: CommentM.fromDocument(doc).uid,
              commentId: CommentM.fromDocument(doc).commentId,
              timestamp: CommentM.fromDocument(doc).timestamp,
              name: user.name,
              imageUrl: user.imageUrl,
              hasReply: CommentM.fromDocument(doc).hasReply));
        }

        notifyListeners(); // Notify listeners after updating the list
      } catch (error) {
        print("Error loading more comments: $error");
      }
      notifyListeners();
    }).whenComplete(() {
      _isLoading = false;
    });
  }

  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;

  // Setter for isLoading
  set isEditMode(bool value) {
    _isEditMode = value;
    notifyListeners(); // Notify listeners whenever isLoading changes
  }

  Future<void> updateCommentAndReply(String commentText, BuildContext context,
      WidgetRef ref, String postId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid == null) {
        // User is not authenticated
        return;
      }
      if (commentText.trim().isEmpty) {
        // Comment text is empty
        print('reply cannot be empty.');
        return;
      }
      List<String> restrictedWords = ref.watch(restrictedWord);

      if (restrictedWords.any((word) => commentText.contains(word))) {
        // Comment contains restricted words
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please use appropriate language."),
          ),
        );
        FocusScope.of(context).unfocus();
        return;
      }

      final info = await getUserInfo(uid);

      if (!ref.watch(isReplyModeProvider)) {
        final commentIdToEdit = ref.watch(commentIdProvider);
        if (commentIdToEdit.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('Places')
              .doc(postId)
              .collection('postComments')
              .doc(commentIdToEdit)
              .update({
            'text': commentText,
          });
          int index = _comments
              .indexWhere((comment) => comment.commentId == commentIdToEdit);
          if (index != -1) {
            final newComment = CommentM(
                name: info.name,
                imageUrl: info.imageUrl,
                text: commentText,
                uid: _comments[index].uid,
                commentId: _comments[index].commentId,
                timestamp: DateTime.now(),
                hasReply: _comments[index].hasReply);
            _comments[index] = newComment;
            notifyListeners();
          }
        }
        ref.read(commentIdProvider.notifier).state = '';
        isEditMode = false;
      } else {
        final commentIdToEdit = ref.watch(commentIdProvider);
        final replyIdToEdit = ref.watch(replyIdProvider);
        if (commentIdToEdit.isNotEmpty && replyIdToEdit.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('Places')
              .doc(postId)
              .collection('postComments')
              .doc(commentIdToEdit)
              .collection('reply')
              .doc(replyIdToEdit)
              .update({
            'text': commentText,
          });
          int index = replies
              .indexWhere((comment) => comment.commentId == replyIdToEdit);
          if (index != -1) {
            final newComment = CommentM(
                name: info.name,
                imageUrl: info.imageUrl,
                text: commentText,
                uid: replies[index].uid,
                commentId: replies[index].commentId,
                timestamp: DateTime.now(),
                hasReply: replies[index].hasReply);
            replies[index] = newComment;
          }
        }
        ref.read(commentIdProvider.notifier).state = '';
        isEditMode = false;
      }
      ref.read(commentProvider.notifier).controller.clear();
      ref.read(emojiShowingProvider.notifier).state = false;
      ref.read(replyCommentProvider.notifier).state = false;
      ref.read(commentIdProvider.notifier).state = '';
      // Notify listeners or update state
      notifyListeners();
    } catch (e) {
      print('Error editing comment: $e');
    }
  }

  void submitComment(String commentText, BuildContext context, WidgetRef ref,
      String postId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid == null) {
        // User is not authenticated
        return;
      }

      if (commentText.trim().isEmpty) {
        // Comment text is empty
        print('Comment cannot be empty.');
        return;
      }

      List<String> restrictedWords = ref.watch(restrictedWord);

      if (restrictedWords.any((word) => commentText.contains(word))) {
        // Comment contains restricted words
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please use appropriate language."),
          ),
        );
        FocusScope.of(context).unfocus();
        return;
      }

      final info = await getUserInfo(uid);

      if (!ref.watch(replyCommentProvider)) {
        // Add a new comment
        print("Adding new comment");

        final newCommentDoc = await FirebaseFirestore.instance
            .collection('Places')
            .doc(postId)
            .collection('postComments')
            .add({
          'name': '',
          'imageUrl': '',
          'text': commentText,
          'uid': uid,
          'timestamp': FieldValue.serverTimestamp(),
          'hasReply': false
        });

        final newComment = CommentM(
            name: info.name,
            imageUrl: info.imageUrl,
            text: commentText,
            uid: uid,
            commentId: newCommentDoc.id,
            timestamp: DateTime.now(),
            hasReply: false);

        // Update local state or UI with new comment
        setComments([newComment, ...comments]);
        setIsReplyOpened([false, ...isReplyOpened]);
      } else {
        final commentIdToReply = ref.watch(commentIdProvider);
        // Adding a new reply
        print("Adding new reply");
        if (!ref.watch(hasReplyProvider)) {
          FirebaseFirestore.instance
              .collection('Places')
              .doc(postId)
              .collection('postComments')
              .doc(commentIdToReply)
              .update({
            'hasReply': true,
          });
          int index = comments
              .indexWhere((element) => element.commentId == commentIdToReply);

          comments[index] = CommentM(
              text: comments[index].text,
              uid: comments[index].uid,
              commentId: comments[index].commentId,
              timestamp: comments[index].timestamp,
              name: info.name,
              imageUrl: info.imageUrl,
              hasReply: true);
        }
        if (commentIdToReply.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('Places')
              .doc(postId)
              .collection('postComments')
              .doc(commentIdToReply)
              .collection("reply")
              .add({
            'name': '',
            'imageUrl': '',
            'text': commentText,
            'uid': uid,
            'timestamp': FieldValue.serverTimestamp(),
            'hasReply': false,
          });
        } else {
          print('Reply parent comment ID is empty.');
        }
      }

      ref.read(commentProvider.notifier).controller.clear();
      ref.read(emojiShowingProvider.notifier).state = false;
      ref.read(replyCommentProvider.notifier).state = false;
      ref.read(commentIdProvider.notifier).state = '';
      // Notify listeners or update state
      notifyListeners();
    } catch (e) {
      print('Error submitting comment: $e');
    }
  }

  Future<Users> getUserInfo(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('User').doc(uid).get();
    notifyListeners();
    return userDoc.exists
        ? Users.fromMap(userDoc.data() as Map<String, dynamic>)
        : Users(
            id: '1',
            name: 'name',
            lastName: 'lastName',
            email: 'email',
            createdAt: Timestamp.now().toString(),
            fcmToken: 'fcmToken',
            isOnline: true,
            imageUrl: '',
            userType: 'normal');
  }

  void deleteComment(
    int? index,
    String? commentId,
    CommentM reply,
    WidgetRef ref,
    String postId,
    bool isReply,
  ) async {
    controller.clear();
    _isEditMode = false;
    ref.watch(replyCommentProvider.notifier).state = false;

    if (!isReply) {
      setComments(
          comments.where((c) => c.commentId != reply.commentId).toList());
      await FirebaseFirestore.instance
          .collection('Places')
          .doc(postId)
          .collection('postComments')
          .doc(reply.commentId)
          .collection('reply')
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      // Delete the comment itself from 'postComments' collection
      await FirebaseFirestore.instance
          .collection('Places')
          .doc(postId)
          .collection('postComments')
          .doc(reply.commentId)
          .delete();
    } else {
      replies = replies.where((c) => c.commentId != reply.commentId).toList();
      if (replies.isEmpty) {
        _isReplyOpened[index!] = false;
        ref.read(hasReplyProvider.notifier).state = true;

        FirebaseFirestore.instance
            .collection('Places')
            .doc(postId)
            .collection('postComments')
            .doc(commentId)
            .update({
          'hasReply': false,
        });
      }
      await FirebaseFirestore.instance
          .collection('Places')
          .doc(postId)
          .collection('postComments')
          .doc(commentId)
          .collection('reply')
          .doc(reply.commentId)
          .delete();
    }

    // Notify listeners after the deletion process is complete
    notifyListeners();
  }

  void showCommentSheet(BuildContext context, String postId, WidgetRef ref) {
    ref.watch(replyCommentProvider.notifier).state = false;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return CommentSheet(
          postId: postId,
        );
      },
    ).then((value) {
      ref.read(emojiShowingProvider.notifier).state = false;

      if (_commentController.text.isNotEmpty) {
        bool found = false;
        for (int i = 0; i < texts.length; i++) {
          if (texts[i].postId == postId) {
            texts[i].comment = _commentController.text;
            found = true;
            break; // Exit the loop since the comment has been updated
          }
        }

        // If no existing UnsentComment with matching postId is found, add a new one
        if (!found) {
          texts.add(
            UnsentComment(comment: _commentController.text, postId: postId),
          );
        }
      }
      _commentController.clear();
      for (int i = 0; i < _isReplyOpened.length; i++) {
        _isReplyOpened[i] = false;
      }
      notifyListeners();
    });
  }

  void unSent(String postId) {
    List<UnsentComment> copyTexts = List.from(texts);

    for (int i = 0; i < copyTexts.length; i++) {
      if (copyTexts[i].postId == postId) {
        _commentController.text = copyTexts[i].comment;
        texts.remove(copyTexts[i]);
        break;
      }
    }

    notifyListeners(); // Notify listeners after the modification
  }

  String name = '';
  String replyText = '';
  List<Widget> buildSlidableActions(
      int? index,
      String commentId,
      String postId,
      BuildContext context,
      bool isOwner,
      canDeleteComment,
      bool isRTL,
      WidgetRef ref,
      bool isReply,
      CommentM comment) {
    return [
      isOwner
          ? SlidableAction(
              padding: const EdgeInsets.all(1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              onPressed: (_) {
                name = comment.name;
                replyText = comment.text;

                isEditMode = true;

                ref.read(isReplyModeProvider.notifier).state = isReply;
                ref.read(commentIdProvider.notifier).state = commentId;
                if (isReply) {
                  ref.read(replyIdProvider.notifier).state = comment.commentId;
                }
                _commentController.text = comment.text;
                notifyListeners();
              },
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.white,
              icon: Icons.edit_calendar,
              label: 'Edit',
            )
          : const SizedBox(),
      if (isOwner)
        VerticalDivider(
          width: 1,
          color: Colors.grey.shade600,
        ),
      SlidableAction(
        padding: const EdgeInsets.all(1),
        onPressed: (_) {
          isEditMode = false;
          _commentController.clear();

          name = comment.name;
          replyText = comment.text;
          ref.read(commentIdProvider.notifier).state = '';
          ref.read(commentIdProvider.notifier).state = comment.commentId;
          ref.read(hasReplyProvider.notifier).state = comment.hasReply;
          ref.read(replyCommentProvider.notifier).state = false;
          ref.read(replyCommentProvider.notifier).state = true;
        },
        backgroundColor: Colors.grey.shade700,
        foregroundColor: Colors.white,
        icon: Icons.reply,
        label: 'Reply',
      ),
      VerticalDivider(
        width: 1,
        color: Colors.grey.shade600,
      ),
      isOwner || canDeleteComment
          ? SlidableAction(
              padding: const EdgeInsets.all(1),
              onPressed: (_) {
                if (isOwner || canDeleteComment) {
                  deleteComment(
                      index, commentId, comment, ref, postId, isReply);
                  // Perform delete action
                }
              },
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Delete',
            )
          : SlidableAction(
              padding: const EdgeInsets.all(1),
              onPressed: (_) {
                // Handle archive action here
              },
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.red,
              icon: Icons.report,
              label: 'Report',
            ),

      // Add more SlidableAction widgets here as needed
    ];
  }

  List<CommentM> replies = [];
  Future<void> fetchReplies(
      WidgetRef ref, String postId, String commentId) async {
    ref.read(isReplyLoadedProvider.notifier).state = true;
    replies = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Places')
          .doc(postId)
          .collection('postComments')
          .doc(commentId)
          .collection('reply')
          .orderBy("timestamp", descending: true)
          .get();

      for (final doc in querySnapshot.docs) {
        final userDoc = await FirebaseFirestore.instance
            .collection("User")
            .doc(CommentM.fromDocument(doc).uid)
            .get();

        final user = userDoc.exists
            ? Users.fromMap(userDoc.data() as Map<String, dynamic>)
            : Users(
                id: '1',
                name: 'name',
                lastName: 'lastName',
                email: 'email',
                createdAt: Timestamp.now().toString(),
                fcmToken: 'fcmToken',
                isOnline: true,
                imageUrl: '',
                userType: 'normal');

        replies.add(CommentM(
            text: CommentM.fromDocument(doc).text,
            uid: CommentM.fromDocument(doc).uid,
            commentId: CommentM.fromDocument(doc).commentId,
            timestamp: CommentM.fromDocument(doc).timestamp,
            name: user.name,
            imageUrl: user.imageUrl,
            hasReply: CommentM.fromDocument(doc).hasReply));
      }
    } catch (error) {
      print('Error fetching replies: $error');
      // Handle error as needed (e.g., show error message)
    }
    ref.read(isReplyLoadedProvider.notifier).state = false;
  }
}

final hasReplyProvider = StateProvider<bool>((ref) => false);
final isReplyModeProvider = StateProvider<bool>((ref) => false);
final isReplyLoadedProvider = StateProvider<bool>((ref) => false);
final commentIdReplyProvider = StateProvider<String>((ref) => "");
final replyCommentProvider = StateProvider<bool>((ref) => false);
final commentIdProvider = StateProvider<String>((ref) => "");
final replyIdProvider = StateProvider<String>((ref) => "");
