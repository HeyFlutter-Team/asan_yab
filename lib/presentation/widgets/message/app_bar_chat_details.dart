import 'package:asan_yab/domain/riverpod/data/message/message_data.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_history.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_seen.dart';
import 'package:asan_yab/domain/riverpod/data/message/messages_notifier.dart';
import 'package:asan_yab/domain/riverpod/screen/follow_checker.dart';
import 'package:asan_yab/presentation/pages/profile/other_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarChatDetails extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarChatDetails(
      {required this.urlImage,
      required this.name,
      required this.isOnline,
      required this.employee,
      required this.userId,
      super.key});
  final String urlImage;
  final String name;
  final bool isOnline;
  final String employee;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        ref.read(messageProvider.notifier).clearState();
                        ref
                            .read(messageNotifierProvider.notifier)
                            .fetchMessage();
                        ref.read(messageHistory.notifier).getMessageHistory();
                        ref
                            .read(seenMassageProvider.notifier)
                            .messageIsSeen(
                                userId, FirebaseAuth.instance.currentUser!.uid)
                            .whenComplete(() => ref
                                .read(seenMassageProvider.notifier)
                                .isNewMassage());

                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: isOnline ? Colors.green : Colors.grey,
                                size: 12,
                              ),
                              SizedBox(width: 5),
                              Text(
                                isOnline ? 'Online' : 'Offline',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        ref.read(loadingIconChat.notifier).state = false;
                        ref
                            .read(followerProvider.notifier)
                            .followOrUnFollow(
                                FirebaseAuth.instance.currentUser!.uid, userId)
                            .whenComplete(
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OtherProfile(),
                                ),
                              ),
                            );
                      },
                      child: urlImage == ''
                          ? const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/p3.webp'),
                              maxRadius: 20,
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(urlImage),
                              maxRadius: 20,
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(70);
}

final loadingIconChat = StateProvider((ref) => true);
