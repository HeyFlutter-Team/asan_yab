import 'package:asan_yab/presentation/widgets/update_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateDialogWidget extends ConsumerStatefulWidget {
  final String version;
  final String description;
  final String appLink;
  final bool allowDismissal;

  const UpdateDialogWidget({
    Key? key,
    this.version = " ",
    required this.description,
    required this.appLink,
    required this.allowDismissal,
  }) : super(key: key);

  @override
  ConsumerState<UpdateDialogWidget> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends ConsumerState<UpdateDialogWidget> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: UpdateContentWidget(
          ref: ref,
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          widget: widget,
          context: context,
        ),
      ),
    );
  }
}
