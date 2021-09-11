import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {

  static const String id = "RequestPage";
  const RequestPage({Key key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Request Page"),
      ),
    );
  }
}
