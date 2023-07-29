// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Category {
  final IconData icon;
  final String title;
  final String subtitle;

  const Category({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

final listOfCategories = [
  Category(
    icon: Icons.restaurant,
    title: ' تبتلسنیتبسیرستورانت',
    subtitle: ' سیشبتسیب نوید رستورانت',
  ),
  Category(
    icon: Icons.local_hospital,
    title: 'شفاخانه شیسبسیشبتکن',
    subtitle: 'شفاخانه مفیدت شسیبتسیشب ',
  ),
  Category(
    icon: Icons.computer,
    title: 'یسشبسیبنت کامپیوتر',
    subtitle: 'یبسشبنتسیشب فهیم کامپیوتر',
  ),
  Category(
    icon: Icons.icecream_rounded,
    title: ' یشسبتسیشکتبن آیسکریم',
    subtitle: 'بسیمبتنستینب هرات آیسکریم',
  ),
  Category(
    icon: Icons.sports_gymnastics_sharp,
    title: 'سیبنسشیتب جمناستیک',
    subtitle: 'یسشنمستیبسی آریانا جمناستیک',
  ),
  Category(
    icon: Icons.sports_soccer_rounded,
    title: 'یشسبتسیشب فوتبال',
    subtitle: 'یسبنتشسیشب انصاری فوتبال',
  ),
  Category(
    icon: Icons.park,
    title: 'یسبنمتشیب پارک',
    subtitle: 'یسبنتئسیشنب پارک فرهنگ',
  ),
  Category(
    icon: Icons.phone,
    title: 'موبایل سیشبنتنسیشب ',
    subtitle: 'نسیشبتنسی گالری موبایل',
  )
];
