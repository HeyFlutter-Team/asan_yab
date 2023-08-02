import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../database/firebase_helper/firebase_modle_helper.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          'درخواست مکان جدید',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  TextFieldWidget(
                      addController: nameController,
                      labelName: 'نام مکان ',
                      validator: (value) => value != null && value.isEmpty
                          ? 'مکان خود را وارد کنید؟'
                          : null),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                      addController: addressController,
                      labelName: 'ادرس مکان ',
                      validator: (value) => value != null && value.isEmpty
                          ? 'ادرس خود را وارد کنید؟'
                          : null),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                      addController: phoneController,
                      labelName: ' شماره های تماس',
                      validator: (value) => value != null && value.isEmpty
                          ? 'شماره خود را وارد کنید؟'
                          : null),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                      addController: typeController,
                      labelName: 'چه نوع تجارتی دارید؟ ',
                      validator: (value) => value != null && value.isEmpty
                          ? 'نوع تجارت خود را وارد کنید؟'
                          : null),
                  const SizedBox(height: 10),
                  ButtonWidget(
                    onClicked: () {
                      final isValid = _key.currentState!.validate();
                      if (!isValid) return;
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
                    },
                    titleName: 'ارسال درخواست',
                    textColor1: Colors.white,
                    btnColor: secondaryColor,
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
      title: const Text('ارسال درخواست مکان'),
      content: const Text('درخواست شما ثیت گردید'),
      actions: <Widget>[
        TextButton(
          child: const Text('بازگشت به صفحه قبلی ',
              style: TextStyle(
                color: Colors.blueAccent,
              )),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
