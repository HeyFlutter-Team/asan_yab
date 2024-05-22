import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/riverpod/data/message/message.dart';
import '../../../../domain/riverpod/data/message/message_data.dart';

class EditingContainerWidget extends StatelessWidget {
  const EditingContainerWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
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
        color: Colors.grey.shade300
            .withOpacity(0.7),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets
                      .symmetric(
                      horizontal: 8.0),
                  child: Icon(
                    Icons
                        .edit_calendar_outlined,
                    color: Colors
                        .purple.shade700,
                    size: 35,
                  ),
                ),
                Container(
                    height: double.infinity,
                    width: 4,
                    color: Colors
                        .purple.shade700),
                Padding(
                  padding: const EdgeInsets
                      .symmetric(
                      horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [
                      Text(
                        'Editing Message',
                        style: TextStyle(
                            fontWeight:
                            FontWeight
                                .bold,
                            fontSize: 17,
                            color: Colors
                                .purple
                                .shade700),
                      ),
                      Text(
                        textDirection:
                        TextDirection
                            .ltr,
                        ref
                            .watch(
                            editingMessageDetails)
                            .content
                            .substring(
                            0,
                            ref.watch(editingMessageDetails).content.length >
                                20
                                ? 19
                                : ref
                                .watch(editingMessageDetails)
                                .content
                                .length),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight
                                .w300,
                            color: Colors
                                .black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets
                  .symmetric(
                  horizontal: 8.0),
              child: InkWell(
                  splashColor:
                  Colors.transparent,
                  highlightColor:
                  Colors.transparent,
                  onTap: () {
                    ref
                        .read(
                        isMessageEditing
                            .notifier)
                        .state = false;
                    ref
                        .read(
                        hasTextFieldValueProvider
                            .notifier)
                        .state = false;
                    ref
                        .read(
                        messageProfileProvider
                            .notifier)
                        .textController
                        .clear();
                    ref
                        .read(replayProvider
                        .notifier)
                        .state = '';
                    ref
                        .read(
                        replayIsMineProvider
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
