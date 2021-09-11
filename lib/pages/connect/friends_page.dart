import 'package:flutter/material.dart';
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
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey,width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    height: 65.0,
                    width: 65.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'John Doe',
                        style: cTextStyleBold,
                      ),
                      Text(
                        'john@mail.com',
                        style: cTextStyle,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
