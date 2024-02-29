// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/themeProvider.dart';

class CustomTextField extends ConsumerStatefulWidget {
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? label;
  final String? label2;
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
    this.label2,
    this.hintText,
  }) : super(key: key);

  @override
  ConsumerState<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final themeModel = ref.watch(themeModelProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.17,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '  ${widget.label}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 5,),
              widget.label2!=null?
              Text('${widget.label2}',style: const TextStyle(color: Colors.red,fontSize: 15),)
                  :const SizedBox()
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
              textCapitalization: widget.textCapitalization,
              obscureText: widget.obscureText,
              controller: widget.controller,
              decoration: InputDecoration(
                suffixIcon: widget.suffixIcon,
                border: const OutlineInputBorder(
                  borderSide: BorderSide()
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:  BorderSide(
                    color:themeModel.currentThemeMode == ThemeMode.dark?Colors.white
                      :Colors.black,
                      width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                ),
                hintText: widget.hintText,
              ),
              keyboardType: widget.keyboardType,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: widget.validator),
        ],
      ),
    );
  }
}
