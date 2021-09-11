import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/edit_profile_page.dart';
import 'package:with_app/pages/login_page.dart';
import 'package:with_app/pages/user_timeline_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'ProfilePage';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(),
                ),
              );
            },
            icon: Icon(
              FontAwesome.edit,
              size: 35,
              color: CustomColor.primaryColor,
            ),
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FireCollection().userDoc().snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return Container(
            child: Stack(
              children: [
                Hero(
                  tag: 'imgTag',
                  child: AnimatedContainer(
                    height: Styles.height(context) * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: snapshot.data['image'] == 'n/a'
                            ? AssetImage(
                                "assets/images/upload_img.png",
                              )
                            : snapshot.data['image'] != null
                                ? NetworkImage(snapshot.data['image'])
                                : AssetImage(
                                    "assets/images/upload_img.png",
                                  ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    duration: Duration(milliseconds: 1000),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: Styles.height(context) * 0.35,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 30,
                            offset: Offset(0, -3),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${snapshot.data['firstName']} ${snapshot.data['lastName']}",
                            style: cTextStyleLargeBold,
                          ),
                          Text(
                            snapshot.data['email'],
                            style: cTextStyleBold,
                          ),
                          AutoSizeText(
                            snapshot.data['about'],
                            style: cTextStyleMedium,
                            maxLines: 2,
                          ),
                          RoundRectButtonCustom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            text: 'My Feed',
                            height: 40,
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserTimelinePage(),
                                ),
                              );
                            },
                          ),
                          RoundRectButtonCustom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            text: 'Logout',
                            height: 40,
                            onPress: () {
                              GoogleSignIn().signOut();
                              FirebaseAuth.instance.signOut();
                              pushNewScreen(
                                context,
                                screen: LoginPage(),
                                withNavBar: false,
                              );
                              Navigator.pushReplacementNamed(
                                  context, LoginPage.id);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
