import 'package:asan_yab/pages/search_bar_page.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/category_item.dart';

class ListCategoryItem extends StatefulWidget {
  final String catId;
  final String categoryName;

  const ListCategoryItem(
      {super.key, required this.catId, required this.categoryName});

  @override
  State<ListCategoryItem> createState() => _ListCategoryItemState();
}

class _ListCategoryItemState extends State<ListCategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.categoryName,
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25.0),
        ),
      ),
      body: CategoryItem(id: widget.catId),
    );
  }
}
