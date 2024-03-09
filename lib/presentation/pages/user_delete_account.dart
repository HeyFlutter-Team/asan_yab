// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:asan_yab/presentation/widgets/custom_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/delete_account_riv.dart';
import '../../domain/riverpod/data/profile_data_provider.dart';
import '../../domain/riverpod/data/sign_in_provider.dart';

class UserDeleteAccount extends ConsumerStatefulWidget {
  final String uid;
  final String imageUrl;
  const UserDeleteAccount({Key? key, required this.uid,required this.imageUrl}) : super(key: key);

  @override
  ConsumerState<UserDeleteAccount> createState() => _UserDeleteAccountState();
}

class _UserDeleteAccountState extends ConsumerState<UserDeleteAccount>
    with SingleTickerProviderStateMixin {
  final emailCTRL = TextEditingController();
  final passwordCTRL = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deleteIsLoading.notifier).state=false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailCTRL.dispose();
    passwordCTRL.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = ref.watch(loadingProvider);
    final languageText = AppLocalizations.of(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment:isRTL?MainAxisAlignment.end: MainAxisAlignment.start,
            crossAxisAlignment:isRTL? CrossAxisAlignment.end:CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 190,
                  child: Image.asset('assets/delete_account45-.png',)),
              Column(
                children: [
                  CustomTextField(
                    label: languageText!.sign_in_email,
                    controller: emailCTRL,
                    hintText: languageText.sign_in_email_hintText,
                    keyboardType: TextInputType.emailAddress,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return languageText.sign_in_email_1_valid;
                      } else if (p0.length < 10 && !EmailValidator.validate(p0)) {
                        return languageText.sign_in_email_2_valid;
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(p0)) {
                        return languageText.sign_in_email_3_valid;
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                      label: languageText.sign_in_password,
                      controller: passwordCTRL,
                      hintText: languageText.sign_in_password_hintText,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: ref.watch(isObscureProvider),
                      suffixIcon: IconButton(
                          onPressed: () =>
                              ref.read(isObscureProvider.notifier).isObscure(),
                          icon: const Icon(Icons.remove_red_eye_outlined)),
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return languageText.sign_in_password_1_valid;
                        } else if (p0.length < 6) {
                          return languageText.sign_in_password_2_valid;
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer(
                    builder: (context, sref, child) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade800,
                          minimumSize: const Size(340, 55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () async {
                        final isValid = formKey.currentState!.validate();
                        if (!isValid) return;
                        final deleteIsLoadings = ref.read(deleteIsLoading.notifier);
                        final deleteProfiles = ref.read(deleteProfile.notifier);
                        final deleteAccountProviders = ref.read(deleteAccountProvider.notifier);

                        deleteIsLoadings.state = true;

                        try {
                          await deleteAccountProviders.deleteFavorites(widget.uid);
                          await deleteProfiles.deleteImageAndClearUrl(widget.imageUrl);
                          await deleteAccountProviders.deleteRating(widget.uid);
                          await deleteAccountProviders.deleteUserComments(widget.uid);
                          await deleteAccountProviders.deleteUserDocument(widget.uid);
                          await deleteAccountProviders.deleteAccount(emailCTRL.text, passwordCTRL.text);
                          await deleteAccountProviders.deleteChatCollection(widget.uid);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),
                          );
                        } catch (error) {
                          print('Error: $error');
                        } finally {
                          deleteIsLoadings.state = false;
                        }
                      },

                      // onPressed: () async {
                      //   final isValid = formKey.currentState!.validate();
                      //   if (!isValid) return;
                      //   ref.read(deleteIsLoading.notifier).state=true;
                      //  await FirebaseFirestore.instance.collection('Favorite').doc(widget.uid).delete();
                      //  await ref.read(deleteProfile.notifier).deleteImageAndClearUrl(widget.imageUrl);
                      //  await FirebaseFirestore.instance
                      //      .collection('ratings')
                      //      .where('userId', isEqualTo: widget.uid)
                      //      .get()
                      //      .then((querySnapshot) {
                      //    for (var doc in querySnapshot.docs) {
                      //      doc.reference.delete();
                      //    }
                      //  }).whenComplete(()async{
                      //    await ref
                      //        .read(deleteAccountProvider.notifier).deleteUserComments(widget.uid);
                      //    await ref
                      //        .read(deleteAccountProvider.notifier)
                      //        .deleteUserDocument(widget.uid)
                      //        .whenComplete(() async {
                      //      await ref
                      //          .read(deleteAccountProvider.notifier).deleteChatCollection(widget.uid);
                      //      await ref
                      //          .read(deleteAccountProvider.notifier)
                      //          .deleteAccount(emailCTRL.text, passwordCTRL.text);
                      //    }).whenComplete(() => Navigator.pushReplacement(
                      //        context,
                      //        MaterialPageRoute(
                      //          builder: (context) => const MainPage(),
                      //        )));
                      //  });
                      //   ref.read(deleteIsLoading.notifier).state=false;
                      // },
                      child: ref.watch(deleteIsLoading)==true?
                      const CircularProgressIndicator(color: Colors.white,)
                      :Text(languageText.user_delete_account,
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: loadingState
                        ? const CircularProgressIndicator(
                            color: Colors.red,
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
