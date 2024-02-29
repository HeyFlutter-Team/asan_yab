import 'package:asan_yab/domain/riverpod/data/comment_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/users.dart';
import '../../domain/riverpod/data/other_user_data.dart';

import '../../domain/riverpod/screen/follow_checker.dart';
import '../pages/profile/other_profile.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner =
        currentUser != null && widget.comment.uid == currentUser.uid;

    return Card(
      elevation: 10,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                widget.comment.imageUrl != ""
                    ? GestureDetector(
                        onTap: () async {
                          DocumentSnapshot snapshot = await FirebaseFirestore
                              .instance
                              .collection('User')
                              .doc(widget.comment.uid)
                              .get();
                          if (snapshot.exists) {
                            Users myUser = Users.fromMap(
                                snapshot.data() as Map<String, dynamic>);
                            ref
                                .read(otherUserProvider.notifier)
                                .setDataUser(myUser);
                            ref
                                .read(followerProvider.notifier)
                                .followOrUnFollow(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.comment.uid);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OtherProfile(),
                                ));
                            print('6');
                          }
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.comment.imageUrl),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          DocumentSnapshot snapshot = await FirebaseFirestore
                              .instance
                              .collection('User')
                              .doc(widget.comment.uid)
                              .get();

                          if (snapshot.exists) {
                            Users myUser = Users.fromMap(
                                snapshot.data() as Map<String, dynamic>);

                            ref
                                .read(otherUserProvider.notifier)
                                .setDataUser(myUser);

                            ref
                                .read(followerProvider.notifier)
                                .followOrUnFollow(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.comment.uid);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OtherProfile(),
                                ));
                          }
                        },
                        child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/Avatar.png')),
                      ),
                const SizedBox(width: 8.0),
                GestureDetector(
                    onTap: () async {
                      DocumentSnapshot snapshot = await FirebaseFirestore
                          .instance
                          .collection('User')
                          .doc(widget.comment.uid)
                          .get();
                      if (snapshot.exists) {
                        Users myUser = Users.fromMap(
                            snapshot.data() as Map<String, dynamic>);
                        ref
                            .read(otherUserProvider.notifier)
                            .setDataUser(myUser);

                        ref.read(followerProvider.notifier).followOrUnFollow(
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.comment.uid);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OtherProfile(),
                            ));
                      }
                    },
                    child: Text(widget.comment.name)),
              ],
            ),
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(widget.comment.text),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            ref
                .read(commentProvider.notifier)
                .showOptionsBottomSheet(context, isOwner, widget.onDelete);
          },
        ),
      ),
    );
  }
}
