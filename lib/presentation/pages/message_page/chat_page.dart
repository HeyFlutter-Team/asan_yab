import 'package:asan_yab/domain/riverpod/data/message/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/message/chat_messages_widget.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white70,
        elevation: 5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(
              child: CircleAvatar(
                backgroundImage: NetworkImage(''),
                radius: 23,
              ),
            ),
            Expanded(
              flex: 5,
              child: ListTile(
                title: const Text('name'),
                subtitle: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 14,
                    ),
                    SizedBox(width: 2.w),
                    const Text('online'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          const ChatMessagesWidget(receiverId: '', urlImage: ''),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 0, bottom: 10, top: 4),
              height: 70,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTap: () {},
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 7),
                            hintText: "Say Something ... ",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                          ),
                          controller: ref
                              .watch(messageProvider.notifier)
                              .textController,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                        onPressed: () => ref
                            .read(messageProvider.notifier)
                            .textController
                            .clear(),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
