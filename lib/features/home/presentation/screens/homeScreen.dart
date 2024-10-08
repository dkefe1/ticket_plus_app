import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/common/loadingContainer.dart';
import 'package:ticketing_app/features/home/data/dataSources/remoteDatasource/homeDataSource.dart';
import 'package:ticketing_app/features/home/data/models/category.dart';
import 'package:ticketing_app/features/home/data/models/event.dart';
import 'package:ticketing_app/features/home/data/repositories/homeRepository.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/eventDetailScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/exploreAllScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/hotTickets.dart';
import 'package:ticketing_app/features/home/presentation/screens/recommendedScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/upcomingScreen.dart';
import 'package:ticketing_app/features/home/presentation/widgets/searchField.dart';

class HomeScreen extends StatefulWidget {
  final HomeRepository homeRepository;
  HomeScreen({super.key, required this.homeRepository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  final pref = PrefService();

  int activeIndex = 0;

  List<String> categoryPhotoPaths = [
    "images/category/all.png",
    "images/category/concert.png",
    "images/category/exhibition.png",
    "images/category/family.png",
    "images/category/festival.png",
    "images/category/party.png",
    "images/category/seminar.png",
    "images/category/spiritual.png",
    "images/category/sports.png",
    "images/category/theaters.png",
    "images/category/tour.png",
    "images/category/workshop.png",
  ];

  bool isSelected = false;
  bool isLoading = false;
  int selectedIndex = 0;
  String selectedCategory = 'All';
  List<Event> categorizedEventList = [];
  bool isCategorySelected = false;

  @override
  void initState() {
    BlocProvider.of<EventBloc>(context).add(GetEventListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.135,
        elevation: 0,
        surfaceTintColor: whiteColor,
        title: searchField(
          context: context,
          controller: searchController,
          hintText: "Find band, artist, genre...",
          icon: Icons.search,
        ),
        // actions: [
        //   const SizedBox(
        //     width: 10,
        //   ),
        //   Container(
        //     padding: EdgeInsets.all(5),
        //     decoration: BoxDecoration(
        //         border: Border.all(color: notificationCircleColor),
        //         shape: BoxShape.circle),
        //     child: IconButton(
        //         onPressed: () {
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) => NotificationScreen()));
        //         },
        //         icon: SvgPicture.asset(
        //           "images/notification.svg",
        //           width: 24,
        //           height: 27,
        //         )),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   )
        // ],
      ),
      body: BlocConsumer<EventBloc, EventState>(
        listener: (_, state) {},
        builder: (_, state) {
          print(state);
          if (state is EventLoadingState) {
            isLoading = true;
            return buildLoading();
          } else if (state is EventSuccessfulState) {
            isLoading = false;
            print('');
            print('');
            print(state.event[0].category[0].category_name);
            print('');
            print('');
            if (state is EventCategorySuccessfulState) {}
            return buildInitialInput(event: state.event);
          } else if (state is EventFailureState) {
            isLoading = false;
            if (state.error ==
                "ClientException with SocketException: Failed host lookup: 'tiket-plus-dev-api.onrender.com' (OS Error: No address associated with hostname, errno = 7), uri=https://tiket-plus-dev-api.onrender.com/api/v1/events/active") {
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

  Widget buildInitialInput({required List<Event> event}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 23),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  width: width,
                  child: BlocProvider(
                    create: (context) => EventBloc(widget.homeRepository)
                      ..add(GetEventCategoryEvent()),
                    child: BlocBuilder<EventBloc, EventState>(
                      builder: (_, state) {
                        print(state);
                        if (state is EventCategoryLoadingState) {
                          return SizedBox.shrink();
                        } else if (state is EventCategorySuccessfulState) {
                          final category = [
                            EventCategory(
                                id: 'all',
                                category_name: 'All',
                                cover_image_url: 'images/category/all.png',
                                is_active: 'true'),
                            ...state.category
                          ];
                          // final category = state.category;
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: category.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory =
                                            category[index].category_name;

                                        print(selectedCategory);

                                        if (selectedCategory == 'All') {
                                          categorizedEventList = event;
                                        } else {
                                          categorizedEventList = event
                                              .where((event) => event.category
                                                  .any((cat) =>
                                                      cat.category_name ==
                                                      selectedCategory))
                                              .toList();
                                        }
                                        isCategorySelected = true;
                                        selectedIndex = index;
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: ColorFiltered(
                                            colorFilter: selectedIndex == index
                                                ? ColorFilter.mode(
                                                    Colors.transparent,
                                                    BlendMode.saturation)
                                                : ColorFilter.mode(Colors.grey,
                                                    BlendMode.saturation),
                                            child: Image.network(
                                              category[index].cover_image_url,
                                              height: 104,
                                              width: 150,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Placeholder();
                                              },
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: 150,
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              category[index].category_name,
                                              style: const TextStyle(
                                                  color: blackColor,
                                                  fontSize: fontSize17,
                                                  fontWeight: FontWeight.w600),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else if (state is EventCategoryFailureState) {
                          return errorFlushbar(
                              context: context, message: state.error);
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EventDetailScreen()));
                        },
                        child: CarouselSlider.builder(
                            itemCount: promotionalEvent.length,
                            itemBuilder: (context, index, realIndex) {
                              final promoImage =
                                  promotionalEvent[index].cover_image_url;
                              return buildImage(promoImage, index);
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
                      ),
                      Positioned(
                        bottom: 40,
                        left: 17,
                        child: SizedBox(
                          width: width,
                          child: RichText(
                            softWrap: true,
                            overflow: TextOverflow.visible,
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
          ////////////////////////////////////////////////////////////////////////////////////////////////////

          // Visibility(
          //   visible: isCategorySelected,
          //   child: Container(
          //     margin: const EdgeInsets.only(left: 20),
          //     child: Column(
          //       children: [
          //         const SizedBox(
          //           height: 20,
          //         ),
          //         SizedBox(
          //           width: width,
          //           height: 240,
          //           child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: categorizedEventList.length,
          //               itemBuilder: (BuildContext context, int index) {
          //                 var eventDetail = categorizedEventList[index];
          //                 return GestureDetector(
          //                   onTap: () {
          //                     Navigator.of(context).push(MaterialPageRoute(
          //                         builder: (context) => EventDetailScreen()));
          //                   },
          //                   child: Container(
          //                     margin:
          //                         const EdgeInsets.only(right: 16, bottom: 10),
          //                     decoration: BoxDecoration(
          //                         boxShadow: [
          //                           BoxShadow(
          //                               color: Colors.grey.withOpacity(0.1),
          //                               spreadRadius: 5,
          //                               blurRadius: 3,
          //                               offset: const Offset(0, 3))
          //                         ],
          //                         borderRadius: const BorderRadius.only(
          //                             bottomLeft: Radius.circular(10),
          //                             bottomRight: Radius.circular(10))),
          //                     width: 213,
          //                     child: Stack(
          //                       children: [
          //                         Container(
          //                           decoration: BoxDecoration(
          //                               image: DecorationImage(
          //                                   image: NetworkImage(
          //                                       eventDetail.cover_image_url),
          //                                   fit: BoxFit.cover),
          //                               borderRadius: const BorderRadius.only(
          //                                   topLeft: Radius.circular(10),
          //                                   topRight: Radius.circular(10))),
          //                           height: 145,
          //                         ),
          //                         Align(
          //                           alignment: Alignment.bottomCenter,
          //                           child: Container(
          //                             padding: const EdgeInsets.symmetric(
          //                                 horizontal: 12, vertical: 12),
          //                             height: 125,
          //                             decoration: BoxDecoration(
          //                                 color: whiteColor,
          //                                 borderRadius:
          //                                     BorderRadius.circular(10)),
          //                             child: Column(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     Text(
          //                                       formatDate(
          //                                           eventDetail.event_date),
          //                                       style: TextStyle(
          //                                           color: tileDateColor,
          //                                           fontSize: fontSize10),
          //                                     ),
          //                                     Container(
          //                                       padding:
          //                                           const EdgeInsets.all(6),
          //                                       decoration: BoxDecoration(
          //                                           color: onSellBgColor,
          //                                           borderRadius:
          //                                               BorderRadius.circular(
          //                                                   10)),
          //                                       child: const Center(
          //                                         child: Text(
          //                                           "On Sell",
          //                                           style: TextStyle(
          //                                               color: blackColor,
          //                                               fontSize: fontSize8,
          //                                               fontWeight:
          //                                                   FontWeight.w600),
          //                                         ),
          //                                       ),
          //                                     )
          //                                   ],
          //                                 ),
          //                                 const SizedBox(
          //                                   height: 10,
          //                                 ),
          //                                 Text(
          //                                   eventDetail.event_name,
          //                                   style: TextStyle(
          //                                       color: blackColor,
          //                                       fontSize: fontSize16,
          //                                       fontWeight: FontWeight.w700),
          //                                 ),
          //                                 const SizedBox(
          //                                   height: 8,
          //                                 ),
          //                                 Text(
          //                                   eventDetail.venue,
          //                                   style: TextStyle(
          //                                       color: blackColor,
          //                                       fontSize: fontSize12,
          //                                       fontWeight: FontWeight.w500),
          //                                 ),
          //                                 Text(
          //                                   eventDetail.region,
          //                                   style: TextStyle(
          //                                       color: locationTextColor,
          //                                       fontSize: fontSize12,
          //                                       fontWeight: FontWeight.w500),
          //                                 )
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 );
          //               }),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          ////////////////////////////////////////////////////////////////////////////////////////////////////
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 30),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HotTickets()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: const Text(
                          "Hot Tickets",
                          style: TextStyle(
                              color: blackColor,
                              fontSize: fontSize18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 20),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: width,
                  height: height > 750 ? 270 : 240,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: event.length > 5 ? 5 : event.length,
                      itemBuilder: (BuildContext context, int index) {
                        var eventDetail = event[index];
                        return GestureDetector(
                          onTap: () async {
                            print(eventDetail.event_id);
                            await pref.storeEventId(eventDetail.event_id);
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
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              eventDetail.cover_image_url),
                                          fit: BoxFit.cover),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  height: 145,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    height: height > 750 ? 135 : 125,
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
                                            Text(
                                              formatDate(
                                                  eventDetail.event_date),
                                              style: TextStyle(
                                                  color: tileDateColor,
                                                  fontSize: fontSize10),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                  color: onSellBgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Center(
                                                child: Text(
                                                  "On Sell",
                                                  style: TextStyle(
                                                      color: blackColor,
                                                      fontSize: fontSize8,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                              fontSize: fontSize16,
                                              fontWeight: FontWeight.w700),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          eventDetail.venue,
                                          style: TextStyle(
                                              color: blackColor,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          eventDetail.region,
                                          style: TextStyle(
                                              color: locationTextColor,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w500),
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
          ),
          const SizedBox(
            height: 10,
          ),
          BlocProvider(
            create: (context) => EventBloc(widget.homeRepository)
              ..add(GetUpcomingEventListEvent()),
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                print(state);
                if (state is UpcomingEventSuccessfulState) {
                  final upcoming = state.event;

                  return Visibility(
                    visible: upcoming.isNotEmpty,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UpcomingScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Upcoming",
                                    style: TextStyle(
                                        color: blackColor,
                                        fontSize: fontSize18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Text(
                                      "View all",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: fontSize14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 20),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryColor,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: width,
                            height: height > 780 ? 270 : 240,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    upcoming.length > 5 ? 5 : upcoming.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var upcomingDetail = upcoming[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      print(upcomingDetail.event_id);
                                      await pref.storeEventId(
                                          upcomingDetail.event_id);
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
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      width: 213,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        upcomingDetail
                                                            .cover_image_url),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(
                                                                10))),
                                            height: 145,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 12),
                                              height: height > 750 ? 135 : 125,
                                              decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        formatDate(
                                                            upcomingDetail
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
                                                    upcomingDetail.event_name,
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontSize: fontSize16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    upcomingDetail.venue,
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontSize: fontSize12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    upcomingDetail.region,
                                                    style: TextStyle(
                                                        color:
                                                            locationTextColor,
                                                        fontSize: fontSize12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          BlocProvider(
            create: (context) => EventBloc(widget.homeRepository)
              ..add(GetRecommendedEventListEvent()),
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is RecommendedEventSuccessfulState) {
                  final recommended = state.event;
                  return Visibility(
                    visible: recommended.isNotEmpty,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RecommendedScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: const Text(
                                    "Recommended",
                                    style: TextStyle(
                                        color: blackColor,
                                        fontSize: fontSize18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Text(
                                      "View all",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: fontSize14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 20),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryColor,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: width,
                            height: height > 780 ? 270 : 240,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: recommended.length > 5
                                    ? 5
                                    : recommended.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var recommendedDetail = recommended[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      await pref.storeEventId(
                                          recommendedDetail.event_id);
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
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      width: 213,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        recommendedDetail
                                                            .cover_image_url),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(
                                                                10))),
                                            height: 145,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 12),
                                              height: height > 750 ? 135 : 125,
                                              decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        formatDate(
                                                            recommendedDetail
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
                                                    recommendedDetail
                                                        .event_name,
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontSize: fontSize16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    recommendedDetail.venue,
                                                    style: TextStyle(
                                                        color: blackColor,
                                                        fontSize: fontSize12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    recommendedDetail.region,
                                                    style: TextStyle(
                                                        color:
                                                            locationTextColor,
                                                        fontSize: fontSize12,
                                                        fontWeight:
                                                            FontWeight.w500),
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
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ExploreAllScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: const Text(
                          "Explore All",
                          style: TextStyle(
                              color: blackColor,
                              fontSize: fontSize18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                isCategorySelected
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categorizedEventList.length > 20
                            ? 20
                            : categorizedEventList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16),
                        itemBuilder: (context, index) {
                          var eventDetail = categorizedEventList[index];
                          return GestureDetector(
                            onTap: () async {
                              await pref.removeEventId();
                              await pref.storeEventId(eventDetail.event_id);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EventDetailScreen()));
                            },
                            child: SizedBox(
                              width: width * 0.418,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: width > 550 ? 250 : height * 0.129,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              eventDetail.cover_image_url),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    eventDetail.event_name,
                                    style: TextStyle(
                                        color: blackColor,
                                        fontSize: fontSize14,
                                        fontWeight: FontWeight.w600),
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          eventDetail.region,
                                          style: TextStyle(
                                              color: locationTextColor,
                                              fontSize: fontSize10,
                                              fontWeight: FontWeight.w400),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: onSellBgColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                          child: Text(
                                            "On Sell",
                                            style: TextStyle(
                                                color: blackColor,
                                                fontSize: fontSize8,
                                                fontWeight: FontWeight.w600),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: event.length > 7 ? 5 : event.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16),
                        itemBuilder: (context, index) {
                          var eventDetail = event[index];
                          return GestureDetector(
                            onTap: () async {
                              await pref.removeEventId();
                              await pref.storeEventId(eventDetail.event_id);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EventDetailScreen()));
                            },
                            child: SizedBox(
                              width: width * 0.418,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: width > 550 ? 250 : height * 0.129,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              eventDetail.cover_image_url),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    eventDetail.event_name,
                                    style: TextStyle(
                                        color: blackColor,
                                        fontSize: fontSize14,
                                        fontWeight: FontWeight.w600),
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          eventDetail.region,
                                          style: TextStyle(
                                              color: locationTextColor,
                                              fontSize: fontSize10,
                                              fontWeight: FontWeight.w400),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: onSellBgColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                          child: Text(
                                            "On Sell",
                                            style: TextStyle(
                                                color: blackColor,
                                                fontSize: fontSize8,
                                                fontWeight: FontWeight.w600),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
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

  Widget buildLoading() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  width: width,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryPhotoPaths.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Stack(
                            children: [
                              LoadingContainer(
                                  width: 150, height: 104, borderRadius: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: LoadingContainer(
                                      width: 70, height: 20, borderRadius: 10),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
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
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Hot Tickets",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize18,
                          fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 20),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                            ),
                          )
                        ],
                      ),
                    )
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
                          onTap: () {},
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
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 3),
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
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Upcoming",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize18,
                          fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 20),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                            ),
                          )
                        ],
                      ),
                    )
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
                          onTap: () {},
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
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 3),
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Explore All",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize18,
                          fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 21,
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 20,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: width * 0.418,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoadingContainer(
                                width: double.infinity,
                                height: width > 550 ? 250 : height * 0.129,
                                borderRadius: 10),
                            const SizedBox(
                              height: 8,
                            ),
                            LoadingContainer(
                                width: 140, height: 20, borderRadius: 10),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: LoadingContainer(
                                      width: 90, height: 20, borderRadius: 10),
                                ),
                                Flexible(
                                  child: LoadingContainer(
                                      width: 40, height: 20, borderRadius: 10),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }),
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
