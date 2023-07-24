
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import '../database/firebase_helper/place.dart';
import '../model/favorite.dart';
import '../providers/places_provider.dart';
import '../utils/convert_digits_to_farsi.dart';
import '../constants/kcolors.dart';

class NewPlaces extends StatefulWidget {
  const NewPlaces({super.key});

  @override
  State<NewPlaces> createState() => _NewPlacesState();
}

class _NewPlacesState extends State<NewPlaces> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final carouselController = CarouselController();
    final screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future:Provider.of<PlaceProvider>(context).getPlaces(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<Place> category = snapshot.data ?? [];
            return Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: 1,
                  itemBuilder: (context, index, realIndex) {
                    final phoneNumberItems =
                        category[index].adresses[index].phone;
                    final items = category[index];
                    final phoneNumber = convertDigitsToFarsi(phoneNumberItems);
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage(items.coverImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60, right: 10, left:150),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items.name!,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 24.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await FlutterPhoneDirectCaller.callNumber(
                                        phoneNumber);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        phoneNumber,
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.phone_android,
                                        color: Colors.green,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight * 0.25,
                    enlargeCenterPage: true,
                    reverse: false,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                    viewportFraction: 1,
                    onPageChanged: (index, reson) {
                      setState(
                        () {
                          currentIndex = index;
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 25,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: favorites.asMap().entries.map((entries) {
                      return GestureDetector(
                        onTap: () =>
                            carouselController.animateToPage(entries.key),
                        child: Container(
                          width: currentIndex == entries.key ? 7 : 7,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: currentIndex == entries.key
                                ? Colors.white
                                : Colors.white30,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        });
  }
}
