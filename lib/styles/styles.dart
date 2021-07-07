import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:flutter/material.dart';

// following theme data
var cTextStyleLarge = GoogleFonts.mPlusRounded1c(
  fontSize: 30,
);
var cTextStyleExLarge = GoogleFonts.mPlusRounded1c(
  fontSize: 40,
);
var cTextStyle = GoogleFonts.mPlusRounded1c(fontSize: 16);
var cTextStyleMedium = GoogleFonts.mPlusRounded1c(fontSize: 22);

var cTextStyleLargeAccent =
    GoogleFonts.mPlusRounded1c(fontSize: 30, color: CustomColor.primaryColor);
var cTextStyleExLargeAccent =
    GoogleFonts.mPlusRounded1c(fontSize: 40, color: CustomColor.primaryColor);
var cTextStyleAccent =
    GoogleFonts.mPlusRounded1c(fontSize: 16, color: CustomColor.primaryColor);
var cTextStyleMediumAccent =
    GoogleFonts.mPlusRounded1c(fontSize: 22, color: CustomColor.primaryColor);

var cTextStyleLargeWhite =
    GoogleFonts.mPlusRounded1c(fontSize: 30, color: Colors.white);
var cTextStyleExLargeWhite =
    GoogleFonts.mPlusRounded1c(fontSize: 40, color: Colors.white);
var cTextStyleWhite =
    GoogleFonts.mPlusRounded1c(fontSize: 16, color: Colors.white);
var cTextStyleMediumWhite =
    GoogleFonts.mPlusRounded1c(fontSize: 22, color: Colors.white);

var cTextStyleLargeBoldAccent = GoogleFonts.mPlusRounded1c(
    fontSize: 30, fontWeight: FontWeight.bold, color: CustomColor.primaryColor);
var cTextStyleBoldAccent = GoogleFonts.mPlusRounded1c(
    fontSize: 16, fontWeight: FontWeight.bold, color: CustomColor.primaryColor);
var cTextStyleMediumBoldAccent = GoogleFonts.mPlusRounded1c(
    fontSize: 22, fontWeight: FontWeight.bold, color: CustomColor.primaryColor);

var cTextStyleLargeBold =
    GoogleFonts.mPlusRounded1c(fontSize: 30, fontWeight: FontWeight.bold);
var cTextStyleBold =
    GoogleFonts.mPlusRounded1c(fontSize: 16, fontWeight: FontWeight.bold);
var cTextStyleMediumBold =
    GoogleFonts.mPlusRounded1c(fontSize: 22, fontWeight: FontWeight.bold);

var cTextStyleLargeThin =
    GoogleFonts.mPlusRounded1c(fontSize: 30, fontWeight: FontWeight.w400);
var cTextStyleThin =
    GoogleFonts.mPlusRounded1c(fontSize: 16, fontWeight: FontWeight.w400);
var cTextStyleMediumThin =
    GoogleFonts.mPlusRounded1c(fontSize: 22, fontWeight: FontWeight.w400);

class Styles {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
