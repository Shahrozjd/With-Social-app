import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:with_app/components/round_rect_button.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/users_profile_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class chatscreen extends StatefulWidget {
  String recvrId;
  String recvremail;
  String recvrimg;
  String recvrname;
  String status;

  chatscreen({
    this.recvrId,
    this.recvremail,
    this.recvrname,
    this.recvrimg,
    this.status,
  });

  @override
  _chatscreenState createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  String currentuser = FirebaseAuth.instance.currentUser.email.toString();
  String msg;
  final textfieldcontroller = TextEditingController();
  String convoId;

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }

  @override
  void initState() {
    convoId = getConversationID(FireCollection().userId, widget.recvrId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == 'iBlocked') {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'You have blocked this user',
                style: cTextStyleMediumBold,
              ),
              RoundRectButton(
                text: 'Unblock',
                height: 40,
                onPress: () {
                  unblockUser();
                },
              )
            ],
          ),
        ),
      );
    }
    if (widget.status == 'blocked') {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'You have been blocked by the user',
                style: cTextStyleMediumBold,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(FontAwesome5.arrow_left),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersProfilePage(
                        uid: widget.recvrId,
                      ),
                    ),
                  );
                },
                child: AnimatedContainer(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                    image: DecorationImage(
                      image: NetworkImage(widget.recvrimg),
                      fit: BoxFit.cover,
                    ),
                  ),
                  duration: Duration(milliseconds: 400),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.recvrname,
                style: cTextStyleMedium,
              )
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: Styles.height(context) * 0.2,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Are you sure you want to block the user?",
                            style: cTextStyleMediumBold,
                          ),
                          RoundRectButton(
                            text: 'Block',
                            height: 40,
                            onPress: () {
                              blockUser();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(FontAwesome.block),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(convoId)
                  .collection('msgs')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data.docs.reversed;
                  List<msgbubble> messageWidgets = [];
                  for (var msg in messages) {
                    final msgtext = msg['text'];
                    final msgSender = msg['sender'];
                    final msgtime = msg['time'];

                    final messagebubble = msgbubble(
                      text: msgtext,
                      sender: msgSender,
                      time: msgtime,
                      isMe: currentuser == msgSender,
                    );

                    messageWidgets.add(messagebubble);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageWidgets,
                    ),
                  );
                }
                return Container();
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textfieldcontroller,
                      onChanged: (String text) {
                        msg = text;
                      },
                      keyboardType: TextInputType.text,
                      style: cTextStyle,
                      decoration: InputDecoration(
                        hintText: "Enter Message",
                        hintStyle: TextStyle(fontSize: 18),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[800]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RoundRectButtonCustom(
                    height: 45,
                    backgroundColor: CustomColor.secColor,
                    text: "Send",
                    onPress: () {
                      setState(() {
                        print(widget.recvremail);
                        textfieldcontroller.clear();
                        sendtext(text: msg);
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> blockUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FireCollection().userId)
        .collection('friends')
        .doc(widget.recvrId)
        .update({
      'status': "iBlocked",
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.recvrId)
        .collection('friends')
        .doc(FireCollection().userId)
        .update({
      'status': 'blocked',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User Blocked"),
      ),
    );

    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> unblockUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FireCollection().userId)
        .collection('friends')
        .doc(widget.recvrId)
        .update({
      'status': "active",
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.recvrId)
        .collection('friends')
        .doc(FireCollection().userId)
        .update({
      'status': 'active',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User Unblock Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> sendtext({String text}) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('hh:mm a yy-MM-dd ');
    String formattedDate = formatter.format(now);

    var formattertime = new DateFormat('hh:mm');
    String formattedtime = formattertime.format(now);

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(convoId)
        .collection('msgs')
        .doc()
        .set({
          'sender': currentuser,
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'time': formattedtime.toString(),
        })
        .then((value) => print('Sent text'))
        .catchError((error) => print("Failed to sent text: $error"));
  }
}

class msgbubble extends StatelessWidget {
  String text;
  String sender;
  String time;
  bool isMe;

  msgbubble({this.text, this.sender, this.time, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            elevation: 5.0,
            color: isMe ? CustomColor.primaryColor : Colors.grey[100],
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 15,
                        color: isMe ? Colors.white : Colors.black),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 10,
                        color: isMe ? Colors.grey[200] : Colors.black87),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
