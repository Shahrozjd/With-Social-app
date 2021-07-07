import 'package:flutter/material.dart';

  class RoundRectButtonChild extends StatelessWidget {
  Widget child;
  final VoidCallback onPress;
  double height, width;
  Color backgroundColor;

  RoundRectButtonChild({this.child, this.onPress, this.height, this.width, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        onPressed: onPress,
        child: child,
      ),
    );
  }
}
