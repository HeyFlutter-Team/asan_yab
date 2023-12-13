 import 'package:asan_yab/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final SignInProvider = StateNotifierProvider((ref) => SignIn(ref) );
class SignIn extends StateNotifier{
  SignIn(super.state);

  Future signIn(GlobalKey<FormState> formKey,BuildContext context ,TextEditingController emailController,TextEditingController passwordController)async{
    final isValid=formKey.currentState!.validate();
    if(!isValid)return;
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),);
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    }on FirebaseAuthException catch(e){
      print('Younis$e');
      if(e.code=='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ایمیل شما در دیتابیس ثبت نشده است'))
        );
      }else if(e.code=='wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('رمز شما اشتباه است'))
        );
      }else if(e.code=='too-many-requests'){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('برای درخواست اشتباه مکرر اکانت شما بلاک شده است لطفا بعدا امتحان کنید'))
        );
      }
    }
    navigatorKey.currentState
    !.popUntil((route) => route.isFirst);

  }
}

 class IsCheckNotifier extends StateNotifier<bool> {
   IsCheckNotifier() : super(false);

   void setIsCheck(bool value) {
     state = value;
   }

   // void rememberGmail(String email)async{
   //
   //     SharedPreferences prefs=await SharedPreferences.getInstance();
   //     await prefs.setString('SaveEmail', email);
   //     final emails=prefs.getString('SaveEmail');
   //     print('younis :its the saved email $emails');
   //
   // }
 }

 final isCheckProvider = StateNotifierProvider<IsCheckNotifier, bool>((ref) {
   return IsCheckNotifier();
 });


class ObscureBool extends StateNotifier<bool>{
  ObscureBool(): super(true);

  void isObscure(){
    state=!state;
    print('younis obscure = $state');
  }
}

final isObscureProvider=StateNotifierProvider<ObscureBool, bool>((ref) => ObscureBool());