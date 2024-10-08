import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/home/data/dataSources/remoteDatasource/homeDataSource.dart';
import 'package:ticketing_app/features/home/data/repositories/homeRepository.dart';
import 'package:ticketing_app/features/home/presentation/screens/homeScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/myFeed.dart';
import 'package:ticketing_app/features/home/presentation/screens/profile.dart';
import 'package:ticketing_app/features/home/presentation/screens/ticketsScreen.dart';
// import 'package:ticketing_app/features/home/presentation/screens/travel.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key, required this.pageIndex});

  final int pageIndex;
  @override
  State<IndexScreen> createState() => _IndexScreenState(pageIndex: pageIndex);
}

class _IndexScreenState extends State<IndexScreen> {
  final pages = [
    HomeScreen(
      homeRepository: HomeRepository(HomeRemoteDataSource()),
    ),
    // TravelScreen(),
    MyFeedScreen(),
    TicketsScreen(),
    ProfileScreen()
  ];
  _IndexScreenState({required this.pageIndex});

  int pageIndex;
  void navigationMenu(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: navigationMenu,
          selectedItemColor: primaryColor,
          unselectedItemColor: inactiveBottomNavIconColor,
          showUnselectedLabels: true,
          currentIndex: pageIndex,
          items: [
            BottomNavigationBarItem(
                icon: pageIndex == 0
                    ? SvgPicture.asset("images/homeSelected.svg")
                    : SvgPicture.asset("images/home.svg"),
                label: "Home"),
            // BottomNavigationBarItem(
            //     icon: pageIndex == 1
            //         ? SvgPicture.asset("images/travelSelected.svg")
            //         : SvgPicture.asset('images/travel.svg'),
            //     label: "Travel"),
            BottomNavigationBarItem(
                icon: pageIndex == 2
                    ? SvgPicture.asset("images/myFeedSelected.svg")
                    : SvgPicture.asset("images/myFeed.svg"),
                label: "My Feed"),
            BottomNavigationBarItem(
                icon: pageIndex == 3
                    ? SvgPicture.asset("images/ticketsSelected.svg")
                    : SvgPicture.asset("images/tickets.svg"),
                label: "Tickets"),
            BottomNavigationBarItem(
                icon: pageIndex == 4
                    ? SvgPicture.asset("images/profileSelected.svg")
                    : SvgPicture.asset("images/profile.svg"),
                label: "Profile")
          ]),
    );
  }
}
