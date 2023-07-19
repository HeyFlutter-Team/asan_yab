import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database/firebase_helper/category.dart';
import '../model/category.dart';
import '../utils/kcolors.dart';
import 'list_category_item.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'دسته بندی ها',
          style: TextStyle(color: kSecodaryColor),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Loading...');
      }
      if (snapshot.hasData) {
        List<CategoryData> category = snapshot.data!.docs
            .map((doc) => CategoryData.fromJson(doc.data()))
            .toList();
        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  mainAxisExtent: 200.0,
                ),
                itemCount: category.length,
                itemBuilder: (context, index) {

                  return GestureDetector(
                    onTap: () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListCategoryItem(categoryNameCollection: category[index].categoryName!,)),
                        ),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12) , color: Color(int.parse((category[index].color!.replaceAll('#', '0xff')))).withOpacity(0.6),),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconData(int.parse(category[index].iconCode!) ,fontFamily: 'MaterialIcons'),
                            size: 40.0,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            category[index].categoryName!,
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );
      }else{return const SizedBox(height: 0,);}
    })

    );
  }
}
