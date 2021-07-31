import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/styles/styles.dart';

class TimelinePage extends StatefulWidget {
  static const String id = 'TimelinePage';

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar:ScrollAppBar(
        controller: controller,
        title: Text("Feed",style: cTextStyleLarge,),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FireCollection.timelineCollection().orderBy("timestamp",descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading",style: cTextStyleMedium,),
              );
            }
            return Snap(
              controller: controller.appBar,
              child: ListView(
                controller: controller,
                shrinkWrap: true,
                primary: false,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return PostCards(
                    imagePath: document['url'].toString(),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PostCards extends StatelessWidget {
  String imagePath;


  PostCards({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5,top: 5),
      height: Styles.height(context) * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.grey),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                AnimatedContainer(
                  height: 55.0,
                  width: 55.0,
                  child: Center(child: Icon(FontAwesome.user)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color : Colors.amber,
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
                    "John Doe",
                    style: cTextStyleBold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: Styles.width(context) * 0.02,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(imagePath)),
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
