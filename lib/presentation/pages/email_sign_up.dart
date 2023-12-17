// import 'package:asan_yab/presentation/pages/sign_up_page.dart';
// import 'package:asan_yab/presentation/pages/verify_email_page.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
//
// import '../widgets/custom_text_field.dart';
//
// class EmailSignUpPage extends StatefulWidget {
//   final Function()? onClickedSignIn;
//   const EmailSignUpPage({super.key, this.onClickedSignIn});
//
//   @override
//   State<EmailSignUpPage> createState() => _EmailSignUpPageState();
// }
//
// class _EmailSignUpPageState extends State<EmailSignUpPage> {
//   final signUpFormKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return   Scaffold(
//       backgroundColor: Colors.white,
//       body: Form(
//         key: signUpFormKey,
//         child: Padding(
//           padding: const EdgeInsets.only(top: 15.0, left: 20),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/gmail@.jpg',
//                   height: 200,
//                   width: 200,
//                 ),
//                 const SizedBox(
//                   height: 2,
//                 ),
//
//                 CustomTextField(
//                     label: 'ایمیل',
//                     controller: emailController,
//                     hintText: 'ایمیل خود را وارد کنید',
//                     validator: (p0) {
//                       if (p0!.isEmpty ||
//                           p0.length < 10 && !EmailValidator.validate(p0)) {
//                         return 'ایمیل شما اشتباه است';
//                       }else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(p0)) {
//                         return 'فورمت ایمیل شما اشتباه است';
//                       }else {
//                         return null;
//                       }
//                     }
//                 ),
//                 CustomTextField(
//                   // obscureText: ref.watch(isObscureProvider),
//                   suffixIcon: IconButton(
//                       onPressed: (){},
//                           // ref.read(isObscureProvider.notifier).isObscure(),
//                       icon: const Icon(Icons.remove_red_eye_outlined)),
//                   label: 'رمز',
//                   controller: passwordController,
//                   hintText: 'رمز خود را وارد کنید',
//                   validator: (p0) => p0!.length < 6
//                       ? 'رمز باید بیشتر از 6 عدد باشد'
//                       : null,
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       const TextSpan(
//                         text: '  قبلا اکانت داشتید؟',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       TextSpan(
//                         text: '  ورود',
//                         style: const TextStyle(color: Colors.blue),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.pop(context);
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red.shade800,
//                       minimumSize: const Size(340, 55),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12))),
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmailPage(),));
//                   },
//                   child: const Text('بعدی'),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
