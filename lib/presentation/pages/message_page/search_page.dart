import 'package:asan_yab/core/utils/utils.dart';
import 'package:asan_yab/domain/riverpod/config/internet_connectivity_checker.dart';
import 'package:asan_yab/domain/riverpod/data/search_id.dart';
import 'package:asan_yab/presentation/pages/profile/other_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        ref.refresh(searchProvider.notifier).clearSearch();
        ref.read(searchLoadingProvider.notifier).state = false;
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            shadowColor: Colors.white,
            title: TextFormField(
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              controller: searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)?.searchById,
                hintStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              onChanged: (value) async {
                if (Utils.netIsConnected(ref)) {
                  try {
                    if (value.isNotEmpty) {
                      ref.read(searchLoadingProvider.notifier).state = true;

                      final profileById = ref.read(searchProvider.notifier).getProfile(value);
                      final profileByName = ref.read(searchProvider.notifier).getProfileByName(value);

                      await Future.wait([profileByName,profileById]);
                    } else {
                      ref.refresh(searchProvider.notifier).clearSearch();
                      ref.read(searchLoadingProvider.notifier).state = false;
                    }
                  } catch (e) {
                    print('Error parsing input: $e');
                  }
                } else {
                  Utils.lostNetSnackBar(context);
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
                          ref.read(searchLoadingProvider.notifier).state=false;
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
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
                ref.refresh(searchProvider.notifier).clearSearch();
                ref.read(searchLoadingProvider.notifier).state=false;
              },
              icon: const Icon(Icons.arrow_back, size: 25.0),
            ),
          ),
          body: ref.watch(searchProvider).isEmpty
              ? Center(
                  child: Text(
                  AppLocalizations.of(context)!.findingFriendById,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: ref.watch(searchProvider).length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    // final items = ref.watch(searchTypeSenseProvider);
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  OtherProfile(
                                user: ref.watch(searchProvider)[index],
                                uid:ref.watch(searchProvider)[index].uid! ,
                              ),
                            ));
                      },
                      child: Row(
                        children: [
                          ref.watch(searchProvider)[index].imageUrl == '' ||
                              ref.watch(searchProvider)[index].imageUrl.isEmpty
                              ? const CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/Avatar.png'),
                                )
                              : CircleAvatar(
                                  radius: 30,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: CachedNetworkImage(
                                      imageUrl: ref
                                          .watch(searchProvider)[index]
                                          .imageUrl,
                                      errorListener: (value) =>  Image.asset(
                                          'assets/Avatar.png'),
                                      placeholder: (context, url) =>  Image.asset(
                                          'assets/Avatar.png'),
                                    ),
                                  ),
                                ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                ref.watch(searchProvider)[index].name.length > 15
                                    ? ref.watch(searchProvider)[index].name.substring(0, 15)
                                    : ref.watch(searchProvider)[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              subtitle: Text(
                                ref.watch(searchProvider)[index].id.length > 15
                                    ? ref.watch(searchProvider)[index].id.substring(0, 15)
                                    : ref.watch(searchProvider)[index].id,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
    );
  }
}
