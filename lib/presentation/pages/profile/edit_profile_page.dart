// ignore_for_file: avoid_print
import 'package:asan_yab/core/utils/utils.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/edit_profile_page_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositoris/language_repository.dart';
import '../../../domain/riverpod/data/profile_data_provider.dart';
import '../../../domain/riverpod/data/sign_up_provider.dart';
import '../../widgets/profile/edit_profile_widget.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final personalIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        nameController.text = ref.read(userDetailsProvider)!.name;
        lastNameController.text = ref.read(userDetailsProvider)!.lastName;
        personalIdController.text = ref.read(userDetailsProvider)!.id;
        ref
            .read(editProfilePageProvider.notifier)
            .editData(nameController, lastNameController, personalIdController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersData = ref.watch(userDetailsProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final languageText = AppLocalizations.of(context);
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 10) {
          if (Utils.netIsConnected(ref)) {
            if (nameController.text == usersData!.name &&
                lastNameController.text ==
                    usersData.lastName &&
                personalIdController.text ==
                    usersData.id) {
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.red.shade300,
                    title: Text('${languageText?.edit_dialog}',
                        style: const TextStyle(color: Colors.white)),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            '${languageText?.edit_dialog_do_not_save}',
                            style: const TextStyle(color: Colors.white),
                          )),
                      TextButton(
                          onPressed: () {
                            if (ref.watch(isContainIdProvider) ||
                                nameController.text.isEmpty ||
                                lastNameController.text.isEmpty ||
                                personalIdController.text.isEmpty) {
                              Navigator.pop(context);
                              final isValid = _formKey.currentState!.validate();
                              if (!isValid) return;
                            } else {
                              ref
                                  .read(editProfilePageProvider.notifier)
                                  .editData(nameController, lastNameController,
                                      personalIdController)
                                  .whenComplete(() {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text('${languageText?.edit_appBar_leading}',
                              style: const TextStyle(color: Colors.white))),
                    ],
                  );
                },
              );
            }
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 280,
              child: EditProfileWidget(
                  isRTL: isRTL,
                  ref: ref,
                  nameController: nameController,
                  lastNameController: lastNameController,
                  personalIdController: personalIdController,
                  languageText: languageText,
                  formKey: _formKey,
                  usersData: usersData),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    controller: nameController,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return languageText?.edit_name_is_empty;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: languageText?.edit_1_txf_label,
                      prefixIcon: const Icon(
                        Icons.person_2_outlined,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    onChanged: (value) {
                      final isValid = _formKey.currentState!.validate();
                      if (value.isEmpty) {
                        if (!isValid) return;
                      } else {
                        if (isValid) return;
                      }
                    },
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    controller: lastNameController,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return '${languageText?.edit_last_name_is_empty}';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: '${languageText?.edit_2_txf_label}',
                      prefixIcon: const Icon(
                        Icons.person_pin_outlined,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    onChanged: (value) {
                      final isValid = _formKey.currentState!.validate();
                      if (value.isEmpty) {
                        if (!isValid) return;
                      } else {
                        if (isValid) return;
                      }
                    },
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    controller: personalIdController,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return languageText?.edit_id_is_empty;
                      } else if (p0.isNotEmpty &&
                          usersData?.id !=
                              personalIdController.text &&
                          ref.watch(isContainIdProvider)) {
                        return languageText?.edit_id_validation_is_empty;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: languageText?.edit_3_txf_label,
                      prefixIcon: const Icon(
                        Icons.account_circle,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    onChanged: (value) {
                      ref
                          .read(userRegisterDetailsProvider)
                          .updateIsContainId(personalIdController.text, ref)
                          .whenComplete(() {
                        if (value != usersData?.id) {
                          final isValid = _formKey.currentState!.validate();
                          if (!isValid) return;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
