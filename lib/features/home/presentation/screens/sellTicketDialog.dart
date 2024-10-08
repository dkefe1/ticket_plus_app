import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/home/data/models/returnRequest.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/returnSuccessDialog.dart';
import 'package:ticketing_app/features/home/presentation/widgets/secondaryButton.dart';

class SellTicketDialog extends StatefulWidget {
  final String eventId;
  final String bankNumber;
  final String cause;
  final TicketModel ticket;
  SellTicketDialog(
      {super.key,
      required this.eventId,
      required this.bankNumber,
      required this.cause,
      required this.ticket});

  @override
  State<SellTicketDialog> createState() => _SellTicketDialogState();
}

class _SellTicketDialogState extends State<SellTicketDialog> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestReturnBloc, RequestReturnState>(
      listener: (context, state) {
        if (state is RequestReturnLoadingState) {
          isLoading = true;
        } else if (state is RequestReturnSuccessfulState) {
          isLoading = false;
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) {
                return ReturnSuccessDialog();
              });
        } else if (state is RequestReturnFailureState) {
          isLoading = false;
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) {
                return ReturnSuccessDialog();
              });
        }
      },
      builder: (context, state) {
        print(state);
        return buildDialog();
      },
    );
  }

  Widget buildDialog() {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      surfaceTintColor: whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: width < 290 ? 15 : 24),
      title: Text(
        "Sell Ticket",
        style: TextStyle(
            color: blackColor,
            fontSize: fontSize18,
            fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 300,
        width: width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to you want to sell this ticket",
                    style: TextStyle(
                        color: blackColor,
                        fontSize: fontSize12,
                        fontWeight: FontWeight.w400),
                  ),
                  buildRow(
                      "Event Type",
                      widget.ticket.event.category[0].category_name,
                      false,
                      false),
                  buildRow("Event Name", widget.ticket.event.event_name, false,
                      false),
                  buildRow("Ticket Type", widget.ticket.sit_type, false, false),
                  buildRow("Venue", widget.ticket.event.venue, false, false),
                  buildRow("Region", widget.ticket.event.region, false, false),
                  buildRow("Deadline", formatDate(widget.ticket.event.deadline),
                      false, false),
                  buildRow(
                      "Ticket For", widget.ticket.phone_number, false, true),
                  buildRow(
                      "Paid Fee", "${widget.ticket.price} Birr", false, false),
                  buildRow(
                      "Sell Fee",
                      "${(double.parse(widget.ticket.price) * 0.25)} Birr",
                      true,
                      false),
                  buildRow(
                      "Selling Price",
                      "${(double.parse(widget.ticket.price) - double.parse(widget.ticket.price) * 0.25)} Birr",
                      false,
                      true),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : SizedBox.shrink()
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
                        text: "Confirm Return",
                        disable: false,
                        onInteraction: () {
                          BlocProvider.of<RequestReturnBloc>(context).add(
                              PostRequestReturnEvent(RequestReturn(
                                  event_id: widget.eventId,
                                  bank_number: widget.bankNumber,
                                  cause: widget.cause)));
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
                      text: "Confirm Return",
                      disable: false,
                      onInteraction: () {
                        BlocProvider.of<RequestReturnBloc>(context).add(
                            PostRequestReturnEvent(RequestReturn(
                                event_id: widget.eventId,
                                bank_number: widget.bankNumber,
                                cause: widget.cause)));
                      }),
                ],
              )
      ],
    );
  }

  Widget buildRow(String lead, String follow, bool mixedText, bool green) {
    return green
        ? Row(
            children: [
              Text(
                lead,
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w500),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              Text(
                " : ",
                style: TextStyle(
                    color: tileDateColor,
                    fontSize: fontSize18,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Text(
                  follow,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: fontSize10,
                      fontWeight: FontWeight.w500),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          )
        : Row(
            children: [
              Text(
                lead,
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w500),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              Text(
                " : ",
                style: TextStyle(
                    color: tileDateColor,
                    fontSize: fontSize18,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: mixedText
                    ? RichText(
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                            style: TextStyle(
                                color: tileDateColor,
                                fontSize: fontSize10,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: follow,
                              ),
                              TextSpan(
                                text: "(25%)",
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ]))
                    : Text(
                        follow,
                        style: TextStyle(
                            color: tileDateColor,
                            fontSize: fontSize10,
                            fontWeight: FontWeight.w400),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
              ),
            ],
          );
  }
}
