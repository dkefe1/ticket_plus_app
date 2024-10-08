import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';

Widget dateFormField(
    {required TextEditingController controller,
    required String hintText,
    required VoidCallback onPressed,
    required VoidCallback onInteraction}) {
  return TextFormField(
    controller: controller,
    onTap: onPressed,
    onChanged: (value) {
      onInteraction();
    },
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
    ],
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      hintText: hintText,
      hintStyle: TextStyle(
          color: hintColor, fontSize: fontSize14, fontWeight: FontWeight.w400),
      iconColor: hintColor,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          "images/calendarIcon.svg",
        ),
      ),
      filled: true,
      fillColor: inputFieldColor,
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: inputFieldBorderColor)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: inputFieldBorderColor)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: dangerColor),
      ),
    ),
  );
}
