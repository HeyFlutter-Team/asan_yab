import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/data/repositoris/language_repository.dart';
class LanguageBottomSheet extends ConsumerStatefulWidget {
  const LanguageBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<LanguageBottomSheet> createState() => _LanguagePopUpState();
}

class _LanguagePopUpState extends ConsumerState<LanguageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final languageRepository = ref.watch(languageRepositoryProvider);
    final selectedLanguage = ref.watch(selectedLanguageProvider.notifier);

    return ListTile(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.black,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: Language.values.map((value) {
                return ListTile(
                  onTap: () {
                    ref.read(selectedLanguageProvider.notifier).state = value;
                    languageRepository.setLanguage(value);
                    Navigator.pop(context);
                  },
                  title: Row(
                    children: [
                      Text(value.flag),
                      const SizedBox(width: 3),
                      Text(
                        value.name,
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      if (selectedLanguage.state == value)
                        const Icon(Icons.done, color: Colors.green),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        );
      },
      title: selectedLanguage.state != null
          ? Text(
        '${AppLocalizations.of(context)!.profile_language_listTile} ${selectedLanguage.state!.flag}',
      )
          : Text(
        AppLocalizations.of(context)!.profile_language_listTile,
      ),
      leading: const Icon(Icons.language, color: Colors.red, size: 30),
    );
  }
}
