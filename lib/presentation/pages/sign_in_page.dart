// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:asan_yab/presentation/pages/sign_up_page.dart';
import 'package:asan_yab/presentation/pages/verify_email_page.dart';
import 'package:asan_yab/presentation/widgets/custom_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/riverpod/data/isOnline.dart';
import '../../domain/riverpod/data/sign_in_provider.dart';

final isSignInningProvider = StateProvider<bool>((ref) => false);

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
    _initializeValues();
    ref.read(isSignInningProvider.notifier).state = false;
  }

  void _initializeValues() async {
    await retrieveSavedValues();
  }

  Future<void> retrieveSavedValues() async {
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
    final loadingState = ref.watch(loadingProvider);
    final languageText = AppLocalizations.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
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
              CustomTextField(
                label: languageText!.sign_in_email,
                controller: emailCTRL,
                hintText: languageText.sign_in_email_hintText,
                keyboardType: TextInputType.emailAddress,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return languageText.sign_in_email_1_valid;
                  } else if (p0.length < 10 && !EmailValidator.validate(p0)) {
                    return languageText.sign_in_email_2_valid;
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(p0)) {
                    return languageText.sign_in_email_3_valid;
                  }
                  return null;
                },
              ),
              CustomTextField(
                  label: languageText.sign_in_password,
                  controller: passwordCTRL,
                  hintText: languageText.sign_in_password_hintText,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: ref.watch(isObscureProvider),
                  suffixIcon: IconButton(
                      onPressed: () =>
                          ref.read(isObscureProvider.notifier).isObscure(),
                      icon: const Icon(Icons.remove_red_eye_outlined)),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return languageText.sign_in_password_1_valid;
                    } else if (p0.length < 6) {
                      return languageText.sign_in_password_2_valid;
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
                      languageText.sign_in_checkBox,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer(
                builder: (context, sref, child) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.9, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: ref.watch(isSignInningProvider)
                      ? null
                      : () async {
                          final isValid = formKey.currentState!.validate();
                          if (!isValid) return;
                          ref.read(isSignInningProvider.notifier).state = true;
                          FocusScope.of(context).unfocus();
                          final isCheckboxChecked = ref.read(isCheckProvider);
                          if (isCheckboxChecked) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('email', emailCTRL.text);
                            prefs.setString('password', passwordCTRL.text);
                          }

                          final currentContext =
                              context; // Store the current context

                          await ref
                              .read(signInProvider)
                              .signIn(
                                context: context,
                                email: emailCTRL.text,
                                password: passwordCTRL.text,
                                ref: ref,
                              )
                              .then((_) async {
                            await ref
                                .watch(userDetailsProvider.notifier)
                                .getCurrentUserData();
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (currentUser != null) {
                              if (context.mounted) {
                                  if (currentUser.emailVerified) {  Navigator.pushReplacement(
                                     currentContext, // Use the stored context
                                     MaterialPageRoute(
                                         builder: (context) => const MainPage(),
                                   ));
                                 
                                } else {
                                  Navigator.pushReplacement(
                                    currentContext, // Use the stored context
                                    MaterialPageRoute(
                                      builder: (context) => VerifyEmailPage(
                                          email: emailCTRL.text),
                                    ),
                                  );
                                }
                              }
                            } else {
                              print('');
                            }
                          });
                        },
                  child: ref.watch(isSignInningProvider)
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          languageText.sign_in_elbT,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Text(
                languageText.sig_in_account_text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.9, 55),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black.withOpacity(0.44)),
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: Text(
                  languageText.sign_in_2_elbT,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.44), fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: loadingState
                    ? const CircularProgressIndicator(
                        color: Colors.red,
                      )
                    : const SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
