 import 'package:asan_yab/domain/riverpod/data/controllers_provider.dart';
import 'package:asan_yab/main.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final SignInProvider = StateNotifierProvider((ref) => SignIn(ref,ref) );
class SignIn extends StateNotifier{
  final Ref ref;
  SignIn(super.state, this.ref);

  Future signIn({required BuildContext context,required String email,required String password})async{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signing in...')),
    );
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email:email.trim(),
          password:password
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
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
      // else if(e.code!='user-not-found'&&e.code!='wrong-password'&&e.code!='too-many-requests'){
      // return  Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(),));
      // }
    }catch (e){
      print('younis general errors $e');
    }

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