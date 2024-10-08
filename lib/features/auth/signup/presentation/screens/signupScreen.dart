import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:ticketing_app/features/auth/signup/data/models/signUp.dart';
import 'package:ticketing_app/features/auth/signup/presentation/screens/blocs/signup_bloc.dart';
import 'package:ticketing_app/features/auth/signup/presentation/screens/blocs/signup_event.dart';
import 'package:ticketing_app/features/auth/signup/presentation/screens/blocs/signup_state.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/dateFormField.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/errortext.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/passwordFormField.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/phoneTextFormField.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/textFormField.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/guidelines/presentation/screens/privacyPolicy.dart';
import 'package:ticketing_app/features/guidelines/presentation/screens/termsAndConditions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

  DateTime firstDate = DateTime.now().subtract(Duration(days: 130 * 365));
  DateTime initialDate = DateTime.now().subtract(Duration(days: 21 * 365));
  DateTime lastDate = DateTime.now().subtract(Duration(days: 21 * 365));

  final signupFormKey = GlobalKey<FormState>();

  bool isChecked = false;
  bool isFirstNameEmpty = false;
  bool isLastNameEmpty = false;
  bool isPhoneEmpty = false;
  bool isDOBEmpty = false;
  bool isPasswordEmpty = false;
  bool isConfirmPwdEmpty = false;
  bool isPhoneInvalid = false;
  bool isPwdDifferent = false;
  bool isLoading = false;
  bool isSafaricom = false;

  Timer? _timer;
  int _dotCount = 0;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4; // Cycle through 0 to 3 dots
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _loadingTextWithDots() {
    return 'Registering ${'.' * _dotCount}';
  }

  @override
  void dispose() {
    _stopTimer();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          print(state);
          if (state is SignupLoadingState) {
            isLoading = true;
            CircularProgressIndicator(
              color: primaryColor,
              semanticsLabel: "Registering you",
            );
          } else if (state is SignupSuccessfulState) {
            isLoading = false;
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SigninScreen()));
          } else if (state is SignupFailureState) {
            isLoading = false;
            errorFlushbar(context: context, message: state.error);
          }
        },
        builder: (context, state) {
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() {
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Form(
          key: signupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height == 750
                  ? SizedBox(
                      height: 40,
                    )
                  : SizedBox(
                      height: 10,
                    ),
              const Text(
                "Create an Account",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize24,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "Sign-Up and enjoy buying any concert tickets with out the hustle",
                style: TextStyle(
                    color: bodyColor,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 34),
                child: textFormField(
                    controller: firstNameController,
                    hintText: "First Name",
                    icon: Icons.person,
                    onInteraction: () {
                      setState(() {
                        isFirstNameEmpty = false;
                      });
                    }),
              ),
              isFirstNameEmpty
                  ? errorText(text: "Please Enter your First Name")
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: textFormField(
                    controller: lastNameController,
                    hintText: "Last Name",
                    icon: Icons.person,
                    onInteraction: () {
                      setState(() {
                        isLastNameEmpty = false;
                      });
                    }),
              ),
              isLastNameEmpty
                  ? errorText(text: "Please Enter your Last Name")
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: phoneTextFormField(
                    controller: phoneController,
                    hintText: "Phone Number",
                    onInteraction: () {
                      setState(() {
                        isPhoneEmpty = false;
                        isPhoneInvalid = false;
                        isSafaricom = false;
                      });
                    }),
              ),
              isSafaricom
                  ? errorText(
                      text:
                          "Safaricom Provider is not supported yet. Please use Ethio-Telecom Provider")
                  : const SizedBox(),
              isPhoneEmpty
                  ? errorText(text: "Please Enter your Phone Number")
                  : const SizedBox(),
              isPhoneInvalid
                  ? errorText(text: "Please Enter a Valid Phone Number")
                  : const SizedBox(),
              Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: dateFormField(
                      controller: dobController,
                      hintText: "Date of Birth",
                      onPressed: () {
                        displayDatePicker(context);
                      },
                      onInteraction: () {
                        setState(() {
                          isDOBEmpty = false;
                        });
                      })),
              isDOBEmpty
                  ? errorText(text: "Please Enter your Date of Birth")
                  : const SizedBox(),
              Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: passwordFormField(
                      controller: passwordController,
                      hintText: "Password",
                      onInteraction: () {
                        setState(() {
                          isPasswordEmpty = false;
                          isPwdDifferent = false;
                        });
                      })),
              isPasswordEmpty
                  ? errorText(text: "Please Enter a Password")
                  : const SizedBox(),
              isPwdDifferent
                  ? errorText(text: "Entered Password Doesn't match")
                  : const SizedBox(),
              Padding(
                  padding: const EdgeInsets.only(top: 16),
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
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        checkColor: whiteColor,
                        activeColor: primaryColor,
                        value: isChecked,
                        side: const BorderSide(color: primaryColor),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        }),
                    Expanded(
                      child: RichText(
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          text: TextSpan(
                              style: const TextStyle(fontSize: fontSize11),
                              children: [
                                const TextSpan(
                                    text:
                                        "I confirm that I am at least 18 years old and agree to the ",
                                    style: TextStyle(
                                        color: blackColor,
                                        fontWeight: FontWeight.w400)),
                                TextSpan(
                                    text: "Terms & Conditions",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TermsAndConditionsScreen()));
                                      },
                                    style: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700)),
                                const TextSpan(
                                    text: " and ",
                                    style: TextStyle(
                                        color: blackColor,
                                        fontWeight: FontWeight.w400)),
                                TextSpan(
                                    text: "Privacy Policy",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PrivacyPolicyScreen()));
                                      },
                                    style: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700)),
                              ])),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              submitButton(
                text: isLoading ? _loadingTextWithDots() : "SignUp",
                disable: isLoading ? true : !isChecked,
                onInteraction: () {
                  if (signupFormKey.currentState!.validate()) {
                    if (firstNameController.text.isEmpty) {
                      return setState(() {
                        isFirstNameEmpty = true;
                      });
                    }
                    if (lastNameController.text.isEmpty) {
                      return setState(() {
                        isLastNameEmpty = true;
                      });
                    }
                    if (phoneController.text.isEmpty) {
                      return setState(() {
                        isPhoneEmpty = true;
                      });
                    }
                    if (phoneController.text.length >= 2) {
                      String firstTwoDigits =
                          phoneController.text.substring(0, 2);
                      if (firstTwoDigits == "07") {
                        return setState(() {
                          isSafaricom = true;
                        });
                      }

                      if (firstTwoDigits != "09") {
                        return setState(() {
                          isPhoneInvalid = true;
                        });
                      }
                    }
                    if (dobController.text.isEmpty) {
                      return setState(() {
                        isDOBEmpty = true;
                      });
                    }
                    if (passwordController.text.isEmpty) {
                      return setState(() {
                        isPasswordEmpty = true;
                      });
                    }
                    if (confirmPwdController.text.isEmpty) {
                      return setState(() {
                        isConfirmPwdEmpty = true;
                      });
                    }
                    if (passwordController.text != confirmPwdController.text) {
                      return setState(() {
                        isPwdDifferent = true;
                      });
                    }
                    if (!RegExp(r'^[0-9]{10}$')
                        .hasMatch(phoneController.text)) {
                      return setState(() {
                        isPhoneInvalid = true;
                      });
                    }
                  }
                  final signup = BlocProvider.of<SignupBloc>(context);
                  signup.add(SignupAttendee(SignUp(
                      first_name: firstNameController.text,
                      last_name: lastNameController.text,
                      phone_number: phoneController.text,
                      date_of_birth: dobController.text,
                      password: passwordController.text,
                      password_confirm: confirmPwdController.text)));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23),
                child: Center(
                  child: RichText(
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      text: TextSpan(
                          style: const TextStyle(fontSize: fontSize14),
                          children: [
                            const TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: "Login",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SigninScreen()));
                                  },
                                style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700)),
                          ])),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              onSurface: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final pickedDate = date.toLocal().toString().split(" ")[0];
      List<String> splittedDate = pickedDate.split("-");
      String dateFormat =
          "${splittedDate[0]}-${splittedDate[1]}-${splittedDate[2]}";
      setState(() {
        dobController.text = dateFormat;
      });
    }
  }
}
