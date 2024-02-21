import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/domain/riverpod/screen/search_load_screen.dart';
import 'package:asan_yab/presentation/pages/profile/list_followers.dart';
import 'package:asan_yab/presentation/pages/profile/list_following.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/repositoris/language_repository.dart';

class ListOfFollow extends ConsumerWidget {
  const ListOfFollow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageText = AppLocalizations.of(context);
    final profileDetails = ref.watch(userDetailsProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
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
            flexibleSpace: Container(
              decoration:  BoxDecoration(
                gradient:  isRTL
                    ? LinearGradient(colors: [
                  Colors.purple,
                  Colors.red.shade900,
                ],
                begin:Alignment.bottomLeft ,
                    end: Alignment.topRight
                )
                    : LinearGradient(colors: [
                  Colors.red.shade900,
                  Colors.purple,
                ],
                    begin:Alignment.bottomLeft ,
                    end: Alignment.topRight
                ),
              ),
            ),
            title: Text(
              profileDetails!.name,
            style: const TextStyle(fontSize: 24),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
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
              labelStyle: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 18),
              tabs: [
                Tab(
                  text: '${languageText?.profile_following} ${profileDetails.followingCount}',
                  // AppLocalizations.of(context)?.following ??
                ),
                Tab(
                  text: '${languageText?.profile_followers} ${profileDetails.followerCount}',
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
