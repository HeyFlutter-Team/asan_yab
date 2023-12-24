// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:asan_yab/presentation/pages/sign_up_page.dart';
import 'package:asan_yab/presentation/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/riverpod/data/sign_in_provider.dart';
import '../widgets/custom_language_icon.dart';

class LogInPage extends ConsumerStatefulWidget {
  final Function()? onClickedSignUp;
  const LogInPage({Key? key, this.onClickedSignUp}) : super(key: key);

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage>
    with SingleTickerProviderStateMixin {
  final emailCTRL = TextEditingController();
  final passwordCTRL = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
    _controller.forward();
    retrieveSavedValues();
  }

  void retrieveSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    final isCheckboxChecked = ref.watch(isCheckProvider);
    if (isCheckboxChecked) {
      emailCTRL.text = savedEmail ?? '';
      passwordCTRL.text = savedPassword ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    emailCTRL.dispose();
    passwordCTRL.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 88.0, right: 10),
                  child: Container(
                    height: 50,
                    width: 50,
                    child: const LanguageIcon(),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                FadeTransition(
                  alwaysIncludeSemantics: false,
                  opacity: _animation,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.asset(
                      'assets/asanYabbYounis.jpg',
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
              ]),
              CustomTextField(
                label: 'sign_in_email'.tr(),
                controller: emailCTRL,
                hintText: 'sign_in_email_hintText'.tr(),
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'sign_in_email_1_valid'.tr();
                  } else if (p0.length < 10 && !EmailValidator.validate(p0)) {
                    return 'sign_in_email_2_valid'.tr();
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(p0)) {
                    return 'sign_in_email_3_valid'.tr();
                  }
                  return null;
                },
              ),
              CustomTextField(
                  label: 'sign_in_password'.tr(),
                  controller: passwordCTRL,
                  hintText: 'sign_in_password_hintText'.tr(),
                  obscureText: ref.watch(isObscureProvider),
                  suffixIcon: IconButton(
                      onPressed: () =>
                          ref.read(isObscureProvider.notifier).isObscure(),
                      icon: const Icon(Icons.remove_red_eye_outlined)),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'sign_in_password_1_valid'.tr();
                    } else if (p0.length < 6) {
                      return 'sign_in_password_2_valid'.tr();
                    }
                    return null;
                  }),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                child: Row(
                  children: [
                    Transform.scale(
                      scaleX: 1.38,
                      scaleY: 1.38,
                      child: Checkbox(
                        activeColor: Colors.red,
                        value: ref.watch(isCheckProvider),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        onChanged: (value) {
                          ref.read(isCheckProvider.notifier).setIsCheck(value!);
                        },
                      ),
                    ),
                    Text(
                      'sign_in_checkBox'.tr(),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w400),
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
                onPressed: () async {
                  final isValid = formKey.currentState!.validate();
                  if (!isValid) return;
                  final isCheckboxChecked = ref.watch(isCheckProvider);
                  if (isCheckboxChecked) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('email', emailCTRL.text);
                    prefs.setString('password', passwordCTRL.text);
                  }
                  ref.read(signInProvider.notifier).signIn(
                      context: context,
                      email: emailCTRL.text,
                      password: passwordCTRL.text);
                },
                child: Text(
                  'sign_in_elbT'.tr(),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Text(
                'sig_in_account_text'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(340, 55),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black.withOpacity(0.44)),
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: Text(
                  'sign_in_2_elbT'.tr(),
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.44), fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
