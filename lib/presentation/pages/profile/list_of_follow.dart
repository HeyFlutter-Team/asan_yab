import 'package:asan_yab/core/utils/utils.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/config/internet_connectivity_checker.dart';
import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/presentation/pages/profile/list_followers.dart';
import 'package:asan_yab/presentation/pages/profile/list_following.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositoris/language_repository.dart';

class ListOfFollow extends ConsumerStatefulWidget {
  final int initialIndex;
  const ListOfFollow({Key? key, required this.initialIndex}) : super(key: key);

  @override
  ConsumerState<ListOfFollow> createState() => _ListOfFollowState();
}

class _ListOfFollowState extends ConsumerState<ListOfFollow> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if(ref.watch(internetConnectivityCheckerProvider.notifier).isConnected){
      ref.read(listOfDataProvider.notifier).state.clear();
      ref.read(listOfDataFollowersProvider.notifier).state.clear();
      ref
          .read(followingDataProvider.notifier)
          .getProfile(FirebaseAuth.instance.currentUser!.uid);
    }
    else{
      Utils.lostNetSnackBar(context);
    }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileDetails = ref.watch(userDetailsProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return DefaultTabController(
      initialIndex: widget.initialIndex,
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
              decoration: BoxDecoration(
                gradient: isRTL
                    ? LinearGradient(colors: [
                        Colors.red.shade900,
                        Colors.grey,
                        Colors.red.shade900,
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight)
                    : LinearGradient(colors: [
                        Colors.red.shade900,
                        Colors.grey,
                        Colors.red.shade900,
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight),
              ),
            ),
            title: Text(
              profileDetails!.name.length>18?profileDetails.name.substring(0,18):profileDetails.name,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
                ref.read(listOfDataProvider.notifier).state.clear();
                ref.read(listOfDataFollowersProvider.notifier).state.clear();
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
              labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              indicatorColor: Colors.white,
              unselectedLabelStyle:
                  const TextStyle(color: Colors.white, fontSize: 14),
              tabs: [
                Tab(
                  icon: Text('${profileDetails.followingCount}',
                      style: const TextStyle(fontSize: 20)),
                  text: 'Following',
                ),
                Tab(
                  icon: Text('${profileDetails.followerCount}',
                      style: const TextStyle(fontSize: 20)),
                  text: 'Followers',
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


