import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/common/loadingContainer.dart';
import 'package:ticketing_app/features/home/data/models/getBookmark.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/eventDetailScreen.dart';
import 'package:ticketing_app/features/home/presentation/widgets/appBar.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final pref = PrefService();

  List<String> tilePhotos = [
    "images/tiles/rophnan.png",
    "images/tiles/aster.png",
    "images/tiles/theWeeknd.png",
    "images/tiles/seminar.png",
    "images/tiles/rophnan.png",
    "images/tiles/aster.png",
    "images/tiles/theWeeknd.png",
    "images/tiles/seminar.png",
    "images/tiles/rophnan.png",
    "images/tiles/aster.png",
    "images/tiles/theWeeknd.png",
    "images/tiles/seminar.png",
  ];
  bool isEmpty = false;

  @override
  void initState() {
    BlocProvider.of<BookmarkBloc>(context).add(GetBookmarkEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Bookmarks"),
      body: BlocConsumer<BookmarkBloc, BookmarkState>(
        listener: (context, state) {
          if (state is DeleteBookmarkSuccessfulState) {
            BlocProvider.of<BookmarkBloc>(context).add(GetBookmarkEvent());
          }
        },
        builder: (context, state) {
          print(state);
          if (state is GetBookmarkLoadingState) {
            return buildLoading();
          } else if (state is GetBookmarkSuccessfulState) {
            if (state.bookmarks[0].event.isEmpty) {
              return buildEmptyState();
            } else {
              return buildInitialInput(bookmark: state.bookmarks);
            }
          } else if (state is GetBookmarkFailureState) {
            print("Bookmark Error: ${state.error}");
            return buildEmptyState();
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
            "No Bookmark Found",
            style: TextStyle(
                color: blackColor,
                fontSize: fontSize16,
                fontWeight: FontWeight.w600),
          ),
          Text(
            "There is no Bookmark saved. Please\n bookmark your favorite events.",
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

  Widget buildInitialInput({required List<GetBookmarkModel> bookmark}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 25, 20, 50),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bookmark[0].event.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.9,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                await pref.removeEventId();
                await pref.storeEventId(bookmark[0].event[index].event_id);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EventDetailScreen()));
              },
              child: SizedBox(
                width: width * 0.418,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: width > 550 ? 250 : height * 0.12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                                bookmark[0].event[index].cover_image_url),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Text(
                      formatDate(bookmark[0].event[index].event_date),
                      style: TextStyle(
                          color: tileDateColor,
                          fontSize: fontSize8,
                          fontWeight: FontWeight.w600),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      bookmark[0].event[index].event_name,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w600),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bookmark[0].event[index].venue,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: fontSize11,
                                    fontWeight: FontWeight.w500),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                bookmark[0].event[index].region,
                                style: TextStyle(
                                    color: locationTextColor,
                                    fontSize: fontSize10,
                                    fontWeight: FontWeight.w400),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: IconButton(
                            onPressed: () async {
                              await pref.removeEventBookmark(
                                  bookmark[0].event[index].event_id);
                              BlocProvider.of<BookmarkBloc>(context).add(
                                  DeleteBookmarkEvent(
                                      bookmark[0].event[index].event_id));
                              print("I guesssssssssss");
                            },
                            icon:
                                SvgPicture.asset("images/bookmarkSelected.svg"),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildLoading() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 25, 20, 50),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {},
              child: SizedBox(
                width: width * 0.418,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadingContainer(
                        width: width,
                        height: width > 550 ? 250 : height * 0.1,
                        borderRadius: 8),
                    const SizedBox(
                      height: 3,
                    ),
                    LoadingContainer(width: 100, height: 10, borderRadius: 10),
                    const SizedBox(
                      height: 3,
                    ),
                    LoadingContainer(width: 150, height: 18, borderRadius: 10),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LoadingContainer(
                                  width: 80, height: 15, borderRadius: 10),
                              const SizedBox(
                                height: 3,
                              ),
                              LoadingContainer(
                                  width: 120, height: 15, borderRadius: 10),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0, top: 3),
                          child: LoadingContainer(
                              width: 20, height: 20, borderRadius: 100),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
