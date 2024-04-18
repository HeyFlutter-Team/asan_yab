import 'package:asan_yab/domain/riverpod/data/other_user_data.dart';
import 'package:asan_yab/domain/riverpod/data/search_list_of_user.dart';
import 'package:asan_yab/domain/riverpod/screen/check_follower.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/routes.dart';
import '../../../core/utils/translation_util.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final text = texts(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.white,
        title: TextFormField(
          keyboardType: TextInputType.number,
          controller: searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: text.searchById,
          ),
          onChanged: (value) {
            debugPrint('This is the Value of id $value');
            final id = int.parse(value);
            ref.read(searchListOfUserProvider.notifier).getProfile(id);
            debugPrint(
                'Sharif please check this${ref.read(searchListOfUserProvider.notifier).getProfile(id)}');
            if (value.isEmpty) {
              ref.refresh(searchListOfUserProvider.notifier).clearSearch();
              ref.refresh(searchLoadingProvider.notifier).state = false;
            } else {
              ref.refresh(searchLoadingProvider.notifier).state = true;
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
                      ref
                          .refresh(searchListOfUserProvider.notifier)
                          .clearSearch();
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
            context.pop();
            ref.refresh(searchListOfUserProvider.notifier).clearSearch();
          },
          icon: const Icon(Icons.arrow_back, size: 25.0),
        ),
      ),
      body: ref.watch(searchListOfUserProvider).isEmpty
          ? Center(
              child: Text(
                text.findingFriendById,
                style: GoogleFonts.lobster(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: ref.watch(searchListOfUserProvider).length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    ref.read(otherUserDataProvider.notifier).setDataUser(
                        ref.watch(searchListOfUserProvider)[index]);
                    ref.read(checkFollowerProvider.notifier).followOrUnFollow(
                        FirebaseAuth.instance.currentUser!.uid,
                        ref.watch(searchListOfUserProvider)[index].uid!);
                    context.pushNamed(Routes.otherProfile);
                  },
                  child: Row(
                    children: [
                      ref.watch(searchListOfUserProvider)[index].imageUrl == ''
                          ? const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/Avatar.png'),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: CachedNetworkImageProvider(ref
                                  .watch(searchListOfUserProvider)[index]
                                  .imageUrl),
                            ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          ref.watch(searchListOfUserProvider)[index].name,
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
            ),
    );
  }
}
