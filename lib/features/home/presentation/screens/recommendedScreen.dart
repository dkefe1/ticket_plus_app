import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/common/loadingContainer.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/eventDetailScreen.dart';
import 'package:ticketing_app/features/home/presentation/widgets/appBar.dart';

class RecommendedScreen extends StatefulWidget {
  const RecommendedScreen({super.key});

  @override
  State<RecommendedScreen> createState() => _RecommendedScreenStateScreen();
}

class _RecommendedScreenStateScreen extends State<RecommendedScreen> {
  final pref = PrefService();
  bool isRecommendedEmpty = false;

  @override
  void initState() {
    BlocProvider.of<EventBloc>(context).add(GetRecommendedEventListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Recommended"),
      body: BlocConsumer<EventBloc, EventState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is RecommendedEventLoadingState) {
            return buildLoading();
          } else if (state is RecommendedEventSuccessfulState) {
            isRecommendedEmpty = state.event.isEmpty;
            return buildInitialInput(event: state.event);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required List<TicketEventModel> event}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return isRecommendedEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Recommended List is Empty"),
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              width: width,
              height: height,
              child: GridView.builder(
                  itemCount: event.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: height * 0.13,
                              width: width * 0.418,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        eventDetail.cover_image_url),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatDate(eventDetail.event_date),
                                  style: TextStyle(
                                      color: tileDateColor,
                                      fontSize: fontSize10,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  eventDetail.event_name,
                                  style: TextStyle(
                                      color: blackColor,
                                      fontSize: fontSize14,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  eventDetail.venue,
                                  style: TextStyle(
                                      color: locationTextColor,
                                      fontSize: fontSize10,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          );
  }

  Widget buildLoading() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        width: width,
        height: height,
        child: GridView.builder(
            itemCount: 21,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LoadingContainer(
                      height: height * 0.13,
                      width: width * 0.418,
                      borderRadius: 8,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      LoadingContainer(
                          width: 100, height: 18, borderRadius: 10),
                      const SizedBox(
                        height: 4,
                      ),
                      LoadingContainer(
                          width: 150, height: 24, borderRadius: 10),
                      const SizedBox(
                        height: 4,
                      ),
                      LoadingContainer(width: 70, height: 18, borderRadius: 10)
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}
