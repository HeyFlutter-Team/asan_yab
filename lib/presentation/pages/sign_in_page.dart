// ignore_for_file: avoid_print

import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:asan_yab/presentation/pages/sign_up_page.dart';
import 'package:asan_yab/presentation/widgets/custom_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/data/sign_in_provider.dart';

class LogInPage extends ConsumerStatefulWidget {
  final Function()? onClickedSignUp;
  const LogInPage({Key? key,  this.onClickedSignUp}) : super(key: key);

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FadeTransition(
                alwaysIncludeSemantics: false,
                opacity: _controller,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.asset(
                    'assets/asanYabbYounis.jpg',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              CustomTextField(
                label: 'ایمیل',
                controller: emailController,
                hintText: 'ایمیل خود را وارد کنید',
                validator: (p0) {
                  if(p0!.isEmpty){
                    return 'لطفا ایمیل خود را وارد کنید';
                  }
                 else if ( p0.length < 10 && !EmailValidator.validate(p0)) {
                    return 'ایمیل شما اشتباه است';
                  }else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(p0)) {
                    return 'فورمت ایمیل شما اشتباه است';
                  }
                  return null;

                },
              ),
              SizedBox(height: 20,),
              CustomTextField(
                  label: 'رمز',
                  controller: passwordController,
                  hintText: 'رمز خود را وارد کنید',
                  obscureText: ref.watch(isObscureProvider),
                  suffixIcon: IconButton(

                      onPressed: ()=>ref.read(isObscureProvider.notifier).isObscure(),
                      icon:const Icon(Icons.remove_red_eye_outlined)),
                  validator: (p0){
                   if(p0==null || p0.isEmpty){
                     return 'رمز خود را وارد کنید';
                   }else if(p0.length<6){
                     return 'رمز باید شیش کاراکتر یا بیشتر از شیش تا باشد';
                   }
                   return null;
                  }
                      ),
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
                            // if(value==true){
                              // ref.read(isCheckProvider.notifier).rememberGmail(emailController.text);
                            // }
                          },
                        ),
                    ),
                    const Text(
                      'مرا بخاطر داشته باش',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    minimumSize: const Size(340, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: (){
                  final isValid=formKey.currentState!.validate();
                  if(!isValid)return;
                  ref.read(SignInProvider.notifier).signIn(
                      formKey, context, emailController, passwordController).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(),)));
                },
                child: const Text('ورود'),
              ),
              const SizedBox(
                height: 100,
              ),
              Text(
                'اکانت قبلی ندارید؟',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.44)),
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
                        builder: (context) => SignUpPage(
                          onClickedSignIn: widget.onClickedSignUp,
                        ),
                      ));
                },
                child: Text(
                  'ساخت اکانت',
                  style: TextStyle(color: Colors.black.withOpacity(0.44)),
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
