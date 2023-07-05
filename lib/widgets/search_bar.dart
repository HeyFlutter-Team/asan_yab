// ignore_for_file: prefer_const_constructors, camel_case_types, non_constant_identifier_names

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
        style: TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
          filled: true,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: 'جستجو ',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
