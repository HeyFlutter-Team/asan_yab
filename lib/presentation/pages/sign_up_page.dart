// ignore_for_file: avoid_print

import 'package:asan_yab/domain/riverpod/data/controllers_provider.dart';
import 'package:asan_yab/presentation/pages/verify_email_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:asan_yab/domain/riverpod/data/sign_up_provider.dart';
import 'package:asan_yab/presentation/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/riverpod/data/sign_in_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final Function()? onClickedSignIn;
  const SignUpPage({super.key, this.onClickedSignIn});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final signUpFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: signUpFormKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/gmail@.jpg',
                  height: 200,
                  width: 200,
                ),
                CustomTextField(
                    label: 'ایمیل',
                    controller: emailController,
                    hintText: 'ایمیل خود را وارد کنید',
                    validator: (p0) {
                      if (p0!.isEmpty ||
                          p0.length < 10 && !EmailValidator.validate(p0)) {
                        return 'ایمیل شما اشتباه است';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(p0)) {
                        return 'فورمت ایمیل شما اشتباه است';
                      } else {
                        return null;
                      }
                    }),
                CustomTextField(
                  obscureText: ref.watch(isObscureProvider),
                  suffixIcon: IconButton(
                      onPressed: () =>
                          ref.read(isObscureProvider.notifier).isObscure(),
                      icon: const Icon(Icons.remove_red_eye_outlined)),
                  label: 'رمز',
                  controller: passwordController,
                  hintText: 'رمز خود را وارد کنید',
                  validator: (p0) =>
                      p0!.length < 6 ? 'رمز باید بیشتر از 6 عدد باشد' : null,
                ),
                CustomTextField(
                  obscureText: true,
                  label: 'تایید رمز',
                  controller: confirmPasswordController,
                  hintText: 'تکرار رمز',
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'رمز خود را مکررا وارد کنید';
                    } else if (p0 != passwordController.text) {
                      return 'رمز ها برابری نمیکنند';
                    } else {
                      return null;
                    }
                  },
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '  قبلا اکانت داشتید؟',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: '  ورود',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      minimumSize: const Size(340, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    final isValid = signUpFormKey.currentState!.validate();
                    if (!isValid) return;

                    ref.read(signUpNotifierProvider.notifier).signUp(
                        context: context,
                        email: emailController.text,
                        password: passwordController.text);
                  },
                  child: const Text('ساخت'),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
