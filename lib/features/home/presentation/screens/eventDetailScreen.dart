import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/common/loadingContainer.dart';
import 'package:ticketing_app/features/home/data/models/bookmark.dart';
import 'package:ticketing_app/features/home/data/models/event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/verifyDialog.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final pref = PrefService();

  String eventId = "";
  String package = "";
  int packagePrice = 0;

  int selectedPackageIndex = -1;
  bool isBookmarked = false;

  @override
  void initState() {
    BlocProvider.of<EventBloc>(context).add(GetEventListEvent());
    fetchEventId();
    super.initState();
  }

  Future<void> fetchEventId() async {
    final id = await pref.readEventId();
    setState(() {
      eventId = id;
    });

    final isBookmarkedFromStorage = await pref.isEventBookmarked(eventId);
    setState(() {
      isBookmarked = isBookmarkedFromStorage;
    });
  }

  void _showImageDialog(BuildContext context, Event eventData) {
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
                image: NetworkImage(eventData.cover_image_url),
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await pref.removeEventId();
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(
              onPressed: () async {
                final event_id = await pref.readEventId();
                BlocProvider.of<BookmarkBloc>(context)
                    .add(PostBookmarkEvent(Bookmark(event_id: event_id)));
                setState(() {
                  isBookmarked = !isBookmarked;
                });
                await pref.setEventBookmarked(eventId, isBookmarked);
                if (!isBookmarked) {
                  await pref.removeEventBookmark(eventId);
                  BlocProvider.of<BookmarkBloc>(context)
                      .add(DeleteBookmarkEvent(eventId));
                  print('Removeddddddddddd');
                }
              },
              icon: SvgPicture.asset(isBookmarked
                  ? "images/bookmarkSelected.svg"
                  : "images/bookmark.svg")),
        ],
      ),
      body: BlocConsumer<EventBloc, EventState>(
        listener: (_, state) {},
        builder: (_, state) {
          if (state is EventLoadingState) {
            return buildLoading();
          } else if (state is EventSuccessfulState) {
            final event = state.event;
            final singleEventData =
                event.firstWhere((eventData) => eventData.event_id == eventId);
            return buildInitialInput(eventData: singleEventData);
          } else if (state is EventFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required Event eventData}) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _showImageDialog(context, eventData);
                },
                child: Container(
                  height: 225,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(eventData.cover_image_url),
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
                height: 115,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // "16th Aug 2022 - 6:15pm",
                          formatDate(eventData.event_date),
                          style: TextStyle(
                              color: tileDateColor, fontSize: fontSize10),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
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
                      eventData.event_name,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize18,
                          fontWeight: FontWeight.w700),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      eventData.venue,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w500),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      eventData.region,
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
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Category:",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                Text(
                  eventData.category[0].category_name,
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                Text(
                  "Description:",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  eventData.event_description,
                  style: TextStyle(
                      color: notificationBodyColor,
                      fontSize: fontSize12,
                      fontWeight: FontWeight.w500),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Max sits : ${eventData.max_sit}',
                        style: TextStyle(
                          color: ticketDetailScreenTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          text: TextSpan(
                              style: TextStyle(
                                color: ticketDetailScreenTextColor,
                                fontSize: fontSize12,
                              ),
                              children: [
                                TextSpan(
                                    text: "Deadline: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: formatDate(eventData.deadline),
                                    style: TextStyle(
                                        fontSize: fontSize11,
                                        fontWeight: FontWeight.w400)),
                              ])),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.only(
                      left: 17, right: 17, top: 17, bottom: 10),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: inactiveBottomNavIconColor),
                          borderRadius: BorderRadius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Package",
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
                      SizedBox(
                        height: 370,
                        child: ListView.builder(
                            physics: width < 300
                                ? null
                                : NeverScrollableScrollPhysics(),
                            itemCount: eventData.pricing.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedPackageIndex == index) {
                                      selectedPackageIndex = -1;
                                    } else {
                                      selectedPackageIndex = index;
                                    }

                                    if (selectedPackageIndex == 0) {
                                      package =
                                          eventData.pricing[index].sit_type;
                                      packagePrice = int.parse(
                                          eventData.pricing[index].price);
                                      print(eventData.pricing[index].price);
                                    } else if (selectedPackageIndex == 1) {
                                      package =
                                          eventData.pricing[index].sit_type;
                                      packagePrice = int.parse(
                                          eventData.pricing[index].price);
                                      print(eventData.pricing[index].price);
                                    } else if (selectedPackageIndex == 2) {
                                      package =
                                          eventData.pricing[index].sit_type;
                                      packagePrice = int.parse(
                                          eventData.pricing[index].price);
                                      print(eventData.pricing[index].price);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: selectedPackageIndex == index
                                          ? Border.all(
                                              width: 2, color: primaryColor)
                                          : Border()),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 53,
                                        width: 53,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            eventData.pricing[index].sit_type,
                                            style: TextStyle(
                                                color: blackColor,
                                                fontSize: eventData
                                                            .pricing[index]
                                                            .sit_type ==
                                                        "STANDARD"
                                                    ? fontSize8
                                                    : fontSize16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                    color:
                                                        notificationBodyColor,
                                                  ),
                                                  children: [
                                            TextSpan(
                                                text: eventData.pricing[index]
                                                        .benefits +
                                                    "\n\n",
                                                style: TextStyle(
                                                    fontSize: fontSize12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            TextSpan(
                                                text:
                                                    "${eventData.pricing[index].price} Birr",
                                                style: TextStyle(
                                                    fontSize: fontSize18,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ])))
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 70, bottom: 30),
            child: submitButton(
                text: "Buy Ticket",
                disable: false,
                onInteraction: () {
                  print(package);
                  print(packagePrice);
                  selectedPackageIndex == -1
                      ? errorFlushbar(
                          context: context,
                          message: "Please select Package Type to proceed")
                      : showDialog(
                          context: context,
                          builder: (context) {
                            return VerifyDialogBox(
                              package: package,
                              packagePrice: packagePrice,
                              event: eventData,
                            );
                          });
                }),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  Widget buildLoading() {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              LoadingContainer(width: width, height: 225, borderRadius: 0),
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
                            width: 155, height: 20, borderRadius: 10),
                        const SizedBox(
                          width: 10,
                        ),
                        LoadingContainer(
                            width: 40, height: 20, borderRadius: 10)
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    LoadingContainer(width: 200, height: 22, borderRadius: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: LoadingContainer(
                          width: 120, height: 18, borderRadius: 10),
                    ),
                    LoadingContainer(width: 90, height: 18, borderRadius: 10),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingContainer(width: 100, height: 22, borderRadius: 10),
                const SizedBox(
                  height: 10,
                ),
                LoadingContainer(width: width, height: 18, borderRadius: 10),
                const SizedBox(
                  height: 5,
                ),
                LoadingContainer(width: width, height: 18, borderRadius: 10),
                const SizedBox(
                  height: 5,
                ),
                LoadingContainer(width: width, height: 18, borderRadius: 10),
                const SizedBox(
                  height: 5,
                ),
                LoadingContainer(
                    width: width / 2, height: 18, borderRadius: 10),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: LoadingContainer(
                          width: 90, height: 20, borderRadius: 10),
                    ),
                    Flexible(
                      child: LoadingContainer(
                          width: 180, height: 20, borderRadius: 10),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.only(
                      left: 17, right: 17, top: 17, bottom: 10),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: inactiveBottomNavIconColor),
                          borderRadius: BorderRadius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingContainer(width: 90, height: 20, borderRadius: 10),
                      const SizedBox(
                        height: 16,
                      ),
                      Divider(
                        color: dividerColor,
                      ),
                      SizedBox(
                        height: 370,
                        child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedPackageIndex == index) {
                                      selectedPackageIndex = -1;
                                    } else {
                                      selectedPackageIndex = index;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: selectedPackageIndex == index
                                          ? Border.all(
                                              width: 2, color: primaryColor)
                                          : Border()),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  child: Row(
                                    children: [
                                      LoadingContainer(
                                          width: 53,
                                          height: 53,
                                          borderRadius: 300),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LoadingContainer(
                                              width: width,
                                              height: 18,
                                              borderRadius: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: LoadingContainer(
                                                width: width,
                                                height: 18,
                                                borderRadius: 10),
                                          ),
                                          LoadingContainer(
                                              width: width * 0.4,
                                              height: 18,
                                              borderRadius: 10),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          LoadingContainer(
                                              width: 90,
                                              height: 22,
                                              borderRadius: 10),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 70, bottom: 30),
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            width: width,
            height: 45,
            decoration: BoxDecoration(
                color: inactiveButton, borderRadius: BorderRadius.circular(25)),
            child: LoadingContainer(width: 30, height: 20, borderRadius: 10),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
