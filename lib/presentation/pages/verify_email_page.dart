import 'dart:async';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/presentation/pages/personal_information_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositoris/language_repository.dart';

final verifyEmailProvider =
    StateNotifierProvider<VerifyEmailNotifier, VerifyEmailState>((ref) {
  return VerifyEmailNotifier(ref);
});

class VerifyEmailState {
  final bool isEmailVerified;
  final bool canResendEmail;

  VerifyEmailState(this.isEmailVerified, this.canResendEmail);
}

class VerifyEmailNotifier extends StateNotifier<VerifyEmailState> {
  final Ref ref;
  late Timer _timer;

  VerifyEmailNotifier(this.ref) : super(VerifyEmailState(false, false)) {
    _initialize();
  }

  Future<void> _initialize() async {
    final isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      await _sendVerificationEmail();
      _timer = Timer.periodic(
          const Duration(seconds: 3), (_) => _checkEmailVerified());
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      state = VerifyEmailState(false, false);
      await Future.delayed(const Duration(seconds: 20));
      state = VerifyEmailState(false, true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _checkEmailVerified() async {
    FirebaseAuth.instance.currentUser?.reload();
    if (FirebaseAuth.instance.currentUser != null) {
      final isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isEmailVerified) {
        _timer.cancel();
        state = VerifyEmailState(isEmailVerified, state.canResendEmail);
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer
    super.dispose();
  }

  void cancelTimer() {
    _timer.cancel();
  }
}

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
            ._sendVerificationEmail()
            .whenComplete(
                () => ref.read(verifyEmailProvider.notifier)._initialize());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final verifyEmailState = ref.watch(verifyEmailProvider);
    final languageText = AppLocalizations.of(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return FirebaseAuth.instance.currentUser!.emailVerified
        ? PersonalInformation(
            email: widget.email,
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.red.shade900,
              title: Text(
                languageText!.verify_appBar_title,
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
                    child: Text(languageText.verify_body_text),
                  ),
                  Text(widget.email),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade800,
                        minimumSize: const Size(340, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: verifyEmailState.canResendEmail
                        ? () => ref
                            .read(verifyEmailProvider.notifier)
                            ._sendVerificationEmail()
                        : null,
                    icon: const Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                    label: Text(
                      languageText.verify_elb_text,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              widget.email,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            content: Text(languageText.verify_email_dialog,
                                textAlign: TextAlign.center),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(languageText.verify_email_give_up),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance
                                      .signOut()
                                      .whenComplete(
                                        () => Navigator.pop(context),
                                      )
                                      .whenComplete(
                                        () => Navigator.pop(context),
                                      )
                                      .whenComplete(
                                        () => Navigator.pop(context),
                                      );
                                },
                                child: Text(languageText.verify_email_continue),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      languageText.verify_tbt_text,
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
//
// import 'dart:async';
// import 'package:asan_yab/presentation/pages/personal_information_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class VerifyEmailPage extends ConsumerStatefulWidget {
//   final String? email;
//   const VerifyEmailPage({
//     this.email,
//     super.key,
//   });
//
//   @override
//   ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
// }
//
// class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
//   bool isEmailVerified = false;
//   bool canResendEmail = false;
//   Timer? timer;
//
//   @override
//   void initState() {
//     super.initState();
//     isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     if (!isEmailVerified) {
//       sendVerificationEmail();
//       timer = Timer.periodic(
//           const Duration(seconds: 3), (_) => checkEmailVerified());
//     }
//   }
//
//   Future sendVerificationEmail() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       await user.sendEmailVerification();
//       setState(() => canResendEmail = false);
//       await Future.delayed(const Duration(seconds: 10));
//       setState(() => canResendEmail = true);
//     } catch (e) {
//       print(e);
//     }
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     timer?.cancel();
//   }
//   Future checkEmailVerified() async {
//     await FirebaseAuth.instance.currentUser!.reload();
//     setState(() {
//       isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     });
//     if (isEmailVerified) {
//       timer?.cancel();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final languageText = AppLocalizations.of(context);
//     return isEmailVerified
//         ? PersonalInformation(email: widget.email)
//         : Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               backgroundColor: Colors.red.shade900,
//               title: Text(
//                 '${languageText?.verify_appBar_title}',
//                 style: const TextStyle(color: Colors.white),
//               ),
//               centerTitle: true,
//             ),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('${languageText?.verify_body_text}',style: const TextStyle(fontSize: 19),textAlign: TextAlign.center),
//                   const SizedBox(height: 14,),
//                   Text('${widget.email}',style: TextStyle(fontSize: 23,color: Colors.red.shade900,fontWeight: FontWeight.bold),),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red.shade800,
//                           minimumSize: const Size(340, 55),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12))),
//                       onPressed: canResendEmail ? sendVerificationEmail : null,
//                       icon: const Icon(
//                         Icons.mail,
//                         color: Colors.white,
//                       ),
//                       label: Text(
//                         '${languageText?.verify_elb_text}',
//                         style:
//                             const TextStyle(fontSize: 19, color: Colors.white),
//                       )),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   TextButton(
//                                     onPressed: () {
//                                     showDialog(
//                                         context: context,
//                                        builder: (context) {
//                                         return AlertDialog(
//                                          title: Text('${widget.email}',textAlign: TextAlign.center,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
//                                        content: Text(languageText!.verify_email_dialog,
//                                 textAlign: TextAlign.center),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child:  Text(languageText.verify_email_give_up),
//                               ),
//                               TextButton(
//                                 onPressed: () async {
//                                   await FirebaseAuth.instance
//                                       .signOut()
//                                       .whenComplete(
//                                         () => Navigator.pop(context),
//                                       )
//                                       .whenComplete(
//                                         () => Navigator.pop(context),
//                                       )
//                                       .whenComplete(
//                                         () => Navigator.pop(context),
//                                       );
//                                 },
//                                 child:  Text(languageText.verify_email_continue),
//                               ),
//
//                             ],
//                           );
//                         },
//                       );
//                       // FirebaseAuth.instance.signOut().whenComplete(
//                       //       () => Navigator.push(
//                       //         context,
//                       //         MaterialPageRoute(
//                       //           builder: (context) => const MainPage(),
//                       //         ),
//                       //       ),
//                       //     );
//                     },
//                     child: Text(
//                       '${languageText?.verify_tbt_text}',
//                       style: TextStyle(color: Colors.red.shade800,fontSize: 19),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }
