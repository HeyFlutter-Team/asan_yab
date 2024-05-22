import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji_gif_picker/views/emoji_gif_menu_layout.dart';
import 'package:flutter_emoji_gif_picker/views/emoji_gif_picker_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/message/message.dart';
import '../../../../data/models/users.dart';
import '../../../../domain/riverpod/config/message_notification_repo.dart';
import '../../../../domain/riverpod/data/message/message.dart';
import '../../../../domain/riverpod/data/message/message_data.dart';
import '../../../../domain/riverpod/data/profile_data_provider.dart';

class GifButtonWidget extends StatelessWidget {
  const GifButtonWidget({
    super.key,
    required this.themDark,
    required this.ref,
  });

  final bool themDark;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: themDark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
          elevation: 0,
          shape: const CircleBorder(),
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 10)),
      onPressed: () async {
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await Future.delayed(
            const Duration(milliseconds: 100));
        if(ref.watch(emojiShowingProvider)){
          ref.read(emojiShowingProvider.notifier).state=false;
        }
        ref
            .read(gifShowingProvider.notifier)
            .state =
        !ref.watch(gifShowingProvider);
        if (ref.watch(gifShowingProvider)) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Icon(
        Icons.gif_box_outlined,
        size: 24,
        color: ref.watch(gifShowingProvider)
            ? Colors.blue.shade200
            : themDark
            ? Colors.white
            : Colors.black45,
      ),
    );
  }
}


class GifPickerWidget extends StatelessWidget {
  const GifPickerWidget({
    super.key,
    required this.ref,
    required this.newProfileUser,
    required this.mounted,
  });

  final WidgetRef ref;
  final Users newProfileUser;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: !ref.watch(gifShowingProvider)?20 : 300,
      child: Column(
        children: [
          Expanded(
            child: Offstage(
              offstage: !ref.watch(gifShowingProvider),
              child:
              EmojiGifMenuLayout(
                child: EmojiGifPickerIcon(
                  id: "1",
                  onGifSelected: (gif) async{
                    print('onGifSelected');
                    ref.read(localMessagesProvider.notifier)
                        .addMessage(
                        MessageModel(
                            senderId: FirebaseAuth.instance.currentUser!.uid,
                            receiverId:newProfileUser.uid! ,
                            content:ref
                                .watch(messageProfileProvider
                                .notifier)
                                .textController.text ,
                            sentTime: DateTime.now().toUtc() ,
                            messageType: MessageType.text,
                            replayMessage:ref.watch(replayProvider),
                            isSeen:false ,
                            replayMessageIndex:ref.watch(
                                messageIndexProvider)+1 ,
                            replayIsMine:  ref.watch(
                                replayIsMineProvider),
                            isMessageEdited:ref.watch(
                                messageEditedProvider
                            ) ,
                            replayMessageTime: ref.watch(replayMessageTimeProvider)
                        )
                    );
                    ref
                        .read(messageProfileProvider
                        .notifier)
                        .sendSticker(
                        receiverId: newProfileUser.uid!,
                        context: context,
                        currentUserCoinCount: 0,
                        scrollPositioned: 0,
                        gifUrl: '${gif?.images
                            ?.fixedHeight?.url}'
                    ).whenComplete((){
                      if(mounted){
                        MessageNotification
                            .sendPushNotificationMessage(
                            newProfileUser,
                            ref
                                .read(messageProfileProvider
                                .notifier)
                                .textController
                                .text,
                            ref.watch(
                                userDetailsProvider)!);

                      }

                    });
                    ref
                        .read(replayPositionProvider.notifier)
                        .scrollItem(ref, 0);
                  },
                  fromStack: false,
                  hoveredBackgroundColor: Colors.black,
                  backgroundColor: Colors.black,
                  controller: ref
                      .watch(
                      messageProfileProvider.notifier)
                      .textController ,
                  viewEmoji: false,
                  viewGif: true,
                  keyboardIcon: const Icon(Icons.gif_box_outlined
                    ,color: Colors.red,),
                  icon: const Icon(
                    Icons.gif_box_outlined
                    ,color: Colors.red,
                    size: 80,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
