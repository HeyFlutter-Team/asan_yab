import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:asan_yab/domain/riverpod/data/search_id.dart';
import 'package:asan_yab/domain/riverpod/screen/follow_checker.dart';
import 'package:asan_yab/presentation/pages/profile/other_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.white,
          title: TextFormField(
            keyboardType: TextInputType.number,
            controller: searchController,
            // autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)?.searchById,
              hintStyle: GoogleFonts.lobster(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            // onFieldSubmitted: (value) {
            //   print(value);
            //
            // },
            onChanged: (value) {
              final id = int.parse(value);
              ref.read(searchProvider.notifier).getProfile(id);
              // ref.read(searchTypeSenseProvider.notifier).search(value);
              if (value.isEmpty) {
                ref.refresh(searchProvider.notifier).clearSearch();
              }
              if (value.isNotEmpty) {
                ref.refresh(searchLoadingProvider.notifier).state = true;
              } else {
                ref.refresh(searchLoadingProvider.notifier).state = false;
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ref.watch(searchLoadingProvider)
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        ref.refresh(searchProvider.notifier).clearSearch();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 25.0,
                      ),
                    )
                  : null,
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              ref.refresh(searchProvider.notifier).clearSearch();
            },
            icon: const Icon(Icons.arrow_back, size: 25.0),
          ),
        ),
        body: ref.watch(searchProvider).isEmpty
            ? Center(
                child: Text(
                AppLocalizations.of(context)!.findingFriendById,
                style: GoogleFonts.lobster(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ))
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: ref.watch(searchProvider).length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  // final items = ref.watch(searchTypeSenseProvider);
                  return InkWell(
                    onTap: () {
                      // todo for visite
                      ref
                          .read(otherUserProvider.notifier)
                          .setDataUser(ref.watch(searchProvider)[index]);
                      ref.read(followerProvider.notifier).followOrUnFollow(
                          FirebaseAuth.instance.currentUser!.uid,
                          ref.watch(searchProvider)[index].uid!);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OtherProfile(),
                          ));
                    },
                    child: Row(
                      children: [
                        ref.watch(searchProvider)[index].imageUrl==''?
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/Avatar.png'),
                        )
                        :CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                              ref.watch(searchProvider)[index].imageUrl ?? ''),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ref.watch(searchProvider)[index].name ?? 'no data',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}
