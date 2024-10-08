import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/home/presentation/screens/passedTicketsTab.dart';
import 'package:ticketing_app/features/home/presentation/screens/upcomingTicketsTab.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: null,
            icon: SvgPicture.asset(
              "images/logoSecond.svg",
              height: 27,
              width: 27,
            ),
          ),
          centerTitle: true,
          title: Text(
            "My Tickets",
            style: TextStyle(
                color: blackColor,
                fontSize: fontSize18,
                fontWeight: FontWeight.w600),
          ),
          toolbarHeight: 80,
          bottom: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              labelStyle: const TextStyle(
                  fontSize: fontSize14, fontWeight: FontWeight.w600),
              labelColor: primaryColor,
              unselectedLabelStyle: const TextStyle(
                  fontSize: fontSize14, fontWeight: FontWeight.w500),
              unselectedLabelColor: locationTextColor,
              indicatorColor: primaryColor,
              tabs: const [
                Tab(
                  text: "Upcoming",
                ),
                Tab(
                  text: "Passed",
                )
              ]),
        ),
        body: TabBarView(children: [UpcomingTicketsTab(), PassedTicketsTab()]),
      ),
    );
  }
}
