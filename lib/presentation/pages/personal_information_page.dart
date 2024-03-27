import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/riverpod/data/sign_up_provider.dart';
import '../../domain/riverpod/screen/botton_navigation_provider.dart';
import '../widgets/custom_text_field.dart';

final isLoadingInformation = StateProvider<bool>((ref) => false);

class PersonalInformation extends ConsumerStatefulWidget {
  final String? email;
  const PersonalInformation({super.key, this.email});

  @override
  ConsumerState<PersonalInformation> createState() =>
      _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final invitingPersonId = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(isLoadingInformation.notifier).state = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageText = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () async => false,
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
                    label2: '*',
                    controller: nameController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: languageText.first_text_field_hint,
                    validator: (p0) => p0!.isEmpty
                        ? languageText.first_text_field_valid
                        : null,
                  ),
                  CustomTextField(
                    textCapitalization: TextCapitalization.words,
                    label: languageText.second_text_field_label,
                    label2: '*',
                    controller: lastNameController,
                    hintText: languageText.second_text_field_hint,
                    keyboardType: TextInputType.emailAddress,
                    validator: (p0) => p0!.isEmpty
                        ? languageText.second_text_field_valid
                        : null,
                  ),
                  CustomTextField(
                    textCapitalization: TextCapitalization.words,
                    label: languageText.inviter_ID,
                    controller: invitingPersonId,
                    hintText: languageText.third_text_field_hint,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade800,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.9, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: ref.watch(isLoadingInformation)
                        ? null
                        : () {
                            final isValid =
                                signUpFormKey.currentState!.validate();
                            if (!isValid) return;
                            ref.read(isLoadingInformation.notifier).state =
                                true;
                            FocusScope.of(context).unfocus();
                            ref
                                .read(userRegesterDetailsProvider)
                                .addUserDetailsToFirebase(
                                  emailController: widget.email,
                                  lastNameController: lastNameController.text,
                                  nameController: nameController.text,
                                )
                                .whenComplete(() async {
                              await ref
                                  .read(userRegesterDetailsProvider)
                                  .updateInviterRate(invitingPersonId.text);
                              signUpFormKey.currentState!.reset();
                            }).whenComplete(() {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MainPage(),
                                      ))
                                  .whenComplete(() => ref
                                      .read(isLoadingInformation.notifier)
                                      .state = false);
                              ref
                                  .read(buttonNavigationProvider.notifier)
                                  .selectedIndex(0);
                            });
                          },
                    child: ref.watch(isLoadingInformation)
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            languageText.elevated_text,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white),
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
