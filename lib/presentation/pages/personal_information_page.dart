
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/data/sign_up_provider.dart';
import '../widgets/custom_text_field.dart';

class PersonalInformation extends ConsumerStatefulWidget {
  final String? email;
  // final Function()? onClickedSignIn;
  const PersonalInformation({super.key, this.email});

  @override
  ConsumerState<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: signUpFormKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/gmail@.jpg',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomTextField(
                  textCapitalization: TextCapitalization.words,
                  label: 'اسم',
                  controller: nameController,
                  hintText: 'اسم خود را وارد کنید',
                  validator: (p0) => p0!.isEmpty ? 'اسم خالی است' : null,
                ),
                CustomTextField(
                  textCapitalization: TextCapitalization.words,
                  label: 'تخلص',
                  controller:lastNameController,
                  hintText: 'تخلص خود را وارد کنید',
                  validator: (p0) => p0!.isEmpty ? 'تخلص خالی است' : null,
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

                    ref.read(userDetailsProvider.notifier).userDetails(
                      emailController: widget.email!,
                      lastNameController:lastNameController.text,
                      nameController: nameController.text
                    ).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(),)));
                  },
                  child: const Text('ساخت'),
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
