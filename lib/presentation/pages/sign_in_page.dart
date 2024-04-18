// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data.dart';
import 'package:asan_yab/presentation/widgets/custom_text_field_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/riverpod/data/sign_in.dart';
import '../../domain/riverpod/screen/botton_navigation_provider.dart';

class SignInPage extends ConsumerStatefulWidget {
  final Function()? onClickedSignUp;
  const SignInPage({Key? key, this.onClickedSignUp}) : super(key: key);

  @override
  ConsumerState<SignInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<SignInPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
  }

  void _initializeValues() async {
    await retrieveSavedValues();
  }

  Future<void> retrieveSavedValues() async {
    final preFs = await SharedPreferences.getInstance();
    final savedEmail = preFs.getString('email');
    final savedPassword = preFs.getString('password');

    final isCheckboxChecked = ref.watch(rememberMeProvider);
    if (isCheckboxChecked) {
      emailController.text = savedEmail ?? '';
      passwordController.text = savedPassword ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = ref.watch(loadingProvider);
    final text = texts(context);
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
              CustomTextFieldWidget(
                label: text.sign_in_email,
                controller: emailController,
                hintText: text.sign_in_email_hintText,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => validateEmail(value, text),
              ),
              CustomTextFieldWidget(
                label: text.sign_in_password,
                controller: passwordController,
                hintText: text.sign_in_password_hintText,
                keyboardType: TextInputType.emailAddress,
                obscureText: ref.watch(obscureBoolProvider),
                suffixIcon: IconButton(
                  onPressed: () =>
                      ref.read(obscureBoolProvider.notifier).isObscure(),
                  icon: const Icon(Icons.remove_red_eye_outlined),
                ),
                validator: (value) => validatePassword(value, text),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Transform.scale(
                      scaleX: 1.38,
                      scaleY: 1.38,
                      child: Checkbox(
                        activeColor: Colors.red,
                        value: ref.watch(rememberMeProvider),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        onChanged: (value) {
                          ref
                              .read(rememberMeProvider.notifier)
                              .setRememberMe(value!);
                        },
                      ),
                    ),
                    Text(
                      text.sign_in_checkBox,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Consumer(
                builder: (context, sref, child) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    minimumSize: const Size(340, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => signIn(
                      formKey, emailController, passwordController, context),
                  child: Text(
                    text.sign_in_elbT,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 100.h),
              Text(
                text.sig_in_account_text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(340, 55),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black.withOpacity(0.44)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => context.pushNamed(Routes.signUp),
                child: Text(
                  text.sign_in_2_elbT,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.44), fontSize: 20),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: loadingState
                    ? LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.redAccent, size: 60)
                    : const SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn(
    GlobalKey<FormState> formKey,
    TextEditingController emailCTRL,
    TextEditingController passwordCTRL,
    BuildContext context,
  ) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    final isCheckboxChecked = ref.read(rememberMeProvider);
    if (isCheckboxChecked) {
      final preFs = await SharedPreferences.getInstance();
      preFs.setString('email', emailCTRL.text);
      preFs.setString('password', passwordCTRL.text);
    }

    await ref
        .read(signInProvider)
        .signIn(
          context: context,
          email: emailCTRL.text,
          password: passwordCTRL.text,
        )
        .whenComplete(() => ref.watch(profileDataProvider))
        .whenComplete(() {})
        .whenComplete(() async {
      ref.read(stateButtonNavigationBarProvider.notifier).selectedIndex(0);
    }).whenComplete(
      () => context.pushNamed(Routes.home),
    );
  }

  String? validateEmail(String? value, AppLocalizations text) {
    if (value!.isEmpty) {
      return text.sign_in_email_1_valid;
    } else if (value.length < 10 && !EmailValidator.validate(value)) {
      return text.sign_in_email_2_valid;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return text.sign_in_email_3_valid;
    }
    return null;
  }

  String? validatePassword(String? value, AppLocalizations text) {
    if (value == null || value.isEmpty) {
      return text.sign_in_password_1_valid;
    } else if (value.length < 6) {
      return text.sign_in_password_2_valid;
    }
    return null;
  }
}
