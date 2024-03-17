import 'package:asan_yab/domain/riverpod/data/restricted_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/models/users.dart';
import '../../../presentation/widgets/comment_sheet.dart';

final commentProvider = ChangeNotifierProvider<VerticalDataNotifier>(
    (ref) => VerticalDataNotifier());

class VerticalDataNotifier extends ChangeNotifier {
  bool _isLoading = false;
  List<CommentM> _comments = [];

  List<CommentM> get comments => _comments;
  final TextEditingController _commentController = TextEditingController();

  TextEditingController get controller => _commentController;

  int calculateMaxLines() {
    final text = _commentController.text;
    if (text.isEmpty) {
      return 1; // Default to 1 line when text is empty
    }
    int totalLines = (text.length / 24).ceil();

    return totalLines > 3 ? 3 : totalLines;
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

  setComments(List<CommentM> newComments) {
    _comments = newComments;
    notifyListeners();
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
            .limit(5) // Load next 3 comments
            .get();

        for (final doc in snapshot.docs) {
          _comments.add(CommentM.fromDocument(doc));
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

  void submitComment(String commentText, BuildContext context, WidgetRef ref,
      String postId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid != null) {
        if (commentText.trim().isEmpty) {
          print('Comment cannot be empty.');
          return;
        }

        List<String> restrictedWords = ref.watch(restrictedWord);

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

        final newCommentDoc = await FirebaseFirestore.instance
            .collection('Places')
            .doc(postId)
            .collection('postComments')
            .add({
          'name': info.name,
          'imageUrl': info.imageUrl,
          'text': commentText,
          'uid': uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        final newComment = CommentM(
          name: info.name,
          imageUrl: info.imageUrl,
          text: commentText,
          uid: uid,
          commentId: newCommentDoc.id,
          timestamp: DateTime.now(),
        );

        setComments([newComment, ...comments]);
      }
    } catch (e) {
      print('Error submitting comment: $e');
    }
    notifyListeners();
  }

  Future<Users> _getUserInfo(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('User').doc(uid).get();
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

  void deleteComment(CommentM comment, WidgetRef ref, String postId) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null && comment.uid == uid) {
      await FirebaseFirestore.instance
          .collection('Places')
          .doc(postId)
          .collection('postComments')
          .doc(comment.commentId)
          .delete();
    }
    setComments(
        comments.where((c) => c.commentId != comment.commentId).toList());

    notifyListeners();
  }

  void showCommentSheet(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommentSheet(
          postId: postId,
        );
      },
    );
    notifyListeners();
  }

  void showOptionsBottomSheet(
      BuildContext context, bool isOwner, VoidCallback onDelete) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isOwner
                ? ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet
                      if (isOwner) {
                        onDelete(); // Perform delete action
                      }
                    },
                  )
                : const SizedBox(height: 0),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                // Implement report action
              },
            ),
          ],
        );
      },
    );
    notifyListeners();
  }
}
