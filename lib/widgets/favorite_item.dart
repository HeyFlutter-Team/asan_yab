import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../database/firebase_helper/place.dart';
import '../model/favorite.dart';
import '../pages/detials_page.dart';
import '../utils/convert_digits_to_farsi.dart';
import '../utils/kcolors.dart';

class FavoriteItem extends StatelessWidget {
  final String categoryNameCollection;
  const FavoriteItem({super.key, required this.categoryNameCollection});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(categoryNameCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          } else if (snapshot.hasData) {
            List<Place> places = snapshot.data!.docs
                .map((doc) => Place.fromJson(doc.data()))
                .toList();
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  places: places[index],
                                ),
                              ));
                        },
                        child: Container(
                          height: screenHeight * 0.17,
                          width: screenWidth * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage('${places[index].logo}'),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40.0,
                          right: 15.0,
                        ),
                        child: Column(
                          children: [
                            Text(
                              places[index].name!,
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () async {
                                await FlutterPhoneDirectCaller.callNumber( places[index].adresses[0].phone);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    places[index].adresses[0].phone,
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const Icon(Icons.call, color: Colors.teal),
                                ],
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
          } else {
            return const SizedBox(
              height: 0,
            );
          }
        });
  }
}
