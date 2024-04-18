import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/data/repositoris/language_repo.dart';
import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data.dart';
import 'package:asan_yab/domain/riverpod/screen/check_follower.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/routes/routes.dart';
import '../../../core/utils/translation_util.dart';

class OtherProfile extends ConsumerStatefulWidget {
  const OtherProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtherProfileState();
}

class _OtherProfileState extends ConsumerState<OtherProfile> {
  @override
  Widget build(BuildContext context) {
    final usersData = ref.watch(otherUserDataProvider);
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
                        '${usersData?.name} ${usersData?.lastName}',
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
                                    '${ref.watch(otherUserDataProvider)?.imageUrl}'
                              }),
                    child: usersData?.imageUrl == ''
                        ? const Stack(
                            children: [
                              Hero(
                                tag: 'avatarHeroTag',
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: AssetImage(
                                    'assets/Avatar.png',
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ref.watch(otherUserDataProvider)?.imageUrl == ''
                            ? const SizedBox()
                            : Hero(
                                tag: 'avatarHeroTag',
                                child: CircleAvatar(
                                  maxRadius: 80,
                                  backgroundImage: NetworkImage(
                                    '${ref.watch(otherUserDataProvider)?.imageUrl}',
                                  ),
                                ),
                              ),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: 50.0, right: 10, left: 10),
                    child: IconButton(
                      onPressed: () => context.pop(),
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
                SizedBox(height: 5.h),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  //todo for chat
                  final followId = usersData!.uid!;
                  context.pushNamed(Routes.chatDetail,
                      pathParameters: {'followId': followId});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  height: 55,
                  width: context.screenWidth * .40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.blueAccent,
                          Colors.purpleAccent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.chat_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      const Text(
                        'Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              InkWell(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  ref.read(loadingFollowers.notifier).state = true;
                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  final followId = usersData!.uid!;
                  ref
                      .read(followingDataProvider.notifier)
                      .updateFollowers(uid, followId)
                      .whenComplete(() => ref
                          .read(checkFollowerProvider.notifier)
                          .followOrUnFollow(uid, followId));
                  ref.read(profileDataProvider.notifier).getCurrentUserData();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  height: 55,
                  width: context.screenWidth * .40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.redAccent,
                          Colors.redAccent.withOpacity(0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )),
                  child: ref.watch(loadingFollowers)
                      ? Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                              color: Colors.redAccent, size: 60),
                        )
                      : Center(
                          child: Text(
                            ref.watch(checkFollowerProvider)
                                ? 'Follow'
                                : "Unfollow",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
