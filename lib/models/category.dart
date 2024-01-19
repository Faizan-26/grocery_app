import 'package:flutter/material.dart';

enum Categories {
  fruits,//
  vegetables,//
  dairy,//
  bakery,
  meat,//
  fruit,//
  carbs,//
  spices,//
  sweets,//
  hygiene,//
  convenience,//
  other,//
}

class Category {
  Category(this.name, this.color);

  final String name;
  final Color color;
}
