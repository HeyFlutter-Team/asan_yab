import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController addController;
  final String labelName;
  final bool hiddenText;
  const TextFieldWidget(
      {super.key,
      required this.addController,
      required this.labelName,
      this.hiddenText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      controller: addController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blueGrey.withOpacity(0.1),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.black,
        labelText: labelName,
        labelStyle: const TextStyle(color: Colors.black),
        enabled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.yellow,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      obscureText: hiddenText,
    );
  }
}
