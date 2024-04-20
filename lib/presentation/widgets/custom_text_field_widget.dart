// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/repositoris/theme_Provider.dart';

class CustomTextFieldWidget extends ConsumerStatefulWidget {
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? label;
  final String? label2;
  final String? hintText;
  const CustomTextFieldWidget({
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
  ConsumerState<CustomTextFieldWidget> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final themeModel = ref.watch(themeModelProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * 0.17.h,
      width: screenWidth * 0.9.w,
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
              SizedBox(width: 5.w),
              widget.label2 != null
                  ? Text(
                      '${widget.label2}',
                      style: const TextStyle(color: Colors.red, fontSize: 15),
                    )
                  : const SizedBox()
            ],
          ),
          SizedBox(height: 5.h),
          TextFormField(
              textCapitalization: widget.textCapitalization,
              obscureText: widget.obscureText,
              controller: widget.controller,
              decoration: InputDecoration(
                suffixIcon: widget.suffixIcon,
                border: const OutlineInputBorder(borderSide: BorderSide()),
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
                      color: themeModel.currentThemeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
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
