import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/common/loadingContainer.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/returnPromptDialog.dart';
import 'package:ticketing_app/features/home/presentation/screens/ticket.dart';
import 'package:ticketing_app/features/home/presentation/widgets/appBar.dart';
import 'package:ticketing_app/features/home/presentation/widgets/secondaryButton.dart';

class MyTicketDetailScreen extends StatefulWidget {
  final TicketModel ticket;
  MyTicketDetailScreen({super.key, required this.ticket});

  @override
  State<MyTicketDetailScreen> createState() => _MyTicketDetailScreenState();
}

class _MyTicketDetailScreenState extends State<MyTicketDetailScreen> {
  final pref = PrefService();

  @override
  void initState() {
    BlocProvider.of<TicketBloc>(context).add(GetTicketEvent());
    super.initState();
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/ticketDetail.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  weight: 3,
                  color: whiteColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Ticket Details"),
      body: BlocConsumer<TicketBloc, TicketState>(
        listener: (context, state) async {
          String eventId = await pref.readEventId();
          if (state is GetTicketSuccessfulState) {
            print(eventId + " ggggggggggggggg");

            print('');
            print('');
          }
        },
        builder: (context, state) {
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() {
    double taxPercentage = 0.05;
    double tax = int.parse(widget.ticket.price) * taxPercentage;
    int taxAmount = tax.toInt();
    int price = int.parse(widget.ticket.price) - taxAmount;
    return SingleChildScrollView(
      child: Container(
        color: whiteColor,
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _showImageDialog(context);
                  },
                  child: Container(
                    height: 225,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/ticketDetail.png"),
                            fit: BoxFit.cover)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 170, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: whiteColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x0C000000),
                            spreadRadius: 0,
                            blurRadius: 40,
                            offset: Offset(0, 10))
                      ]),
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDate(widget.ticket.event.event_date),
                            style: TextStyle(
                                color: tileDateColor, fontSize: fontSize10),
                          ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: onSellBgColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                "On Sell",
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: fontSize8,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        widget.ticket.event.event_name,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: fontSize18,
                            fontWeight: FontWeight.w700),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        widget.ticket.event.venue,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: fontSize12,
                            fontWeight: FontWeight.w500),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        widget.ticket.event.region,
                        style: TextStyle(
                            color: tileDateColor,
                            fontSize: fontSize10,
                            fontWeight: FontWeight.w400),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildContainer(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ticket Detail",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: dividerColor,
                ),
                buildRow("Venue", widget.ticket.event.venue),
                buildRow("Package", widget.ticket.ticket_type),
                buildRow("Date",
                    formatDateMMMddyyyy(widget.ticket.event.event_date)),
                buildRow("Starting Time",
                    formatTime(widget.ticket.event.event_date)),
              ],
            )),
            buildContainer(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price Detail",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: dividerColor,
                ),
                buildRow("VIP Price", "${price} Birr"),
                buildRow("Tax", "${taxAmount} Birr"),
                Divider(
                  color: dividerColor,
                ),
                buildRow("Total", "${widget.ticket.price} Birr"),
              ],
            )),
            buildContainer(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Transaction Detail",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: dividerColor,
                ),
                buildRow("Amount", "${widget.ticket.price} Birr"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Status",
                          style: TextStyle(
                              color: tileDateColor,
                              fontSize: fontSize12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 9),
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          "Paid",
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      )
                    ],
                  ),
                ),
                // buildRow("Payment Method", "CBE"),
                buildRow("Ticket ID", widget.ticket.id),
                // buildRow("Transaction ID", "iuvqf97qdwhd"),
                // buildRow("Reference ID", "iuvqf97qdwhd"),
              ],
            )),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: submitButton(
                  text: "View Ticket",
                  disable: false,
                  onInteraction: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Ticket(
                              ticket: widget.ticket,
                            )));
                  }),
            ),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: secondaryButton(
                  text: "Return Ticket",
                  onInteraction: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ReturnPromptDialog(
                            eventId: widget.ticket.event.event_id,
                            ticket: widget.ticket,
                          );
                        });
                  },
                  bgColor: whiteColor,
                  txtColor: primaryColor,
                  border: true),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return SingleChildScrollView(
      child: Container(
        color: whiteColor,
        child: Column(
          children: [
            Stack(
              children: [
                LoadingContainer(
                    width: double.infinity, height: 225, borderRadius: 10),
                Container(
                  margin: const EdgeInsets.only(top: 170, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: whiteColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x0C000000),
                            spreadRadius: 0,
                            blurRadius: 40,
                            offset: Offset(0, 10))
                      ]),
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LoadingContainer(
                              width: 120, height: 18, borderRadius: 10),
                          const SizedBox(
                            width: 10,
                          ),
                          LoadingContainer(
                              width: 50, height: 20, borderRadius: 10)
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      LoadingContainer(
                          width: 180, height: 22, borderRadius: 10),
                      const SizedBox(
                        height: 4,
                      ),
                      LoadingContainer(
                          width: 100, height: 18, borderRadius: 10),
                      const SizedBox(
                        height: 2,
                      ),
                      LoadingContainer(width: 80, height: 17, borderRadius: 10),
                    ],
                  ),
                ),
              ],
            ),
            buildContainer(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ticket Detail",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: dividerColor,
                ),
                buildLoadingRow("Venue"),
                buildLoadingRow("Package"),
                buildLoadingRow("Date"),
                buildLoadingRow("Starting Time"),
              ],
            )),
            buildContainer(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price Detail",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: dividerColor,
                ),
                buildLoadingRow("VIP Price"),
                buildLoadingRow("Tax"),
                Divider(
                  color: dividerColor,
                ),
                buildLoadingRow("Total"),
              ],
            )),
            buildContainer(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Transaction Detail",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  color: dividerColor,
                ),
                buildLoadingRow("Amount"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Status",
                          style: TextStyle(
                              color: tileDateColor,
                              fontSize: fontSize12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 9),
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: LoadingContainer(
                            width: 50, height: 18, borderRadius: 10),
                      )
                    ],
                  ),
                ),
                buildLoadingRow("Payment Method"),
                buildLoadingRow("Ticket ID"),
                buildLoadingRow("Transaction ID"),
                buildLoadingRow("Reference ID"),
              ],
            )),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: submitButton(
                  text: "View Ticket",
                  disable: false,
                  onInteraction: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Ticket(
                              ticket: widget.ticket,
                            )));
                  }),
            ),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: secondaryButton(
                  text: "Return Ticket",
                  onInteraction: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return SellTicketDialog();
                    //     });
                  },
                  bgColor: whiteColor,
                  txtColor: primaryColor,
                  border: true),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer(Widget myColumn) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.only(left: 17, right: 17, top: 17, bottom: 10),
            decoration: ShapeDecoration(
                color: inputFieldColor,
                shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1, color: inactiveBottomNavIconColor),
                    borderRadius: BorderRadius.circular(8))),
            child: myColumn,
          )
        ],
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  color: tileDateColor,
                  fontSize: fontSize12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: ticketDetailScreenTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingRow(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  color: tileDateColor,
                  fontSize: fontSize12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          LoadingContainer(width: 100, height: 18, borderRadius: 10),
        ],
      ),
    );
  }
}
