import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:with_app/components/custom_loading.dart';
import 'package:with_app/components/round_rect_button_custom.dart';
import 'package:with_app/models/Contants.dart';
import 'package:with_app/pages/connect/recieved_page.dart';
import 'package:with_app/pages/connect/sent_page.dart';
import 'package:with_app/pages/user_timeline_page.dart';
import 'package:with_app/pages/users_profile_page.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class RequestPage extends StatefulWidget {
  static const String id = "RequestPage";
  const RequestPage({Key key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: Colors.white,
            child: new SafeArea(
              child: Column(
                children: <Widget>[
                  new Expanded(child: new Container()),
                  new TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        text: "Recieved",
                      ),
                      Tab(
                        text: "Sent",
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(children: [
          RecievedReqPage(),
          SentReqPage(),
        ]),
      ),
    );
  }
}
