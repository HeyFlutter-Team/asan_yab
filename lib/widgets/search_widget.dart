// ignore_for_file: prefer_const_constructors, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';

class searchWidget extends StatelessWidget {
  final String Search;
  const searchWidget({
    super.key,
    required this.Search,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextField(
        autofocus: false,
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
          hintText: Search,
          prefixIcon: Icon(
            Icons.search,
          ),
        ),
      ),
    );
  }
}
