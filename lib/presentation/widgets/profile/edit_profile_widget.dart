import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/utils/utils.dart';
import '../../../data/models/users.dart';
import '../../../domain/riverpod/data/edit_profile_page_provider.dart';
import '../../../domain/riverpod/data/profile_data_provider.dart';
import '../../../domain/riverpod/data/sign_up_provider.dart';
import '../../pages/profile/show_profile_page.dart';
import '../buildProgress.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({
    super.key,
    required this.isRTL,
    required this.ref,
    required this.nameController,
    required this.lastNameController,
    required this.personalIdController,
    required this.languageText,
    required GlobalKey<FormState> formKey,
    required this.usersData,
  }) : _formKey = formKey;

  final bool isRTL;
  final WidgetRef ref;
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController personalIdController;
  final AppLocalizations? languageText;
  final GlobalKey<FormState> _formKey;
  final Users? usersData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: isRTL
                ? LinearGradient(colors: [
              Colors.white,
              Colors.red.shade900,
            ])
                : LinearGradient(colors: [
              Colors.red.shade900,
              Colors.white,
            ]),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(600, 100),
              bottomRight: Radius.elliptical(600, 100),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 4),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                if (Utils.netIsConnected(ref)) {
                  if (nameController.text ==
                      ref.read(userDetailsProvider)!.name &&
                      lastNameController.text ==
                          ref.read(userDetailsProvider)!.lastName &&
                      personalIdController.text ==
                          ref.read(userDetailsProvider)!.id) {
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.red.shade300,
                          title: Text('${languageText?.edit_dialog}',
                              style: const TextStyle(
                                  color: Colors.white)),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  '${languageText?.edit_dialog_do_not_save}',
                                  style: const TextStyle(
                                      color: Colors.white),
                                )),
                            TextButton(
                                onPressed: () {
                                  if (ref.watch(
                                      isContainIdProvider) ||
                                      nameController.text.isEmpty ||
                                      lastNameController
                                          .text.isEmpty ||
                                      personalIdController.text.isEmpty) {
                                    Navigator.pop(context);
                                    final isValid = _formKey
                                        .currentState!
                                        .validate();
                                    if (!isValid) return;
                                  } else {
                                    ref
                                        .read(editProfilePageProvider
                                        .notifier)
                                        .editData(
                                        nameController,
                                        lastNameController,
                                        personalIdController)
                                        .whenComplete(() {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: Text(
                                    '${languageText?.edit_appBar_leading}',
                                    style: const TextStyle(
                                        color: Colors.white))),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  Navigator.pop(context);
                }
              },
            )),
        Positioned(
          top: 40,
          left: isRTL ? 4 : null,
          right: isRTL ? null : 4,
          child: TextButton(
            child: Text(
              languageText!.edit_appBar_leading,
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              if (Utils.netIsConnected(ref)) {
                if (ref.watch(isContainIdProvider) ||
                    nameController.text.isEmpty ||
                    lastNameController.text.isEmpty ||
                    personalIdController.text.isEmpty) {
                  final isValid = _formKey.currentState!.validate();
                  if (!isValid) return;
                }
                ref
                    .read(editProfilePageProvider.notifier)
                    .editData(nameController, lastNameController,
                    personalIdController)
                    .whenComplete(() => Navigator.pop(context));
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 118.0, left: 116, right: 116),
          child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: (){
                if(ref.watch(userDetailsProvider)!.imageUrl.isNotEmpty &&
                    ref.watch(userDetailsProvider)?.imageUrl != '') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        usersData?.imageUrl == ''
                            ? const SizedBox()
                            : ShowProfilePage(
                            imagUrl:
                            '${ref
                                .watch(userDetailsProvider)
                                ?.imageUrl}',
                            isEditing: true),
                      ));
                }},
              child: Stack(
                children: [
                  Hero(
                      tag: 'avatarHeroTag',
                      child: ClipRRect(
                        borderRadius:  const BorderRadius.all(
                            Radius.circular(80)),
                        child:ref.watch(userDetailsProvider)!.imageUrl.isNotEmpty &&
                            ref.watch(userDetailsProvider)?.imageUrl != ''?
                        CachedNetworkImage(
                          imageUrl:
                          '${ref.watch(userDetailsProvider)?.imageUrl}',
                          placeholder: (context, url) =>
                              Image.asset('assets/Avatar.png'),
                          errorListener: (value) =>
                              Image.asset('assets/Avatar.png'),
                        )
                            :Image.asset('assets/Avatar.png'),
                      )),
                  Padding(
                    padding: isRTL
                        ? const EdgeInsets.only(top: 53.0, right: 55)
                        : const EdgeInsets.only(top: 53.0, left: 55),
                    child: ImageWidgets.buildProgress(ref: ref),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 15,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (Utils.netIsConnected(ref)) {
                            ImageWidgets.showBottomSheets(
                                context: context, ref: ref);
                          } else {
                            Utils.lostNetSnackBar(context);
                          }
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 32,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
