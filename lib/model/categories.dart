// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Categories {
  final IconData iconProduct;
  final String titleProduct;
  final String subtitleProduct;

  const Categories(
      {required this.iconProduct,
      required this.titleProduct,
      required this.subtitleProduct});
}

final listOfCategories = [
  Categories(
      iconProduct: Icons.restaurant,
      titleProduct: 'رستورانت',
      subtitleProduct: 'نوید رستورانت'),
  Categories(
      iconProduct: Icons.local_hospital,
      titleProduct: 'شفاخانه',
      subtitleProduct: 'شفاخانه مفید'),
  Categories(
      iconProduct: Icons.computer,
      titleProduct: 'کامپیوتر',
      subtitleProduct: 'فهیم کامپیوتر'),
  Categories(
      iconProduct: Icons.icecream_rounded,
      titleProduct: 'آیسکریم',
      subtitleProduct: 'هرات آیسکریم'),
  Categories(
      iconProduct: Icons.sports_gymnastics_sharp,
      titleProduct: 'جمناستیک',
      subtitleProduct: 'آریانا جمناستیک'),
  Categories(
      iconProduct: Icons.sports_soccer_rounded,
      titleProduct: 'فوتبال',
      subtitleProduct: 'انصاری فوتبال'),
  Categories(
      iconProduct: Icons.park,
      titleProduct: 'پارک',
      subtitleProduct: 'پارک فرهنگ'),
  Categories(
      iconProduct: Icons.phone,
      titleProduct: 'موبایل',
      subtitleProduct: 'گالری موبایل')
];
