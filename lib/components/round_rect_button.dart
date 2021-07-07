import 'package:flutter/material.dart';

class RoundRectButton extends StatelessWidget {
  String text;
  final VoidCallback onPress;
  double height, width;

  RoundRectButton({this.text, this.onPress, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        onPressed: onPress,
        child: Text(text,
            style: TextStyle(fontSize: 15, color: Theme.of(context).backgroundColor)),
      ),
    );
  }
}
