import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({super.key});

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/noConnection.png",
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              "No Connection",
              style: TextStyle(
                color: blackColor,
                fontSize: fontSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "No internet connection found. Check \nyour connectivity or try again.",
              style: TextStyle(
                color: locationTextColor,
                fontSize: fontSize12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 21,
            ),
            SizedBox(
              width: 165,
              child: submitButton(
                  text: "Try Again",
                  disable: true,
                  onInteraction: () {
                    Navigator.of(context).pop();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
