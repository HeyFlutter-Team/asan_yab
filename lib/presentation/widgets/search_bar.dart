import 'package:flutter/material.dart';

class TextSearchBar extends StatelessWidget {
  const TextSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        autofocus: true,
        style: const TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
          filled: true,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          hintText: 'جستجو ',
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
