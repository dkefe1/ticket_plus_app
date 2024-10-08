import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:ticketing_app/features/onboarding/widgets/onboardingScreen1.dart';
import 'package:ticketing_app/features/onboarding/widgets/onboardingScreen2.dart';
import 'package:ticketing_app/features/onboarding/widgets/onboardingScreen3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardinScreenState();
}

class _OnboardinScreenState extends State<OnboardingScreen> {
  final prefs = PrefService();

  final pageController = PageController();

  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          if (index == 2) {
            setState(() {
              isLastPage = true;
            });
          } else {
            setState(() {
              isLastPage = false;
            });
          }
        },
        children: const [
          OnboardingScreenOne(),
          OnboardingScreenTwo(),
          OnboardingScreenThree()
        ],
      ),
      bottomSheet: isLastPage
          ? Container(
              color: whiteColor,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: height * 0.21),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                          spacing: 15,
                          radius: 4,
                          dotWidth: 12,
                          dotHeight: 7,
                          strokeWidth: 1.5,
                          activeDotColor: primaryColor,
                          dotColor: inactiveDotColor),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 67, left: 20, right: 20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 50)),
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor)),
                        onPressed: () {
                          prefs.board();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SigninScreen()));
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: fontSize15,
                              fontWeight: FontWeight.w500),
                        )),
                  )
                ],
              ),
            )
          : Container(
              color: whiteColor,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: height * 0.21),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                          spacing: 15,
                          radius: 4,
                          dotWidth: 12,
                          dotHeight: 7,
                          strokeWidth: 1.5,
                          activeDotColor: primaryColor,
                          dotColor: inactiveDotColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 67),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(150, 50)),
                                backgroundColor: MaterialStateProperty.all(
                                    inactiveDotColor)),
                            onPressed: () {
                              pageController.jumpToPage(2);
                            },
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: fontSize15,
                                  fontWeight: FontWeight.w500),
                            )),
                        ElevatedButton(
                            style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(150, 50)),
                                backgroundColor:
                                    MaterialStateProperty.all(primaryColor)),
                            onPressed: () {
                              pageController.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn);
                            },
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: fontSize15,
                                  fontWeight: FontWeight.w500),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
