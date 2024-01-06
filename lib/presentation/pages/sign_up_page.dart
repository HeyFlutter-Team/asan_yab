// ignore_for_file: avoid_print

import 'package:asan_yab/domain/riverpod/data/sign_up_provider.dart';
import 'package:asan_yab/presentation/widgets/custom_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/riverpod/data/sign_in_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final Function()? onClickedSignIn;
  final String? name;
  final String? lastName;
  const SignUpPage({super.key, this.onClickedSignIn,this.name,this.lastName});

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
    final languageText=AppLocalizations.of(context);
    return Scaffold(
      body: Form(
        key: signUpFormKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/newGmail.png',
                  height: 200,
                  width: 200,
                ),
                CustomTextField(
                    label: languageText!.sign_in_email,
                    controller: emailController,
                    hintText: languageText.sign_in_email_hintText,
                    validator: (p0) {
                      if (p0!.isEmpty ||
                          p0.length < 10 && !EmailValidator.validate(p0)) {
                        return languageText.sign_in_email_2_valid;
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(p0)) {
                        return languageText.sign_in_email_3_valid;
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
                  label: languageText.sign_in_password,
                  controller: passwordController,
                  hintText: languageText.sign_in_password_hintText,
                  validator: (p0) =>
                      p0!.length < 6 ? languageText.sign_in_password_2_valid : null,
                ),
                CustomTextField(
                  obscureText: true,
                  label: languageText.sign_up_confirm_p,
                  controller: confirmPasswordController,
                  hintText: languageText.sign_up_confirm_p_hint_text,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return languageText.sign_up_confirm_p_1_valid;
                    } else if (p0 != passwordController.text) {
                      return languageText.sign_up_confirm_p_2_valid;
                    } else {
                      return null;
                    }
                  },
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:languageText.sign_up_account_text,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: '  ${languageText.sign_up_account_text1}',
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

                    ref.read(signUpNotifierProvider).signUp(
                        context: context,
                        email: emailController.text,
                        password: passwordController.text,
                    );
                  },
                  child: Text(
                    languageText.sign_up_elbT,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
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
