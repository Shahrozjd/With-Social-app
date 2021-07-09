import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:with_app/pages/home_page.dart';
import 'package:with_app/pages/login_page.dart';
import 'package:with_app/styles/custom_color.dart';

class BottomBarPage extends StatefulWidget {
  static const String id = "bottom_bar_page";

  @override
  _BottomBarPageState createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  FirebaseAuth auth;
  int currindex = 0;
  final List<Widget> children = [
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: CustomColor.primaryColor,
        height: 40,
        elevation: 3,
        activeColor: CustomColor.secColor,
        items: [
          TabItem(
            icon: Icon(
              Icons.home,
              size: 25,
              color: Colors.grey[400],
            ),
            activeIcon: Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
          ),
          TabItem(
            icon: Icon(
              Icons.map,
              size: 25,
              color: Colors.grey[400],
            ),
            activeIcon: Icon(
              Icons.map,
              size: 30,
              color: Colors.white,
            ),
          ),
          TabItem(
            icon: Icon(
              FontAwesome.user,
              size: 25,
              color: Colors.grey[400],
            ),
            activeIcon: Icon(
              FontAwesome.user,
              size: 30,
              color: Colors.white,
            ),
          ),
          TabItem(
            icon: Icon(
              Icons.add,
              size: 25,
              color: Colors.grey[400],
            ),
            activeIcon: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
        initialActiveIndex: 2,
        //optional, default as 0
        onTap: (int i) => print('click index=$i'),
      ),
      body: children[currindex],
    );
  }
}
