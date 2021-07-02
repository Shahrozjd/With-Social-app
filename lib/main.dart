import 'package:flutter/material.dart';
import 'package:with_app/pages/home_page.dart';
import 'package:with_app/pages/splash_page.dart';
import 'package:with_app/styles/custom_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        primaryColor: CustomColor.primaryColor
      ),
      initialRoute: SplashPage.id,
      routes: {
        HomePage.id: (context)=>HomePage(),
        SplashPage.id: (context)=>SplashPage(),
      },
    );
  }
}

