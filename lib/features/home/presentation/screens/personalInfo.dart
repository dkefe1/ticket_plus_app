import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/dateFormField.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/textFormField.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/common/loadingContainer.dart';
import 'package:ticketing_app/features/home/data/models/updateProfile.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/indexScreen.dart';
import 'package:ticketing_app/features/home/presentation/widgets/appBar.dart';

class PersonalInfoScreen extends StatefulWidget {
  PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  String phoneNumber = "";

  bool isLoading = false;
  bool isDOBEmpty = false;

  DateTime firstDate = DateTime.now().subtract(Duration(days: 130 * 365));
  DateTime initialDate = DateTime.now().subtract(Duration(days: 21 * 365));
  DateTime lastDate = DateTime.now().subtract(Duration(days: 21 * 365));

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(GetProfileEvent());

    profileBloc.stream.listen((state) {
      if (state is ProfileSuccessfulState) {
        final userProfile = state.profile;

        setState(() {
          firstNameController.text = userProfile.first_name;
          lastNameController.text = userProfile.last_name;
          phoneController.text = userProfile.phone_number;
          phoneNumber = userProfile.phone_number;
          dobController.text = formatDOB(userProfile.date_of_birth);
        });
      }
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Personal Info"),
      body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
        listener: (_, state) {
          print(state);
          if (state is UpdateProfileLoadingState) {
            isLoading = true;
            buildLoading();
          } else if (state is UpdateProfileSuccessfulState) {
            isLoading = false;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => IndexScreen(pageIndex: 4)));
          } else if (state is UpdateProfileFailureState) {
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: Image.asset(
                  "images/profilePic.png",
                  height: 111,
                  width: 111,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Text(
              "First Name",
              style: TextStyle(
                  color: bodyColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 6,
            ),
            textFormField(
                controller: firstNameController,
                hintText: "First Name",
                icon: Icons.person,
                onInteraction: () {}),
            const SizedBox(
              height: 13,
            ),
            Text(
              "Last Name",
              style: TextStyle(
                  color: bodyColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 6,
            ),
            textFormField(
                controller: lastNameController,
                hintText: "Last Name",
                icon: Icons.person,
                onInteraction: () {}),
            const SizedBox(
              height: 13,
            ),
            Text(
              "Phone Number",
              style: TextStyle(
                  color: bodyColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 6,
            ),
            textFormField(
                controller: phoneController,
                hintText: "0912******",
                icon: Icons.phone,
                onInteraction: () {}),
            const SizedBox(
              height: 13,
            ),
            Text(
              "Date of Birth",
              style: TextStyle(
                  color: bodyColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 6,
            ),
            dateFormField(
                controller: dobController,
                hintText: "2024-12-20",
                onPressed: () {
                  displayDatePicker(context);
                },
                onInteraction: () {
                  setState(() {
                    isDOBEmpty = false;
                  });
                }),
            const SizedBox(
              height: 40,
            ),
            submitButton(
                text: isLoading ? "Updating Info..." : "Save",
                disable: isLoading ? true : false,
                onInteraction: () {
                  BlocProvider.of<UpdateProfileBloc>(context).add(
                      PatchUpdateProfileEvent(UpdateProfile(
                          first_name: firstNameController.text,
                          last_name: lastNameController.text,
                          phone_number: phoneController.text,
                          date_of_birth: dobController.text)));
                  if (phoneController.text != phoneNumber) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SigninScreen()));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "You have changed your phone number recently. Please login again"),
                      backgroundColor: primaryColor,
                    ));
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: LoadingContainer(
                    width: 111, height: 111, borderRadius: 300),
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Text(
              "Full Name",
              style: TextStyle(
                  color: bodyColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 6,
            ),
            LoadingContainer(width: width, height: 45, borderRadius: 4),
            const SizedBox(
              height: 13,
            ),
            Text(
              "Phone Number",
              style: TextStyle(
                  color: bodyColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 6,
            ),
            LoadingContainer(width: width, height: 45, borderRadius: 4),
            const SizedBox(
              height: 13,
            ),
            Text(
              "Date of Birth",
              style: TextStyle(
                  color: bodyColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 6,
            ),
            LoadingContainer(width: width, height: 45, borderRadius: 4),
            const SizedBox(
              height: 40,
            ),
            submitButton(text: "Save", disable: false, onInteraction: () {})
          ],
        ),
      ),
    );
  }

  Future<void> displayDatePicker(BuildContext context) async {
    DateTime? currentDate;

    // Parse the date from dobController's text
    if (dobController.text.isNotEmpty) {
      try {
        currentDate = DateTime.parse(dobController.text);
      } catch (e) {
        currentDate = initialDate; // If parsing fails, default to initialDate
      }
    } else {
      currentDate =
          initialDate; // If dobController is empty, default to initialDate
    }

    var date = await showDatePicker(
      context: context,
      initialDate: currentDate,
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
