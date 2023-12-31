// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import '../../core/res/image_res.dart';
import '../pages/search_bar_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final languageText=AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      ),
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
                  languageText!.container_text,
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
