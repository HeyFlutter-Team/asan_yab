import 'package:asan_yab/domain/riverpod/data/message/message_data.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_history.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_seen.dart';
import 'package:asan_yab/domain/riverpod/data/message/messages_notifier.dart';
import 'package:asan_yab/presentation/pages/profile/other_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/message/textfield_message.dart';
import '../../../domain/riverpod/data/message/message.dart';

class AppBarChatDetails extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarChatDetails({
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
    if (context.findRenderObject() == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      child: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Row(
              children: [
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (ref.watch(emojiShowingProvider)) {
                          ref.read(emojiShowingProvider.notifier).state = false;
                        }
                        Navigator.pop(context);
                        if (ref
                            .watch(messageProfileProvider.notifier)
                            .textController
                            .text
                            .isNotEmpty) {
                          ref.read(textFieldMessagesListPro.notifier).state.add(
                              TextFieldMessage(
                                 userId: userId,
                                textFieldMessage: ref
                                      .watch(messageProfileProvider.notifier)
                                      .textController
                                      .text,
                                replayText: ref.watch(replayProvider)
                              ),);
                        }
                        if(ref.watch(replayProvider.notifier).state.isNotEmpty){
                          ref
                              .read(replayProvider.notifier)
                              .state = '';
                        }

                        ref
                            .read(messageProfileProvider.notifier)
                            .textController
                            .clear();

                        ref
                            .read(messageNotifierProvider.notifier)
                            .fetchMessage();
                        ref.read(messageHistory.notifier).getMessageHistory();
                        ref
                            .read(seenMassageProvider.notifier)
                            .messageIsSeen(
                                userId, FirebaseAuth.instance.currentUser!.uid)
                            .whenComplete(
                          () async {
                            if (context.mounted) {
                              ref.read(messageProvider.notifier).clearState();
                              await ref
                                  .read(seenMassageProvider.notifier)
                                  .isNewMassage();
                            }
                          },
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      name.length > 15 ? name.substring(0, 15) : name,
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
                        const SizedBox(width: 5),
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
                const Spacer(),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        ref.read(loadingIconChat.notifier).state = false;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherProfile(
                              isFromChat: true,
                              uid: userId,
                            ),
                          ),
                        );
                      },
                      child: urlImage == ''
                          ? const CircleAvatar(
                              backgroundImage: AssetImage('assets/avatar.jpg'),
                              maxRadius: 20,
                            )
                          : CircleAvatar(
                              maxRadius: 20,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                child: CachedNetworkImage(
                                  imageUrl: urlImage,
                                  placeholder: (context, url) =>
                                      Image.asset('assets/asan_yab.png'),
                                  errorListener: (value) =>
                                      Image.asset('assets/asan_yab.png'),
                                ),
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

final loadingIconChat = StateProvider((ref) => true);
