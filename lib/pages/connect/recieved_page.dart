import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/users_profile_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class RecievedReqPage extends StatefulWidget {
  const RecievedReqPage({Key key}) : super(key: key);

  @override
  _RecievedPageState createState() => _RecievedPageState();
}

class _RecievedPageState extends State<RecievedReqPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Styles.height(context),
      padding: EdgeInsets.all(5),
      child: StreamBuilder<QuerySnapshot>(
        stream: FireCollection()
            .userDoc()
            .collection('requests')
            .where('type', isEqualTo: 'recieved')
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
                'No Request Yet',
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
                return RecievedProfileCard(
                  userId: document['userId'],
                  email: document['email'],
                  sentId: document['sentId'],
                  reqId: document.id,
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}

class RecievedProfileCard extends StatelessWidget {
  String email;
  String userId;
  String reqId;
  String sentId;

  RecievedProfileCard({
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
      height: 150,
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
          Row(
            children: [
              Expanded(
                child: RoundRectButtonCustom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  text: 'Reject',
                  onPress: () {
                    rejectRequest(userId, reqId, sentId);
                  },
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: RoundRectButtonCustom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  text: 'Accept',
                  onPress: () {
                    acceptRequest(userId, reqId, sentId);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void acceptRequest(String friendId, String reqId, String sentId) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(FireCollection().userId)
        .collection('friends')
        .doc();
    doc.set({
      'friendId': friendId,
      'docId': doc.id,
    });

    DocumentReference doc1 = FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc();
    doc1.set({
      'friendId': FireCollection().userId,
      'docId': doc1.id,
    });
    rejectRequest(friendId, reqId, sentId);
  }

  void rejectRequest(String friendId, String reqId, String sentId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FireCollection().userId)
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
        .doc(friendId)
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
