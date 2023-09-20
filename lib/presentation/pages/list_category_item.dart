import 'package:asan_yab/presentation/pages/search_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/screen/loading_circularPRI_provider.dart';
import '../widgets/category_item.dart';

class ListCategoryItem extends ConsumerWidget {
  final String catId;
  final String categoryName;

  const ListCategoryItem(
      {super.key, required this.catId, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            categoryName,
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 25,
                ))
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(loadingProvider.notifier).state =
                  !ref.watch(loadingProvider);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25.0),
          ),
        ),
        body: CategoryItem(id: catId),
      ),
    );
  }
}
