import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/data/repositoris/language_repository.dart';

class LanguageBottomSheet extends ConsumerStatefulWidget {
  const LanguageBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<LanguageBottomSheet> createState() =>
      _LanguagePopUpState();
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
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade900, Colors.black],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(22),
                  topLeft: Radius.circular(22),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: Language.values.map((value) {
                    return ListTile(
                      onTap: () {
                        ref.read(selectedLanguageProvider.notifier).state = value;
                        languageRepository.setLanguage(value);
                        Navigator.pop(context);
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value.name,
                            style: const TextStyle(fontSize: 23, color: Colors.white),
                          ),
                          Text(
                            value.flag,
                            style: const TextStyle(fontSize: 23, color: Colors.white),
                          ),
                        ],
                      ),
                      leading: Radio<Language>(
                        value: value,
                        groupValue: selectedLanguage.state,
                        onChanged: (newValue) {
                          ref.read(selectedLanguageProvider.notifier).state = newValue!;
                          languageRepository.setLanguage(newValue);
                          Navigator.pop(context);
                        },
                        activeColor: Colors.green,
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.green; // selected color
                            }
                            return Colors.white; // unselected color
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
        '${AppLocalizations.of(context)!.profile_language_listTile} 🇦🇫',
      ),
      leading: const Icon(Icons.language, color: Colors.red, size: 30),
    );
  }
}


