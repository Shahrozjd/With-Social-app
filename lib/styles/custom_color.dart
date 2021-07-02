import 'package:flutter/material.dart';

class CustomColor{
  static Color primaryColor = Color(0xFF303F9F);
  static Color secColor = Color(0xFF3F51B5);

  static var primaryGradient = LinearGradient(
    colors: [
      primaryColor,
      secColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

}