import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../domain/riverpod/data/message/message.dart';
import '../../../pages/themeProvider.dart';
import 'package:flutter/foundation.dart' as foundation;

class EmojiButtonWidget extends StatelessWidget {
  const EmojiButtonWidget({
    super.key,
    required this.themDark,
    required this.ref,
  });

  final bool themDark;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isGifOpened = ref.watch(gifShowingProvider);
    final isEmojiOpened = ref.watch(emojiShowingProvider);
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
        if(isGifOpened){
          ref.read(gifShowingProvider.notifier).state=false;
        }
        ref
            .read(emojiShowingProvider.notifier)
            .state =
        !isEmojiOpened;
        if (isEmojiOpened) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Icon(
        Icons.emoji_emotions_outlined,
        size: 24,
        color: isEmojiOpened
            ? Colors.blue.shade200
            : themDark
            ? Colors.white
            : Colors.black45,
      ),
    );
  }
}
