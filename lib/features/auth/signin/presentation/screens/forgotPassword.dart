import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signin/presentation/screens/verifyOtpScreen.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/errortext.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/phoneTextFormField.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneController = TextEditingController();

  final forgotPwdFormKey = GlobalKey<FormState>();

  bool isPhoneEmpty = false;
  bool isPhoneInvalid = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Form(
            key: forgotPwdFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reset Your Password",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize24,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Please enter your phone we will send you the OTP in the next step to reset you password",
                  style: TextStyle(
                      color: bodyColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 34, bottom: 7),
                  child: Text(
                    "Phone Number",
                    style: TextStyle(
                        color: bodyColor,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                phoneTextFormField(
                    controller: phoneController,
                    hintText: "Phone Number",
                    onInteraction: () {
                      setState(() {
                        isPhoneEmpty = false;
                        isPhoneInvalid = false;
                      });
                    }),
                isPhoneEmpty
                    ? errorText(text: "Please Enter your Phone Number")
                    : const SizedBox(),
                isPhoneInvalid
                    ? errorText(text: "Please Enter a Valid Phone Number")
                    : const SizedBox(),
                const SizedBox(
                  height: 65,
                ),
                submitButton(
                  text: "Continue",
                  disable: false,
                  onInteraction: () {
                    if (forgotPwdFormKey.currentState!.validate()) {
                      if (phoneController.text.isEmpty) {
                        return setState(() {
                          isPhoneEmpty = true;
                        });
                      }
                      if (!RegExp(r'^[0-9]{10}$')
                          .hasMatch(phoneController.text)) {
                        return setState(() {
                          isPhoneInvalid = true;
                        });
                      }
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => VerifyOtpScreen()));
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
