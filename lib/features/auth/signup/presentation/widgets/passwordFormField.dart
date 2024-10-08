import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';

class passwordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onInteraction;
  passwordFormField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.onInteraction});
  @override
  State<passwordFormField> createState() => _passwordFormFieldState();
}

class _passwordFormFieldState extends State<passwordFormField> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) {
        widget.onInteraction();
      },
      obscureText: isHidden,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: hintColor,
            fontSize: fontSize14,
            fontWeight: FontWeight.w400),
        prefixIcon: IconButton(
          onPressed: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
          icon: isHidden
              ? SvgPicture.asset("images/lockIcon.svg")
              : Icon((Icons.lock_open_outlined)),
        ),
        prefixIconColor: hintColor,
        filled: true,
        fillColor: inputFieldColor,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
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
}
