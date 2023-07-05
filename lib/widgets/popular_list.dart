// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../model/popular.dart';

class PopularList extends StatelessWidget {
  const PopularList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
            mainAxisExtent: 230.0,
          ),
          itemCount: popularList.length,
          itemBuilder: (context, index) {
            final items = popularList[index];
            return Stack(
              children: [
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                          child: Image.asset(
                            items.imageUrl,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          items.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          items.phone,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  top: 10.0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
