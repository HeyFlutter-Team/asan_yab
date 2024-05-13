import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/riverpod/data/message/message.dart';
import '../../../../domain/riverpod/data/message/message_data.dart';

class ChatScrollButton extends StatelessWidget {
  const ChatScrollButton({
    super.key,
    required this.isKeyboardOpen,
    required this.ref,
    required this.themDark,
  });

  final bool isKeyboardOpen;
  final WidgetRef ref;
  final bool themDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 0,
          right: 0,
          bottom: isKeyboardOpen
              ? ref.watch(isMessageEditing) ||
              ref.watch(replayProvider) != ''
              ? 420
              : 350
              : ref.watch(replayProvider) == ''
              ? 90
              : 150),
      child: Visibility(
        visible: !ref.watch(isToEndProvider),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            ref
                .read(replayPositionProvider.notifier)
                .scrollItem(ref, 0);
          },
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: themDark
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.6),
                borderRadius:
                const BorderRadius.all(Radius.circular(32))),
            child: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: themDark
                  ? Colors.black.withOpacity(0.6)
                  : Colors.white,
              size: 37,
            ),
          ),
        ),
      ),
      // ),
    );
  }
}