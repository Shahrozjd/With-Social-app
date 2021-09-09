import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/edit_profile_page.dart';
import 'package:with_app/pages/login_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class UsersProfilePage extends StatefulWidget {
  static const String id = 'UsersProfilePage';
  String uid;

  UsersProfilePage({this.uid});

  @override
  _UsersProfilePageState createState() => _UsersProfilePageState();
}

class _UsersProfilePageState extends State<UsersProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: CustomColor.secColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return Container(
            child: Stack(
              children: [
                snapshot.data['image'] == 'n/a'
                    ? Center(
                        child: Icon(
                          FontAwesome.user,
                          size: 45,
                        ),
                      )
                    : AnimatedContainer(
                        height: Styles.height(context) * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        duration: Duration(milliseconds: 1000),
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: Styles.height(context) * 0.3,
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
                          snapshot.data['email']!= FirebaseAuth.instance.currentUser.email? RoundRectButtonCustom(
                            backgroundColor: Theme.of(context).primaryColor,
                            height: 40,
                            text: "Add Friend",
                            onPress: () {

                            },
                          ):SizedBox(),
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
