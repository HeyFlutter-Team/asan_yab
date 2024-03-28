// ignore_for_file: avoid_print

import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/riverpod/data/sign_up_provider.dart';
import 'package:asan_yab/presentation/widgets/custom_text_field_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/data/sign_in_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final Function()? onClickedSignIn;
  final String? name;
  final String? lastName;
  const SignUpPage({super.key, this.onClickedSignIn, this.name, this.lastName});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final formKey = GlobalKey<FormState>();
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
    final text = texts(context);
    return Scaffold(
      body: Form(
        key: formKey,
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
                CustomTextFieldWidget(
                    label: text.sign_in_email,
                    controller: emailController,
                    hintText: text.sign_in_email_hintText,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => validateEmail(value, text)),
                CustomTextFieldWidget(
                  obscureText: ref.watch(isObscureProvider),
                  suffixIcon: IconButton(
                      onPressed: () =>
                          ref.read(isObscureProvider.notifier).isObscure(),
                      icon: const Icon(Icons.remove_red_eye_outlined)),
                  label: text.sign_in_password,
                  controller: passwordController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: text.sign_in_password_hintText,
                  validator: (value) =>
                      value!.length < 6 ? text.sign_in_password_2_valid : null,
                ),
                CustomTextFieldWidget(
                  obscureText: true,
                  label: text.sign_up_confirm_p,
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: text.sign_up_confirm_p_hint_text,
                  validator: (value) => validatePasswordConfirmation(
                      value, passwordController, text),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text.sign_up_account_text,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '  ${text.sign_up_account_text1}',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      minimumSize: const Size(340, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () => signUp(
                      formKey, emailController, passwordController, context),
                  child: Text(
                    text.sign_up_elbT,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value, AppLocalizations text) {
    if (value!.isEmpty ||
        (value.length < 10 && !EmailValidator.validate(value))) {
      return text.sign_in_email_2_valid;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return text.sign_in_email_3_valid;
    } else {
      return null;
    }
  }

  String? validatePasswordConfirmation(
    String? value,
    TextEditingController passwordController,
    AppLocalizations text,
  ) {
    if (value!.isEmpty) {
      return text.sign_up_confirm_p_1_valid;
    } else if (value != passwordController.text) {
      return text.sign_up_confirm_p_2_valid;
    } else {
      return null;
    }
  }

  void signUp(
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    BuildContext context,
  ) {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    ref.read(signUpNotifierProvider).signUp(
          context: context,
          email: emailController.text,
          password: passwordController.text,
        );
  }
}
