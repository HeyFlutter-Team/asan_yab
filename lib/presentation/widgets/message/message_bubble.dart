import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends ConsumerWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
    required this.isImage,
    required this.urlImage,
    this.isGift = false,
  });
  final bool isMe;
  final bool isImage;
  final MessageModel message;
  final String urlImage;
  final bool isGift;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileDetails = ref.watch(userDetailsProvider);
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMe == false)
            Container(
              margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(urlImage),
                maxRadius: 20,
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.blueAccent : Colors.white,
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(22),
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(22),
                      topLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
            ),
            margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                isImage
                    ? Column(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      message.content.split(' ').first),
                                  fit: BoxFit.fill),
                            ),
                            // child: isGift
                            //     ? Text(
                            //         isMe
                            //             ? AppLocalizations.of(context)
                            //                     ?.youSentGiftOfCoins(message
                            //                         .content
                            //                         .split(' ')
                            //                         .last) ??
                            //                 'You sent a gift of ${message.content.split(' ').last} coins'
                            //             : AppLocalizations.of(context)
                            //                     ?.sentYouGiftOfCoins(message
                            //                         .content
                            //                         .split(' ')
                            //                         .last) ??
                            //                 'Sent You a Gift of ${message.content.split(' ').last} coins',
                            //         style: TextStyle(
                            //           color: isMe
                            //               ? Colors.white
                            //               : Colors.blueAccent,
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       )
                            //     : null,
                          ),
                        ],
                      )
                    : Text(
                        message.content,
                        style: TextStyle(
                            color: isMe ? Colors.black : Colors.black),
                      ),
                // const SizedBox(height: 5),
                // Text(timeago.format(message.sentTime.toLocal()))
              ],
            ),
          ),
          if (isMe == true)
            Container(
              margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
              child: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(profileDetails!.imageUrl!),
                maxRadius: 20,
              ),
            ),
        ],
      ),
    );
  }
}
