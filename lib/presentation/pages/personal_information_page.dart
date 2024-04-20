import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/riverpod/data/sign_up.dart';
import 'package:asan_yab/domain/riverpod/screen/botton_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/routes.dart';
import '../widgets/custom_text_field_widget.dart';

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
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = texts(context);
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
                  SizedBox(height: 2.h),
                  CustomTextFieldWidget(
                    textCapitalization: TextCapitalization.words,
                    label: text.first_text_field_label,
                    label2: '*',
                    controller: nameController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: text.first_text_field_hint,
                    validator: (value) =>
                        value!.isEmpty ? text.first_text_field_valid : null,
                  ),
                  CustomTextFieldWidget(
                    textCapitalization: TextCapitalization.words,
                    label: text.second_text_field_label,
                    label2: '*',
                    controller: lastNameController,
                    hintText: text.second_text_field_hint,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value!.isEmpty ? text.second_text_field_valid : null,
                  ),
                  CustomTextFieldWidget(
                    textCapitalization: TextCapitalization.words,
                    label: text.inviter_ID,
                    controller: invitingPersonId,
                    hintText: text.third_text_field_hint,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade800,
                        minimumSize: const Size(340, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      final isValid = signUpFormKey.currentState!.validate();
                      if (!isValid) return;
                      ref
                          .read(createUserProvider)
                          .addUserDetailsToFirebase(
                              emailController: widget.email,
                              lastNameController: lastNameController.text,
                              nameController: nameController.text)
                          .whenComplete(() async {
                        await ref
                            .read(createUserProvider)
                            .updateInviterRate(invitingPersonId.text);
                        signUpFormKey.currentState!.reset();
                        if (context.mounted) {
                          context.pushNamed(Routes.home);
                        }
                        ref
                            .read(stateButtonNavigationBarProvider.notifier)
                            .selectedIndex(0);
                      });
                    },
                    child: Text(
                      text.elevated_text,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
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
