import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';

Widget phoneTextFormField(
    {required TextEditingController controller,
    required String hintText,
    required VoidCallback onInteraction}) {
  return TextFormField(
    controller: controller,
    onChanged: (value) {
      onInteraction();
    },
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      LengthLimitingTextInputFormatter(10)
    ],
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      hintText: hintText,
      hintStyle: TextStyle(
          color: hintColor, fontSize: fontSize14, fontWeight: FontWeight.w400),
      iconColor: hintColor,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          "images/phoneIcon.svg",
          width: 10,
          height: 10,
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
