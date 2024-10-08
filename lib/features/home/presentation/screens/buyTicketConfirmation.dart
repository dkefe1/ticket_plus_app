import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/home/data/models/buyTicket.dart';
import 'package:ticketing_app/features/home/data/models/event.dart';
import 'package:ticketing_app/features/home/data/models/ticketInputs.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/chapaPayment.dart';
import 'package:ticketing_app/features/home/presentation/screens/verifyDialog.dart';
import 'package:ticketing_app/features/home/presentation/widgets/secondaryButton.dart';

class BuyTicketConfirmationDialog extends StatefulWidget {
  final String ticketType;
  final int packagePrice;
  final String package, phoneNumber;
  final Event event;
  BuyTicketConfirmationDialog(
      {super.key,
      required this.ticketType,
      required this.packagePrice,
      required this.package,
      required this.phoneNumber,
      required this.event});

  @override
  State<BuyTicketConfirmationDialog> createState() =>
      _BuyTicketConfirmationDialogState();
}

class _BuyTicketConfirmationDialogState
    extends State<BuyTicketConfirmationDialog> {
  final pref = PrefService();
  bool isLoading = false;

  @override
  void initState() {
    print(widget.package);
    print(widget.packagePrice);
    print(widget.phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BuyTicketBloc, BuyTicketState>(
      listener: (context, state) {
        print(state);
        if (state is BuyTicketLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is BuyTicketSuccessfulState) {
          setState(() {
            isLoading = false;
          });
          print(state.checkout.checkout_url);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChapaPayment(
                    checkoutUrl: state.checkout.checkout_url,
                  )));
          // Navigator.of(context).pop();
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return SuccessDialog();
          //     });
        } else if (state is BuyTicketFailureState) {
          setState(() {
            isLoading = false;
          });
        }
      },
      builder: (context, state) {
        return buildInitialInput();
      },
    );
  }

  Widget buildInitialInput() {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      surfaceTintColor: whiteColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      titlePadding: EdgeInsets.only(left: 10, right: 10, top: 20),
      actionsPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      insetPadding: EdgeInsets.symmetric(horizontal: width < 290 ? 15 : 24),
      content: SizedBox(
        height: 250,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  buildRow("Event Type", widget.event.category[0].category_name,
                      false),
                  SizedBox(
                    height: 5,
                  ),
                  buildRow("Event Name", widget.event.event_name, false),
                  SizedBox(
                    height: 5,
                  ),
                  buildRow("Ticket Type", widget.package, false),
                  SizedBox(
                    height: 5,
                  ),
                  buildRow("Place", widget.event.region, false),
                  SizedBox(
                    height: 5,
                  ),
                  buildRow(
                      "Deadline", formatDate(widget.event.event_date), false),
                  SizedBox(
                    height: 5,
                  ),
                  buildRow("Ticket For", widget.phoneNumber, true),
                  SizedBox(
                    height: 5,
                  ),
                  buildRow("Total Fee", "${widget.packagePrice} Birr", false),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: primaryColor,
                  ))
                : SizedBox()
          ],
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "images/confirm.svg",
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 13,
          ),
          Text(
            "Confirmation",
            style: TextStyle(
                color: blackColor,
                fontSize: fontSize18,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: [
        width > 290
            ? Row(
                children: [
                  Expanded(
                    child: goBackButton(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: buyButton(),
                  ),
                ],
              )
            : Column(
                children: [
                  goBackButton(),
                  SizedBox(
                    width: 20,
                  ),
                  buyButton(),
                ],
              )
      ],
    );
  }

  Widget buyButton() {
    return submitButton(
        text: "Buy Ticket",
        disable: isLoading,
        onInteraction: () async {
          String event_id = await pref.readEventId();
          print("Event Id: ${event_id}");

          BlocProvider.of<BuyTicketBloc>(context).add(PostBuyTicketEvent(
              BuyTicket(
                  total_price: widget.packagePrice,
                  phone_number: widget.phoneNumber,
                  inputs: TicketInputs(
                      phone_number: widget.phoneNumber,
                      ticket_type: widget.ticketType,
                      sit_type: widget.package),
                  event_id: event_id)));
        });
  }

  Widget goBackButton() {
    return secondaryButton(
        text: "Go back",
        onInteraction: () {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) {
                return VerifyDialogBox(
                  package: widget.package,
                  packagePrice: widget.packagePrice,
                  event: widget.event,
                );
              });
        },
        bgColor: Colors.green[100],
        txtColor: Colors.green,
        border: false);
  }

  Widget buildRow(String lead, String follow, bool green) {
    return green
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                      color: tileDateColor,
                      fontSize: fontSize10,
                      fontWeight: FontWeight.w400),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
