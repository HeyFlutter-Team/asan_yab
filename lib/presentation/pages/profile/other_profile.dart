import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/data/repositoris/language_repository.dart';
import 'package:asan_yab/domain/riverpod/data/follow_https.dart';
import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/domain/riverpod/screen/follow_checker.dart';
import 'package:asan_yab/presentation/pages/about_us_page.dart';
import 'package:asan_yab/presentation/pages/profile/show_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtherProfile extends ConsumerStatefulWidget {
  const OtherProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtherProfileState();
}

class _OtherProfileState extends ConsumerState<OtherProfile> {
  @override
  Widget build(BuildContext context) {
    final usersData = ref.watch(otherUserProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final languageText = AppLocalizations.of(context);

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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Center(
                    child: Text(
                      '${usersData?.name} ${usersData?.lastName}',
                      style: const TextStyle(color: Colors.white, fontSize: 28),
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
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowProfilePage(
                                imagUrl:
                                    '${ref.watch(userDetailsProvider)?.imageUrl}'),
                          )),
                  child: usersData?.imageUrl == ''
                      ? const Stack(
                          children: [
                            Hero(
                              tag: 'avatarHeroTag',
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage(
                                    'assets/Avatar.png'), // Your image URL
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
                  padding:
                      const EdgeInsets.only(top: 50.0, right: 10, left: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
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
                  //todo user data for copy
                  ref
                      .read(userDetailsProvider.notifier)
                      .copyToClipboard('${usersData?.id}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(languageText!.profile_copy_id_snack_bar),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text('${usersData?.name} ${usersData?.lastName}'),
                leading: const Icon(
                  color: Colors.red,
                  Icons.person_2_outlined,
                  size: 30,
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              // LanguageIcon(),
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
                  title: Text(languageText!.profile_about_us_listTile),
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
            //todo for follow
            final uid = FirebaseAuth.instance.currentUser!.uid;
            final followId = usersData!.uid!;
            ref
                .read(followHttpsProvider.notifier)
                .updateFollowers(uid, followId)
                .whenComplete(() => ref
                    .read(followerProvider.notifier)
                    .followOrUnFollow(uid, followId));
            ref.read(userDetailsProvider.notifier).getCurrentUserData(context);
          },
          child: ref.watch(loadingFollowers)
              ? CircularProgressIndicator(
                  color: Colors.white70,
                  strokeWidth: 2,
                )
              : Text(
                  ref.watch(followerProvider) ? 'Follow' : "Unfollow",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    ));
  }
}
