import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/guidelines/presentation/widgets/secondaryTextFormField.dart';
import 'package:ticketing_app/features/home/presentation/widgets/appBar.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  List<String> myList = ["General", "Account", "Event", "Payment", "Resell"];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Help Center"),
      body: buildInitialInput(),
    );
  }

  Widget buildInitialInput() {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 45,
            width: width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: myList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: index == 0 ? primaryColor : whiteColor,
                          borderRadius: BorderRadius.circular(100),
                          border: index == 0
                              ? null
                              : Border.all(color: hintColor, width: 1)),
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: Text(
                        myList[index],
                        style: TextStyle(
                          color: index == 0
                              ? whiteColor
                              : ticketDetailScreenTextColor,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: secondaryTextFormField(
                controller: searchController,
                hintText: "Search",
                icon: Icons.search,
                onInteraction: () {}),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
                itemCount: 10,
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
                            "What is Ticket+",
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
                                "You An event description is a written piece that provides an overview of your event. It serves as a persuasive statement that aims to attract your intended audience and potentially attract.",
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
