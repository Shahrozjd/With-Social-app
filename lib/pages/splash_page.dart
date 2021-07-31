import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:with_app/pages/bottom_bar_page.dart';
import 'package:with_app/pages/home_page.dart';
import 'package:with_app/pages/login_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class SplashPage extends StatefulWidget {
  static const String id = 'splash_page';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  //Your animation controller
  AnimationController _controller;
  Animation _animation;
  FirebaseAuth auth;


  Future<void> checkLogin() {
    auth = FirebaseAuth.instance;
    User loggedInUser;
    final user = auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      if (loggedInUser.email != null) {
        Navigator.pushReplacementNamed(context, BottomBarPage.id);
      }
    }
    else {
      Navigator.pushReplacementNamed(context, LoginPage.id);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    //Implement animation here
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    Timer(Duration(milliseconds: 2500), () => checkLogin());

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: CustomColor.primaryGradient,
        ),
        child: Center(
            child: FadeTransition(
                //Use your animation here
                opacity: _animation,
                child: SizedBox(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                        tag: "tagImg",
                        child: Image.asset(
                          "assets/images/branch_leaves.png",
                          height: Styles.height(context) * 0.2,
                        )),
                    SizedBox(
                      width: Styles.width(context) * 0.02,
                    ),
                    Text(
                      "With",
                      style: GoogleFonts.mPlusRounded1c(
                          fontSize: Styles.width(context) * 0.25,
                          color: Colors.white),
                    ),
                  ],
                )))),
      ),
    );
  }
}
