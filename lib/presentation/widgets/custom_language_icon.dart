import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/riverpod/data/language_controller_provider.dart';

class LanguageIcon extends ConsumerStatefulWidget {
  const LanguageIcon({Key? key}) : super(key: key);

  @override
  ConsumerState<LanguageIcon> createState() => _LanguageIconState();
}

class _LanguageIconState extends ConsumerState<LanguageIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  trailing:
                  context.locale == const Locale('fa', 'AF')
                      ? const Icon(
                    Icons.done,
                    color: Colors.blue,
                  )
                      : null,
                  leading: const Icon(Icons.language,
                      color: Colors.blue),
                  title: const Center(
                    child: Text(
                      'فارسی',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  onTap: () {
                    ref
                        .read(languageProvider.notifier)
                        .setToFarsi(context);

                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 0, color: Colors.grey),
                ListTile(
                  trailing:
                  context.locale == const Locale('en', 'US')
                      ? const Icon(
                    Icons.done,
                    color: Colors.blue,
                  )
                      : null,
                  leading: const Icon(Icons.language,
                      color: Colors.blue),
                  title: const Center(
                    child: Text(
                      'English',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  onTap: () {
                    ref
                        .read(languageProvider.notifier)
                        .setToEnglish(context);

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
      icon: const Icon(Icons.language),
    );
  }
}
