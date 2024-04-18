import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/constants/firebase_collection_names.dart';
import '../../data/repositoris/firebase_suggestion_create.dart';
import '../../data/repositoris/language_repo.dart';
import '../../domain/riverpod/screen/suggestion_page_provider.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_card_widget.dart';
import '../widgets/custom_dialog_widget.dart';
import '../widgets/text_form_field_widget.dart';

class SuggestionPage extends ConsumerStatefulWidget {
  const SuggestionPage({super.key});

  @override
  ConsumerState<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends ConsumerState<SuggestionPage> {
  final formeKey = GlobalKey<FormState>();

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(isloadingProvider.notifier).loadingTrue();
      final snapshot = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.description)
          .doc('add_new_place')
          .get();

      if (snapshot.exists) {
        final isRTL = ref.watch(languageProvider).code == 'fa';
        if (!isRTL) {
          ref
              .read(suggestionTextProvider.notifier)
              .updateSuggestion(snapshot.data()?['eNote']);
        } else {
          ref
              .read(suggestionTextProvider.notifier)
              .updateSuggestion(snapshot.data()?['pNote']);
        }

        ref.read(isloadingProvider.notifier).loadingFalse();
      }
    });
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
    final text = texts(context);
    final suggestionText = ref.watch(suggestionTextProvider);
    return ref.watch(isloadingProvider)
        ? Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.redAccent, size: 60),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(text.suggestion_appBar_title),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Form(
                  key: formeKey,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.h),
                        TextFormFieldWidget(
                          addController: nameController,
                          labelName: text.suggestion_1_tf_labelName,
                          validator: (value) => value != null && value.isEmpty
                              ? text.suggestion_1_tf_valid
                              : null,
                        ),
                        SizedBox(height: 10.h),
                        TextFormFieldWidget(
                          addController: addressController,
                          labelName: text.suggestion_2_tf_labelName,
                          validator: (value) => value != null && value.isEmpty
                              ? text.suggestion_2_tf_valid
                              : null,
                        ),
                        SizedBox(height: 10.h),
                        TextFormFieldWidget(
                          line: 2,
                          addController: typeController,
                          labelName: text.suggestion_3_tf_labelName,
                          validator: (value) => value != null && value.isEmpty
                              ? text.suggestion_3_tf_valid
                              : null,
                        ),
                        SizedBox(height: 10.h),
                        TextFormFieldWidget(
                          addController: phoneController,
                          labelName: text.suggestion_4_tf_labelName,
                          validator: (value) => value != null && value.isEmpty
                              ? text.suggestion_4_tf_valid
                              : null,
                        ),
                        SizedBox(height: 20.h),
                        CustomCardWidget(
                          title: text.suggestion_custom_card_title,
                          child: Text(suggestionText),
                        ),
                        SizedBox(height: 10.h),
                        ButtonWidget(
                          onClicked: () => suggestionCreation(
                            formeKey,
                            nameController,
                            addressController,
                            phoneController,
                            typeController,
                            context,
                            controllerClear,
                          ),
                          titleName: text.suggestion_button,
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

  void suggestionCreation(
    GlobalKey<FormState> formKey,
    TextEditingController nameController,
    TextEditingController addressController,
    TextEditingController phoneController,
    TextEditingController typeController,
    BuildContext context,
    Function controllerClear,
  ) {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      const create = FirebaseSuggestionCreate();
      create
          .createSuggestion(
            nameController.text,
            addressController.text,
            phoneController.text,
            typeController.text,
          )
          .whenComplete(
            () => showDialog(
              context: context,
              builder: (context) => const CustomDialogWidget(),
            ),
          );
      controllerClear();
    }
  }
}
