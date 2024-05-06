// ignore_for_file: avoid_print

import 'package:asan_yab/core/utils/utils.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/edit_profile_page_provider.dart';
import 'package:asan_yab/presentation/pages/profile/show_profile_page.dart';
import 'package:asan_yab/presentation/widgets/buildProgress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositoris/language_repository.dart';
import '../../../domain/riverpod/data/profile_data_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        nameController.text = ref.read(userDetailsProvider)!.name;
        lastNameController.text = ref.read(userDetailsProvider)!.lastName;
        ref
            .read(editProfilePageProvider.notifier)
            .editData(nameController, lastNameController);
        ref.read(imageProvider.notifier).state.imageUrl;
        ref.read(imageProvider.notifier).state.imageUrl =
            ref.read(userDetailsProvider)?.imageUrl ?? '';
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
            if (nameController.text ==
                ref.read(userDetailsProvider)!.name &&
                lastNameController.text ==
                    ref.read(userDetailsProvider)!.lastName) {
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.red.shade300,
                    title: Text(languageText.edit_dialog,
                        style:
                        const TextStyle(color: Colors.white)),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            languageText.edit_dialog_do_not_save,
                            style: const TextStyle(
                                color: Colors.white),
                          )),
                      TextButton(
                          onPressed: () {
                            ref
                                .read(editProfilePageProvider
                                .notifier)
                                .editData(nameController,
                                lastNameController)
                                .whenComplete(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                              languageText.edit_appBar_leading,
                              style: const TextStyle(
                                  color: Colors.white))),
                    ],
                  );
                },
              );
            }
        }},
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 280,
              child: Stack(
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
                          if(Utils.netIsConnected(ref)){
                            if (nameController.text ==
                                ref.read(userDetailsProvider)!.name &&
                                lastNameController.text ==
                                    ref.read(userDetailsProvider)!.lastName) {
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.red.shade300,
                                    title: Text('${languageText?.edit_dialog}',
                                        style:
                                        const TextStyle(color: Colors.white)),
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
                                            ref
                                                .read(editProfilePageProvider
                                                .notifier)
                                                .editData(nameController,
                                                lastNameController)
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
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
                          }else{
                            Navigator.pop(context);
                          }
                        },
                      )),
                  Positioned(
                    top: 40,
                    left: isRTL?4:null,
                    right: isRTL?null:4,
                    child: TextButton(
                      child: Text(
                        languageText!.edit_appBar_leading,
                        style: const TextStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        if(Utils.netIsConnected(ref)){
                          ref
                              .read(editProfilePageProvider.notifier)
                              .editData(nameController, lastNameController)
                              .whenComplete(() => Navigator.pop(context));
                        }else{
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 118.0, left: 116, right: 116),
                    child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => usersData?.imageUrl == ''
                                  ? const SizedBox()
                                  : ShowProfilePage(
                                      imagUrl:
                                          '${ref.watch(userDetailsProvider)?.imageUrl}',
                                      isEditing: true),
                            )),
                        child: Stack(
                          children: [
                            Hero(
                                tag: 'avatarHeroTag',
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(80)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${ref.watch(userDetailsProvider)?.imageUrl}',
                                    placeholder: (context, url) =>
                                        Image.asset('assets/Avatar.png'),
                                    errorListener: (value) =>
                                        Image.asset('assets/Avatar.png'),
                                  ),
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
                                    if(Utils.netIsConnected(ref)){
                                      ImageWidgets.showBottomSheets(
                                          context: context, ref: ref);
                                    }else{
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
              ),
            ),
            Column(
              children: [
                TextField(
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(25),
                  ],
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: languageText.edit_1_txf_label,
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(25),
                  ],
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: languageText.edit_2_txf_label,
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
