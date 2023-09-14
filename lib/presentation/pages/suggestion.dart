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
                          ? 'مکان خود را وارد کنید!'
                          : null),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                      addController: addressController,
                      labelName: 'ادرس مکان ',
                      validator: (value) => value != null && value.isEmpty
                          ? 'ادرس خود را وارد کنید!'
                          : null),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                      addController: phoneController,
                      labelName: ' شماره های تماس',
                      validator: (value) => value != null && value.isEmpty
                          ? 'شماره خود را وارد کنید!'
                          : null),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                      line: 2,
                      addController: typeController,
                      labelName: 'توضیجات مکان ',
                      validator: (value) => value != null && value.isEmpty
                          ? 'توضیجات مکان را بنویسید'
                          : null),
                  const SizedBox(height: 10),
                  const CustomCard(
                    title: 'توضیحات',
                    child: Text(
                        'در بخش توضیحات, شما میتوانید در مورد مشکلات مکان های برنامه به ما اطلاع بدید ,\n اگر مکان جدیدی را میخواهید معرفی کنید مشخصات کامل ان را وارد نمایید....'),
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
                    titleName: 'ارسال درخواست',
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
      title: const Text('ارسال درخواست مکان'),
      content: const Text('درخواست شما ثیت گردید'),
      actions: <Widget>[
        TextButton(
          child: const Text('بازگشت به صفحه قبلی ',
              style: TextStyle(
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
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
                            Icons.library_books,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
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
      ),
    );
  }
}
