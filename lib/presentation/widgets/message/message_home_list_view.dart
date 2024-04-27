import 'package:asan_yab/core/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/message/message.dart';
import '../../../domain/riverpod/data/message/message.dart';
import '../../../domain/riverpod/data/message/message_data.dart';
import '../../../domain/riverpod/data/message/message_history.dart';
import '../../../domain/riverpod/data/message/message_seen.dart';
import '../../../domain/riverpod/data/message/messages_notifier.dart';
import '../../../domain/riverpod/data/other_user_data.dart';
import '../../pages/message_page/chat_details_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:ui' as ui;


class MessageHomeListView extends ConsumerStatefulWidget {
  const MessageHomeListView({super.key});

  @override
  ConsumerState<MessageHomeListView> createState() =>
      _MessageHomeListViewState();
}

class _MessageHomeListViewState extends ConsumerState<MessageHomeListView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(seenMassageProvider);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final messageNotifier = ref.watch(messageHistory);
    final messageDetails = ref.watch(messageNotifierProvider);
    return Column(
      children: [
        const SizedBox(height: 12),
        messageNotifier.isEmpty
            ? const Expanded(
                child: Center(
                  child: Image(image: AssetImage('assets/message_icon.png')),
                ),
              )
            : Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: messageNotifier.length,
                    itemBuilder: (context, index) {
                      if (index < 0 ||
                          index >= messageNotifier.length ||
                          index >= messageDetails.length) {
                        return Container();
                      }
                      final userForChat = messageNotifier[index];
                      ref.read(unreadMessageCountProvider('${userForChat.uid}').notifier)
                          .getUnseenMessageCounts(ref,'${userForChat.uid}',
                          messageDetails[index]
                              .senderId !=
                              FirebaseAuth.instance
                                  .currentUser?.uid
                      );
                      final unreadMessages =ref.watch(unreadMessageCountProvider('${userForChat.uid}').notifier).unreadMessagesCount;
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          final id = userForChat.uid;
                          ref.read(messageProvider.notifier).clearState();
                          ref
                              .read(otherUserProvider.notifier)
                              .setDataUser(userForChat);
                          print('goooooooooooooooooooooooooooood');
                          print(userForChat);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailPage(uid: id,),
                              ));
                        },
                        child: Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.red,
                                            Colors.green,
                                            Colors.brown,
                                            Colors.black,
                                            Colors.white
                                          ], // Replace with your gradient colors
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        border: Border.all(
                                          color: Colors.transparent,
                                          width: 2.5,
                                        ),
                                      ),
                                      child: userForChat.imageUrl == '' ||
                                              userForChat.uid == null
                                          ? Container(
                                              padding: EdgeInsets.zero,
                                              margin: EdgeInsets.zero,
                                              width: 65.0,
                                              height: 65.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff7c94b6),
                                                image: const DecorationImage(
                                                  image:
                                                      AssetImage('assets/avatar.jpg'),
                                                  fit: BoxFit.cover,
                                                ),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1.0,
                                                ),
                                              ),
                                            )
                                          : Container(
                                            padding: EdgeInsets.zero,
                                            margin: EdgeInsets.zero,
                                            width: 65.0,
                                            height: 65.0,
                                            decoration: BoxDecoration(
                                              image:  DecorationImage(
                                                filterQuality: FilterQuality.high,
                                                onError: (exception, stackTrace) {
                                                  Image.asset('assets/avatar.jpg');
                                                },
                                                image:NetworkImage(userForChat.imageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                              color: const Color(0xff7c94b6),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                            ),
                                            child:
                                            Container(
                                              padding: EdgeInsets.zero,
                                              margin: EdgeInsets.zero,
                                              width: 65.0,
                                              height: 65.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff7c94b6),
                                                image:  DecorationImage(
                                                  filterQuality: FilterQuality.high,
                                                  onError: (exception, stackTrace) {
                                                    Image.asset('assets/avatar.jpg');
                                                  },
                                                  image:NetworkImage(userForChat.imageUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1.0,
                                                ),
                                              ),
                                            )
                                          ),
                                    ),
                                    if(Utils.netIsConnected(ref))
                                      Positioned(
                                        bottom: 5,
                                        left: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                            color: userForChat.isOnline
                                                ? Colors.green
                                                : null,
                                          ),
                                          height: 15,
                                          width: 15,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                            userForChat.name.length > 15
                                                ? userForChat.name
                                                    .substring(0, 15)
                                                : userForChat.name,
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    messageDetails.isEmpty
                                                        ? ''
                                                        : timeago.format(
                                                            messageDetails[index]
                                                                .sentTime
                                                                .toLocal()),
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  if (messageDetails[index]
                                                              .senderId ==
                                                          FirebaseAuth.instance
                                                              .currentUser?.uid &&
                                                      messageDetails[index]
                                                              .isSeen ==
                                                          true)
                                                    const Icon(
                                                      Icons.done_all,
                                                      color: Colors.blue,
                                                      size: 18,
                                                    ),
                                                  const SizedBox(width: 4),
                                                  if (messageDetails[index]
                                                              .senderId ==
                                                          FirebaseAuth.instance
                                                              .currentUser?.uid &&
                                                      messageDetails[index]
                                                              .isSeen ==
                                                          false)
                                                    const Icon(
                                                      Icons.done,
                                                      color: Colors.grey,
                                                      size: 18,
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              messageDetails[index].isSeen
                                                  ? const SizedBox()
                                                  : messageDetails[index].receiverId == '${currentUser?.uid}'
                                                      ? Container(
                                                          height: 30,
                                                          constraints:
                                                              const BoxConstraints(
                                                                  minWidth: 30),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .blue.shade600,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          32))),
                                                          child: Center(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: unreadMessages >
                                                                    0
                                                                ? Text(
                                                                    '$unreadMessages',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12),
                                                                  )
                                                                : const SizedBox(),
                                                          )))
                                                      : const SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ),
                                      subtitle: messageDetails.isEmpty
                                          ? const Text('')
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                if (messageDetails[index]
                                                        .messageType ==
                                                    MessageType.text)
                                                  Flexible(
                                                    child: Text(
                                                      messageDetails[index]
                                                          .content,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                else
                                                  Image.network(
                                                    messageDetails[index]
                                                        .content
                                                        .split(' ')
                                                        .first,
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                const Spacer(),
                                              ],
                                            ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
