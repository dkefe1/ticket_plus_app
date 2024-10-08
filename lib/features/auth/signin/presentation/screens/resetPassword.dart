import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signin/presentation/screens/verifyOtpScreen.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/errortext.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/passwordFormField.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

  final resetPwdFormKey = GlobalKey<FormState>();

  bool isNewPwdEmpty = false;
  bool isConfirmPwdEmpty = false;
  bool isPwdDifferent = false;

  @override
  void dispose() {
    newPwdController.dispose();
    confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => VerifyOtpScreen()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Form(
            key: resetPwdFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Your Password",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize24,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Create your new password here.",
                  style: TextStyle(
                      color: bodyColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 34, bottom: 7),
                  child: Text(
                    "New Password",
                    style: TextStyle(
                        color: bodyColor,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: passwordFormField(
                        controller: newPwdController,
                        hintText: "New Password",
                        onInteraction: () {
                          setState(() {
                            isNewPwdEmpty = false;
                            isPwdDifferent = false;
                          });
                        })),
                isNewPwdEmpty
                    ? errorText(text: "Please Enter a Password")
                    : const SizedBox(),
                isPwdDifferent
                    ? errorText(text: "Entered Password Doesn't match")
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 34, bottom: 7),
                  child: Text(
                    "Confirm Password",
                    style: TextStyle(
                        color: bodyColor,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: passwordFormField(
                        controller: confirmPwdController,
                        hintText: "Confirm Password",
                        onInteraction: () {
                          setState(() {
                            isConfirmPwdEmpty = false;
                            isPwdDifferent = false;
                          });
                        })),
                isConfirmPwdEmpty
                    ? errorText(text: "Please Confirm your Password")
                    : const SizedBox(),
                isPwdDifferent
                    ? errorText(text: "Entered Password Doesn't match")
                    : const SizedBox(),
                const SizedBox(
                  height: 65,
                ),
                submitButton(
                  text: "Continue",
                  disable: false,
                  onInteraction: () {
                    if (resetPwdFormKey.currentState!.validate()) {
                      if (newPwdController.text.isEmpty) {
                        return setState(() {
                          isNewPwdEmpty = true;
                        });
                      }
                      if (confirmPwdController.text.isEmpty) {
                        return setState(() {
                          isConfirmPwdEmpty = true;
                        });
                      }
                      if (newPwdController.text != confirmPwdController.text) {
                        return setState(() {
                          isPwdDifferent = true;
                        });
                      }
                    }
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
