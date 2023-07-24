import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  late Function() onClicked;
  late String titleName;
  late Color textColor1;
  late Color btnColor;
  final double? elevation;
  bool? border;
  ButtonWidget(
      {super.key,
      required this.onClicked,
      required this.titleName,
      required this.textColor1,
      required this.btnColor,
      this.elevation = 1,
      this.border = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onClicked,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: border!
              ? const BorderSide(width: 0.5, color: Colors.black)
              : null,
        ),
        child: Text(
          titleName,
          style: TextStyle(color: textColor1, fontSize: 18),
        ),
      ),
    );
  }
}
