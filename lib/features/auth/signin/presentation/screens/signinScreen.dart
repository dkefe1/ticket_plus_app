import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signin/data/models/login.dart';
import 'package:ticketing_app/features/auth/signin/presentation/blocs/login_bloc.dart';
import 'package:ticketing_app/features/auth/signin/presentation/blocs/login_event.dart';
import 'package:ticketing_app/features/auth/signin/presentation/blocs/login_state.dart';
import 'package:ticketing_app/features/auth/signin/presentation/screens/forgotPassword.dart';
import 'package:ticketing_app/features/auth/signup/presentation/screens/signupScreen.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/errortext.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/passwordFormField.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/phoneTextFormField.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/common/languageDropdown.dart';
import 'package:ticketing_app/features/home/personalize.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/screens/indexScreen.dart';
import 'package:ticketing_app/l10n/l10n.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final prefs = PrefService();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();

  bool isPhoneEmpty = false;
  bool isPasswordEmpty = false;
  bool isPhoneInvalid = false;
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
    return '${AppLocalizations.of(context)!.loggingIn} ${'.' * _dotCount}';
  }

  @override
  void dispose() {
    _stopTimer();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (_, state) {
          print(state);
          if (state is LoginLoadingState) {
            isLoading = true;
            Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                semanticsLabel: AppLocalizations.of(context)!.signingYouIn,
              ),
            );
          } else if (state is LoginSuccessfulState) {
            prefs.login(passwordController.text);
            prefs.storePhone(phoneController.text);
            isLoading = false;
            prefs.getPersonalization().then((value) {
              if (value == null) {
                BlocProvider.of<EventBloc>(context)
                  ..add(GetEventCategoryEvent());
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PersonalizeFeedScreen()));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => IndexScreen(
                          pageIndex: 0,
                        )));
              }
            });
          } else if (state is LoginFailureState) {
            isLoading = false;
            errorFlushbar(context: context, message: state.error);
          }
        },
        builder: (_, state) {
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: dropdownWidget(),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                AppLocalizations.of(context)!.welcomeBack,
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize24,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                AppLocalizations.of(context)!.pleaseEnterYourPhone,
                style: TextStyle(
                    color: bodyColor,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 34, bottom: 7),
                child: Text(
                  AppLocalizations.of(context)!.phoneNumber,
                  style: TextStyle(
                      color: bodyColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              phoneTextFormField(
                  controller: phoneController,
                  hintText: "09 ** ** ** **",
                  onInteraction: () {
                    setState(() {
                      isPhoneEmpty = false;
                      isPhoneInvalid = false;
                      isSafaricom = false;
                    });
                  }),
              isSafaricom
                  ? errorText(
                      text: AppLocalizations.of(context)!.safariNotSupported)
                  : const SizedBox(),
              isPhoneEmpty
                  ? errorText(text: AppLocalizations.of(context)!.emptyPhone)
                  : const SizedBox(),
              isPhoneInvalid
                  ? errorText(text: AppLocalizations.of(context)!.invalidPhone)
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 13, bottom: 7),
                child: Text(
                  AppLocalizations.of(context)!.password,
                  style: TextStyle(
                      color: bodyColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              passwordFormField(
                  controller: passwordController,
                  hintText: "********",
                  onInteraction: () {
                    setState(() {
                      isPasswordEmpty = false;
                    });
                  }),
              isPasswordEmpty
                  ? errorText(text: AppLocalizations.of(context)!.emptyPwd)
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 23),
                child: GestureDetector(
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()));
                  },
                ),
              ),
              const SizedBox(
                height: 56,
              ),
              submitButton(
                text: isLoading
                    ? _loadingTextWithDots()
                    : AppLocalizations.of(context)!.login,
                disable: isLoading,
                onInteraction: () {
                  if (loginFormKey.currentState!.validate()) {
                    if (phoneController.text.isEmpty) {
                      return setState(() {
                        isPhoneEmpty = true;
                      });
                    }
                    if (passwordController.text.isEmpty) {
                      return setState(() {
                        isPasswordEmpty = true;
                      });
                    }
                    if (!RegExp(r'^[0-9]{10}$')
                        .hasMatch(phoneController.text)) {
                      return setState(() {
                        isPhoneInvalid = true;
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
                  }
                  final login = BlocProvider.of<LoginBloc>(context);
                  login.add(LoginAttendee(Login(
                      phone_number: phoneController.text,
                      password: passwordController.text)));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23),
                child: Center(
                  child: Text.rich(
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      TextSpan(
                          style: const TextStyle(fontSize: fontSize14),
                          children: [
                            TextSpan(
                                text: AppLocalizations.of(context)!
                                    .dontHaveAccount,
                                style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: AppLocalizations.of(context)!.signupLogin,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupScreen()));
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
}
