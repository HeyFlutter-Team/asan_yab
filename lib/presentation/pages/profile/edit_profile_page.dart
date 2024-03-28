// ignore_for_file: avoid_print

import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/domain/riverpod/data/edit_profile_page_provider.dart';
import 'package:asan_yab/presentation/pages/profile/show_profile_page.dart';
import 'package:asan_yab/core/utils/custom_progress_indicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/translation_util.dart';
import '../../../data/repositoris/language_repo.dart';
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
        nameController.text = ref.read(profileDetailsProvider)!.name;
        lastNameController.text = ref.read(profileDetailsProvider)!.lastName;
        ref
            .read(editProfilePageProvider.notifier)
            .editData(nameController, lastNameController);
        ref.read(imageProvider.notifier).state.imageUrl;
        ref.read(imageProvider.notifier).state.imageUrl =
            ref.read(profileDetailsProvider)?.imageUrl ?? '';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersData = ref.watch(profileDetailsProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final text = texts(context);
    return Scaffold(
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
                      onPressed: () => Navigator.pop(context),
                    )),
                Padding(
                  padding: isRTL
                      ? const EdgeInsets.only(top: 40.0, right: 334)
                      : const EdgeInsets.only(top: 40.0, left: 334),
                  child: TextButton(
                    child: Text(
                      text.edit_appBar_leading,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      ref
                          .read(editProfilePageProvider.notifier)
                          .editData(nameController, lastNameController)
                          .whenComplete(() => Navigator.pop(context));
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 118.0, left: 116, right: 116),
                  child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => usersData?.imageUrl == ''
                                ? const SizedBox()
                                : ShowProfilePage(
                                    imageUrl:
                                        '${ref.watch(profileDetailsProvider)?.imageUrl}'),
                          )),
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'avatarHeroTag',
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: usersData?.imageUrl == ''
                                  ? const AssetImage('assets/Avatar.png')
                                  : NetworkImage(
                                      '${ref.watch(profileDetailsProvider)?.imageUrl}',
                                    ) as ImageProvider<
                                      Object>, // Your image URL
                            ),
                          ),
                          Padding(
                            padding: isRTL
                                ? const EdgeInsets.only(top: 40.0, right: 50)
                                : const EdgeInsets.only(top: 40.0, left: 55),
                            child: CustomProgressIndicatorWidget
                                .progressIndicator(ref: ref),
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
                                onPressed: () => CustomProgressIndicatorWidget
                                    .showBottomSheets(
                                        context: context, ref: ref),
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
                controller: nameController,
                decoration: InputDecoration(
                  labelText: text.edit_1_txf_label,
                  prefixIcon: const Icon(
                    Icons.person_2_outlined,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: text.edit_2_txf_label,
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
    );
  }
}
