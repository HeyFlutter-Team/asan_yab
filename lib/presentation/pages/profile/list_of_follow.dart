import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/presentation/pages/profile/list_followers.dart';
import 'package:asan_yab/presentation/pages/profile/list_following.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositoris/language_repository.dart';

class ListOfFollow extends ConsumerWidget {
  final int initialIndex;
  const ListOfFollow({Key? key,required this.initialIndex}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileDetails = ref.watch(userDetailsProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return DefaultTabController(
      initialIndex: initialIndex,
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
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: Container(
              decoration:  BoxDecoration(
                gradient:  isRTL
                    ? LinearGradient(colors: [
                  Colors.red.shade900,
                  Colors.grey,
                  Colors.red.shade900,
                ],
                begin:Alignment.bottomLeft ,
                    end: Alignment.topRight
                )
                    : LinearGradient(colors: [
                  Colors.red.shade900,
                  Colors.grey,
                  Colors.red.shade900,
                ],
                    begin:Alignment.bottomLeft ,
                    end: Alignment.topRight
                ),
              ),
            ),
            title: Text(
              profileDetails!.name,
            style: const TextStyle(fontSize: 24,color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
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
              labelStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
              indicatorColor: Colors.white,
              unselectedLabelStyle:const TextStyle(color: Colors.white,fontSize: 14),
              tabs: [
                Column(
                  children: [
                     Text('${profileDetails.followingCount}',style: const TextStyle(
                       fontSize: 20
                     ),),
                     const Tab(
                      child: Text('Following'),
                    ),
                  ],
                ),
                Column(
                  children: [
                     Text('${profileDetails.followerCount}',style: const TextStyle(
                         fontSize: 20
                     ),),
                    const Tab(
                      child: Text('Followers'),
                    ),
                  ],
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
