import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/repositoris/firebase_modle_helper.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_form_field_widget.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final _key = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final typeController = TextEditingController();

  void controllerClear() {
    nameController.clear();
    addressController.clear();
    phoneController.clear();
    typeController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    typeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title:  Text(
          'suggestion_appBar_title'.tr(),
          style:const TextStyle(color: Colors.black),
        ),
        elevation: 0,
        //backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  TextFieldWidget(
                    addController: nameController,
                    labelName: 'suggestion_1_tf_labelName'.tr(),
                    validator: (value) => value != null && value.isEmpty
                        ? 'suggestion_1_tf_valid'.tr()
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    addController: addressController,
                    labelName: 'suggestion_2_tf_labelName'.tr(),
                    validator: (value) => value != null && value.isEmpty
                        ? 'suggestion_2_tf_valid'.tr()
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    line: 2,
                    addController: typeController,
                    labelName: 'suggestion_3_tf_labelName'.tr(),
                    validator: (value) => value != null && value.isEmpty
                        ? 'suggestion_3_tf_valid'.tr()
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    addController: phoneController,
                    labelName: 'suggestion_4_tf_labelName'.tr(),
                    validator: (value) => value != null && value.isEmpty
                        ? 'suggestion_4_tf_valid'.tr()
                        : null,
                  ),
                  const SizedBox(height: 20),
                   CustomCard(
                    title: 'suggestion_custom_card_title'.tr(),
                    child: Text(
                      'suggestion_custom_card_text'.tr(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ButtonWidget(
                    onClicked: () {
                      final isValid = _key.currentState!.validate();

                      if (isValid) {
                        FirebaseSuggestionCreate create =
                            FirebaseSuggestionCreate();
                        create
                            .createSuggestion(
                                nameController.text,
                                addressController.text,
                                phoneController.text,
                                typeController.text)
                            .whenComplete(() => showDialog(
                                  context: context,
                                  builder: (context) => const CustomDialog(),
                                ));
                        controllerClear();
                      }
                    },
                    titleName: 'suggestion_button'.tr(),
                    textColor1: Colors.white,
                    btnColor: Colors.grey,
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

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('suggestion_customDialog_title'.tr()),
      content:  Text('suggestion_customDialog_content'.tr()),
      actions: <Widget>[
        TextButton(
          child: Text('suggestion_customDialog_textButton'.tr(),
              style:const TextStyle(
                color: Colors.blueAccent,
              )),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.title,
    this.description,
    this.child,
  });

  final String title;
  final String? description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          // color: Colors.black54,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
