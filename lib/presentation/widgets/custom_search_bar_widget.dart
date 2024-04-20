// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/res/image_res.dart';

class CustomSearchBarWidget extends StatelessWidget {
  const CustomSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final text = texts(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => context.pushNamed(Routes.searchBar),
      child: Container(
        height: 46,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.withOpacity(0.3),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.search),
            ),
            Row(
              children: [
                Text(
                  text.container_text,
                  style: TextStyle(fontSize: 15.0),
                ),
                Image.asset(
                  ImageRes.asanYab,
                  fit: BoxFit.cover,
                  height: 90,
                  width: 90,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
