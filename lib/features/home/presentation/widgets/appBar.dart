import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';

PreferredSizeWidget myAppBar(BuildContext context, String title) {
  double height = MediaQuery.of(context).size.height;

  return AppBar(
    toolbarHeight: height * 0.1,
    surfaceTintColor: whiteColor,
    leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: blackColor,
        )),
    centerTitle: true,
    title: Center(
        child: Text(
      title,
      style: TextStyle(
          color: blackColor, fontSize: fontSize18, fontWeight: FontWeight.w600),
    )),
    actions: [
      SizedBox(
        width: 30,
      )
    ],
  );
}
