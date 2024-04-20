// ignore_for_file: use_build_context_synchronously

import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/data/repositoris/theme_Provider.dart';
import 'package:asan_yab/core/utils/custom_progress_indicator_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/firebase_collection_names.dart';
import '../../../core/extensions/language.dart';
import '../../../core/routes/routes.dart';
import '../../../core/utils/translation_util.dart';
import '../../../data/repositoris/language_repo.dart';
import '../../../domain/riverpod/data/profile_data.dart';
import '../../widgets/language/language_bottom_sheet.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        ref.read(profileDataProvider.notifier).getCurrentUserData();
        ref.read(imageNotifierProvider).imageUrl ==
            ref.read(profileDataProvider)?.imageUrl;
      },
    );
  }

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();

  final userName = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final usersData = ref.watch(profileDataProvider);
    final themeModel = ref.watch(themeModelProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final text = texts(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 280.h,
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Center(
                      child: Text(
                        '${usersData?.name}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 118.0, right: 116, left: 116),
                  child: InkWell(
                    onTap: () => usersData?.imageUrl == ''
                        ? const SizedBox()
                        : context.pushNamed(Routes.showProfile,
                            pathParameters: {
                                'imageUrl':
                                    '${ref.watch(profileDataProvider)?.imageUrl}'
                              }),
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
                                padding: isRTL
                                    ? const EdgeInsets.only(
                                        top: 40.0, right: 50)
                                    : const EdgeInsets.only(
                                        top: 40.0, left: 55),
                                child: CustomProgressIndicatorWidget
                                    .progressIndicator(ref: ref),
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
                                    onPressed: () =>
                                        CustomProgressIndicatorWidget
                                            .showBottomSheets(
                                                ref: ref, context: context),
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
                        : ref.watch(profileDataProvider)?.imageUrl == ''
                            ? const SizedBox()
                            : Hero(
                                tag: 'avatarHeroTag',
                                child: CircleAvatar(
                                  maxRadius: 80,
                                  backgroundImage: NetworkImage(
                                    '${ref.watch(profileDataProvider)?.imageUrl}',
                                  ),
                                ),
                              ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, right: 10, left: 10),
                  child: IconButton(
                    onPressed: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        await FirebaseFirestore.instance
                            .collection(FirebaseCollectionNames.user)
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'isOnline': false, 'fcmToken': "token"});

                        await signOut();
                        context.pushReplacementNamed(Routes.home);
                      }
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: () {
                    ref.read(listOfDataProvider.notifier).state.clear();
                    ref
                        .read(listOfDataFollowersProvider.notifier)
                        .state
                        .clear();
                    ref
                        .read(followingDataProvider.notifier)
                        .getProfile(FirebaseAuth.instance.currentUser!.uid);

                    context.pushNamed(Routes.listOfFollow);
                  },
                  title: Text(text.profile_followers),
                  leading: const Icon(
                    color: Colors.red,
                    Icons.person_2_outlined,
                    size: 30,
                  ),
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: Text(
                      '${isRTL ? convertDigitsToFarsi('${usersData?.id}') : usersData?.id}'),
                  leading: const Icon(
                    color: Colors.red,
                    Icons.account_circle,
                    size: 30,
                  ),
                  onTap: () {
                    ref
                        .read(profileDataProvider.notifier)
                        .copyToClipboard('${usersData?.id}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(text.profile_copy_id_snack_bar),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: Text('${usersData?.name} ${usersData?.lastName}'),
                  leading: const Icon(
                    color: Colors.red,
                    Icons.person_2_outlined,
                    size: 30,
                  ),
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: Text('${usersData?.email}'),
                  leading: const Icon(
                    color: Colors.red,
                    Icons.mail_outline,
                    size: 30,
                  ),
                ),
                const Divider(color: Colors.grey),
                const LanguageBottomSheet(),
                // LanguageIcon(),
                const Divider(color: Colors.grey),
                ListTile(
                  title: Text(text.profile_dark_mode),
                  leading: const Icon(
                    color: Colors.red,
                    Icons.dark_mode_outlined,
                    size: 30,
                  ),
                  trailing: Switch(
                    value: themeModel.currentThemeMode == ThemeMode.dark,
                    onChanged: (value) {
                      final newThemeMode =
                          value ? ThemeMode.dark : ThemeMode.light;
                      ref.read(themeModelProvider).setThemeMode(newThemeMode);
                    },
                  ),
                ),
                const Divider(color: Colors.grey),
                InkWell(
                  onTap: () => context.pushNamed(Routes.aboutUs),
                  child: ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.red,
                      size: 30,
                    ),
                    title: Text(text.profile_about_us_listTile),
                  ),
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  title: Text(
                      '${text.profile_rate_score} ${isRTL ? convertDigitsToFarsi('${usersData?.invitationRate}') : usersData?.invitationRate}'),
                  leading: const Icon(
                    color: Colors.red,
                    Icons.star_rate_outlined,
                    size: 30,
                  ),
                ),
                const Divider(color: Colors.grey),
                SizedBox(height: 5.h),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              minimumSize: const Size(260, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            onPressed: () {
              context.pushNamed(Routes.editProfile).then((_) =>
                  ref.read(profileDataProvider.notifier).getCurrentUserData());
            },
            child: Text(
              text.profile_edit_button_text,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }
}
