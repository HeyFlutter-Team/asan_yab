// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  const CustomTextField({
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    Key? key,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    required this.controller,
    this.label,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.16,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '  $label',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
              textCapitalization: textCapitalization,
              obscureText: obscureText,
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      width: 1, color: Colors.black.withOpacity(0.44)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                ),
                hintText: hintText,
              ),
              keyboardType: keyboardType,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validator),
        ],
      ),
    );
  }
}
