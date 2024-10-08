import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/widgets/secondaryButton.dart';

class CancelResellDialog extends StatelessWidget {
  final String requestId;
  const CancelResellDialog({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      surfaceTintColor: whiteColor,
      title: Text(
        "Cancel Refund",
        style: TextStyle(
            color: primaryColor,
            fontSize: fontSize18,
            fontWeight: FontWeight.w600),
      ),
      content: Text(
        "Are you sure you want to cancel your Refund Request?",
        style: TextStyle(
            color: blackColor,
            fontSize: fontSize16,
            fontWeight: FontWeight.w500),
      ),
      actions: [
        width > 290
            ? Row(
                children: [
                  Expanded(
                    child: secondaryButton(
                        text: "Cancel",
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
                    child: secondaryButton(
                        text: "Confirm",
                        bgColor: dangerColor,
                        txtColor: whiteColor,
                        onInteraction: () {
                          BlocProvider.of<CancelRequestBloc>(context)
                              .add(CancelReturnRequestEvent(requestId));
                        },
                        border: false),
                  ),
                  BlocListener<CancelRequestBloc, CancelRequestState>(
                    listener: (context, state) {
                      if (state is CancelReturnRequestLoadingState) {
                        Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      } else if (state is CancelReturnRequestSuccessfulState) {
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Refund request has been cancelled"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        BlocProvider.of<ReturnRequestBloc>(context)
                            .add(GetReturnTicketEvent());
                      } else if (state is CancelReturnRequestFailureState) {
                        errorFlushbar(
                            context: context,
                            message:
                                "Failed to Cancel Refund. Please try again");
                      }
                    },
                    child: Container(),
                  )
                ],
              )
            : Column(
                children: [
                  secondaryButton(
                      text: "Cancel",
                      onInteraction: () {
                        Navigator.of(context).pop();
                      },
                      bgColor: Colors.green[100],
                      txtColor: Colors.green,
                      border: false),
                  SizedBox(
                    width: 10,
                  ),
                  secondaryButton(
                      text: "Confirm Resale",
                      bgColor: dangerColor,
                      txtColor: whiteColor,
                      onInteraction: () {
                        Navigator.of(context).pop();
                        //TODO: Display notification when resell is cancelled.
                      },
                      border: false),
                ],
              )
      ],
    );
  }
}
