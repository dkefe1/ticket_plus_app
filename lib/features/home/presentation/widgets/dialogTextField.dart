import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticketing_app/core/constants.dart';

Widget dialogTextFormField(
    {required TextEditingController controller,
    required String hintText,
    required VoidCallback onTap,
    required VoidCallback onInteraction,
    required bool enabled}) {
  return GestureDetector(
    onTap: onTap,
    child: TextFormField(
      controller: controller,
      enabled: enabled,
      onChanged: (value) {
        onInteraction();
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(10)
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        hintText: hintText,
        hintStyle: TextStyle(
            color: hintColor,
            fontSize: fontSize14,
            fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: inactiveBottomNavIconColor)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: inactiveBottomNavIconColor)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: dangerColor),
        ),
      ),
    ),
  );
}
