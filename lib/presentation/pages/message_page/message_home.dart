import 'package:asan_yab/core/res/image_res.dart';
import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_history.dart';
import 'package:asan_yab/domain/riverpod/data/message/messages_notifier.dart';
import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/presentation/pages/message_page/chat_details_page.dart';
import 'package:asan_yab/presentation/pages/message_page/search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageHome extends ConsumerStatefulWidget {
  const MessageHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageHomeState();
}

class _MessageHomeState extends ConsumerState<MessageHome> {
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      // ref.read(messageNotifierProvider).fetchMessage(userUid);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.watch(messageHistory.notifier).getMessageHistory();
        ref.watch(messageNotifierProvider.notifier).fetchMessage();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageNotifier = ref.watch(messageHistory);
    final messageDetails = ref.watch(messageNotifierProvider);
    final user = ref.watch(userDetailsProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text(user!.name),
            const SizedBox(height: 4),
            Text(
              "${user.userType} ${AppLocalizations.of(context)!.proFile_type}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ));
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          messageNotifier.isEmpty
              ? Expanded(
                  child: Center(
                    child: Image(image: AssetImage(ImageRes.nodata)),
                  ),
                )
              : Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      itemCount: messageNotifier.length,
                      itemBuilder: (context, index) {
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
                                  builder: (context) => ChatDetailPage(uid: id),
                                ));
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
                                      ], // Replace with your gradient colors
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2.5,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                    width: 65.0,
                                    height: 65.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7c94b6),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            user!.imageUrl),
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
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        userForChat.name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      const SizedBox(width: 5),
                                      Spacer(),
                                      Text(
                                        messageDetails.isEmpty
                                            ? ''
                                            : timeago.format(
                                                messageDetails[index]
                                                    .sentTime
                                                    .toLocal()),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  subtitle: messageDetails.isEmpty
                                      ? Text('')
                                      : Row(
                                          children: [
                                            if (messageDetails[index]
                                                    .messageType ==
                                                MessageType.text)
                                              Expanded(
                                                  child: Text(
                                                messageDetails[index].content,
                                                overflow: TextOverflow.ellipsis,
                                              ))
                                            else
                                              Image.network(
                                                messageDetails[index]
                                                    .content
                                                    .split(' ')
                                                    .first,
                                                height: 20,
                                                width: 20,
                                              ),
                                            const SizedBox(width: 5),
                                            Spacer(),
                                          ],
                                        ),
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
      ),
    );
  }
}
