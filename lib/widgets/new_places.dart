import 'package:asan_yab/pages/detials_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import '../database/firebase_helper/place.dart';

import '../providers/places_provider.dart';
import '../utils/convert_digits_to_farsi.dart';
import '../constants/kcolors.dart';
import 'package:dots_indicator/dots_indicator.dart';

class NewPlaces extends StatefulWidget {
  const NewPlaces({super.key});
  @override
  State<NewPlaces> createState() => _NewPlacesState();
}

class _NewPlacesState extends State<NewPlaces> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: Provider.of<PlaceProvider>(context).getplaces(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
                strokeWidth: 5,
              ),
            );
          } else if (snapshot.hasData) {
            List<Place> places = snapshot.data ?? [];

            return places.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueGrey,
                        strokeWidth: 5,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      CarouselSlider.builder(
                        itemCount: places.length >= 5 ? 5 : places.length,
                        itemBuilder: (context, index, realIndex) {
                          final phoneNumberItems =
                              places[index].adresses[0].phone;
                          final items = places[index];
                          final phoneNumber =
                              convertDigitsToFarsi(phoneNumberItems);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsPage(id: places[index].id),
                                ),
                              );
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  // ClipRRect(
                                  //   borderRadius: BorderRadius.circular(12),
                                  //   child: Image.network(
                                  //     items.coverImage,
                                  //     fit: BoxFit.cover,
                                  //     height: double.infinity,
                                  //     width: double.infinity,
                                  //   ),
                                  // ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          Image.asset('assets/asan_yab.png'),
                                      imageUrl: items.coverImage,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    right: 40,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            items.name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        phoneNumber.isEmpty
                                            ? const SizedBox()
                                            : OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.black
                                                      .withOpacity(0.3),
                                                  elevation: 4,
                                                ),
                                                onPressed: () async {
                                                  await FlutterPhoneDirectCaller
                                                      .callNumber(phoneNumber);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(phoneNumber),
                                                    const Icon(
                                                      Icons.phone_android,
                                                      color: Colors.green,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: screenHeight * 0.25,
                          enlargeCenterPage: true,
                          reverse: false,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 500),
                          viewportFraction: 1,
                          onPageChanged: (index, reson) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),
                      Positioned(
                          bottom: 30,
                          left: 35,
                          child: DotsIndicator(
                            dotsCount: places.length >= 5 ? 5 : places.length,
                            position: currentIndex,
                            decorator: DotsDecorator(
                              size: const Size.square(9.0),
                              activeSize: const Size(18.0, 9.0),
                              activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              color: Colors.white30,
                              activeColor: Colors.white,
                            ),
                          )),
                    ],
                  );
          }
          return const SizedBox();
        });
  }
}
