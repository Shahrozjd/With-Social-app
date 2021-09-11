import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:with_app/pages/add_page.dart';
import 'package:with_app/pages/bottom_bar_page.dart';
import 'package:with_app/pages/edit_profile_page.dart';
import 'package:with_app/pages/home_page.dart';
import 'package:with_app/pages/login_page.dart';
import 'package:with_app/pages/profile_page.dart';
import 'package:with_app/pages/signup_page.dart';
import 'package:with_app/pages/splash_page.dart';
import 'package:with_app/pages/timeline_page.dart';
import 'package:with_app/pages/user_timeline_page.dart';
import 'package:with_app/styles/custom_color.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'With',
      theme: ThemeData.light().copyWith(
        primaryColor: CustomColor.primaryColor,
        textTheme: ThemeData.light().textTheme,
        backgroundColor: Color(0xFFFAFAFA),
      ),
      initialRoute: SplashPage.id,
      routes: {
        HomePage.id: (context)=>HomePage(),
        SplashPage.id: (context)=>SplashPage(),
        LoginPage.id:(context)=>LoginPage(),
        SignUpPage.id:(context)=>SignUpPage(),
        BottomBarPage.id:(context)=>BottomBarPage(),
        TimelinePage.id:(context)=>TimelinePage(),
        ProfilePage.id:(context)=>ProfilePage(),
        AddPage.id:(context)=>AddPage(),
        UserTimelinePage.id:(context)=>UserTimelinePage(),
        EditProfilePage.id:(context)=>EditProfilePage(),
      },
    );
  }
}

