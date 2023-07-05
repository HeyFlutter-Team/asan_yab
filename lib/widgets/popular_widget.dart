import 'package:flutter/material.dart';

import '../model/popular.dart';

class PopularWidget extends StatelessWidget {
  const PopularWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: popularList.length,
      itemBuilder: (context, index) {
        final items = popularList[index];
        return Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 10.0,
            bottom: 10.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * 0.2,
                width: screenWidth * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      items.imageUrl,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40.0,
                  top: 50.0,
                ),
                child: Column(
                  children: [
                    Text(
                      items.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      items.phone,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
