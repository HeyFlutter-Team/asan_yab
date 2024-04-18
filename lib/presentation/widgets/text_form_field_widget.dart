import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController addController;
  final String labelName;
  final Function validator;
  final int? line;
  const TextFormFieldWidget({
    super.key,
    required this.validator,
    required this.addController,
    required this.labelName,
    this.line = 1,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
        maxLines: line,
        style: const TextStyle(fontSize: 16),
        controller: addController,
        validator: (value) => validator(value),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blueGrey.withOpacity(0.1),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(16),
          ),
          hoverColor: Colors.black,
          labelText: labelName,
          labelStyle: const TextStyle(),
          enabled: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.yellow,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
}
