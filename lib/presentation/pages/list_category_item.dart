import 'package:asan_yab/domain/riverpod/config/internet_connectivity_checker.dart';
import 'package:asan_yab/presentation/pages/search_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/utils.dart';
import '../widgets/category_item.dart';

class ListCategoryItem extends ConsumerWidget {
  final String catId;
  final String categoryName;

  const ListCategoryItem(
      {super.key, required this.catId, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('is exist $catId');
    return PopScope(
      onPopInvoked: (didPop) {},
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            categoryName,
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
                  // color: Colors.black,
                  size: 25,
                ))
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, size: 25.0),
          ),
        ),
        body: Utils.netIsConnected(ref)
            ? CategoryItem(id: catId)
        :const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
