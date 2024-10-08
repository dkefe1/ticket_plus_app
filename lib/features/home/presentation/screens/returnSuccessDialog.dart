import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/home/presentation/screens/indexScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/returnTicketScreen.dart';
import 'package:ticketing_app/features/home/presentation/widgets/secondaryButton.dart';

class ReturnSuccessDialog extends StatefulWidget {
  const ReturnSuccessDialog({super.key});

  @override
  State<ReturnSuccessDialog> createState() => _ReturnSuccessDialogState();
}

class _ReturnSuccessDialogState extends State<ReturnSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      surfaceTintColor: whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: width < 290 ? 15 : 24),
      content: SizedBox(
        height: 425,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/ticketSuccess.svg",
              fit: BoxFit.cover,
              height: 113,
              width: 113,
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              "Ticket Selling Order has been Submited",
              style: TextStyle(
                  color: blackColor,
                  fontSize: fontSize18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 21,
            ),
            submitButton(
                text: "View Order",
                disable: false,
                onInteraction: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ReturnTicketScreen()));
                }),
            const SizedBox(
              height: 15,
            ),
            secondaryButton(
                text: "Go back home",
                onInteraction: () {
                  Navigator.of(context).pop;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IndexScreen(
                                pageIndex: 0,
                              )),
                      (route) => false);
                },
                bgColor: Colors.green[100],
                txtColor: primaryColor,
                border: false)
          ],
        ),
      ),
    );
  }
}
