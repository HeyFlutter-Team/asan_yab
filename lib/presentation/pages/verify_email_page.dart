// ignore_for_file: avoid_print

// import 'dart:async';
//
// import 'package:asan_yab/domain/riverpod/data/verify_page_provider.dart';
// import 'package:asan_yab/presentation/pages/sign_in_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/riverpod/data/sign_up_provider.dart';
// import '../../main.dart';
// import 'main_page.dart';
//
// class VerifyEmailPage extends ConsumerStatefulWidget {
//   TextEditingController? emailController;
//   TextEditingController? nameController;
//   TextEditingController? lastNameController;
//   VerifyEmailPage(
//       {super.key,
//       this.emailController,
//       this.lastNameController,
//       this.nameController});
//
//   @override
//   ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
// }
//
// class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
//   Timer? timer;
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       ref.read(isEmailVerifieds.notifier).state =
//           FirebaseAuth.instance.currentUser!.emailVerified;
//
//       if (!ref.read(isEmailVerifieds.notifier).state) {
//         ref
//             .read(sendVirificationEmail.notifier)
//             .sendVerificationEmail(ref, context);
//         timer = Timer.periodic(
//             const Duration(seconds: 3),
//             (timer) => ref
//                     .read(checkEmailVerifiedProvider.notifier)
//                     .checkEmailVerified(ref, timer)
//                     .whenComplete(() {
//                   navigatorKey.currentState!.popUntil((route) => route.isFirst);
//                 }));
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) =>ref.watch(isEmailVerifieds)==true
//       ?const MainPage()
//       : Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red.shade900,
//           title: const Text('تایید ایمیل'),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                   'یک لینک تاییدیه به ایمیل شما فرستاده شد!\n لطفا برای تایید ایمیل خود روی آن کلیک کنید'),
//               const SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red.shade800,
//                       minimumSize: const Size(340, 55),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12))),
//                   onPressed: () => ref.watch(canResendEmailsProvider)
//                       ? ref
//                           .read(sendVirificationEmail.notifier)
//                           .sendVerificationEmail(ref, context)
//                       : null,
//                   icon: const Icon(Icons.mail),
//                   label: const Text('ارسال دوباره')),
//               const SizedBox(
//                 height: 8,
//               ),
//               TextButton(
//                   onPressed: () => FirebaseAuth.instance
//                       .signOut()
//                       .whenComplete(() => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => LogInPage(),
//                           ))),
//                   child: Text(
//                     'لغو',
//                     style: TextStyle(color: Colors.red.shade800),
//                   ))
//             ],
//           ),
//         ),
//       );
// }

// import 'dart:async';
// import 'package:asan_yab/presentation/pages/personal_information_page.dart';
// import 'package:asan_yab/presentation/pages/sign_in_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class VerifyEmailPage extends ConsumerStatefulWidget {
//   final String? email;
//   const VerifyEmailPage({
//      this.email,
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
//   @override
//   void initState() {
//     super.initState();
//     isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     if (!isEmailVerified) {
//       sendVerificationEmail();
//       timer = Timer.periodic(
//         Duration(seconds: 3),
//         (_) => checkEmailVerified()
//       );
//     }
//   }
//
//   Future sendVerificationEmail() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       await user.sendEmailVerification();
//       setState(() => canResendEmail = false);
//       await Future.delayed(Duration(seconds: 3));
//       setState(() => canResendEmail = true);
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future checkEmailVerified() async {
//     await FirebaseAuth.instance.currentUser!.reload();
//     setState(() {
//       isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     });
//     if (isEmailVerified) {
//       timer?.cancel();
//
//
//     }
//
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     timer?.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) =>
//       isEmailVerified
//       ?PersonalInformation(email: widget.email)
//       :
//   Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.red.shade900,
//             title: const Text('تایید ایمیل'),
//             centerTitle: true,
//           ),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                     'یک لینک تاییدیه به ایمیل شما فرستاده شد!\n لطفا برای تایید ایمیل خود روی آن کلیک کنید'),
//                 Text('${widget.email}'),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.shade800,
//                         minimumSize: const Size(340, 55),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12))),
//                     onPressed: canResendEmail ? sendVerificationEmail : null,
//                     icon: const Icon(Icons.mail),
//                     label: const Text('ارسال دوباره')),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 TextButton(
//                     onPressed: () => FirebaseAuth.instance
//                         .signOut()
//                         .whenComplete(() => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => LogInPage(),
//                             ))),
//                     child: Text(
//                       'لغو',
//                       style: TextStyle(color: Colors.red.shade800),
//                     ))
//               ],
//             ),
//           ),
//         );
// }

// younis important
import 'dart:async';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/presentation/pages/personal_information_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      state = VerifyEmailState(state.isEmailVerified, false);
      await Future.delayed(const Duration(seconds: 20));
      state = VerifyEmailState(state.isEmailVerified, true);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _checkEmailVerified() async {
    FirebaseAuth.instance.currentUser?.reload();
    if(FirebaseAuth.instance.currentUser !=null){
      final isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isEmailVerified) {
        _timer.cancel();
        state = VerifyEmailState(isEmailVerified, state.canResendEmail);
      }
    }

  }

  @override
  void dispose() {
    Future.delayed(
      Duration.zero,
      () {
        VerifyEmailState(false, false);
        _initialize();
      },
    );
    super.dispose();
  }
}


//my class
class VerifyEmailPage extends ConsumerStatefulWidget {
  final String? email;

  const VerifyEmailPage({
    this.email,
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
    return verifyEmailState.isEmailVerified
        ?  PersonalInformation(
      email: widget.email,
    )
        : PopScope(
      canPop: false,
          child: Scaffold(
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
                    Text('${widget.email}'),
                    const SizedBox(
                      height: 10,
                    ),
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
                          style:
                              const TextStyle(fontSize: 16, color: Colors.white),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
        );
  }
}
//
// import 'dart:async';
// import 'package:asan_yab/data/models/language.dart';
// import 'package:asan_yab/presentation/pages/personal_information_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import '../../data/repositoris/language_repository.dart';
//
// class VerifyEmailState extends ChangeNotifier {
//   bool isEmailVerified = false;
//   bool canResendEmail = false;
//   late Timer _timer;
//
//   VerifyEmailState() {
//     _initialize();
//   }
//
//   Future<void> _initialize() async {
//     final isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     if (!isEmailVerified) {
//       await _sendVerificationEmail();
//       _timer = Timer.periodic(
//           const Duration(seconds: 3), (_) => _checkEmailVerified());
//     }
//   }
//
//   Future<void> _sendVerificationEmail() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       await user.sendEmailVerification();
//       canResendEmail = false;
//       notifyListeners();
//       await Future.delayed(const Duration(seconds: 20));
//       canResendEmail = true;
//       notifyListeners();
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<void> _checkEmailVerified() async {
//     FirebaseAuth.instance.currentUser?.reload();
//     if (FirebaseAuth.instance.currentUser != null) {
//       var isEmailVerifieded = FirebaseAuth.instance.currentUser!.emailVerified;
//       if (isEmailVerifieded) {
//         _timer.cancel();
//         isEmailVerified = true;
//         notifyListeners();
//       }
//     }
//
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
// }
//
// final verifyEmailProvider = ChangeNotifierProvider<VerifyEmailState>((ref) {
//   return VerifyEmailState();
// });
//
// class VerifyEmailPage extends ConsumerWidget {
//   final String? email;
//
//   const VerifyEmailPage({
//     this.email,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final languageText = AppLocalizations.of(context);
//     final isRTL = ref.watch(languageProvider).code == 'fa';
//     final verifyEmailState = ref.watch(verifyEmailProvider);
//     return verifyEmailState.isEmailVerified
//         ? PersonalInformation(email: email)
//         : PopScope(
//       canPop: false,
//           child: Scaffold(
//               appBar: AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: Colors.red.shade900,
//                 title: Text(languageText!.verify_appBar_title),
//                 centerTitle: true,
//               ),
//               body: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: isRTL
//                           ? const EdgeInsets.only(right: 28.0)
//                           : const EdgeInsets.only(left: 28.0),
//                       child: Text(languageText.verify_body_text),
//                     ),
//                     Text('$email'),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red.shade800,
//                             minimumSize: const Size(340, 55),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12))),
//                         onPressed: verifyEmailState.canResendEmail
//                             ? () => verifyEmailState._sendVerificationEmail()
//                             : null,
//                         icon: const Icon(Icons.mail),
//                         label: Text(languageText.verify_elb_text)),
//                   ],
//                 ),
//               ),
//             ),
//         );
//   }
// }
