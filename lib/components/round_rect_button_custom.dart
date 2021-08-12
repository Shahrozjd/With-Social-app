import 'package:flutter/material.dart';

class RoundRectButtonCustom extends StatelessWidget {
  String text;
  final VoidCallback onPress;
  double height, width;
  Color backgroundColor;
  Color foregroundColor;

  RoundRectButtonCustom({this.text, this.onPress, this.height, this.width, this.backgroundColor,this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
        onPressed: onPress,
        child: Text(text,
            style: TextStyle(fontSize: 15, color: foregroundColor)),
      ),
    );
  }
}
