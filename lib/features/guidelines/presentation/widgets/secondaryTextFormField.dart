import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';

Widget secondaryTextFormField(
    {required TextEditingController controller,
    required String hintText,
    required IconData? icon,
    required VoidCallback onInteraction}) {
  return TextFormField(
    controller: controller,
    onChanged: (value) {
      onInteraction();
    },
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      hintText: hintText,
      hintStyle: TextStyle(
          color: hintColor, fontSize: fontSize14, fontWeight: FontWeight.w400),
      prefixIcon: Icon(icon),
      prefixIconColor: hintColor,
      filled: true,
      fillColor: inputFieldColor,
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: inputFieldBorderColor)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: dangerColor),
      ),
    ),
  );
}
