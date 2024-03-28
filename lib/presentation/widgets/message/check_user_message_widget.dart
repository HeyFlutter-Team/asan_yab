import 'package:asan_yab/core/extensions/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../data/repositoris/language_repo.dart';
import '../../../domain/riverpod/screen/botton_navigation_provider.dart';

class CheckUserMessageWidget extends ConsumerStatefulWidget {
  const CheckUserMessageWidget({super.key});

  @override
  ConsumerState<CheckUserMessageWidget> createState() =>
      _MessageCheckUserState();
}

class _MessageCheckUserState extends ConsumerState<CheckUserMessageWidget> {
  @override
  Widget build(BuildContext context) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final languageText = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          isRTL
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat,
                      size: 80,
                      color: Colors.red.shade800,
                    ),
                    Text(
                      'پیام',
                      style: TextStyle(
                          color: Colors.red.shade800,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Chat',
                      style: TextStyle(
                          color: Colors.red.shade800,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.chat,
                      size: 80,
                      color: Colors.red.shade800,
                    )
                  ],
                ),
          const SizedBox(
            height: 190,
          ),
          Text(languageText!.message_check_user1,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 340,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade800,
                  minimumSize: const Size(340, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                ref.read(buttonNavigationProvider.notifier).selectedIndex(3);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    languageText.message_check_user2,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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
