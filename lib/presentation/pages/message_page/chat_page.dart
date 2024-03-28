import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/riverpod/data/message/message.dart';
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: CircleAvatar(
                backgroundImage: NetworkImage(''),
                radius: 23,
              ),
            ),
            Expanded(
              flex: 5,
              child: ListTile(
                title: Text('name'),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 14,
                    ),
                    SizedBox(width: 2),
                    Text('online'),
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
                              .watch(messageProfileProvider.notifier)
                              .textController,
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                        onPressed: () => ref
                            .read(messageProfileProvider.notifier)
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
