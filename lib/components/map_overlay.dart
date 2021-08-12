import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:with_app/components/bottom_modal_sheet.dart';
import 'package:with_app/components/icon_button_circle.dart';
import 'package:with_app/components/icon_buttons.dart';
import 'package:with_app/styles/styles.dart';


class MapOverlay extends StatefulWidget {
  VoidCallback onRelocateTap, refreshTap;
  MapType currentMapType;

  MapOverlay({this.onRelocateTap, this.currentMapType, this.refreshTap});

  @override
  _MapOverlayState createState() => _MapOverlayState();
}

class _MapOverlayState extends State<MapOverlay> {
  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                Column(
                  children: [
                    IconButtons(
                      iconData: Icons.refresh,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      onPress: widget.refreshTap,
                    ),
                    // IconButtons(
                    //   iconData: Icons.refresh,
                    //   borderRadius: BorderRadius.circular(0),
                    //   onPress: widget.refreshTap,
                    // ),
                    IconButtons(
                        iconData: Icons.my_location_outlined,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        onPress: widget.onRelocateTap),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
