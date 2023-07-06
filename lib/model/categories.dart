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
      titleProduct: 'Resturant',
      subtitleProduct: 'Navid Resturant'),
  Categories(
      iconProduct: Icons.local_hospital,
      titleProduct: 'Hospital',
      subtitleProduct: 'Mofed Hospital'),
  Categories(
      iconProduct: Icons.computer,
      titleProduct: 'Computer',
      subtitleProduct: 'Fahim Computer'),
  Categories(
      iconProduct: Icons.icecream_rounded,
      titleProduct: 'Icecream',
      subtitleProduct: 'Char Fasl'),
  Categories(
      iconProduct: Icons.sports_gymnastics_sharp,
      titleProduct: 'Sports Gymnastics',
      subtitleProduct: 'Almas'),
  Categories(
      iconProduct: Icons.sports_soccer_rounded,
      titleProduct: 'Soccer',
      subtitleProduct: 'Hemmat'),
  Categories(
      iconProduct: Icons.park,
      titleProduct: 'Park',
      subtitleProduct: 'farhang'),
  Categories(
      iconProduct: Icons.phone,
      titleProduct: 'Phone Shop',
      subtitleProduct: 'Gallry')
];
