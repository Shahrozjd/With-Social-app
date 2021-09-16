import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/octicons_icons.dart';

import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/chat_page.dart';
import 'package:with_app/pages/users_profile_page.dart';
import 'package:with_app/styles/styles.dart';

class FriendsPage extends StatefulWidget {
  static const String id = "FriendsPage";

  const FriendsPage({Key key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: EdgeInsets.all(10),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FireCollection().userId)
              .collection('friends')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CustomLoading(),
              );
            }
            if (snapshot.data.size == 0) {
              return Center(
                child: Text(
                  'No Friends',
                  style: cTextStyleMedium,
                ),
              );
            }
            return ListView(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.all(0),
              children: snapshot.data.docs.map(
                (DocumentSnapshot document) {
                  return ProfileCard(
                    userId: document['friendId'],
                  );
                },
              ).toList(),
            );
          }),
    );
  }
}

class ProfileCard extends StatefulWidget {
  final String userId;
  ProfileCard({
    this.userId,
  });

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String name;
  String email;
  String img;
  bool isLoading = false;

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .get()
        .then(
      (DocumentSnapshot snapshot) {
        setState(() {
          name = snapshot['firstName'] + " " + snapshot["lastName"];
          email = snapshot['email'];
          img = snapshot['image'];

          isLoading = false;
        });
      },
    );
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: isLoading
          ? CustomLoading()
          : InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersProfilePage(
                      uid: widget.userId,
                    ),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    height: 65.0,
                    width: 65.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                      image: DecorationImage(
                        image: NetworkImage(img),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5.0,
                            offset: Offset(3, 3),
                            spreadRadius: 1.0)
                      ],
                    ),
                    duration: Duration(milliseconds: 400),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: cTextStyleBold,
                            ),
                            Text(
                              email,
                              style: cTextStyle,
                            )
                          ],
                        ),
                        IconButton(
                          color: Theme.of(context).primaryColor,
                          iconSize: 35,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => chatscreen(
                                  recvrId: widget.userId,
                                  recvremail: email,
                                  recvrimg: img,
                                  recvrname: name,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.message),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
