import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/message/message.dart';
import '../../../domain/riverpod/data/message/message_history.dart';
import '../../../domain/riverpod/data/message/message_seen.dart';
import '../../../domain/riverpod/data/message/messages_notifier.dart';
import '../../../domain/riverpod/data/other_user_data.dart';
import '../../pages/message_page/chat_details_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageHomeListView extends ConsumerWidget {
  const MessageHomeListView({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final messageNotifier = ref.watch(messageHistory);
    final messageDetails = ref.watch(messageNotifierProvider);
    final newMessage = ref.watch(seenMassageProvider);
    return Column(
      children: [
        const SizedBox(height: 12),
        messageNotifier.isEmpty
            ? const Expanded(
          child: Center(
            child: Image(
                image: AssetImage('assets/message_icon.png')),
          ),
        )
            : Expanded(
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              itemCount: messageNotifier.length,
              itemBuilder: (context, index) {
                if (index < 0 ||
                    index >= messageNotifier.length ||
                    index >= messageDetails.length) {
                  return Container();
                }
                final userForChat = messageNotifier[index];
                return InkWell(
                  onTap: () {
                    final id = userForChat.uid;
                    ref
                        .read(otherUserProvider.notifier)
                        .setDataUser(userForChat);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatDetailPage(uid: id),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
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
                          child: userForChat.imageUrl == '' ||userForChat.uid ==null
                              ? Container(
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            width: 65.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xff7c94b6),
                              image:
                              const DecorationImage(
                                image: AssetImage(
                                    'assets/avatar.jpg'),
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
                              color: const Color(
                                  0xff7c94b6),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius
                                  .all(
                                  Radius.circular(
                                      30)),
                              child: CachedNetworkImage(
                                imageUrl: userForChat
                                    .imageUrl,
                                placeholder: (context,
                                    url) =>
                                    Image.asset(
                                        'assets/Avatar.png'),
                                errorListener: (value) =>
                                    Image.asset(
                                        'assets/Avatar.png'),
                              ),
                            ),
                          ),
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
                                        ? userForChat.name.substring(0, 15)
                                        : userForChat.name,
                                  ),
                                  const Spacer(),
                                  Text(
                                    textDirection:
                                    TextDirection.ltr,
                                    messageDetails.isEmpty
                                        ? ''
                                        : timeago.format(
                                        messageDetails[
                                        index]
                                            .sentTime
                                            .toLocal()),
                                    style: const TextStyle(
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                              subtitle: messageDetails.isEmpty
                                  ? const Text('')
                                  : Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                                children: [
                                  if (messageDetails[
                                  index]
                                      .messageType ==
                                      MessageType.text)
                                    Flexible(
                                      child: Text(
                                        messageDetails[
                                        index]
                                            .content,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                      ),
                                    )
                                  else
                                    Image.network(
                                      messageDetails[
                                      index]
                                          .content
                                          .split(' ')
                                          .first,
                                      height: 20,
                                      width: 20,
                                    ),
                                  const SizedBox(
                                      width: 5),
                                  newMessage.isNotEmpty
                                      ? newMessage[
                                  index]
                                      ? const Icon(
                                    Icons
                                        .circle,
                                    color: Colors
                                        .blue,
                                    size: 12,
                                  )
                                      : const SizedBox()
                                      : const SizedBox(),
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
