import 'package:flutter/material.dart';

class IconButtonCircle extends StatelessWidget {
  VoidCallback onPress;
  IconData iconData;
  double iconSize = 30;
  double height;
  double width;

  IconButtonCircle(
      {this.onPress, this.iconData, this.iconSize, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: height == null ? 50 : height,
        width: width == null ? 50 : width,
        child: Center(
            child: Icon(
          iconData,
          size: iconSize,
              color: Theme.of(context).accentColor,
        )),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                offset: Offset(0, 3),
                spreadRadius: 1.0)
          ],
        ),
      ),
    );
  }
}
