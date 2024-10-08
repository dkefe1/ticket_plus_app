import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/indexScreen.dart';
import 'package:ticketing_app/features/onboarding/screens/onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final pref = PrefService();
  @override
  void initState() {
    navigate();
    super.initState();
    // Timer(Duration(seconds: 4), () {
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => OnboardingScreen()));
    // });
  }

  Future navigate() async {
    await Future.delayed(Duration(seconds: 2));
    pref.getBoarded().then((value) {
      if (value == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OnboardingScreen()));
      } else {
        pref.readLogin().then((value) {
          if (value == null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SigninScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => IndexScreen(
                      pageIndex: 0,
                    )));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Stack(children: [
          SvgPicture.asset(
            "images/vector.svg",
            fit: BoxFit.cover,
          ),
          Center(
            child: SvgPicture.asset("images/logo.svg"),
          ),
        ]),
      ),
    );
  }
}
