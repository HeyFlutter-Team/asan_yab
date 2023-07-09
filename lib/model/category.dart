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
      icon: Icons.restaurant, title: 'رستورانت', subtitle: 'نوید رستورانت'),
  Category(
    icon: Icons.local_hospital,
    title: 'شفاخانه',
    subtitle: 'شفاخانه مفید',
  ),
  Category(
    icon: Icons.computer,
    title: 'کامپیوتر',
    subtitle: 'فهیم کامپیوتر',
  ),
  Category(
      icon: Icons.icecream_rounded, title: 'آیسکریم', subtitle: 'هرات آیسکریم'),
  Category(
    icon: Icons.sports_gymnastics_sharp,
    title: 'جمناستیک',
    subtitle: 'آریانا جمناستیک',
  ),
  Category(
    icon: Icons.sports_soccer_rounded,
    title: 'فوتبال',
    subtitle: 'انصاری فوتبال',
  ),
  Category(
    icon: Icons.park,
    title: 'پارک',
    subtitle: 'پارک فرهنگ',
  ),
  Category(
    icon: Icons.phone,
    title: 'موبایل',
    subtitle: 'گالری موبایل',
  )
];
