import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/common/loadingContainer.dart';
import 'package:ticketing_app/features/home/data/dataSources/remoteDatasource/homeDataSource.dart';
import 'package:ticketing_app/features/home/data/models/event.dart';
import 'package:ticketing_app/features/home/data/repositories/homeRepository.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/concertScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/eventDetailScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/eventScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/seminarScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/sportScreen.dart';

class MyFeedScreen extends StatefulWidget {
  const MyFeedScreen({super.key});

  @override
  State<MyFeedScreen> createState() => _MyFeedScreenState();
}

class _MyFeedScreenState extends State<MyFeedScreen> {
  final pref = PrefService();
  int activeIndex = 0;

  Event? seminar;

  bool isSeminarEmpty = false;
  late List<String> userPreferences = [];

  @override
  void initState() {
    BlocProvider.of<EventBloc>(context).add(GetEventListEvent());
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    fetchUserPreferences();
    super.initState();
  }

  Future<void> fetchUserPreferences() async {
    userPreferences = await pref.getStringList();
    print(userPreferences.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(HomeRepository(HomeRemoteDataSource()))
        ..add(GetProfileEvent()),
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        if (state is ProfileLoadingState) {
          return buildLoading();
        } else if (state is ProfileSuccessfulState) {
          print(state);
          var profileData = state.profile;
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 100,
              leading: Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(
                    "images/profilePic.png",
                    width: 40,
                    height: 40,
                  )),
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: profileData.full_name,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize16,
                          fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: "\nWelcome Back",
                      style: TextStyle(
                          color: locationTextColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w600))
                ])),
              ),
            ),
            body: BlocConsumer<EventBloc, EventState>(
              listener: (context, state) {},
              builder: (context, state) {
                print(state);
                if (state is EventLoadingState) {
                  return buildLoading();
                } else if (state is EventSuccessfulState) {
                  // seminar = state.event.firstWhere((eventData) =>
                  //     eventData.category.category_name == "Seminar");
                  return buildInitialInput(event: state.event);
                } else if (state is EventFailureState) {
                  if (state.error ==
                      "ClientException with SocketException: Failed host lookup: 'tiket-plus-dev-api.onrender.com' (OS Error: No address associated with hostname, errno = 7), uri=https://tiket-plus-dev-api.onrender.com/api/v1/events") {
                    return errorFlushbar(
                        context: context, message: socketErrorMessage);
                  } else {
                    return errorFlushbar(
                        context: context, message: state.error);
                  }
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          );
        } else if (state is ProfileFailureState) {
          if (state.error ==
              "ClientException with SocketException: Failed host lookup: 'tiket-plus-dev-api.onrender.com' (OS Error: No address associated with hostname, errno = 7), uri=https://tiket-plus-dev-api.onrender.com/api/v1/attendees/profile") {
            return errorFlushbar(context: context, message: socketErrorMessage);
          } else {
            return errorFlushbar(context: context, message: state.error);
          }
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }

  Widget buildInitialInput({required List<Event> event}) {
    double width = MediaQuery.of(context).size.width;
    bool hasEventsBasedOnPreferences = event.any((eventDetail) {
      return eventDetail.category.any((category) {
        return userPreferences.contains(category.category_name);
      });
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          BlocProvider(
            create: (context) =>
                PromotionalEventBloc(HomeRepository(HomeRemoteDataSource()))
                  ..add(GetPromotionalEventList()),
            child: BlocBuilder<PromotionalEventBloc, PromotionalEventState>(
              builder: (context, state) {
                print(state);
                if (state is PromotionalEventSuccessfulState) {
                  var promotionalEvent = state.event;
                  return Stack(
                    children: [
                      CarouselSlider.builder(
                          itemCount: promotionalEvent.length,
                          itemBuilder: (context, index, realIndex) {
                            final promoImage =
                                promotionalEvent[index].cover_image_url;
                            return GestureDetector(
                                onTap: () async {
                                  print(promotionalEvent[index].event_id);
                                  print(promotionalEvent[index]
                                      .event_description);
                                  print(promotionalEvent[index].event_date);
                                  print(promotionalEvent[index].deadline);
                                  await pref.removeEventId();
                                  await pref.storeEventId(
                                      promotionalEvent[index].event_id);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetailScreen()));
                                },
                                child: buildImage(promoImage, index));
                          },
                          options: CarouselOptions(
                              height: width > 550 ? 250 : 200,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              viewportFraction: 1.0,
                              onPageChanged: (index, reason) =>
                                  setState(() => activeIndex = index))),
                      Positioned(
                        bottom: 40,
                        left: 17,
                        child: SizedBox(
                          width: width,
                          child: RichText(
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                style: TextStyle(color: whiteColor),
                                children: [
                                  TextSpan(
                                    text:
                                        "${promotionalEvent[activeIndex].event_name}\n",
                                    style: TextStyle(
                                        fontSize: fontSize24,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  TextSpan(
                                    text: formatMonthAndDate(
                                        promotionalEvent[activeIndex]
                                            .event_date),
                                    style: TextStyle(
                                        fontSize: fontSize16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 20,
                          left: width * 0.35,
                          child: buildIndicator(promotionalEvent))
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
          const SizedBox(
            height: 33,
          ),
          Visibility(
            visible: hasEventsBasedOnPreferences,
            child: SizedBox(
              height: 30,
              width: width,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    var eventDetail = event[index];
                    var filteredCategories = eventDetail.category
                        .where((category) =>
                            userPreferences.contains(category.category_name))
                        .toList();
                    return Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (event.any((eventDetail) {
                                return eventDetail.category.any((category) {
                                  return category.category_name == "Seminar";
                                });
                              })) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SeminarScreen()));
                              } else if (event.any((eventDetail) {
                                return eventDetail.category.any((category) {
                                  return category.category_name == "Concert";
                                });
                              })) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ConcertScreen()));
                              } else if (event.any((eventDetail) {
                                return eventDetail.category.any((category) {
                                  return category.category_name == "Sport";
                                });
                              })) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SportScreen()));
                              } else if (event.any((eventDetail) {
                                return eventDetail.category.any((category) {
                                  return category.category_name == "Event";
                                });
                              })) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EventsScreen()));
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    filteredCategories.isNotEmpty
                                        ? filteredCategories.first.category_name
                                        : "",
                                    style: TextStyle(
                                        color: blackColor,
                                        fontSize: fontSize18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                filteredCategories.isNotEmpty
                                    ? Row(
                                        children: [
                                          Text(
                                            "View all",
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: fontSize14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 20),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: primaryColor,
                                            ),
                                          )
                                        ],
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          hasEventsBasedOnPreferences
              ? SizedBox(
                  height: 270,
                  width: width,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        var eventDetail = event[index];
                        var filteredCategories = eventDetail.category
                            .where((category) => userPreferences
                                .contains(category.category_name))
                            .toList();
                        return Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: width,
                                height: 240,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredCategories.length,
                                    itemBuilder: (BuildContext context,
                                        int categoryIndex) {
                                      return GestureDetector(
                                        onTap: () async {
                                          await pref.storeEventId(
                                              eventDetail.event_id);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventDetailScreen()));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 16, bottom: 10),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    spreadRadius: 5,
                                                    blurRadius: 3,
                                                    offset: const Offset(0, 3))
                                              ],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10))),
                                          width: 213,
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            eventDetail
                                                                .cover_image_url),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10))),
                                                height: 145,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 12),
                                                  height: 125,
                                                  decoration: BoxDecoration(
                                                      color: whiteColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            formatDate(
                                                                eventDetail
                                                                    .event_date),
                                                            style: TextStyle(
                                                                color:
                                                                    tileDateColor,
                                                                fontSize:
                                                                    fontSize10),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    onSellBgColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: const Center(
                                                              child: Text(
                                                                "On Sell",
                                                                style: TextStyle(
                                                                    color:
                                                                        blackColor,
                                                                    fontSize:
                                                                        fontSize8,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        eventDetail.event_name,
                                                        style: TextStyle(
                                                            color: blackColor,
                                                            fontSize:
                                                                fontSize16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        eventDetail.venue,
                                                        style: TextStyle(
                                                            color: blackColor,
                                                            fontSize:
                                                                fontSize12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Text(
                                                        eventDetail.region,
                                                        style: TextStyle(
                                                            color:
                                                                locationTextColor,
                                                            fontSize:
                                                                fontSize12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        );
                      }),
                )
              : userPreferences.isEmpty || event.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "images/noTicket.svg",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "You have not yet chosen your preferences",
                            style: TextStyle(
                                color: locationTextColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "images/noTicket.svg",
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "There are no upcoming events based \non your preferences",
                            style: TextStyle(
                                color: locationTextColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildLoadingAppBar() {
    return AppBar(
      toolbarHeight: 100,
      title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              LoadingContainer(width: 50, height: 50, borderRadius: 100),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingContainer(width: 160, height: 20, borderRadius: 10),
                  SizedBox(
                    height: 4,
                  ),
                  LoadingContainer(width: 120, height: 20, borderRadius: 10)
                ],
              ),
            ],
          )),
    );
  }

  Widget buildLoading() {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: buildLoadingAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: LoadingContainer(
                      width: double.infinity,
                      height: width > 550 ? 250 : 200,
                      borderRadius: 8),
                ),
                Positioned(
                  bottom: 40,
                  left: 17,
                  child: SizedBox(
                    width: width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoadingContainer(
                              width: 190, height: 24, borderRadius: 10),
                          SizedBox(height: 4),
                          LoadingContainer(
                              width: 100, height: 20, borderRadius: 10)
                        ]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 33,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LoadingContainer(
                          width: 150, height: 20, borderRadius: 10),
                      LoadingContainer(width: 80, height: 20, borderRadius: 10)
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: width,
                    height: 240,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EventDetailScreen()));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 16, bottom: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3))
                                  ],
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              width: 213,
                              child: Stack(
                                children: [
                                  LoadingContainer(
                                      width: double.infinity,
                                      height: 145,
                                      borderRadius: 5),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      height: 125,
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              LoadingContainer(
                                                  width: 110,
                                                  height: 20,
                                                  borderRadius: 10),
                                              LoadingContainer(
                                                  width: 50,
                                                  height: 20,
                                                  borderRadius: 10),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          LoadingContainer(
                                              width: 170,
                                              height: 20,
                                              borderRadius: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, bottom: 3),
                                            child: LoadingContainer(
                                                width: 100,
                                                height: 15,
                                                borderRadius: 10),
                                          ),
                                          LoadingContainer(
                                              width: 170,
                                              height: 15,
                                              borderRadius: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 34,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LoadingContainer(
                          width: 150, height: 20, borderRadius: 10),
                      LoadingContainer(width: 80, height: 20, borderRadius: 10)
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: width,
                    height: 240,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EventDetailScreen()));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 16, bottom: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3))
                                  ],
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              width: 213,
                              child: Stack(
                                children: [
                                  LoadingContainer(
                                      width: double.infinity,
                                      height: 145,
                                      borderRadius: 5),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      height: 125,
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              LoadingContainer(
                                                  width: 110,
                                                  height: 20,
                                                  borderRadius: 10),
                                              LoadingContainer(
                                                  width: 50,
                                                  height: 20,
                                                  borderRadius: 10),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          LoadingContainer(
                                              width: 170,
                                              height: 20,
                                              borderRadius: 10),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: LoadingContainer(
                                                width: 100,
                                                height: 15,
                                                borderRadius: 10),
                                          ),
                                          LoadingContainer(
                                              width: 170,
                                              height: 15,
                                              borderRadius: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 34,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LoadingContainer(
                          width: 150, height: 20, borderRadius: 10),
                      LoadingContainer(width: 80, height: 20, borderRadius: 10)
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: width,
                    height: 240,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EventDetailScreen()));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 16, bottom: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3))
                                  ],
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              width: 213,
                              child: Stack(
                                children: [
                                  LoadingContainer(
                                      width: double.infinity,
                                      height: 145,
                                      borderRadius: 5),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      height: 125,
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              LoadingContainer(
                                                  width: 110,
                                                  height: 20,
                                                  borderRadius: 10),
                                              LoadingContainer(
                                                  width: 50,
                                                  height: 20,
                                                  borderRadius: 10),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          LoadingContainer(
                                              width: 170,
                                              height: 20,
                                              borderRadius: 10),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: LoadingContainer(
                                                width: 100,
                                                height: 15,
                                                borderRadius: 10),
                                          ),
                                          LoadingContainer(
                                              width: 170,
                                              height: 15,
                                              borderRadius: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 34,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LoadingContainer(
                          width: 150, height: 20, borderRadius: 10),
                      LoadingContainer(width: 80, height: 20, borderRadius: 10)
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: width,
                    height: 240,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EventDetailScreen()));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 16, bottom: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 3,
                                        offset: const Offset(0, 3))
                                  ],
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              width: 213,
                              child: Stack(
                                children: [
                                  LoadingContainer(
                                      width: double.infinity,
                                      height: 145,
                                      borderRadius: 5),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      height: 125,
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              LoadingContainer(
                                                  width: 110,
                                                  height: 20,
                                                  borderRadius: 10),
                                              LoadingContainer(
                                                  width: 50,
                                                  height: 20,
                                                  borderRadius: 10),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          LoadingContainer(
                                              width: 170,
                                              height: 20,
                                              borderRadius: 10),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: LoadingContainer(
                                                width: 100,
                                                height: 15,
                                                borderRadius: 10),
                                          ),
                                          LoadingContainer(
                                              width: 170,
                                              height: 15,
                                              borderRadius: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(List<Event> promoEvents) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: promoEvents.length,
      effect: const ExpandingDotsEffect(
          dotWidth: 10, dotHeight: 7, activeDotColor: primaryColor),
    );
  }

  Widget buildImage(String promoImage, int index) {
    return Stack(
      children: [
        // Image Container
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(promoImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  gradientColor,
                  blackColor,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
