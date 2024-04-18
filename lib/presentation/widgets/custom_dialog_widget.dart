import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final text = texts(context);
    return AlertDialog(
      title: Text(text.suggestion_customDialog_title),
      content: Text(text.suggestion_customDialog_content),
      actions: <Widget>[
        TextButton(
          child: Text(text.suggestion_customDialog_textButton,
              style: const TextStyle(color: Colors.blueAccent)),
          onPressed: () {
            FocusScope.of(context).unfocus();
            context.pop();
          },
        ),
      ],
    );
  }
}
