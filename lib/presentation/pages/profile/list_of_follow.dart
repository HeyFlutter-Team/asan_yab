import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/domain/riverpod/screen/search_load_screen.dart';
import 'package:asan_yab/presentation/pages/profile/list_followers.dart';
import 'package:asan_yab/presentation/pages/profile/list_following.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListOfFollow extends ConsumerWidget {
  const ListOfFollow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileDetails = ref.watch(userDetailsProvider);
    return DefaultTabController(
      initialIndex: ref.read(indexFollowPageProvider),
      length: 2, // Number of tabs
      child: WillPopScope(
        onWillPop: () async {
          ref.read(listOfDataProvider.notifier).state.clear();
          ref.read(listOfDataFollowersProvider.notifier).state.clear();
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              profileDetails!.name!,
              style: TextStyle(color: Colors.black87),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black87,
              ),
              onPressed: () {
                ref.read(listOfDataProvider.notifier).state.clear();
                ref.read(listOfDataFollowersProvider.notifier).state.clear();
                Navigator.pop(context);
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
              labelStyle: TextStyle(color: Colors.black87),
              tabs: [
                Tab(
                  text: '${'Following'} ${profileDetails.followingCount}',
                  // AppLocalizations.of(context)?.following ??
                ),
                Tab(
                  text: '${'Followers'} ${profileDetails.followerCount}',
                  // AppLocalizations.of(context)?.followers ??
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
