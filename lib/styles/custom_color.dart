import 'package:flutter/material.dart';

class CustomColor{
  static const Color primaryColor = Color(0xFF303F9F);
  static const Color secColor = Color(0xFF3F51B5);

  static var primaryGradient = LinearGradient(
    colors: [
      primaryColor,
      secColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

}