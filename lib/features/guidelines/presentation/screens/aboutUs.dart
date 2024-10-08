import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_bloc.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_event.dart';
import 'package:ticketing_app/features/guidelines/presentation/screens/feedback.dart';
import 'package:ticketing_app/features/guidelines/presentation/screens/privacyPolicy.dart';
import 'package:ticketing_app/features/guidelines/presentation/screens/termsAndConditions.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
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
          child: RichText(
              text: const TextSpan(
                  style: TextStyle(
                      fontSize: fontSize16, fontWeight: FontWeight.w600),
                  children: [
                TextSpan(text: "About ", style: TextStyle(color: blackColor)),
                TextSpan(text: "Ticket+", style: TextStyle(color: primaryColor))
              ])),
        ),
        actions: const [
          SizedBox(
            width: 30,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SvgPicture.asset(
                "images/logoSecond.svg",
                height: 110,
                width: 102,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 34,
            ),
            Center(
              child: Text(
                "Ticket+ V1.0.0",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen()));
              },
              title: Text(
                "Terms and Condition",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PrivacyPolicyScreen()));
              },
              title: Text(
                "Privacy and Policy",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Contact Us",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                BlocProvider.of<FeedbackBloc>(context)
                    .add(GetFeedbackTitleEvent());
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FeedbackScreen()));
              },
              title: Text(
                "Feedback",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Rate Us",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
