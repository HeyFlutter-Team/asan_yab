// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../model/favorite.dart';
import '../utils/convert_digits_to_farsi.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final items = favorites[index];
          final phoneNumber = convertDigitsToFarsi(items.phone);
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
                      Container(
                        height: 130.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                          image: DecorationImage(
                            image: AssetImage(items.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        items.name,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await FlutterPhoneDirectCaller.callNumber(
                            items.phone,
                          );
                        },
                        label: Text(
                          phoneNumber,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        ),
                        icon: Icon(Icons.call, color: Colors.green),
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
        },
      ),
    );
  }
}
