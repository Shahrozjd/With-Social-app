import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:with_app/styles/custom_color.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("With",style: GoogleFonts.mPlusRounded1c(fontSize: 50,color: CustomColor.primaryColor),)

            ],
          ),
        ),
      ),
    );
  }
}
