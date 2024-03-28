import 'package:flutter/material.dart';

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget({
    super.key,
    required this.searchController,
    required this.name,
  });

  final TextEditingController searchController;
  final String name;

  @override
  Widget build(BuildContext context) {
    final startIndex =
        name.toLowerCase().indexOf(searchController.text.toLowerCase());

    if (startIndex == -1) {
      return Text(name);
    }

    final endIndex = startIndex + searchController.text.length;
    final beforeMatch = name.substring(0, startIndex);
    final match = name.substring(startIndex, endIndex);
    final afterMatch = name.substring(endIndex);

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 20.0),
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }
}
