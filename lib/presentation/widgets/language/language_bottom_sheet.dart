import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/data/repositoris/language_repository.dart';

import '../../pages/themeProvider.dart';
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
          context: context,
          builder: (BuildContext context) {
            return Container(
              decoration:  BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.red.shade900,
                    Colors.black,
                  ]),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(22),
                  topLeft: Radius.circular(22)
                )
              ),
              child: Column(
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
                        Text(value.flag,
                    style: const TextStyle(
                        fontSize: 23,
                      color: Colors.white
                    ),),
                        const SizedBox(width: 5),
                        Text(
                          value.name,
                          style: const TextStyle(
                            fontSize: 23,
                            color: Colors.white
                          ),
                        ),
                        if (selectedLanguage.state == value)
                          const Icon(Icons.done, color: Colors.green),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
      title: selectedLanguage.state != null
          ? Text(
        '${AppLocalizations.of(context)!.profile_language_listTile} ${selectedLanguage.state!.flag}',
      )
          : Text(
           '${AppLocalizations.of(context)!.profile_language_listTile} 🇦🇫', // Replace with your default language flag text

                    ),
      leading: const Icon(Icons.language, color: Colors.red, size: 30),
    );
  }
}
