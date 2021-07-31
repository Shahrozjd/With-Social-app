import 'package:flutter/material.dart';

class CustomColor{
  static const Color primaryColor = Color(0xFF0059D4);
  static const Color secColor = Color(0xFF00c853);

  static var primaryGradient = LinearGradient(
    colors: [
      secColor,
      primaryColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

}