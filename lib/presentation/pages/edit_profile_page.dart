// ignore_for_file: avoid_print

import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/edit_profile_page_provider.dart';
import 'package:asan_yab/presentation/pages/show_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/profile_data_provider.dart';

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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersData = ref.watch(userDetailsProvider);
    final isRTL = ref.watch(languageProvider).code=='fa';
    final languageText=AppLocalizations.of(context);
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
                    gradient:isRTL?
                  LinearGradient(colors: [
                  Colors.white,
                      Colors.red.shade900,
                      ])
                    :LinearGradient(colors: [
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
                  padding: isRTL?const EdgeInsets.only(top: 40.0, right: 334):const EdgeInsets.only(top: 40.0, left: 334),
                  child: TextButton(
                    child: Text(
                      languageText!.edit_appBar_leading,
                      style:const TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      ref
                          .read(editProfilePageProvider.notifier)
                          .editData(nameController, lastNameController);

                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 118.0, left: 116,right: 116),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowProfilePage(
                              imagUrl:
                                  '${ref.watch(userDetailsProvider)?.imageUrl}'),
                        )),
                    child: usersData?.imageUrl == ''
                        ? Stack(
                            children: [
                              const Hero(
                                tag: 'avatarHeroTag',
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: AssetImage(
                                      'assets/Avatar.png'), // Your image URL
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40.0, right: 50),
                                child: buildProgress(),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showBottomSheets(context);
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
                          )
                        : Stack(
                            children: [
                              Hero(
                                tag: 'avatarHeroTag',
                                child: CircleAvatar(
                                  maxRadius: 80,
                                  backgroundImage: NetworkImage(
                                    '${ref.watch(userDetailsProvider)?.imageUrl}',
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40.0, right: 50),
                                child: buildProgress(),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showBottomSheets(context);
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
                          ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              TextField(
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
    );
  }

  Widget buildProgress() {
    return StreamBuilder<TaskSnapshot>(
      stream: ref.watch(imageProvider).uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          if (data.state == TaskState.success) {
            // If upload is complete, return an empty Container
            return Container();
          }

          return SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.red,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void showBottomSheets(BuildContext context) {
    final languageText=AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Handle Camera option
                  ref
                      .read(imageProvider.notifier)
                      .pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.camera),
                    const SizedBox(height: 8.0),
                    Text(languageText!
                        .profile_buttonSheet_camera),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // Handle Gallery option
                  ref
                      .read(imageProvider.notifier)
                      .pickImage(ImageSource.gallery);
                  Navigator.pop(
                      context); // Call a function to handle Gallery action
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.image),
                    const SizedBox(height: 8.0),
                    Text(languageText
                        .profile_buttonSheet_gallery),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
