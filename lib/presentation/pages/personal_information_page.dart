
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/data/sign_up_provider.dart';
import '../widgets/custom_text_field.dart';

class PersonalInformation extends ConsumerStatefulWidget {
  final String? email;
  // final Function()? onClickedSignIn;
  const PersonalInformation({super.key, this.email});

  @override
  ConsumerState<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                const SizedBox(
                  height: 2,
                ),
                CustomTextField(
                  textCapitalization: TextCapitalization.words,
                  label: 'اسم',
                  controller: nameController,
                  hintText: 'اسم خود را وارد کنید',
                  validator: (p0) => p0!.isEmpty ? 'اسم خالی است' : null,
                ),
                CustomTextField(
                  textCapitalization: TextCapitalization.words,
                  label: 'تخلص',
                  controller:lastNameController,
                  hintText: 'تخلص خود را وارد کنید',
                  validator: (p0) => p0!.isEmpty ? 'تخلص خالی است' : null,
                ),
                // CustomTextField(
                //     label: 'ایمیل',
                //     controller: emailController,
                //     hintText: 'ایمیل خود را وارد کنید',
                //     validator: (p0) {
                //       if (p0!.isEmpty ||
                //           p0.length < 10 && !EmailValidator.validate(p0)) {
                //         return 'ایمیل شما اشتباه است';
                //       }else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(p0)) {
                //         return 'فورمت ایمیل شما اشتباه است';
                //       }else {
                //         return null;
                //       }
                //     }
                // ),
                // CustomTextField(
                //   obscureText: ref.watch(isObscureProvider),
                //   suffixIcon: IconButton(
                //       onPressed: () => ref.read(isObscureProvider.notifier).isObscure(),
                //       icon: const Icon(Icons.remove_red_eye_outlined)),
                //   label: 'رمز',
                //   controller: passwordController,
                //   hintText: 'رمز خود را وارد کنید',
                //   validator: (p0) => p0!.length < 6
                //       ? 'رمز باید بیشتر از 6 عدد باشد'
                //       : null,
                // ),
                // CustomTextField(
                //   obscureText: true,
                //   label: 'تایید رمز',
                //   controller: confirmPasswordController,
                //   hintText: 'تکرار رمز',
                //   validator:(p0) {
                //     if(p0!.isEmpty){
                //       return 'رمز خود را مکررا وارد کنید';
                //     }else if(p0 != passwordController.text){
                //       return 'رمز ها برابری نمیکنند';
                //     }else{
                //       return null;
                //     }
                //   },
                //
                // ),
                // RichText(
                //   text: TextSpan(
                //     children: [
                //       const TextSpan(
                //         text: '  قبلا اکانت داشتید؟',
                //         style: TextStyle(color: Colors.black),
                //       ),
                //       TextSpan(
                //         text: '  ورود',
                //         style: const TextStyle(color: Colors.blue),
                //         recognizer: TapGestureRecognizer()
                //           ..onTap = () {
                //             Navigator.pop(context);
                //           },
                //       ),
                //     ],
                //   ),
                // ),
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
                    if (!isValid)return;

                    ref.read(userDetailsProvider.notifier).userDetails(
                      emailController: widget.email!,
                      lastNameController:lastNameController.text,
                      nameController: nameController.text
                    ).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(),)));

                    // ref.read(signUpNotifierProvider.notifier).signUp(signUpFormKey,context,emailController,passwordController);
                    // .whenComplete(() =>
                    // ref.read(userDetailsProvider.notifier).userDetails(lastNameController,nameController,context);


                  },
                  child: const Text('ساخت'),
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
