import 'package:asan_yab/core/extensions/language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/firebase_collection_names.dart';
import '../../data/repositoris/firebase_suggestion_create.dart';
import '../../data/repositoris/language_repo.dart';
import '../../domain/riverpod/screen/suggestion_page_provider.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_card_widget.dart';
import '../widgets/custom_dialog_widget.dart';
import '../widgets/text_form_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      ref.read(isLoading.notifier).state = true;
      final snapshot = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.description)
          .doc('add_new_place')
          .get();

      if (snapshot.exists) {
        final isRTL = ref.watch(languageProvider).code == 'fa';
        if (!isRTL) {
          ref.read(noteProvider.notifier).state = snapshot.data()?['eNote'];
        } else {
          ref.read(noteProvider.notifier).state = snapshot.data()?['pNote'];
        }

        ref.read(isLoading.notifier).state = false;
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
    final languageText = AppLocalizations.of(context);
    return ref.watch(isLoading)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                  key: formeKey,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        TextFormFieldWidget(
                          addController: nameController,
                          labelName: languageText.suggestion_1_tf_labelName,
                          validator: (value) => value != null && value.isEmpty
                              ? languageText.suggestion_1_tf_valid
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormFieldWidget(
                          addController: addressController,
                          labelName: languageText.suggestion_2_tf_labelName,
                          validator: (value) => value != null && value.isEmpty
                              ? languageText.suggestion_2_tf_valid
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormFieldWidget(
                          line: 2,
                          addController: typeController,
                          labelName: languageText.suggestion_3_tf_labelName,
                          validator: (value) => value != null && value.isEmpty
                              ? languageText.suggestion_3_tf_valid
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormFieldWidget(
                          addController: phoneController,
                          labelName: languageText.suggestion_4_tf_labelName,
                          validator: (value) => value != null && value.isEmpty
                              ? languageText.suggestion_4_tf_valid
                              : null,
                        ),
                        const SizedBox(height: 20),
                        CustomCardWidget(
                          title: languageText.suggestion_custom_card_title,
                          child: Text(ref.watch(noteProvider)),
                        ),
                        const SizedBox(height: 10),
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
