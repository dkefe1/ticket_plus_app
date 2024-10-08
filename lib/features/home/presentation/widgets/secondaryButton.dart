import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';

Widget secondaryButton(
    {required String text,
    required VoidCallback onInteraction,
    required Color? bgColor,
    required Color? txtColor,
    required bool border}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
        onPressed: onInteraction,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor),
            side: border
                ? MaterialStateProperty.all(
                    BorderSide(color: primaryColor, width: 1))
                : null),
        child: Text(
          text,
          style: TextStyle(
            color: txtColor,
            fontSize: fontSize14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        )),
  );
}
