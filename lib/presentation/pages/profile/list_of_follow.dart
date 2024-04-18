import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data.dart';
import 'package:asan_yab/domain/riverpod/screen/search_load_screen.dart';
import 'package:asan_yab/presentation/pages/profile/list_of_followers.dart';
import 'package:asan_yab/presentation/pages/profile/list_of_following.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/translation_util.dart';
import '../../../data/repositoris/language_repo.dart';

class ListOfFollow extends ConsumerWidget {
  const ListOfFollow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = texts(context);
    final profileDetails = ref.watch(profileDataProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return DefaultTabController(
      initialIndex: ref.read(stateFollowPageProvider),
      length: 2, // Number of tabs
      child: WillPopScope(
        onWillPop: () async {
          ref.read(listOfDataProvider.notifier).state.clear();
          ref.read(listOfDataFollowersProvider.notifier).state.clear();
          context.pop();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: isRTL
                    ? LinearGradient(colors: [
                        Colors.purple,
                        Colors.red.shade900,
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight)
                    : LinearGradient(colors: [
                        Colors.red.shade900,
                        Colors.purple,
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight),
              ),
            ),
            title: Text(
              profileDetails!.name,
              style: const TextStyle(fontSize: 24),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                ref.read(listOfDataProvider.notifier).state.clear();
                ref.read(listOfDataFollowersProvider.notifier).state.clear();
                context.pop();
              },
            ),
            bottom: TabBar(
              onTap: (value) {
                ref.read(listOfDataProvider.notifier).state.clear();
                ref.read(listOfDataFollowersProvider.notifier).state.clear();
                ref
                    .read(followingDataProvider.notifier)
                    .getProfile(FirebaseAuth.instance.currentUser!.uid);
              },
              labelColor: Colors.black87,
              labelStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              tabs: [
                Tab(
                  text:
                      '${text.profile_following} ${profileDetails.followingCount}',
                ),
                Tab(
                  text:
                      '${text.profile_followers} ${profileDetails.followerCount}',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ListOfFollowing(),
              ListOfFollowers(),
            ],
          ),
        ),
      ),
    );
  }
}
