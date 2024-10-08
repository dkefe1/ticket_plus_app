import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';

Widget submitButton(
    {required String text,
    required bool disable,
    required VoidCallback onInteraction}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
        onPressed: disable ? null : onInteraction,
        style: ButtonStyle(
            backgroundColor: disable
                ? MaterialStateProperty.all(inactiveButton)
                : MaterialStateProperty.all(primaryColor)),
        child: Text(
          text,
          style: TextStyle(
            color: whiteColor,
            fontSize: fontSize15,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        )),
  );
}
