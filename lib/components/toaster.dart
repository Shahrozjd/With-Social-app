import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:with_app/styles/custom_color.dart';

class Toaster{
  static void showToast(String message, ToastGravity toastGravity) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: toastGravity,
        timeInSecForIosWeb: 1,
        backgroundColor: CustomColor.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }


}