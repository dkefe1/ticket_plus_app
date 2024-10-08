import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            color: primaryColor,
          ),
          SvgPicture.asset(
            "images/vector.svg",
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: width,
            child: Padding(
              padding: EdgeInsets.only(top: height > 700 ? 100 : 30),
              child: Image.asset(
                "images/onboardingPhone3.png",
                width: 300,
                height: 600,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 1),
            child: Container(
              padding: EdgeInsets.only(top: height > 700 ? 70 : 40),
              height: height > 700 ? height * 0.55 : height * 0.51,
              width: width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "images/onboardingBottom.png",
                      ),
                      fit: BoxFit.fill)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize:
                                    height > 700 ? fontSize28 : fontSize24,
                                fontWeight: FontWeight.w600),
                            children: [
                          TextSpan(
                              text: "Buy Your Ticket with one ",
                              style: TextStyle(color: blackColor)),
                          TextSpan(
                              text: "Click",
                              style: TextStyle(color: primaryColor))
                        ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 27, vertical: 20),
                    child: Text(
                      "Enjoy a user-friendly interface, intuitive navigation, and rich multimedia content.",
                      style: TextStyle(
                          color: bodyColor,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
