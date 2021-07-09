import 'package:flutter/material.dart';

class CustomColor{
  static const Color primaryColor = Color(0xFF0059D4);
  static const Color secColor = Color(0xFF2D86FF);

  static var primaryGradient = LinearGradient(
    colors: [
      primaryColor,
      secColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

}