import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';

Widget successFlushBar(
        {required BuildContext context, required String message}) =>
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      messageColor: Colors.black,
      backgroundColor: Colors.greenAccent,
      duration: Duration(seconds: 2),
      mainButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: primaryColor,
          )),
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: primaryColor,
      ),
      leftBarIndicatorColor: primaryColor,
    )..show(context);
