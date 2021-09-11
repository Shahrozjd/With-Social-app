import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:with_app/pages/connect/friends_page.dart';
import 'package:with_app/pages/connect/request_page.dart';
import 'package:with_app/styles/styles.dart';

class ConnectPage extends StatefulWidget {
  static const String id = "ConnectPage";

  const ConnectPage({Key key}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Friends",
            style: cTextStyleLarge,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  FontAwesome5.user_friends,
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesome5.user_plus,
                ),
              )

            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendsPage(),
            RequestPage(),
          ],
        )
      ),
    );
  }
}

