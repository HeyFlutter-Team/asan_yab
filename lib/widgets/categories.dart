import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database/firebase_helper/category.dart';
import '../model/category.dart';
import '../pages/list_category_item.dart';
import '../utils/kcolors.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection('Categories')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text('Loading...');
      }
      if (snapshot.hasData) {
        List<CategoryData> category = snapshot.data!.docs
            .map((doc) => CategoryData.fromJson(doc.data()))
            .toList();
        return
          SizedBox(
            height: screenHeight * 0.2,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: category.length,
              itemBuilder: (context, index) {

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                           ListCategoryItem(
                            categoryNameCollection: category[index].categoryName!,)));
                    },
                    child: Container(
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.4,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12) , color: Color(int.parse((category[index].color!.replaceAll('#', '0xff')))).withOpacity(0.6),),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconData(int.parse(category[index].iconCode!) ,fontFamily: 'MaterialIcons'), color: kPrimaryColor, size: 45.0),
                          const SizedBox(height: 4),
                          Text(category[index].categoryName as String,
                              style: TextStyle(color: kPrimaryColor)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
      } else {
        return const SizedBox(height: 0,);
      }
    });

  }
}
