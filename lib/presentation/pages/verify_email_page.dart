import 'dart:async';
import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/presentation/pages/personal_information_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositoris/language_repo.dart';
import '../../domain/riverpod/data/verify_email.dart';

//my class
class VerifyEmailPage extends ConsumerStatefulWidget {
  final String email;
  final String? password;

  const VerifyEmailPage({
    required this.email,
    this.password,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        ref
            .read(verifyEmailProvider.notifier)
            .sendVerificationEmail()
            .whenComplete(
                () => ref.read(verifyEmailProvider.notifier).initialize());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final verifyEmailState = ref.watch(verifyEmailProvider);
    final text = texts(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return FirebaseAuth.instance.currentUser!.emailVerified
        ? PersonalInformation(email: widget.email)
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.red.shade900,
              title: Text(
                text.verify_appBar_title,
                style: const TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: isRTL
                        ? const EdgeInsets.only(right: 28.0)
                        : const EdgeInsets.only(left: 28.0),
                    child: Text(text.verify_body_text),
                  ),
                  Text(widget.email),
                  SizedBox(height: 10.h),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      minimumSize: const Size(340, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: verifyEmailState.canResendEmail
                        ? () => ref
                            .read(verifyEmailProvider.notifier)
                            .sendVerificationEmail()
                        : null,
                    icon: const Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                    label: Text(
                      text.verify_elb_text,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            widget.email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          content: Text(text.verify_email_dialog,
                              textAlign: TextAlign.center),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: Text(text.verify_email_give_up),
                            ),
                            TextButton(
                              onPressed: () async {
                                await FirebaseAuth.instance
                                    .signOut()
                                    .whenComplete(
                                      () => context.pop(),
                                    )
                                    .whenComplete(
                                      () => context.pop(),
                                    )
                                    .whenComplete(
                                      () => context.pop(),
                                    );
                              },
                              child: Text(text.verify_email_continue),
                            ),
                          ],
                        );
                      },
                    ),
                    child: Text(
                      text.verify_tbt_text,
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
