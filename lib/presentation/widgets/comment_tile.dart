import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/comment_model.dart';
import '../../data/models/users_info.dart';

class CommentTile extends ConsumerStatefulWidget {
  final CommentM comment;
  final VoidCallback onDelete;

  const CommentTile({
    Key? key,
    required this.comment,
    required this.onDelete,
  }) : super(key: key);

  @override
  ConsumerState<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends ConsumerState<CommentTile> {
  late Future<UsersInfo> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _getUserInfo(widget.comment.uid);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner =
        currentUser != null && widget.comment.uid == currentUser.uid;

    return Card(
      elevation: 10,
      child: ListTile(
        title: FutureBuilder<UsersInfo>(
          future: _userInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(height: 0)); // or any other loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final usersInfo = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      usersInfo.imageUrl != ""
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(usersInfo.imageUrl),
                            )
                          : const CircleAvatar(
                              backgroundImage: AssetImage('assets/Avatar.png')),
                      const SizedBox(width: 8.0),
                      Text(usersInfo.name),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(widget.comment.text),
                  ),
                ],
              );
            }
          },
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
                        widget.onDelete(); // Perform delete action
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

  Future<UsersInfo> _getUserInfo(String uid) async {
    // Assuming you have a collection called 'users' with user information
    final userDoc =
        await FirebaseFirestore.instance.collection('User').doc(uid).get();

    // Assuming UsersInfo has a constructor that takes the document snapshot
    return userDoc.exists
        ? UsersInfo.fromDocument(userDoc)
        : UsersInfo(name: "unknown", imageUrl: "", uid: uid);
  }
}
