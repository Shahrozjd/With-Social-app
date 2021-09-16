import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

import '../users_profile_page.dart';

class SentReqPage extends StatefulWidget {
  const SentReqPage({Key key}) : super(key: key);

  @override
  _SentReqPageState createState() => _SentReqPageState();
}

class _SentReqPageState extends State<SentReqPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Styles.height(context),
      padding: EdgeInsets.all(5),
      child: StreamBuilder<QuerySnapshot>(
        stream: FireCollection()
            .userDoc()
            .collection('requests')
            .where('type', isEqualTo: 'sent')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                'No Sent Request',
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
                return SentProfileCard(
                  userId: document['userId'],
                  email: document['email'],
                  sentId: document.id,
                  reqId: document['recId'],
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}

class SentProfileCard extends StatelessWidget {
  final String email, userId, sentId, reqId;

  SentProfileCard({
    this.email,
    this.userId,
    this.sentId,
    this.reqId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      height: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            email,
            style: cTextStyleMediumBold,
          ),
          RoundRectButtonCustom(
            backgroundColor: CustomColor.primaryColor,
            foregroundColor: Colors.white,
            text: 'Profile',
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsersProfilePage(
                    uid: userId,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: RoundRectButtonCustom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              text: 'Cancel',
              onPress: () {
                cancelFriendRequest(reqId, sentId, userId);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> cancelFriendRequest(
    String reqId,
    String sentId,
    String friendId,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('requests')
        .doc(reqId)
        .delete()
        .then((value) {
      print('Deleted request');
    }).catchError((e) {
      print('Error sending request');
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FireCollection().userId)
        .collection('requests')
        .doc(sentId)
        .delete()
        .then((value) {
      print('Deleted sent req');
    }).catchError((e) {
      print('Error saving sending request data');
    });
  }
}
