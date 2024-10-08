import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';

Widget errorText({required String text}) {
  return Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Text(
      text,
      style: TextStyle(color: dangerColor, fontSize: fontSize12),
    ),
  );
}
