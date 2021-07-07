import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:with_app/styles/styles.dart';

class LightTextField extends StatelessWidget {
  bool obscureText;
  var inputType;
  String labelText, hinText;
  Function onChanged;
  TextEditingController controller;
  bool hasFocus;
  VoidCallback onEditingComplete;
  TextInputAction textInputAction;
  FocusNode focusNode;

  LightTextField(
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
      cursorColor: Colors.white,
      enabled: hasFocus,
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: inputType,
      style: cTextStyleMedium,
      decoration: InputDecoration(
        hintText: hinText,
        hintStyle: cTextStyleMedium,
        labelText: labelText,
        labelStyle: cTextStyleMedium,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
