import 'package:cloud_firestore/cloud_firestore.dart';

class CommentM {
  final String text;
  final String uid;
  final String commentId;
  final DateTime timestamp;
  final String name;
  final String imageUrl;
  final bool hasReply;

  CommentM(
      {required this.text,
      required this.uid,
      required this.commentId,
      required this.timestamp,
      required this.name,
      required this.imageUrl,
      required this.hasReply});

  factory CommentM.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data was not available.');
    }

    final timestamp = data['timestamp'];

    return CommentM(
      name: data['name'],
      imageUrl: data['imageUrl'],
      text: data['text'],
      uid: data['uid'],
      hasReply: data['hasReply'],
      commentId: doc.id,
      timestamp: (timestamp != null && timestamp is Timestamp)
          ? timestamp.toDate()
          : DateTime.now(),
    );
  }
}
