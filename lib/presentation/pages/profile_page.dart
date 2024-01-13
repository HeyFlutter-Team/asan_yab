// ignore_for_file: use_build_context_synchronously

import 'package:asan_yab/presentation/pages/about_us_page.dart';
import 'package:asan_yab/presentation/pages/edit_profile_page.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:asan_yab/presentation/pages/show_profile_page.dart';
import 'package:asan_yab/presentation/pages/themeProvider.dart';
import 'package:asan_yab/presentation/widgets/buildProgress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/language.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/profile_data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/language/language_bottom_sheet.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        ref.read(userDetailsProvider.notifier).getCurrentUserData(context);
        ref.read(imageProvider).imageUrl ==
            ref.read(userDetailsProvider)?.imageUrl;
      },
    );
  }

  final userName = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final usersData = ref.watch(userDetailsProvider);
    final themeModel = ref.watch(themeModelProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final languageText = AppLocalizations.of(context);

    return Scaffold(
        body:  Column(
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
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 50.0),
                            child: Center(
                              child: Text(
                                '${usersData?.name} ${usersData?.lastName}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 28),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 118.0, right: 116, left: 116),
                          child: InkWell(
                            onTap: () => usersData?.imageUrl == ''
                                ? const SizedBox()
                                : Navigator.push(
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
                                        padding: const EdgeInsets.only(
                                            top: 40.0, right: 50),
                                        child: ImageWidgets.buildProgress(
                                            ref: ref),
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
                                              ImageWidgets.showBottomSheets(
                                                  ref: ref, context: context);
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
                                : ref.watch(userDetailsProvider)?.imageUrl == ''
                                    ? const SizedBox()
                                    : Hero(
                                        tag: 'avatarHeroTag',
                                        child: CircleAvatar(
                                          maxRadius: 80,
                                          backgroundImage: NetworkImage(
                                            '${ref.watch(userDetailsProvider)?.imageUrl}',
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, right: 10, left: 10),
                            child: IconButton(
                              onPressed: () async {
                                if(FirebaseAuth.instance.currentUser!=null) {
                                  await FirebaseAuth.instance.signOut()
                                      .whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()))
                                  );}
                              },
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text('${usersData?.id}'),
                          leading: const Icon(
                            color: Colors.red,
                            Icons.account_circle,
                            size: 30,
                          ),
                          onTap: () {
                            ref
                                .read(userDetailsProvider.notifier)
                                .copyToClipboard('${usersData?.id}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    languageText!.profile_copy_id_snack_bar),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        ListTile(
                          title:
                              Text('${usersData?.name} ${usersData?.lastName}'),
                          leading: const Icon(
                            color: Colors.red,
                            Icons.person_2_outlined,
                            size: 30,
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        ListTile(
                          title: Text('${usersData?.email}'),
                          leading: const Icon(
                            color: Colors.red,
                            Icons.mail_outline,
                            size: 30,
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const LanguageBottomSheet(),
                        // LanguageIcon(),
                        const Divider(
                          color: Colors.grey,
                        ),
                        ListTile(
                          title: Text(languageText!.profile_dark_mode),
                          leading: const Icon(
                            color: Colors.red,
                            Icons.dark_mode_outlined,
                            size: 30,
                          ),
                          trailing: Switch(
                            value:
                                themeModel.currentThemeMode == ThemeMode.dark,
                            onChanged: (value) {
                              final newThemeMode =
                                  value ? ThemeMode.dark : ThemeMode.light;
                              ref
                                  .read(themeModelProvider)
                                  .setThemeMode(newThemeMode);
                            },
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AboutUsPage(),
                                ));
                          },
                          child: ListTile(
                            leading: const Icon(
                              Icons.info_outline,
                              color: Colors.red,
                              size: 30,
                            ),
                            title: Text(languageText.profile_about_us_listTile),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade800,
                        minimumSize: const Size(260, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32))),
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ))
                          .then((value) => ref
                              .read(userDetailsProvider.notifier)
                              .getCurrentUserData(context));
                    },
                    child: Text(
                      languageText.profile_edit_button_text,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ));
  }
}
