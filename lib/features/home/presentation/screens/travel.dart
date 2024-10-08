import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double fontSize;
    if (width < 390) {
      fontSize = width > 340 ? fontSize45 : fontSize35;
    } else if (width >= 380 && width < 405) {
      fontSize = fontSize52;
    } else {
      fontSize = width > 500 ? fontSize80 : fontSize55;
    }
    return Scaffold(
        body: Container(
      height: height,
      width: width,
      color: primaryColor,
      child: Stack(
        children: [
          SvgPicture.asset(
            "images/vector.svg",
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: -70,
            left: -25,
            right: -25,
            child: Container(
              height: 423,
              width: 423,
              decoration:
                  ShapeDecoration(color: firstCircle, shape: CircleBorder()),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -25,
            right: -25,
            child: Container(
              height: 403,
              width: 423,
              decoration:
                  ShapeDecoration(color: secondCircle, shape: CircleBorder()),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -25,
            right: -25,
            child: Container(
              height: 403,
              width: 423,
              decoration:
                  ShapeDecoration(color: thirdCircle, shape: CircleBorder()),
            ),
          ),
          Positioned(
            bottom: -200,
            left: -25,
            right: -25,
            child: Container(
              height: 403,
              width: 423,
              decoration:
                  ShapeDecoration(color: fourthCircle, shape: CircleBorder()),
            ),
          ),
          Positioned(
              bottom: 30,
              right: 50,
              left: 50,
              child: SvgPicture.asset(
                "images/rocket.svg",
                height: 280,
              )),
          Positioned(
              top: 70,
              right: 35,
              left: 35,
              child: Text(
                "Launching\nSoon",
                style: TextStyle(
                    color: whiteColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    ));
  }
}
