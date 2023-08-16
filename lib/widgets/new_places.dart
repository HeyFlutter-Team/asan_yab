import 'package:asan_yab/pages/detials_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../database/firebase_helper/place.dart';

import '../providers/places_provider.dart';
import '../utils/convert_digits_to_farsi.dart';

class NewPlaces extends StatefulWidget {
  final RefreshCallback onRefresh;
  const NewPlaces({super.key, required this.onRefresh});
  @override
  State<NewPlaces> createState() => _NewPlacesState();
}

class _NewPlacesState extends State<NewPlaces> {
  final CarouselController pageController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: FutureBuilder(
          future:
              Provider.of<PlaceProvider>(context, listen: false).getplaces(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else if (snapshot.hasData) {
              List<Place> places = snapshot.data ?? [];
              debugPrint('new places invoke');
              return places.isEmpty
                  ? const Center(
                      child: Text('Null'),
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
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.3),
                                                    elevation: 4,
                                                  ),
                                                  onPressed: () async {
                                                    await FlutterPhoneDirectCaller
                                                        .callNumber(
                                                            phoneNumber);
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
                          carouselController: pageController,
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
                            onPageChanged: (index, reason) {
                              Provider.of<PlaceProvider>(context, listen: false)
                                  .currentIndex = index;
                            },
                          ),
                        ),
                        Positioned(
                            bottom: 30,
                            left: 35,
                            child: AnimatedSmoothIndicator(
                              count: places.length >= 5 ? 5 : places.length,
                              activeIndex: Provider.of<PlaceProvider>(context,
                                      listen: true)
                                  .currentIndex,
                              effect: const ExpandingDotsEffect(
                                dotHeight: 12,
                                dotWidth: 12,
                                activeDotColor: Colors.white,
                                dotColor: Colors.white30,
                              ),
                            )),
                      ],
                    );
            }
            return const SizedBox();
          }),
    );
  }
}