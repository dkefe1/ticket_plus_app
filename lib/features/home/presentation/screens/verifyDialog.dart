import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/home/data/models/event.dart';
import 'package:ticketing_app/features/home/presentation/screens/buyTicketConfirmation.dart';
import 'package:ticketing_app/features/home/presentation/widgets/dialogTextField.dart';

class VerifyDialogBox extends StatefulWidget {
  final String package;
  final int packagePrice;
  final Event event;
  VerifyDialogBox(
      {super.key,
      required this.package,
      required this.packagePrice,
      required this.event});

  @override
  State<VerifyDialogBox> createState() => _VerifyDialogBoxState();
}

class _VerifyDialogBoxState extends State<VerifyDialogBox> {
  final pref = PrefService();
  String ticketRecipient = "Self";
  TextEditingController ownPhone = TextEditingController();
  TextEditingController recipientPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    storePhoneNumber();
  }

  Future<void> storePhoneNumber() async {
    ownPhone.text = await pref.readPhone();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      surfaceTintColor: whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: width < 290 ? 15 : 24),
      content: Container(
        height: 340,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Who you would like to buy for?",
            style: TextStyle(
              color: blackColor,
              fontSize: fontSize18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "Select",
            style: TextStyle(
              color: blackColor,
              fontSize: fontSize12,
              fontWeight: FontWeight.w500,
            ),
          ),
          RadioListTile(
              contentPadding: EdgeInsets.zero,
              fillColor: MaterialStateProperty.all(primaryColor),
              title: dialogTextFormField(
                  onTap: () {
                    ticketRecipient = "Self";
                  },
                  controller: ownPhone,
                  hintText: "Your self",
                  onInteraction: () {},
                  enabled: false),
              value: "Self",
              groupValue: ticketRecipient,
              onChanged: (value) {
                setState(() {
                  ticketRecipient = "Self";
                });
              }),
          RadioListTile(
              contentPadding: EdgeInsets.zero,
              fillColor: MaterialStateProperty.all(primaryColor),
              title: Container(
                  width: width,
                  padding: const EdgeInsets.all(11),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: inactiveBottomNavIconColor),
                          borderRadius: BorderRadius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Someone else",
                        style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          color: notificationBodyColor,
                          fontSize: fontSize8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      dialogTextFormField(
                          onTap: () {
                            setState(() {
                              ticketRecipient = recipientPhone.toString();
                            });
                          },
                          controller: recipientPhone,
                          hintText: "Phone Number",
                          onInteraction: () {},
                          enabled: true),
                    ],
                  )),
              value: recipientPhone.toString(),
              groupValue: ticketRecipient,
              onChanged: (value) {
                setState(() {
                  ticketRecipient = value.toString();
                });
              }),
          const SizedBox(
            height: 20,
          ),
          submitButton(
              text: "Buy Ticket",
              disable: false,
              onInteraction: () {
                String ticketType =
                    ticketRecipient == "Self" ? "PERSONAL" : "GIFT";
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (context) {
                      return BuyTicketConfirmationDialog(
                        ticketType: ticketType,
                        package: widget.package,
                        packagePrice: widget.packagePrice,
                        phoneNumber: ticketRecipient == "Self"
                            ? ownPhone.text
                            : recipientPhone.text,
                        event: widget.event,
                      );
                    });
              })
        ]),
      ),
    );
  }
}
