import 'package:asan_yab/domain/riverpod/screen/search_load_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/res/image_res.dart';
import '../../domain/riverpod/data/search_provider.dart';

import 'detials_page.dart';

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
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.blue,
          backgroundColor: Theme.of(context).primaryColor,
          title: TextFormField(
            controller: searchController,
            // autofocus: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'جستجو ',
            ),
            onChanged: (value) {
              ref.read(searchTypeSenseProvider.notifier).search(value);
              if (value.isEmpty) {
                ref.refresh(searchTypeSenseProvider.notifier).clear;
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
                        ref.refresh(searchTypeSenseProvider.notifier).clear;
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 25.0,
                        color: Colors.black,
                      ),
                    )
                  : null,
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              ref.refresh(searchTypeSenseProvider.notifier).clear;
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25.0),
          ),
        ),
        body: ref.watch(searchTypeSenseProvider).isEmpty
            ? Center(
                child: Image.asset(ImageRes.noInfo),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: ref.watch(searchTypeSenseProvider).length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final items = ref.watch(searchTypeSenseProvider);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            id: items[index].id,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: CachedNetworkImage(
                            imageUrl: items[index].imageUrl,
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
                            items[index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
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
