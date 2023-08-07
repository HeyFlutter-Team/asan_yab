import 'package:cached_network_image/cached_network_image.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchProvider>(context, listen: false).fetchAllPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context);
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
              provider.searchQuery = value;
              provider.performSearch(value);
              if (value.isEmpty) {
                provider.resetSearch();
              }
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: provider.search.text.isNotEmpty
                ? IconButton(
                    onPressed: () => provider.search.clear(),
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25.0),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, value, child) {
          if (provider.searchedPlacesItems.isEmpty) {
            return Center(
              child: Image.asset('assets/noInfo.jpg'),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: provider.searchedPlacesItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final items = provider.searchedPlacesItems[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          id: provider.searchedPlacesItems[index].id,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          imageUrl: items.logo,
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                          placeholder: (context, url) =>
                              Image.asset('assets/asan_yab.png'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          items.name!,
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
            );
          }
        },
      ),
    );
  }
}
