import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/constants/firebase_field_names.dart';

class Comment {
  final String text;
  final String uid;
  final String commentId;
  final DateTime creationTime;
  final String name;
  final String imageUrl;

  const Comment({
    required this.text,
    required this.uid,
    required this.commentId,
    required this.creationTime,
    required this.name,
    required this.imageUrl,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    final creationTime = doc[FirebaseFieldNames.commentCreationTime];

    return Comment(
      name: doc[FirebaseFieldNames.commentName],
      imageUrl: doc[FirebaseFieldNames.commentImage],
      text: doc[FirebaseFieldNames.commentText],
      uid: doc[FirebaseFieldNames.commentUid],
      commentId: doc.id,
      creationTime: (creationTime != null && creationTime is Timestamp)
          ? creationTime.toDate()
          : DateTime
              .now(), // Default to current date if timestamp is null or not of type Timestamp
    );
  }
}

class CommentState {
  final List<Comment> comments;
  final TextEditingController commentController;

  CommentState({
    required this.comments,
    required this.commentController,
  });

  CommentState copyWith({
    List<Comment>? comments,
    TextEditingController? commentController,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      commentController: commentController ?? this.commentController,
    );
  }
}
