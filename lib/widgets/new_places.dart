import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../model/favorite.dart';
import '../utils/convert_digits_to_farsi.dart';
import '../utils/kcolors.dart';

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

    return CarouselSlider.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index, realIndex) {
        final items = favorites[index];
        final phoneNumber = convertDigitsToFarsi(items.phone);
        return Stack(
          children: [
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(items.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
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
                    onTap: () => carouselController.animateToPage(entries.key),
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
            Positioned(
              top: 80.0,
              right: 25.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items.name,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber(items.phone);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          phoneNumber,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16.0,
                          ),
                        ),
                        const Icon(Icons.phone_android, color: Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
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
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          viewportFraction: 1,
          onPageChanged: (index, reson) {
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }
}
