import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:with_app/components/bottom_modal_sheet.dart';
import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/components/round_rect_button.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/components/toaster.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/network_player_widget.dart';
import 'package:with_app/styles/styles.dart';

class UserTimelinePage extends StatefulWidget {
  static const String id = 'UserTimelinePage';

  @override
  _UserTimelinePageState createState() => _UserTimelinePageState();
}

class _UserTimelinePageState extends State<UserTimelinePage> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: ScrollAppBar(
        controller: controller,
        title: Text(
          "Feed",
          style: cTextStyleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FireCollection.timelineCollection()
                .where('userId', isEqualTo: FireCollection.userId)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text(
                    "Loading",
                    style: cTextStyleMedium,
                  ),
                );
              }
              if (snapshot.data.size == 0) {
                return Center(
                  child: Text(
                    'No Post Yet',
                    style: cTextStyleMedium,
                  ),
                );
              }
              return Snap(
                controller: controller.appBar,
                child: ListView(
                  controller: controller,
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return PostCards(
                      imagePath: document['url'].toString(),
                      format: document['format'].toString(),
                      desc: document['desc'],
                      userName: document['userName'],
                      userImg: document['userImg'],
                      docId: document.id,
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PostCards extends StatelessWidget {
  String imagePath, format, docId, desc, userName, userImg;

  PostCards(
      {this.imagePath,
      this.format,
      this.docId,
      this.desc,
      this.userName,
      this.userImg});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Styles.height(context) * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.2, color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AnimatedContainer(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                          image: DecorationImage(
                            image: NetworkImage(
                              userImg,
                            ),
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
                        width: Styles.width(context) * 0.04,
                      ),
                      Expanded(
                        child: Text(
                          userName,
                          style: cTextStyleBold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    bottomModalSheet(
                      context: context,
                      height: Styles.height(context) * 0.2,
                      kChild: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Do you Want to delete Post?',
                              style: cTextStyleMediumBold,
                            ),
                            RoundRectButtonCustom(
                              text: 'Delete',
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              onPress: () async {
                                Navigator.pop(context);
                                Toaster.showToast(
                                    "Deleting Post...",
                                    ToastGravity.TOP);
                                await FirebaseStorage.instance
                                    .refFromURL(imagePath)
                                    .delete();

                                await FirebaseFirestore.instance
                                    .collection('timeline')
                                    .doc(docId)
                                    .delete()
                                    .then(
                                  (value) {
                                    Toaster.showToast(
                                        "Post Deleted successfully",
                                        ToastGravity.TOP);
                                  },
                                ).catchError((e) => print(
                                        "Error occurred while deleting post"));
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          SizedBox(
            width: Styles.width(context) * 0.01,
          ),
          desc != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: AutoSizeText(
                    desc,
                    maxLines: 1,
                  ),
                )
              : SizedBox(),
          SizedBox(
            width: Styles.width(context) * 0.02,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: format == 'image'
                  ? Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(imagePath)),
                        color: Colors.black,
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NetworkPlayerWidget(
                            url: imagePath,
                          ),
                        ],
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
