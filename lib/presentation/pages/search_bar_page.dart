import 'package:asan_yab/core/utils/utils.dart';
import 'package:asan_yab/data/models/place.dart';
import 'package:asan_yab/domain/riverpod/config/internet_connectivity_checker.dart';
import 'package:asan_yab/presentation/pages/search_notifire.dart';
import 'package:asan_yab/presentation/pages/search_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/res/image_res.dart';
import '../../domain/riverpod/data/firbase_favorite_provider.dart';
import '../../domain/riverpod/data/single_place_provider.dart';
import 'detials_page.dart';

final searchLoadingProvider = StateProvider<bool>((ref) => false);
final fetchprovider = StateProvider<bool>((ref) => true);

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _data = ref.watch(userDataProvider);
    final languageText = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: languageText!.search_bar_hint_text,
            ),
            onChanged: (value) {
              if (Utils.netIsConnected(ref)) {
                ref
                    .read(searchNotifierProvider.notifier)
                    .sendQuery(value.trimLeft());
                ref.read(userDataProvider);
                if (value.isEmpty) {
                  ref.read(searchNotifierProvider.notifier).clear;
                }
                if (value.isNotEmpty) {
                  ref.refresh(searchLoadingProvider.notifier).state = true;
                } else {
                  ref.refresh(searchLoadingProvider.notifier).state = false;
                }
              }else{
                Utils.lostNetSnackBar(context);
              }
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ref.watch(searchLoadingProvider)
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                      ref.refresh(searchNotifierProvider.notifier).clear;
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 25.0,
                      // color: Colors.black,
                    ),
                  )
                : null,
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            ref.refresh(searchNotifierProvider.notifier).clear;
          },
          icon: const Icon(Icons.arrow_back, size: 25.0),
        ),
      ),
      body: ref.watch(searchNotifierProvider) == ''
          ? SizedBox()
          : _data.when(
              data: (_data) {
                List<Place> postList = _data.map((e) => e).toList();
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: postList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        ref.read(getSingleProvider.notifier).state = null;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              id: postList[index].id,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: CachedNetworkImage(
                              imageUrl: postList[index].logo,
                              fit: BoxFit.cover,
                              height: 60,
                              width: 60,
                              placeholder: (context, url) =>
                                  Image.asset(ImageRes.asanYab),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildSearchResultText(
                              postList[index].name.toString(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) => Text(' hello: ${error.toString()}'),
              loading: () => const Center(child: CircularProgressIndicator(
                color: Colors.red,
              )),
            ),
    );
  }

  Widget buildSearchResultText(String name) {
    final startIndex =
        name.toLowerCase().indexOf(searchController.text.toLowerCase());

    if (startIndex == -1) {
      return Text(name);
    }

    final endIndex = startIndex + searchController.text.length;
    final beforeMatch = name.substring(0, startIndex);
    final match = name.substring(startIndex, endIndex);
    final afterMatch = name.substring(endIndex);

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          // color: Colors.black,
          fontSize: 20.0,
        ),
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }
}
