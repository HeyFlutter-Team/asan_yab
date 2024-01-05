import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:asan_yab/presentation/pages/sign_up_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/riverpod/data/sign_up_provider.dart';
import '../../domain/riverpod/screen/botton_navigation_provider.dart';
import '../widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PersonalInformation extends ConsumerStatefulWidget {
  // final String? email;
  final Function()? onClickedSignIn;
  const PersonalInformation({super.key,this.onClickedSignIn});

  @override
  ConsumerState<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final languageText=AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Form(
          key: signUpFormKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/newGmail.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  CustomTextField(
                    textCapitalization: TextCapitalization.words,
                    label: languageText!.first_text_field_label,
                    controller: nameController,
                    hintText: languageText.first_text_field_hint,
                    validator: (p0) => p0!.isEmpty ? languageText.first_text_field_valid : null,
                  ),
                  CustomTextField(
                    textCapitalization: TextCapitalization.words,
                    label: languageText.second_text_field_label,
                    controller:lastNameController,
                    hintText: languageText.second_text_field_hint,
                    validator: (p0) => p0!.isEmpty ? languageText.second_text_field_valid : null,
                  ),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(
                        name: nameController.text,
                        lastName: lastNameController.text,
                      ),));
                      // ref.read(userRegesterDetailsProvider).userDetails(
                      //   emailController: widget.email!,
                      //   lastNameController:lastNameController.text,
                      //   nameController: nameController.text
                      // ).whenComplete(() {
                      //   ref.read(buttonNavigationProvider.notifier).selectedIndex(0);
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage(),));
                      // });
                    },
                    child:  Text(languageText.elevated_text),
                  ),
                  const SizedBox(height: 20,),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:languageText.sign_up_account_text,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: '  ${languageText.sign_up_account_text1}',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
