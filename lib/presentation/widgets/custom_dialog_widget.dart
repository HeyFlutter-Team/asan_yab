import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final languageText = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(languageText!.suggestion_customDialog_title),
      content: Text(languageText.suggestion_customDialog_content),
      actions: <Widget>[
        TextButton(
          child: Text(languageText.suggestion_customDialog_textButton,
              style: const TextStyle(
                color: Colors.blueAccent,
              )),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
