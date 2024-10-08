import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/common/loadingContainer.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/myTicketDetailScreen.dart';

class UpcomingTicketsTab extends StatefulWidget {
  const UpcomingTicketsTab({super.key});

  @override
  State<UpcomingTicketsTab> createState() => _UpcomingTicketsTabState();
}

class _UpcomingTicketsTabState extends State<UpcomingTicketsTab> {
  final pref = PrefService();

  DateTime now = DateTime.now();

  bool isEmpty = false;
  @override
  void initState() {
    BlocProvider.of<TicketBloc>(context).add(GetTicketEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TicketBloc, TicketState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is GetTicketLoadingState) {
            return buildLoading();
          } else if (state is GetTicketSuccessfulState) {
            var ticket = state.ticket;
            var passedTicket = ticket.where((myTicket) {
              DateTime deadline = DateTime.parse(myTicket.event.deadline);

              return deadline.isAfter(now);
            }).toList();
            if (passedTicket.isEmpty) {
              return buildEmptyState();
            } else {
              return buildInitialInput(ticket: passedTicket);
            }
          } else if (state is GetTicketFailureState) {
            if (state.error ==
                "ClientException with SocketException: Failed host lookup: 'ticket-plus-api.onrender.com' (OS Error: No address associated with hostname, errno = 7), uri=https://ticket-plus-api.onrender.com/api/v1/eventticket") {
              return errorFlushbar(
                  context: context, message: socketErrorMessage);
            } else {
              return errorFlushbar(context: context, message: state.error);
            }
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "images/noTicket.svg",
            height: 123,
            width: 120,
          ),
          const SizedBox(
            height: 36,
          ),
          Text(
            "No Ticket for Upcoming Event",
            style: TextStyle(
                color: blackColor,
                fontSize: fontSize16,
                fontWeight: FontWeight.w600),
          ),
          Text(
            "There is no ticket that you bought.",
            style: TextStyle(
                color: locationTextColor,
                fontSize: fontSize12,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget buildInitialInput({required List<TicketModel> ticket}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ticket.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    await pref.storeEventId(ticket[index].event.event_id);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MyTicketDetailScreen(ticket: ticket[index])));
                  },
                  child: Container(
                    height: 95, //TODO: Calculate based on the screen Size
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1, color: inactiveBottomNavIconColor),
                            borderRadius: BorderRadius.circular(8))),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            ticket[index].event.cover_image_url,
                            width: 106,
                            height: 75,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ticket[index].event.event_name,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: fontSize15,
                                    fontWeight: FontWeight.w600),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                formatDate(ticket[index].event.event_date),
                                style: TextStyle(
                                    color: notificationBodyColor,
                                    fontSize: fontSize12,
                                    fontWeight: FontWeight.w500),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            width: 20,
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_forward_ios)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget buildLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 95, //TODO: Calculate based on the screen Size
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: inactiveBottomNavIconColor),
                          borderRadius: BorderRadius.circular(8))),
                  child: Row(
                    children: [
                      LoadingContainer(width: 106, height: 75, borderRadius: 4),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingContainer(
                                width: 170, height: 20, borderRadius: 10),
                            SizedBox(
                              height: 4,
                            ),
                            LoadingContainer(
                                width: 80, height: 20, borderRadius: 10)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 20,
                          child: IconButton(
                              onPressed: () {}, icon: const Icon(null)),
                        ),
                      )
                    ],
                  ),
                );
              }),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
