import 'package:asan_yab/data/models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider = StateNotifierProvider<MessageProvider, List<CommentM>>(
    (ref) => MessageProvider([], ref));

class MessageProvider extends StateNotifier<List<CommentM>> {
  final Ref ref;
  MessageProvider(super.state, this.ref);
  Future<List<CommentM>> getMessages(String postId, CommentM comment) async {
    try {
      FirebaseFirestore.instance
          .collection('Places')
          .doc(postId)
          .collection('postComments')
          .doc(comment.commentId)
          .collection('reply')
          .orderBy("timestamp", descending: true)
          .snapshots(includeMetadataChanges: true)
          .listen((messages) async {
        print('getMessageeeeeeeeeeeeeeeeeeeeeeeeeee');
        if (mounted) {
          state =
              messages.docs.map((doc) => CommentM.fromDocument(doc)).toList();
        }
      });
      print('getMessages 2');
      return state;
    } catch (e) {
      rethrow;
    } finally {
      print('final test');
    }
  }

  void clearState() => state.clear();
}
