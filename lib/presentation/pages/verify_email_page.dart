// ignore_for_file: avoid_print

import 'dart:async';

import 'package:asan_yab/domain/riverpod/data/verify_page_provider.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
Timer? timer;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      ref.read(isEmailVerifieds.notifier).state=
          FirebaseAuth.instance.currentUser!.emailVerified;
      if(!ref.read(isEmailVerifieds.notifier).state){
        ref.read(sendVirificationEmail.notifier).sendVerificationEmail(ref,context);
        timer= Timer.periodic(const Duration(seconds: 3),
                (timer)=>ref.read(checkEmailVerifiedProvider.notifier).checkEmailVerified(ref, timer).whenComplete(() => navigatorKey.currentState
                !.popUntil((route) => route.isFirst)
                )
                );
      }

    });

  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context)=>  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: const Text('تایید ایمیل'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('یک لینک تاییدیه به ایمیل شما فرستاده شد!\n لطفا برای تایید ایمیل خود روی آن کلیک کنید'),
            const SizedBox(height: 10,),

            ElevatedButton.icon(
               style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    minimumSize: const Size(340, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
              onPressed:() =>ref.watch(canResendEmailsProvider)
              ?ref.read(sendVirificationEmail.notifier).sendVerificationEmail(ref, context)
              :null ,
               icon: const Icon(Icons.mail),
                label: const Text('ارسال دوباره')
                ),
                const SizedBox(height: 8,),
                TextButton(
                  onPressed:()=>FirebaseAuth.instance.signOut(),
                   child:  Text('لغو',style: TextStyle(color: Colors.red.shade800),))
          ],
        ),
      ) ,
    );
  }
