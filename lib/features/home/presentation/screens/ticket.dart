import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';

class Ticket extends StatelessWidget {
  final TicketModel ticket;
  const Ticket({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        toolbarHeight: height * 0.1,
        surfaceTintColor: whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: whiteColor,
            )),
        centerTitle: true,
        title: Center(
            child: Text(
          "Tickets",
          style: TextStyle(
              color: whiteColor,
              fontSize: fontSize18,
              fontWeight: FontWeight.w600),
        )),
        actions: [
          SizedBox(
            width: 30,
          )
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Divider(
                color: whiteColor,
              ),
            )),
      ),
      body: Container(
        color: primaryColor,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 40),
              child: SvgPicture.asset(
                "images/ticketBg.svg",
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: height > 700
                    ? height < 900
                        ? height > 850
                            ? 740
                            : height < 760
                                ? 600
                                : 700
                        : 770
                    : 530,
                width: width > 380 ? 360 : 270,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      ticket.entrance_code,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: width > 380 ? fontSize80 : fontSize55,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ticket.phone_number,
                      style: TextStyle(
                          color: locationTextColor,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Divider(),
                    ),
                    SizedBox(height: 5),
                    Text(
                      ticket.event.event_name,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize18,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      formatMyDate(ticket.event.event_date),
                      style: TextStyle(
                          color: notificationBodyColor,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Divider(),
                    Text(
                      ticket.event.venue,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize22,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ticket.event.region,
                      style: TextStyle(
                          color: notificationBodyColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      formatDate(ticket.event.event_date),
                      style: TextStyle(
                          color: notificationBodyColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "1 Person",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize16,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    ticket.event.category[0].category_name == "Sport"
                        ? Image.asset(
                            "images/ticketPhoto.png",
                            fit: BoxFit.contain,
                            width: double.infinity,
                          )
                        : Image.asset(
                            "images/ticketPhoto.png",
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                    Text(
                      "Enjoy your event",
                      style: TextStyle(
                          color: locationTextColor,
                          fontSize: fontSize10,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    SvgPicture.asset(
                      "images/logoSecond.svg",
                      width: 26,
                      height: 26,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
