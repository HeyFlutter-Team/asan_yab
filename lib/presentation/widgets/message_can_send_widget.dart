import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import '../../core/res/image_res.dart';
import '../../data/models/message/message_model.dart';
import '../../data/models/users.dart';

class MessageCanSendWidget extends StatelessWidget {
  const MessageCanSendWidget({
    super.key,
    required this.messageNotifier,
    required this.messageDetails,
    required this.ref,
    required this.newMessage,
  });

  final List<Users> messageNotifier;
  final List<MessageModel> messageDetails;
  final WidgetRef ref;
  final List<bool> newMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        messageNotifier.isEmpty
            ? const Expanded(
                child: Center(
                  child: Image(image: AssetImage(ImageRes.noData)),
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
                      return InkWell(
                        onTap: () {
                          final id = userForChat.uid;
                          ref
                              .read(otherUserDataProvider.notifier)
                              .setDataUser(userForChat);
                          context.pushNamed(Routes.chatDetail,
                              pathParameters: {'followId': id!});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                                child: userForChat.imageUrl == ''
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
                                          color: const Color(0xff7c94b6),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                userForChat.imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.0,
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
                                        Text(userForChat.name),
                                        SizedBox(width: 5.w),
                                        const Spacer(),
                                        Text(
                                          messageDetails.isEmpty
                                              ? ''
                                              : timeAgo.format(
                                                  messageDetails[index]
                                                      .sentTime
                                                      .toLocal()),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        const SizedBox(width: 4),
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
                                              SizedBox(width: 5.w),
                                              newMessage[index]
                                                  ? const Icon(
                                                      Icons.circle,
                                                      color: Colors.blue,
                                                      size: 12,
                                                    )
                                                  : const SizedBox(),
                                              const Spacer(),
                                            ],
                                          ),
                                  ),
                                  const Divider(color: Colors.grey)
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
