import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/indexScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/ticket.dart';
import 'package:ticketing_app/features/home/presentation/widgets/secondaryButton.dart';

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({super.key});

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TicketBloc>(context).add(GetTicketEvent());
  }

  final pref = PrefService();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      surfaceTintColor: whiteColor,
      content: SizedBox(
        height: 425,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/ticketSuccess.svg",
              fit: BoxFit.cover,
              height: 113,
              width: 113,
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              "Ticket Successfully Bought",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: blackColor,
                  fontSize: fontSize18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 21,
            ),
            submitButton(
                text: "View Ticket",
                disable: false,
                onInteraction: () async {
                  var eventId = await pref.readEventId();
                  BlocConsumer<TicketBloc, TicketState>(
                    listener: (context, state) {
                      print(state);
                      if (state is GetTicketSuccessfulState) {
                        var ticket = state.ticket;
                        var filteredEvent = ticket.where((myTicket) {
                          return myTicket.event.event_id ==
                              eventId; // Filter by eventId
                        }).toList();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                Ticket(ticket: filteredEvent[0])));
                      }
                    },
                    builder: (context, state) {
                      return SizedBox.shrink();
                    },
                  );
                  Navigator.of(context).pop();
                }),
            const SizedBox(
              height: 15,
            ),
            secondaryButton(
                text: "Go back home",
                onInteraction: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => IndexScreen(pageIndex: 0)));
                },
                bgColor: Colors.green[100],
                txtColor: primaryColor,
                border: false)
          ],
        ),
      ),
    );
  }
}
