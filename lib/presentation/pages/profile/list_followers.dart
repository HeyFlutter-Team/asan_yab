import 'package:asan_yab/domain/riverpod/data/follow_https.dart';
import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/domain/riverpod/screen/follow_checker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListOfFollowers extends ConsumerStatefulWidget {
  const ListOfFollowers({super.key});

  @override
  ConsumerState<ListOfFollowers> createState() => _ListOfFollowersState();
}

class _ListOfFollowersState extends ConsumerState<ListOfFollowers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(listOfDataFollowersProvider);
      ref.read(userDetailsProvider.notifier).getCurrentUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final persons = ref.watch(listOfDataFollowersProvider);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final loadingFollowing = ref.watch(loadingFollowingDataProvider);
    final loadingFollower = ref.watch(loadingFollowers);
    debugPrint('following ${persons.length}');
    return Scaffold(
      body: loadingFollowing
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            )
          : loadingFollower
              ? Column(
                  children: [
                    const SizedBox(
                      height: 14,
                    ),
                    ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: persons.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {},
                          title: Text(persons[index]['user'].name!),
                          leading: persons[index]['user'].imageUrl == ''
                              ? const CircleAvatar(
                                  radius: 33,
                                  backgroundImage:
                                      AssetImage('assets/Avatar.png'),
                                )
                              : CircleAvatar(
                                  radius: 33,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${persons[index]['user'].imageUrl}',
                                      placeholder: (context, url) =>  Image.asset(
                                          'assets/Avatar.png'),
                                      errorListener: (value) =>  Image.asset(
                                          'assets/Avatar.png'),
                                    ),
                                  ),
                                ),
                          trailing: ElevatedButton(
                              onPressed: () async {
                                await ref
                                    .read(followHttpsProvider.notifier)
                                    .updateFollowers(
                                        uid, persons[index]['user'].uid!)
                                    .whenComplete(() => ref
                                        .read(followerProvider.notifier)
                                        .followOrUnFollow(
                                            uid, persons[index]['user'].uid!))
                                    .whenComplete(() {
                                  ref
                                          .read(listOfDataFollowersProvider
                                              .notifier)
                                          .state[index]['followBack'] =
                                      !persons[index]['followBack'];
                                });
                                if (context.mounted) {
                                  ref
                                      .read(userDetailsProvider.notifier)
                                      .getCurrentUserData();
                                }
                              },
                              child: Text(persons[index]['followBack']
                                  ? 'Follow Back'
                                  : 'Unfollow')),
                        );
                      },
                    ),
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 14,
                    ),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: persons.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                persons[index]['user'].name.toString().length>18?'${persons[index]['user'].name!}'.substring(0,18):persons[index]['user'].name!),
                            leading: persons[index]['user'].imageUrl == '' ||persons[index]['user'].imageUrl==null
                                ? const CircleAvatar(
                                    radius: 33,
                                    backgroundImage:
                                        AssetImage('assets/Avatar.png'),
                                  )
                                : CircleAvatar(
                                    radius: 33,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${persons[index]['user'].imageUrl}',
                                        errorListener: (value) =>  Image.asset(
                                            'assets/Avatar.png'),
                                        placeholder: (context, url) =>  Image.asset(
                                            'assets/Avatar.png'),
                                      ),
                                    ),
                                  ),
                            trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade300),
                                onPressed: () async {
                                  await ref
                                      .read(followHttpsProvider.notifier)
                                      .updateFollowers(
                                          uid, persons[index]['user'].uid!)
                                      .whenComplete(() async => await ref
                                          .read(followerProvider.notifier)
                                          .followOrUnFollow(
                                              uid, persons[index]['user'].uid!))
                                      .whenComplete(() {
                                    ref
                                            .read(listOfDataFollowersProvider
                                                .notifier)
                                            .state[index]['followBack'] =
                                        !persons[index]['followBack'];
                                  });
                                  if (context.mounted) {
                                    await ref
                                        .read(userDetailsProvider.notifier)
                                        .getCurrentUserData();
                                  }
                                },
                                child: Text(
                                  persons[index]['followBack']
                                      ? 'Follow Back'
                                      : 'Unfollow',
                                  style: const TextStyle(color: Colors.white),
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
