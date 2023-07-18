import 'package:flutter/material.dart';

import '../pages/search_bar_page.dart';
import '../utils/kcolors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      ),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        height: 46,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: kSecodaryColor.withOpacity(0.3),
        ),
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.search, color:Colors.black),
            ),
            Row(
              children:[
                Text('جستجوی در', style: TextStyle(color: Colors.black, fontSize:15.0)),
                SizedBox(width: 5,),
                Text('آسان یاب', style: TextStyle(color: Colors.red , fontSize: 18.0),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
