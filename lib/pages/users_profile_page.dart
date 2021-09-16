import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class UsersProfilePage extends StatefulWidget {
  static const String id = 'UsersProfilePage';
  final String uid;

  UsersProfilePage({this.uid});

  @override
  _UsersProfilePageState createState() => _UsersProfilePageState();
}

class _UsersProfilePageState extends State<UsersProfilePage> {
  bool isSent = false;
  bool isLoading = false;
  bool isFriend = false;

  Future<void> checkIsFriend(String userId) async {
    isLoading = true;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("users")
        .doc(FireCollection().userId)
        .collection("friends");

    await collectionReference.get().then<dynamic>((doc) {
      if (doc != null) {
        doc.docs.forEach(
          (value) {
            if (value['friendId'] == userId) {
              setState(() {
                isFriend = true;
                isLoading = false;
              });
            }
          },
        );
      }
    });
  }

  Future<void> checkRequestExist(String userId) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("users")
        .doc(FireCollection().userId)
        .collection("requests");

    await collectionReference.get().then<dynamic>((doc) {
      if (doc != null) {
        doc.docs.forEach(
          (value) {
            if (value['userId'] == userId) {
              setState(() {
                isSent = true;
              });
            }
          },
        );
      }
    });
  }

  @override
  void initState() {
    checkIsFriend(widget.uid);
    checkRequestExist(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
            // checkRequestExist(widget.uid);
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.data != null) {
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
                              snapshot.data['email'] !=
                                      FirebaseAuth.instance.currentUser.email
                                  ? RoundRectButtonCustom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      height: 40,
                                      text: isFriend
                                          ? "Friends"
                                          : isSent
                                              ? 'Request Sent'
                                              : "Add Friend",
                                      onPress: () {
                                        if (isFriend) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text("Friends"),
                                            ),
                                          );
                                        } else if (isSent) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text("Request Sent Already"),
                                            ),
                                          );
                                        } else {
                                          sendFriendRequest(snapshot.data.id,
                                              snapshot.data['email']);
                                        }
                                      },
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  'No Profile Data',
                  style: cTextStyleMedium,
                ),
              );
            }

            return Center(
              child: CustomLoading(),
            );
          },
        ),
      ),
    );
  }

  Future<void> sendFriendRequest(String firendId, String friendEmail) async {
    setState(() {
      isLoading = true;
    });

    print("USERID" + FireCollection().userId);
    DocumentReference recReference = FirebaseFirestore.instance
        .collection('users')
        .doc(firendId)
        .collection('requests')
        .doc();
    DocumentReference sentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FireCollection().userId)
        .collection('requests')
        .doc();

    await recReference.set(
      {
        'userId': FireCollection().userId,
        'type': 'recieved',
        'status': 'waiting',
        'email': FirebaseAuth.instance.currentUser.email,
        'sentId': sentReference.id,
      },
    ).then((value) {
      print('Request sent');
    }).catchError((e) {
      print('Error sending request');
    });

    await sentReference.set(
      {
        'userId': firendId,
        'type': 'sent',
        'status': 'waiting',
        'email': friendEmail,
        'recId': recReference.id,
      },
    ).then((value) {
      setState(() {
        isSent = true;
        isLoading = false;
      });
      print('Request sent data saved');
    }).catchError((e) {
      print('Error saving sending request data');
    });
  }
}
