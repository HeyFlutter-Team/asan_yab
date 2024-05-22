import 'package:asan_yab/domain/riverpod/data/follow_https.dart';
import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/domain/riverpod/screen/follow_checker.dart';
import 'package:asan_yab/presentation/pages/profile/other_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListOfFollowing extends ConsumerStatefulWidget {
  const ListOfFollowing({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListOfFollowingState();
}

class _ListOfFollowingState extends ConsumerState<ListOfFollowing> {
  @override
  Widget build(BuildContext context) {
    final persons = ref.watch(listOfDataProvider);
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
                        debugPrint(
                            "is ture ${persons[index]['user'].uid! == uid}");
                        return ListTile(
                          onTap: () {
                          },
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
                                  .whenComplete(() => ref
                                          .read(listOfDataProvider.notifier)
                                          .state[index]['follow'] =
                                      !persons[index]['follow']);
                              if (context.mounted) {
                                ref
                                    .read(userDetailsProvider.notifier)
                                    .getCurrentUserData();
                              }
                            },
                            child: Text(persons[index]['follow']
                                ? 'Follow'
                                : 'Unfollow'),
                          ),
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
                          debugPrint(
                              "is ture ${persons[index]['user'].uid! == uid}");
                          return ListTile(
                            onTap: () async {
                               Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                             OtherProfile(user: persons[index]['user'],
                                             uid:persons[index]['user'].uid ,),
                                      ));
                            },
                            title: Text(
                                persons[index]['user'].name.toString().length>18?'${persons[index]['user'].name!}'.substring(0,18):persons[index]['user'].name!),
                            leading: persons[index]['user'].imageUrl == '' || persons[index]['user'].imageUrl==null
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
                                ref
                                    .read(loadingFollowOrUnfollowProvider(index)
                                        .notifier)
                                    .state = true;
                                await ref
                                    .read(followHttpsProvider.notifier)
                                    .updateFollowers(
                                        uid, persons[index]['user'].uid!)
                                    .whenComplete(() async => await ref
                                        .read(followerProvider.notifier)
                                        .followOrUnFollow(
                                            uid, persons[index]['user'].uid!))
                                    .whenComplete(() => ref
                                            .read(listOfDataProvider.notifier)
                                            .state[index]['follow'] =
                                        !persons[index]['follow']);
                                if (context.mounted) {
                                  await ref
                                      .read(userDetailsProvider.notifier)
                                      .getCurrentUserData()
                                      .whenComplete(() {
                                    ref
                                        .read(listOfDataProvider.notifier)
                                        .state = List.of(persons)
                                      ..removeAt(index);
                                  });
                                }
                                ref
                                    .read(loadingFollowOrUnfollowProvider(index)
                                        .notifier)
                                    .state = false;
                              },
                              child: ref.watch(
                                      loadingFollowOrUnfollowProvider(index))
                                  ? const SizedBox(
                                      height: 7,
                                      width: 7,
                                      child: CircularProgressIndicator(
                                        color: Colors.white70,
                                      ),
                                    )
                                  : Text(
                                      persons[index]['follow']
                                          ? 'Follow'
                                          : 'Unfollow',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
