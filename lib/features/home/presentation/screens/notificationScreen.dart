import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/features/home/presentation/widgets/appBar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    print("object");
    await Future.delayed(Duration(seconds: 2));

    print("after 2 secs");

    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Notifications"),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: onRefresh,
        header: WaterDropHeader(
          waterDropColor: primaryColor,
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = SizedBox.shrink();
            } else if (mode == LoadStatus.loading) {
              body = Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: primaryColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Loading...',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              );
            } else if (mode == LoadStatus.failed) {
              body = Text('Load Failed! Click retry!');
            } else if (mode == LoadStatus.canLoading) {
              body = Text('Release to load more');
            } else {
              body = SizedBox.shrink();
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                          color: locationTextColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Divider(
                        color: locationTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 18),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border.all(color: notificationCircleColor),
                          shape: BoxShape.circle),
                      child: SvgPicture.asset("images/check.svg"),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "New Update Available!",
                            style: TextStyle(
                                color: blackColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Update Ticket+ and get a better experience asdf asd f asdf asdfasdf",
                            style: TextStyle(
                                color: notificationBodyColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            "09:40 AM",
                            style: TextStyle(
                                color: locationTextColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 13),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                const SizedBox(
                  height: 28,
                ),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 72,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: const DecorationImage(
                              image: AssetImage(
                                "images/tiles/rophnan.png",
                              ),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "There is a ROPHAN concert you may be interested",
                            style: TextStyle(
                                color: blackColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w500),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            "09:40 AM",
                            style: TextStyle(
                                color: locationTextColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 13),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                const SizedBox(
                  height: 33,
                ),
                Row(
                  children: [
                    Text(
                      "Yesterday",
                      style: TextStyle(
                          color: locationTextColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Divider(
                        color: locationTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 18),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border.all(color: notificationCircleColor),
                          shape: BoxShape.circle),
                      child: SvgPicture.asset("images/check.svg"),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Successful Payment!",
                            style: TextStyle(
                                color: blackColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "You have bought ticket to the Loche sports event",
                            style: TextStyle(
                                color: notificationBodyColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            "09:40 AM",
                            style: TextStyle(
                                color: locationTextColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 13),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Dec 20, 2023",
                      style: TextStyle(
                          color: locationTextColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Divider(
                        color: locationTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 18),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border.all(color: notificationCircleColor),
                          shape: BoxShape.circle),
                      child: SvgPicture.asset("images/check.svg"),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Successful Payment!",
                            style: TextStyle(
                                color: blackColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "You have bought ticket to the Loche sports event",
                            style: TextStyle(
                                color: notificationBodyColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            "09:40 AM",
                            style: TextStyle(
                                color: locationTextColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 13),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
