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
        if(ref.watch(gifShowingProvider)){
          ref.read(gifShowingProvider.notifier).state=false;
        }
        ref
            .read(emojiShowingProvider.notifier)
            .state =
        !ref.watch(emojiShowingProvider);
        if (ref.watch(emojiShowingProvider)) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Icon(
        Icons.emoji_emotions_outlined,
        size: 24,
        color: ref.watch(emojiShowingProvider)
            ? Colors.blue.shade200
            : themDark
            ? Colors.white
            : Colors.black45,
      ),
    );
  }
}

class EmojiPickerWidget extends StatelessWidget {
  const EmojiPickerWidget({
    super.key,
    required this.ref,
    required this.themeModel,
    required this.languageText,
  });

  final WidgetRef ref;
  final ThemeModel themeModel;
  final AppLocalizations? languageText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: !ref.watch(emojiShowingProvider) ? 20 : 350,
      child: Column(
        children: [
          const SizedBox(
            height: 9,
          ),
          Expanded(
            child: Offstage(
              offstage: !ref.watch(emojiShowingProvider),
              child:
              EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  ref.read(hasTextFieldValueProvider.notifier).state=true;
                },
                textEditingController: ref
                    .watch(
                    messageProfileProvider.notifier)
                    .textController,
                onBackspacePressed: ref
                    .read(messageProfileProvider.notifier)
                    .onBackspacePressed(),
                config: Config(
                  columns: 7,
                  // Issue: https://github.com/flutter/flutter/issues/28894
                  emojiSizeMax: 32 *
                      (foundation.defaultTargetPlatform ==
                          TargetPlatform.iOS
                          ? 1.30
                          : 1.0),
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  initCategory: Category.RECENT,
                  bgColor: (themeModel.currentThemeMode ==
                      ThemeMode.dark)
                      ? Colors.black
                      : Colors.white,
                  indicatorColor: Colors.red,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.red,
                  backspaceColor: Colors.red,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  recentTabBehavior:
                  RecentTabBehavior.RECENT,
                  recentsLimit: 28,
                  replaceEmojiOnLimitExceed: false,
                  noRecents: Text(
                    '${languageText?.emoji_recent}',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  loadingIndicator:
                  const SizedBox.shrink(),
                  tabIndicatorAnimDuration:
                  kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                  checkPlatformCompatibility: true,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
