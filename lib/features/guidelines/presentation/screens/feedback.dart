import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/errortext.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/common/successFlushbar.dart';
import 'package:ticketing_app/features/guidelines/data/models/feedback.dart';
import 'package:ticketing_app/features/guidelines/data/models/feedbackTitle.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_bloc.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_event.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_state.dart';
import 'package:ticketing_app/features/home/presentation/widgets/appBar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String chosenLanguage = "English";
  String dropdownValue = "One";
  TextEditingController feedbackController = TextEditingController();

  bool feedbackEmpty = false;
  bool isLoading = false;

  FeedbackTitle? value;

  late String catId;

  List<FeedbackTitle> categories = [];

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<FeedbackBloc>(context).add(GetFeedbackTitleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Feedback"),
      body: BlocConsumer<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          print(state);
          if (state is FeedbackTitleLoadingState) {
          } else if (state is FeedbackTitleSuccessfulState) {
            categories = state.title;
          } else if (state is FeedbackTitleFailureState) {
            errorFlushbar(context: context, message: "Failed please try again");
          } else if (state is FeedbackLoadingState) {
            isLoading = true;
          } else if (state is FeedbackSuccessfulState) {
            isLoading = false;
            feedbackController.text = "";
            successFlushBar(
                context: context, message: "Feedback Submitted Successfully!");
          } else if (state is FeedbackFailureState) {
            isLoading = false;
            errorFlushbar(
                context: context,
                message: "Failed to submit feedback. Please try again");
          }
        },
        builder: (context, state) {
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 33, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                "Please give us you feedback. The responsible team will get to you right back.",
                style: TextStyle(
                    color: notificationBodyColor,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w500),
              ),
            ),
            categoriesComponent(),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 6),
              child: Text(
                "Message",
                style: TextStyle(
                    color: bodyColor,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: dividerColor, width: 1),
                  color: inputFieldColor,
                  borderRadius: BorderRadius.circular(4)),
              child: TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                    hintText: "Message",
                    hintStyle: TextStyle(
                        color: inactiveBottomNavIconColor,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w400)),
                minLines: 5,
                maxLines: null,
              ),
            ),
            feedbackEmpty
                ? errorText(
                    text: "Please Enter your Feedback before you click Submit")
                : SizedBox(),
            const SizedBox(
              height: 70,
            ),
            submitButton(
              disable: isLoading,
              onInteraction: () {
                if (feedbackController.text.isEmpty) {
                  feedbackEmpty = true;
                }
                print("category ID: ${catId}");
                print("Content ${value!.title}");
                BlocProvider.of<FeedbackBloc>(context).add(SubmitFeedbackEvent(
                    FeedbackModel(title_id: catId, content: value!.title)));
              },
              text: isLoading ? "Submitting ..." : "Submit",
            )
          ],
        ),
      ),
    );
  }

  Widget categoriesComponent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<FeedbackTitle>(
            value: value,
            isExpanded: true,
            hint: Text(
              'Select Category',
              style: TextStyle(
                  color: blackColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w500),
            ),
            items: categories.map(buildMenuCategories).toList(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: primaryColor,
              size: 30,
            ),
            onChanged: (value) {
              setState(() {
                this.value = value;
                catId = value!.id;
              });
            }),
      ),
    );
  }

  DropdownMenuItem<FeedbackTitle> buildMenuCategories(FeedbackTitle category) =>
      DropdownMenuItem(
          value: category,
          child: Text(
            category.title,
            style: TextStyle(
                color: primaryColor,
                fontSize: fontSize14,
                fontWeight: FontWeight.w500),
          ));
}
