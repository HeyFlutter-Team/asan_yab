import 'package:asan_yab/domain/riverpod/screen/botton_navigation_provider.dart';
import 'package:asan_yab/presentation/pages/about_us_page.dart';
import 'package:asan_yab/presentation/pages/edit_profile_page.dart';
import 'package:asan_yab/presentation/pages/sign_in_page.dart';
import 'package:asan_yab/presentation/pages/themeProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/users.dart';
import '../../domain/riverpod/data/profile_data_provider.dart';

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
        ref.read(userDetailsProvider.notifier).getCurrentUserData();
        ref.read(userDetailsProvider.notifier).state?.imageUrl;
      },
    );
  }

  final userName = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final themeModel = ref.watch(themeModelProvider);
    return Scaffold(
      body: FutureBuilder<Users?>(
          future: ref.read(userDetailsProvider.notifier).getCurrentUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('اطلاعات در دسترس نیست'));
            } else {
              Users usersData = snapshot.data!;
              return Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: Stack(
                      children: [
                        Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.white,
                              Colors.red.shade900,
                            ]),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.elliptical(600, 100),
                              bottomRight: Radius.elliptical(600, 100),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 58.0, right: 120),
                          child: Text(
                            maxLines: 1,
                            '${usersData.name} ${usersData.lastName}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 28),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 118.0, right: 116),
                          child: usersData.imageUrl == ''
                              ? Stack(
                                  children: [
                                    const CircleAvatar(
                                      radius: 80,
                                      backgroundImage: AssetImage(
                                          'assets/Avatar.png'), // Your image URL
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 40.0, right: 50),
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
                              : CircleAvatar(
                                  maxRadius: 80,
                                  backgroundImage: NetworkImage(
                                    ref.watch(userDetailsProvider)!.imageUrl,
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, right: 15),
                          child: IconButton(
                              onPressed: () {
                                FirebaseAuth.instance
                                    .signOut()
                                    .whenComplete(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LogInPage(),
                                      ));
                                  ref
                                      .read(buttonNavigationProvider.notifier)
                                      .selectedIndex(0);
                                });
                                // navigatorKey.currentState!.popUntil((route) => route.isFirst);
                              },
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text('${usersData.id}'),
                          leading: const Icon(
                            color: Colors.red,
                            Icons.account_circle,
                            size: 30,
                          ),
                          onTap: () {
                            ref
                                .read(userDetailsProvider.notifier)
                                .copyToClipboard('${usersData.id}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                // backgroundColor: Colors.red,
                                content: Text(
                                    '${usersData.id} آیدی شما در کلیپ بورد کبی شد'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        ListTile(
                          title:
                              Text('${usersData.name} ${usersData.lastName}'),
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
                          title: Text(usersData.email),
                          leading: const Icon(
                            color: Colors.red,
                            Icons.mail_outline,
                            size: 30,
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
                          child: const ListTile(
                            leading: Icon(
                              Icons.info_outline,
                              color: Colors.red,
                              size: 30,
                            ),
                            title: Text('درباره ما'),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        ListTile(
                          title: Text('Dark Mode'),
                          leading: Icon(
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
                        SizedBox(
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
                                builder: (context) => EditProfilePage(
                                  userData: usersData,
                                ),
                              ))
                          .then((value) => ref
                              .read(userDetailsProvider.notifier)
                              .getCurrentUserData());
                    },
                    child: const Text(
                      'ویرایش',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              );
            }
          }),
    );
  }

  void showBottomSheets(BuildContext context) {
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
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.camera),
                    SizedBox(height: 8.0),
                    Text('کامره'),
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
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.image),
                    SizedBox(height: 8.0),
                    Text('گالری'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
}
