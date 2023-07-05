// ignore_for_file: unused_import, prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: const DecorationImage(
                  image: AssetImage('images/1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 30.0,
              child: Container(
                color: Colors.red,
                height: 100.0,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('images/2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('images/3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('images/4.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('images/5.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('images/6.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('images/7.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }
}
