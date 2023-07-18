import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  final lazyLoadingController = ScrollController();

  @override
  void initState() {
    super.initState();
    lazyLoadingController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (lazyLoadingController.position.pixels ==
        lazyLoadingController.position.maxScrollExtent) {
      Provider.of<SearchProvider>(context, listen: false).fetchLazyLoading();
    }
  }

  @override
  void dispose() {
    lazyLoadingController.removeListener(_scrollListener);
    lazyLoadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.blue,
        backgroundColor: Theme.of(context).primaryColor,
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'جستجو ',
          ),
          onChanged: (value) {
            searchProvider.searchItems(value);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: searchController.text.isNotEmpty
                ? InkWell(
                    onTap: () => searchController.clear(),
                    child: const Icon(
                      Icons.cancel,
                      size: 28.0,
                      color: Colors.black,
                    ),
                  )
                : null,
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30.0,
          ),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, value, child) {
          if (searchProvider.lazyLoading.isEmpty) {
            return Center(
              child: Image.asset('assets/noInfo.jpg'),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: lazyLoadingController,
                    itemCount: searchProvider.lazyLoading.length,
                    itemBuilder: (context, index) {
                      final items = searchProvider.lazyLoading[index];
                      return ListTile(
                        onTap: () {},
                        title: Text(
                          items.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20.0),
                        ),
                        subtitle: Text(
                          items.phone,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 15.0),
                        ),
                      );
                    },
                  ),
                ),
                if (searchProvider.isloading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: CircularProgressIndicator(color: Colors.teal),
                  )
              ],
            );
          }
        },
      ),
    );
  }
}
