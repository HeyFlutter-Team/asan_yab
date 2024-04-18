import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/domain/riverpod/data/message/fetch_message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_history.dart';
import 'package:asan_yab/domain/riverpod/data/message/messages_notifier.dart';
import 'package:asan_yab/domain/riverpod/data/message/seen_message.dart';
import 'package:asan_yab/domain/riverpod/screen/check_follower.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

final loadingIconChat = StateProvider((ref) => true);

class AppBarChatDetailsWidget extends ConsumerWidget
    implements PreferredSizeWidget {
  const AppBarChatDetailsWidget({
    required this.urlImage,
    required this.name,
    required this.isOnline,
    required this.employee,
    required this.userId,
    Key? key,
  }) : super(key: key);

  final String urlImage;
  final String name;
  final bool isOnline;
  final String employee;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!context.mounted) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      child: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref.read(fetchMessageProvider.notifier).clearState();
                        ref
                            .read(messagesNotifierProvider.notifier)
                            .fetchMessage();
                        ref
                            .read(messageHistoryProvider.notifier)
                            .getMessageHistory();
                        ref
                            .read(seenMassageProvider.notifier)
                            .messageIsSeen(
                                userId, FirebaseAuth.instance.currentUser!.uid)
                            .whenComplete(() {
                          if (context.mounted) {
                            ref
                                .read(seenMassageProvider.notifier)
                                .isNewMassage();
                          }
                        });
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_outlined),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Icon(
                              Icons.circle,
                              color: isOnline ? Colors.green : Colors.grey,
                              size: 12,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            isOnline ? 'Online' : 'Offline',
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    SizedBox(width: 5.w),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          ref.read(loadingIconChat.notifier).state = false;
                          ref
                              .read(checkFollowerProvider.notifier)
                              .followOrUnFollow(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userId)
                              .whenComplete(
                                () => context.pushNamed(Routes.otherProfile),
                              );
                        },
                        child: urlImage == ''
                            ? const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/avatar.jpg'),
                                maxRadius: 20,
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    CachedNetworkImageProvider(urlImage),
                                maxRadius: 20,
                              ),
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
  Size get preferredSize => const Size.fromHeight(70);
}
