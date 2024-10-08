import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/textFormField.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';
import 'package:ticketing_app/features/home/presentation/screens/sellTicketDialog.dart';
import 'package:ticketing_app/features/home/presentation/widgets/secondaryButton.dart';

class ReturnPromptDialog extends StatefulWidget {
  final String eventId;
  final TicketModel ticket;
  ReturnPromptDialog({super.key, required this.eventId, required this.ticket});

  @override
  State<ReturnPromptDialog> createState() => _ReturnPromptDialogState();
}

class _ReturnPromptDialogState extends State<ReturnPromptDialog> {
  TextEditingController reasonController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return buildDialog();
  }

  Widget buildDialog() {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      surfaceTintColor: whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: width < 290 ? 15 : 24),
      content: SizedBox(
        height: 270,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Fill out the following information to proceed",
              style: TextStyle(
                  color: blackColor,
                  fontSize: fontSize18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 21,
            ),
            textFormField(
                controller: reasonController,
                hintText: 'Reason',
                icon: Icons.description,
                onInteraction: () {}),
            const SizedBox(
              height: 21,
            ),
            textFormField(
                controller: accountController,
                hintText: 'Account Number',
                icon: Icons.money,
                onInteraction: () {}),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () {},
                  child: Text(
                    "Have Questions?",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: fontSize10,
                        fontWeight: FontWeight.w400),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      actions: [
        width > 290
            ? Row(
                children: [
                  Expanded(
                    child: secondaryButton(
                        text: "Go back",
                        onInteraction: () {
                          Navigator.of(context).pop();
                        },
                        bgColor: Colors.green[100],
                        txtColor: Colors.green,
                        border: false),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: submitButton(
                        text: "Return Ticket",
                        disable: false,
                        onInteraction: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SellTicketDialog(
                                  eventId: widget.eventId,
                                  bankNumber: accountController.text,
                                  cause: reasonController.text,
                                  ticket: widget.ticket,
                                );
                              });
                        }),
                  ),
                ],
              )
            : Column(
                children: [
                  secondaryButton(
                      text: "Go back",
                      onInteraction: () {
                        Navigator.of(context).pop();
                      },
                      bgColor: Colors.green[100],
                      txtColor: Colors.green,
                      border: false),
                  SizedBox(
                    width: 10,
                  ),
                  submitButton(
                      text: "Return Ticket",
                      disable: false,
                      onInteraction: () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SellTicketDialog(
                                eventId: widget.eventId,
                                bankNumber: accountController.text,
                                cause: reasonController.text,
                                ticket: widget.ticket,
                              );
                            });
                      }),
                ],
              )
      ],
    );
  }
}
