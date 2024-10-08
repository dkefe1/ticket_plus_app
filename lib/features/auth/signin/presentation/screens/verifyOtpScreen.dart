import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signin/presentation/screens/resetPassword.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/errortext.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  final List<TextEditingController> otpControllers =
      List.generate(5, (_) => TextEditingController());

  final otpFormKey = GlobalKey<FormState>();

  bool otpEmpty = false;

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
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
            key: otpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "OTP Code Verification",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize24,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  text: TextSpan(
                      style: const TextStyle(fontSize: fontSize14),
                      children: [
                        TextSpan(
                            text: "We have sent an OPT Code to ",
                            style: TextStyle(
                                color: bodyColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w400)),
                        const TextSpan(
                            text: "0911111111",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: ". Enter the OTP code below to Verify.",
                            style: TextStyle(
                                color: bodyColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w400)),
                      ]),
                ),
                const SizedBox(
                  height: 33,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(5, (index) {
                    return SizedBox(
                      width: 50,
                      height: 47,
                      child: Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: TextField(
                          controller: otpControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          onChanged: (value) {
                            _onOtpChanged(index, value);
                            otpEmpty = false;
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            fillColor: inputFieldColor,
                            filled: true,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                otpEmpty
                    ? errorText(text: "Please Enter the OTP sent to your Phone")
                    : const SizedBox(),
                const SizedBox(
                  height: 34,
                ),
                Center(
                  child: Text(
                    "Didn’t receive OTP?",
                    style: TextStyle(
                        color: bodyColor,
                        fontSize: fontSize12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: RichText(
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    text: TextSpan(
                        style: const TextStyle(fontSize: fontSize14),
                        children: [
                          TextSpan(
                              text: "You can resend code in ",
                              style: TextStyle(
                                  color: bodyColor,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400)),
                          const TextSpan(
                              text: "52",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w600)),
                          TextSpan(
                              text: " s",
                              style: TextStyle(
                                  color: bodyColor,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400)),
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                submitButton(
                  text: "Continue",
                  disable: false,
                  onInteraction: () {
                    if (otpFormKey.currentState!.validate()) {
                      bool anyEmpty = otpControllers
                          .any((controller) => controller.text.isEmpty);
                      if (anyEmpty) {
                        setState(() {
                          otpEmpty = true;
                        });
                      }
                    }
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen()));
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

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < otpControllers.length - 1) {
        _focusNodes[index].unfocus();
        otpControllers[index].text = value; // Set the entered value

        // Move focus to the next text field
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
        otpControllers[index].text = value; // Set the entered value
      }
    } else {
      // If the value is empty, clear the current field and move to the previous field
      otpControllers[index].clear();

      if (index > 0) {
        // Move focus to the previous text field
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }
}
