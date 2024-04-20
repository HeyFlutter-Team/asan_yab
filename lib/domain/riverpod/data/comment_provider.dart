import 'package:asan_yab/domain/riverpod/data/restricted_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/firebase_collection_names.dart';
import '../../../data/models/comment.dart';
import '../../../data/models/users.dart';
import '../../../presentation/widgets/comment_sheet_widget.dart';

final commentProvider =
    ChangeNotifierProvider<CommentProvider>((ref) => CommentProvider());

class CommentProvider extends ChangeNotifier {
  CommentProvider();
  bool _isLoading = false;
  List<Comment> _comments = [];
  final firestore = FirebaseFirestore.instance;
  List<Comment> get comments => _comments;
  final _commentController = TextEditingController();

  TextEditingController get controller => _commentController;

  int calculateMaxLines() {
    final text = _commentController.text;
    if (text.isEmpty) {
      return 1; // Default to 1 line when text is empty
    }
    int totalLines = (text.length / 30).ceil();
    return totalLines > 2 ? 2 : totalLines;
  }

  void setText(String text) {
    _commentController.text = text;
    notifyListeners();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  setComments(List<Comment> newComments) {
    _comments = newComments;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  onBackspacePressed() {
    controller
      ..text = controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
  }

  Future<void> fetchMoreData(String postId) async {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 1)).then((value) async {
      final lastTimestamp =
          comments.isNotEmpty ? comments.last.creationTime : DateTime.now();

      try {
        final snapshot = await firestore
            .collection(FirebaseCollectionNames.places)
            .doc(postId)
            .collection(FirebaseCollectionNames.postComments)
            .orderBy("timestamp", descending: true)
            .startAfter([lastTimestamp])
            .limit(5)
            .get();

        for (final doc in snapshot.docs) {
          _comments.add(Comment.fromDocument(doc));
        }

        notifyListeners();
      } catch (error) {
        debugPrint("Error loading more comments: $error");
      }
      notifyListeners();
    }).whenComplete(() {
      _isLoading = false;
    });
  }

  void submitComment(
    String commentText,
    BuildContext context,
    WidgetRef ref,
    String postId,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid != null) {
        if (commentText.trim().isEmpty) {
          debugPrint('Comment cannot be empty.');
          return;
        }

        final restrictedWords = ref.watch(restrictedWordProvider);

        if (restrictedWords.any((word) => commentText.contains(word))) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please use appropriate language."),
            ),
          );
          FocusScope.of(context).unfocus();
          return;
        }

        final info = await _getUserInfo(uid);

        final newCommentDoc = await firestore
            .collection(FirebaseCollectionNames.places)
            .doc(postId)
            .collection(FirebaseCollectionNames.postComments)
            .add({
          'name': info.name,
          'imageUrl': info.imageUrl,
          'text': commentText,
          'uid': uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        final newComment = Comment(
          name: info.name,
          imageUrl: info.imageUrl,
          text: commentText,
          uid: uid,
          commentId: newCommentDoc.id,
          creationTime: DateTime.now(),
        );

        setComments([newComment, ...comments]);
      }
    } catch (e) {
      debugPrint('Error submitting comment: $e');
    }
    notifyListeners();
  }

  Future<Users> _getUserInfo(String uid) async {
    final userDoc =
        await firestore.collection(FirebaseCollectionNames.user).doc(uid).get();
    return userDoc.exists
        ? Users.fromMap(userDoc.data() as Map<String, dynamic>)
        : Users(
            id: 1,
            name: 'name',
            lastName: 'lastName',
            email: 'email',
            createdAt: Timestamp.now(),
            fcmToken: 'fcmToken',
            isOnline: true,
            imageUrl: '',
          );
  }

  void deleteComment(
    Comment comment,
    WidgetRef ref,
    String postId,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null && comment.uid == uid) {
      await firestore
          .collection(FirebaseCollectionNames.places)
          .doc(postId)
          .collection(FirebaseCollectionNames.postComments)
          .doc(comment.commentId)
          .delete();
    }
    setComments(
        comments.where((c) => c.commentId != comment.commentId).toList());

    notifyListeners();
  }

  void showCommentSheet(
    BuildContext context,
    String postId,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => CommentSheetWidget(postId: postId),
    );
    notifyListeners();
  }

  void showOptionsBottomSheet(
    BuildContext context,
    bool isOwner,
    VoidCallback onDelete,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isOwner
              ? ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    context.pop();
                    if (isOwner) {
                      onDelete();
                    }
                  },
                )
              : SizedBox(height: 0.h),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report'),
            onTap: () => context.pop(),
          ),
        ],
      ),
    );
    notifyListeners();
  }
}
