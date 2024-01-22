import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/models/comment_model.dart';
import '../../data/models/users_info.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final UsersInfo? userInfo;
  final VoidCallback onDelete;

  const CommentTile({
    Key? key,
    required this.comment,
    required this.onDelete,
    this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner = currentUser != null && comment.uid == currentUser.uid;

    return Card(
      elevation: 10,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInfo != null
                ? Row(
                    children: [
                      userInfo!.imageUrl != ""
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(userInfo!.imageUrl),
                            )
                          : const CircleAvatar(
                              backgroundImage: AssetImage('assets/Avatar.png')),
                      const SizedBox(width: 8.0),
                      Text(userInfo!.name),
                    ],
                  )
                : const Text('Unknown User'),
            const SizedBox(height: 4.0),
            Text(comment.text),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showOptionsBottomSheet(context, isOwner);
          },
        ), // Show options icon only for the owner
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, bool isOwner) {
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
  }
}
