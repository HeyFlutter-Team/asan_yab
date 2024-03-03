import 'package:asan_yab/core/res/image_res.dart';
import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_history.dart';
import 'package:asan_yab/domain/riverpod/data/message/message_seen.dart';
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
import '../../../data/repositoris/language_repository.dart';
import '../../../domain/riverpod/data/message/message_stream.dart';

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
    //   // ref.read(messageNotifierProvider).fetchMessage(userUid);
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //
    //       ref.watch(messageHistory.notifier).getMessageHistory();
    //       ref.watch(messageNotifierProvider.notifier).fetchMessage();
    //       ref.watch(seenMassageProvider.notifier).isNewMassage();
    //   });
      Suspend(ref).suspendUser(context);
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
    final newMessage = ref.watch(seenMassageProvider);
    final languageText = AppLocalizations.of(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: Card(
          elevation: 4,
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
              children: [
                Text('${user?.name}'),
                const SizedBox(height: 4),
                Text(
                  "${user?.userType} ${AppLocalizations.of(context)!.proFile_type}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    user!.invitationRate >= 2?
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                        ))
                    :null;
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
        ),
      ),
      body: user!=null?user.invitationRate >= 2
          ? Column(
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
                                if (index < 0 || index >= messageNotifier.length || index >= messageDetails.length) {
                                  // Return an empty container or handle this case appropriately
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
                                          child: userForChat.imageUrl==''?Container(
                                            padding: EdgeInsets.zero,
                                            margin: EdgeInsets.zero,
                                            width: 65.0,
                                            height: 65.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff7c94b6),
                                              image: const DecorationImage(
                                                image: AssetImage('assets/avatar.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                            ),
                                          ):Container(
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
                                                  Text(
                                                    userForChat.name,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Spacer(),
                                                  Text(
                                                    messageDetails.isEmpty
                                                        ? ''
                                                        : timeago.format(
                                                            messageDetails[index]
                                                                .sentTime
                                                                .toLocal()),
                                                    style: const TextStyle(
                                                        fontSize: 10),
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
                                                              overflow: TextOverflow
                                                                  .ellipsis,
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
                                                        const SizedBox(width: 5),
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
              )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                   Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat,
                              size: 80,
                              color: Colors.red.shade800,
                            ),
                            Text(
                              languageText!.chat_message,
                              style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    languageText.chat_screen,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Text(languageText.message_personal_score,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(width: 2,),
                      Text(isRTL?convertDigitsToFarsi('  ${user.invitationRate}'):
                        '  ${user.invitationRate}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      )
                    ],
                  ),
                  Container(
                    height: 420,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/message_box.png'),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                           Text(languageText.message_description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 19),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          isRTL?
                             Container(
                            height: 100,
                            width: 260,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/newMessage.png'),
                                    fit: BoxFit.cover)),
                          )
                          :Container(
                            height: 90,
                            width: 300,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/message_5.png'),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(languageText.message_your_id),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 40,
                                color: Colors.red.shade800.withOpacity(0.5),
                                child: Center(
                                  child: TextButton(
                                    child: Text(isRTL?convertDigitsToFarsi('${user.id}'):'${user.id}'),
                                    onPressed: () {
                                      ref
                                          .read(userDetailsProvider.notifier)
                                          .copyToClipboard('${user.id}');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(languageText
                                              .profile_copy_id_snack_bar),
                                          duration:
                                              const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
      :const Text('null'),
    );
  }
}
