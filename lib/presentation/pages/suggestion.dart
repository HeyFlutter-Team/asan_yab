import 'package:flutter/material.dart';
import '../../data/repositoris/firebase_modle_helper.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_form_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final languageText=AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          languageText!.suggestion_appBar_title,
        ),
        elevation: 0,
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
                    labelName: languageText.suggestion_1_tf_labelName,
                    validator: (value) => value != null && value.isEmpty
                        ? languageText.suggestion_1_tf_valid
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    addController: addressController,
                    labelName: languageText.suggestion_2_tf_labelName,
                    validator: (value) => value != null && value.isEmpty
                        ? languageText.suggestion_2_tf_valid
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    line: 2,
                    addController: typeController,
                    labelName: languageText.suggestion_3_tf_labelName,
                    validator: (value) => value != null && value.isEmpty
                        ? languageText.suggestion_3_tf_valid
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    addController: phoneController,
                    labelName: languageText.suggestion_4_tf_labelName,
                    validator: (value) => value != null && value.isEmpty
                        ? languageText.suggestion_4_tf_valid
                        : null,
                  ),
                  const SizedBox(height: 20),
                  CustomCard(
                    title: languageText.suggestion_custom_card_title,
                    child: Text(
                      languageText.suggestion_custom_card_text,
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
                    titleName: languageText.suggestion_button,
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
    final languageText=AppLocalizations.of(context);
    return AlertDialog(
      title: Text(languageText!.suggestion_customDialog_title),
      content: Text(languageText.suggestion_customDialog_content),
      actions: <Widget>[
        TextButton(
          child: Text(languageText.suggestion_customDialog_textButton,
              style: const TextStyle(
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
