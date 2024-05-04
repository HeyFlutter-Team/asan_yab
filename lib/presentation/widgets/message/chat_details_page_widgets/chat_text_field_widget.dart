import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/riverpod/data/message/message.dart';

class ChatTextFieldWidget extends StatelessWidget {
  const ChatTextFieldWidget({
    super.key,
    required this.themDark,
    required this.ref,
  });

  final bool themDark;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 7),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(40),
          color: themDark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
        ),
        child:TextField(
          autocorrect: true,
          minLines: 1,
          maxLines: 5,
          focusNode:ref
              .watch(
              messageProfileProvider.notifier)
              .focusNode ,
          onTap: () {
            ref
                .read(emojiShowingProvider.notifier)
                .state = false;
            ref
                .read(gifShowingProvider.notifier)
                .state = false;
          },
          decoration: const InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(
              vertical: 13.0,
              horizontal: 15.0,
            ),
            // hintText:
            //     '   ${languageText?.chat_message}',
            border: InputBorder.none,
          ),
          controller: ref
              .watch(
              messageProfileProvider.notifier)
              .textController,
          onChanged: (value) {
            if(value.isNotEmpty) {
              ref
                  .read(hasTextFieldValueProvider
                  .notifier)
                  .state = true;
            }else{
              ref
                  .read(hasTextFieldValueProvider
                  .notifier)
                  .state = false;
            }
          },
        ),
      ),
    );
  }
}
