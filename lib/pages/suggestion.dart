import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../database/firebase_helper/firebase_modle_helper.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_form_field_widget.dart';




class SuggestionPage extends StatelessWidget {

   SuggestionPage({super.key});


  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final phoneController = TextEditingController();

  final typeController = TextEditingController();

void controllerClear(){
  nameController.clear();
  addressController.clear();
  phoneController.clear();
  typeController.clear();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معرفی مکان جدید'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Form(
          // key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              TextFieldWidget(addController: nameController, labelName: 'نام مکان '),
              const SizedBox(height: 10),
              TextFieldWidget(addController: addressController, labelName: 'ادرس مکان '),
              const SizedBox(height: 10),
              TextFieldWidget(addController: phoneController, labelName: ' شماره های تماس'),
              const SizedBox(height: 10),
              TextFieldWidget(addController: typeController, labelName: 'چه نو تجارتی دارید؟ '),
              const SizedBox(height: 10),
              ButtonWidget(onClicked: () {
                          FirebaseSuggestionCreate create = FirebaseSuggestionCreate() ;
                          create.createSuggestion(nameController.text, addressController.text, phoneController.text, typeController.text).whenComplete(() => showDialog(context: context, builder: (context) => const CustomDialog(),));
                          controllerClear();
              }, titleName: 'ارسال درخواست', textColor1: Colors.white, btnColor: secondaryColor,),
            ],
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

          child: const Text('بازگشت به صفحه قبلی ',style: TextStyle(color :Colors.blueAccent,)),
          onPressed: () {

            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}

