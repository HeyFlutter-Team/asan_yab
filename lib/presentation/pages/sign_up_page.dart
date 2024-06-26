// ignore_for_file: avoid_print

import 'package:asan_yab/domain/riverpod/data/sign_up_provider.dart';
import 'package:asan_yab/presentation/widgets/custom_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/data/sign_in_provider.dart';
import '../../main.dart';

final isSignUppingProvider = StateProvider<bool>((ref) => false);

class SignUpPage extends ConsumerStatefulWidget {
  final Function()? onClickedSignIn;
  final String? name;
  final String? lastName;
  const SignUpPage({super.key, this.onClickedSignIn, this.name, this.lastName});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final signUpFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(isSignUppingProvider.notifier).state=false;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageText = AppLocalizations.of(context);
    return Scaffold(
      body: Form(
        key: signUpFormKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 20,right: 20),
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
                    keyboardType: TextInputType.emailAddress,
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
                  keyboardType: TextInputType.emailAddress,
                  hintText: languageText.sign_in_password_hintText,
                  validator: (p0) => p0!.length < 6
                      ? languageText.sign_in_password_2_valid
                      : null,
                ),
                CustomTextField(
                  obscureText: true,
                  label: languageText.sign_up_confirm_p,
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.emailAddress,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text(languageText.sign_up_account_text,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
                ,InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                  child: Text('  ${languageText.sign_up_account_text1}',
                      style: const TextStyle(color: Colors.blue,fontSize: 15),),
                )],),

                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      minimumSize:  Size(MediaQuery.of(context).size.width * 0.9, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed:ref.watch(isSignUppingProvider)
                      ?null
                      :(){
                    final isValid = signUpFormKey.currentState!.validate();
                    if (!isValid) return;
                    ref.read(isSignUppingProvider.notifier).state=true;
                    FocusScope.of(context).unfocus();
                    ref.read(signUpNotifierProvider).signUp(
                          context: context,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                  },
                  child:ref.watch(isSignUppingProvider)
                      ? const CircularProgressIndicator(color: Colors.white,)
                      : Text(
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
