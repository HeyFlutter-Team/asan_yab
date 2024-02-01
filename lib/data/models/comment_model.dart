import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String text;
  final String uid;
  final String commentId;
  final DateTime timestamp;

  Comment({
    required this.text,
    required this.uid,
    required this.commentId,
    required this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    final timestamp = doc['timestamp'];

    return Comment(
      text: doc['text'],
      uid: doc['uid'],
      commentId: doc.id,
      timestamp: (timestamp != null && timestamp is Timestamp)
          ? timestamp.toDate()
          : DateTime
              .now(), // Default to current date if timestamp is null or not of type Timestamp
    );
  }
}
