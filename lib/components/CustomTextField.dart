import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:with_app/styles/custom_color.dart';
import 'package:with_app/styles/styles.dart';

class CustomTextField extends StatelessWidget {
  bool obscureText;
  var inputType;
  String labelText, hinText;
  Function onChanged;
  TextEditingController controller;
  bool hasFocus;
  VoidCallback onEditingComplete;
  TextInputAction textInputAction;
  FocusNode focusNode;

  CustomTextField(
      {this.obscureText,
        this.inputType,
        this.labelText,
        this.hinText,
        this.onChanged,
        this.controller,
        this.hasFocus,
        this.onEditingComplete,
        this.textInputAction,
        this.focusNode
      });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      focusNode: focusNode,
      cursorColor: CustomColor.primaryColor,
      enabled: hasFocus,
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: inputType,
      style: cTextStyle,
      decoration: InputDecoration(
        hintText: hinText,
        hintStyle: cTextStyle,
        labelText: labelText,
        labelStyle: cTextStyle,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColor.primaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColor.primaryColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColor.primaryColor),
        ),
      ),
    );
  }
}
