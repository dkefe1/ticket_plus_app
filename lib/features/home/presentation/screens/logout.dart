import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/home/presentation/widgets/secondaryButton.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  final prefs = PrefService();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            actionsAlignment: MainAxisAlignment.end,
            surfaceTintColor: whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            content: Container(
              height: 150,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: fontSize18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Are you sure you want to log out?",
                    style: TextStyle(
                        color: blackColor,
                        fontSize: fontSize16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.31,
                        child: submitButton(
                          text: "Cancel",
                          disable: false,
                          onInteraction: () {},
                        ),
                      ),
                      SizedBox(
                        width: width * 0.31,
                        child: secondaryButton(
                            text: "Logout",
                            bgColor: dangerColor,
                            border: false,
                            txtColor: whiteColor,
                            onInteraction: () {
                              prefs.removeToken();
                              prefs.logout();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SigninScreen()),
                                  (route) => false);
                            }),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
