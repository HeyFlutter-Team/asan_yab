import 'package:flutter/material.dart';

import '../widgets/custom_search_bar.dart';
import '../widgets/favorite_item.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: SizedBox(
          width: screenWidth * 0.99,
          child: const CustomSearchBar(),
        ),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30.0,
            )),
      ),
      body: ListView(
        shrinkWrap: true,
        children: const [
          FavoriteItem(),
        ],
      ),
    );
  }
}
