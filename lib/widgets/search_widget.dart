// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';

class searchWidget extends StatelessWidget {
  const searchWidget({
    super.key,
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
          hintText: 'Search Your Target',
          prefixIcon: Icon(
            Icons.search,
          ),
        ),
      ),
    );
  }
}
