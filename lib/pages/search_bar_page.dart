import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import 'detials_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context);
    final searchResults = provider.searchResult;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.blue,
        backgroundColor: Theme.of(context).primaryColor,
        title: TextFormField(
            controller: provider.search,
            autofocus: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'جستجو ',
            ),
            onChanged: (value) {
              provider.setSearchQuery(value);
              provider.performSearch();
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: provider.search.text.isNotEmpty
                ? IconButton(
                    onPressed: () => provider.search.clear(),
                    icon: const Icon(
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
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final items = searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  places: searchResults[index],
                                ),
                              ),
                            );
                          },
                          title: Text(
                            items.name!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(items.logo!),
                          ),
                        ),
                      );
                    },
                    itemCount: searchResults.length,
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
