import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessages extends ConsumerWidget {
  const ChatMessages(
      {super.key, required this.receiverId, required this.urlImage});
  final String receiverId;
  final String urlImage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final messages = ref.watch(messageProvider);
    return true
            ? Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.white, Colors.white70, Colors.white38],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                child: const Center(child: Text('No Message')),
              )
            : SizedBox()
        // Container(
        //         decoration: const BoxDecoration(
        //             gradient: LinearGradient(
        //           colors: [
        //             Color(0xFFb92c9d),
        //             Color(0xFFc02983),
        //             Color(0xFFc82873),
        //           ],
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomCenter,
        //         )),
        //         child: Padding(
        //           padding: const EdgeInsets.only(bottom: 75),
        //           child: ListView.builder(
        //             controller:
        //                 ref.watch(messageProvider.notifier).scrollController,
        //             itemCount: messages.length,
        //             itemBuilder: (context, index) {
        //               final isTextMessage =
        //                   messages[index].messageType == MessageType.text;
        //
        //               final isSticker =
        //                   messages[index].messageType == MessageType.sticker;
        //
        //               final isMe = receiverId != messages[index].senderId;
        //               return isTextMessage
        //                   ? MessageBubble(
        //                       urlImage: urlImage,
        //                       isMe: isMe,
        //                       message: messages[index],
        //                       isImage: false,
        //                     )
        //                   : isSticker
        //                       ? MessageBubble(
        //                           urlImage: urlImage,
        //                           isMe: isMe,
        //                           message: messages[index],
        //                           isImage: true,
        //                           isGift: true,
        //                         )
        //                       : MessageBubble(
        //                           urlImage: urlImage,
        //                           isMe: isMe,
        //                           message: messages[index],
        //                           isImage: true,
        //                         );
        //             },
        //           ),
        //         ),
        //       )
        ;
  }
}
