// ignore_for_file: unused_import, prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class NewPlaces extends StatelessWidget {
  const NewPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black.withOpacity(0.5),
            ),
            child: TitleOfNewPlace(
              title: 'رستورانت',
              subTitle: 'نوید رستورانت',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black.withOpacity(0.5),
            ),
            child: TitleOfNewPlace(
              title: 'شفاخانه',
              subTitle: 'شفاخانه مفید',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black.withOpacity(0.5),
            ),
            child:
                TitleOfNewPlace(title: 'کامپیوتر', subTitle: 'فهیم کامپیوتر'),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/4.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black.withOpacity(0.5),
              ),
              child: TitleOfNewPlace(title: 'آسکریم', subTitle: 'هرات آسکریم')),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/5.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black.withOpacity(0.5),
              ),
              child: TitleOfNewPlace(
                  title: 'جمناستیک', subTitle: 'آریانا جمناستیک')),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.5),
            image: const DecorationImage(
              image: AssetImage('assets/6.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black.withOpacity(0.5),
              ),
              child:
                  TitleOfNewPlace(title: 'فوتبال', subTitle: 'انصاری فوتبال')),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/7.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black.withOpacity(0.5),
            ),
            child: TitleOfNewPlace(title: 'پارک', subTitle: 'پارک فرهنگ'),
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

class TitleOfNewPlace extends StatelessWidget {
  final String title;
  final String subTitle;
  const TitleOfNewPlace({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        Center(
          child: Text(
            subTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }
}
