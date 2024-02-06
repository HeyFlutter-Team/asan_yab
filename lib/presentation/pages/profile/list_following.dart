import 'package:asan_yab/domain/riverpod/data/follow_https.dart';
import 'package:asan_yab/domain/riverpod/data/following_data.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/domain/riverpod/screen/follow_checker.dart';
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

    debugPrint('following ${persons.length}');
    return Scaffold(
      body: ref.watch(loadingFollowingDataProvider)
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            )
          : ref.watch(loadingFollowers)
              ? Column(
                children: [
                  const SizedBox(height: 14,),
                  ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: (context, index) {
                        debugPrint("is ture ${persons[index]['user'].uid! == uid}");
                        return ListTile(
                          onTap: () {
                            // todo for visite
                          },
                          title: Text(persons[index]['user'].name!),
                          leading: CircleAvatar(
                            radius: 33,
                            backgroundImage: CachedNetworkImageProvider(
                                persons[index]['user'].imageUrl!),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              await ref
                                  .read(followHttpsProvider.notifier)
                                  .updateFollowers(uid, persons[index]['user'].uid!)
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
                                    .getCurrentUserData(context);
                              }
                            },
                            child: Text(
                                persons[index]['follow'] ? 'Follow' : 'Unfollow'),
                          ),
                        );
                      },
                    ),
                ],
              )
              : Column(
                children: [
                  const SizedBox(height: 14,),

                  Expanded(
                    child: ListView.builder(
                        itemCount: persons.length,
                        itemBuilder: (context, index) {
                          debugPrint("is ture ${persons[index]['user'].uid! == uid}");
                          return ListTile(
                            onTap: () {
                              ref
                                  .read(followHttpsProvider.notifier)
                                  .updateFollowers(uid, persons[index]['user'].uid!)
                                  .whenComplete(() => ref
                                      .read(followerProvider.notifier)
                                      .followOrUnFollow(
                                          FirebaseAuth.instance.currentUser!.uid,
                                          persons[index]['user'].uid!));

                              // todo for visite
                            },
                            title: Text(persons[index]['user'].name!),
                            leading: CircleAvatar(
                              radius: 33,
                              backgroundImage: CachedNetworkImageProvider(
                                  persons[index]['user'].imageUrl!),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                await ref
                                    .read(followHttpsProvider.notifier)
                                    .updateFollowers(uid, persons[index]['user'].uid!)
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
                                      .getCurrentUserData(context);
                                }
                              },
                              child: Text(
                                  persons[index]['follow'] ? 'Follow' : 'Unfollow'),
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
