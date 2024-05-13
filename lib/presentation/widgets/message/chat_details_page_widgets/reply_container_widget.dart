import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/users.dart';
import '../../../../domain/riverpod/data/message/message.dart';
import '../../../../domain/riverpod/data/message/message_data.dart';

class ReplyContainerWidget extends StatelessWidget {
  const ReplyContainerWidget({
    super.key,
    required this.ref,
    required this.newProfileUser,
    required this.isMessageText,
  });

  final WidgetRef ref;
  final Users? newProfileUser;
  final bool isMessageText;

  @override
  Widget build(BuildContext context) {
    final replyIsMine = ref.watch(
        replayIsMineProvider);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        ref
            .read(replayPositionProvider.notifier)
            .scrollItemByTime(ref,
            DateTime.parse(ref.watch(replayMessageTimeProvider)));

      },
      child: Container(
        height: 60,
        color:
        Colors.grey.shade300.withOpacity(0.7),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 4,
                  color: replyIsMine
                      ? Colors.purple.shade700
                      : Colors.blue,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                      horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        replyIsMine
                            ? 'You'
                            : '${newProfileUser?.name}',
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 17,
                          color: replyIsMine
                              ? Colors
                              .purple.shade700
                              : Colors
                              .blue,
                        ),
                      ),
                      Text(
                        textDirection:
                        TextDirection.ltr,
                        isMessageText?'Gif':
                        ref
                            .watch(
                            replayProvider)
                            .isNotEmpty
                            ? ref
                            .watch(
                            replayProvider)
                            .substring(
                            0,
                            ref.watch(replayProvider).length >
                                20
                                ? 19
                                : ref
                                .watch(
                                replayProvider)
                                .length)
                            : '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0),
              child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor:
                  Colors.transparent,
                  onTap: () {
                    ref
                        .read(
                        replayProvider.notifier)
                        .state = '';
                    ref
                        .read(replayIsMineProvider
                        .notifier)
                        .state = false;
                  },
                  child: const Icon(
                    Icons.cancel_outlined,
                    size: 31,
                    color: Colors.blue,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
