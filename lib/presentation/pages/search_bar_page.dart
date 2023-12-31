import 'package:asan_yab/data/models/place.dart';
import 'package:asan_yab/domain/riverpod/screen/search_load_screen.dart';
import 'package:asan_yab/presentation/pages/search_notifire.dart';
import 'package:asan_yab/presentation/pages/search_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/res/image_res.dart';
import '../../domain/riverpod/data/search_provider.dart';
import 'detials_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        //shadowColor: Colors.blue,
        //backgroundColor: Theme.of(context).primaryColor,
        title: TextFormField(
          controller: searchController,
          // autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: languageText!.search_bar_hint_text,
          ),
          onChanged: (value) {
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
          },
        ),
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
      body:  ref.watch(searchNotifierProvider) == '' ? SizedBox():
      _data.when(
        data: (_data) {
          List<Place> postList = _data.map((e) => e).toList();
          return
            ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount:postList.length,
            separatorBuilder: (context, index) =>
            const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
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
                      child: Text(
                        postList[index].name.toString(),
                        maxLines: 2,
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
          );
        },
        error: (error, stackTrace) => Text(' hello: ${error.toString()}'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
