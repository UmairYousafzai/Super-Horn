import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  double get h => MediaQuery.of(this).size.height; // Height
  double get w => MediaQuery.of(this).size.width; // Width

  double mqH(double percentage) => h * percentage; // Height percentage
  double mqW(double percentage) => w * percentage; // Width percentage
}
