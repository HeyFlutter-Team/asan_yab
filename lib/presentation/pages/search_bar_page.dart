import 'package:asan_yab/data/models/place.dart';
import 'package:asan_yab/domain/riverpod/data/search_notifire.dart';
import 'package:asan_yab/domain/riverpod/data/search_user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/res/image_res.dart';
import '../../core/utils/translation_util.dart';
import '../widgets/search_result_widget.dart';
import 'detials_page.dart';

final searchLoadingProvider = StateProvider<bool>((ref) => false);
final fetchProvider = StateProvider<bool>((ref) => true);

class SearchBarPage extends ConsumerStatefulWidget {
  const SearchBarPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchBarPage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(searchUserProvider);
    final text = texts(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: text.search_bar_hint_text,
          ),
          onChanged: (value) => handleSearchValueChanged(value),
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
          ? const SizedBox()
          : data.when(
              data: (data) {
                List<Place> postList = data.map((e) => e).toList();
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: postList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) => InkWell(
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
                          child: SearchResultWidget(
                            searchController: searchController,
                            name: postList[index].name.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => Text(' hello: ${error.toString()}'),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
    );
  }

  void handleSearchValueChanged(String value) {
    ref.read(searchNotifierProvider.notifier).sendQuery(value.trimLeft());
    ref.read(searchUserProvider);
    if (value.isEmpty) {
      ref.read(searchNotifierProvider.notifier).clear();
      ref.refresh(searchLoadingProvider.notifier).state = false;
    } else {
      ref.refresh(searchLoadingProvider.notifier).state = true;
    }
  }
}
