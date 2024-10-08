import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/guidelines/data/models/termsAndConditions.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_bloc.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_event.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_state.dart';
import 'package:ticketing_app/features/home/presentation/widgets/appBar.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  List<String> myList = ["General", "Account", "Event", "Payment", "Resell"];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TermsAndConditionsBloc>(context)
        .add(GetTermsAndConditionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Terms and Conditions"),
      body: BlocConsumer<TermsAndConditionsBloc, TermsAndConditionsState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is TermsAndConditionsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TermsAndConditionsSuccessfulState) {
            return buildInitialInput(terms: state.terms);
          } else if (state is TermsAndConditionsFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required List<TermsAndConditions> terms}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
                itemCount: terms.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                          color: inputFieldColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: index == 0,
                          iconColor: primaryColor,
                          collapsedIconColor: primaryColor,
                          title: Text(
                            terms[index].title,
                            style: TextStyle(
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w600,
                                color: blackColor),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 28),
                              child: Text(
                                terms[index].content,
                                style: TextStyle(
                                    fontSize: fontSize12,
                                    fontWeight: FontWeight.w500,
                                    color: notificationBodyColor),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            )
                          ],
                        ),
                      ));
                }),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
