import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/common/formatDate.dart';
import 'package:ticketing_app/features/home/data/models/returnTicket.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/cancelResellDialog.dart';
import 'package:ticketing_app/features/home/presentation/screens/eventDetailScreen.dart';
import 'package:ticketing_app/features/home/presentation/widgets/appBar.dart';

class ReturnTicketScreen extends StatefulWidget {
  const ReturnTicketScreen({super.key});

  @override
  State<ReturnTicketScreen> createState() => _ReturnTicketScreenState();
}

class _ReturnTicketScreenState extends State<ReturnTicketScreen> {
  final pref = PrefService();
  @override
  void initState() {
    BlocProvider.of<ReturnRequestBloc>(context).add(GetReturnTicketEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Refund Request"),
      body: BlocConsumer<ReturnRequestBloc, ReturnTicketState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is ReturnTicketLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is ReturnTicketSuccessfulState) {
            return buildInitialInput(request: state.returnRequest);
          } else if (state is ReturnTicketFailureState) {
            return buildEmptyScreen();
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  // Widget buildInitialInput({required List<ReturnTicket> request}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Text(
  //               "Today",
  //               style: TextStyle(
  //                   color: locationTextColor,
  //                   fontSize: fontSize12,
  //                   fontWeight: FontWeight.w400),
  //             ),
  //             const SizedBox(
  //               width: 20,
  //             ),
  //             Flexible(
  //               child: Divider(
  //                 color: locationTextColor,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Row(
  //           children: [
  //             Container(
  //               height: 50,
  //               width: 72,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(5),
  //                   image: const DecorationImage(
  //                       image: AssetImage(
  //                         "images/tiles/rophnan.png",
  //                       ),
  //                       fit: BoxFit.cover)),
  //             ),
  //             const SizedBox(
  //               width: 20,
  //             ),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "Your request to sell the Rophnan concert is Approved",
  //                     style: TextStyle(
  //                         color: blackColor,
  //                         fontSize: fontSize14,
  //                         fontWeight: FontWeight.w500),
  //                     softWrap: true,
  //                     overflow: TextOverflow.visible,
  //                   ),
  //                   Text(
  //                     "09:40 AM",
  //                     style: TextStyle(
  //                         color: locationTextColor,
  //                         fontSize: fontSize12,
  //                         fontWeight: FontWeight.w500),
  //                     softWrap: true,
  //                     overflow: TextOverflow.visible,
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 35,
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "Yesterday",
  //               style: TextStyle(
  //                   color: locationTextColor,
  //                   fontSize: fontSize12,
  //                   fontWeight: FontWeight.w400),
  //             ),
  //             const SizedBox(
  //               width: 20,
  //             ),
  //             Flexible(
  //               child: Divider(
  //                 color: locationTextColor,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Row(
  //           children: [
  //             Container(
  //               height: 50,
  //               width: 72,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(5),
  //                   image: const DecorationImage(
  //                       image: AssetImage(
  //                         "images/tiles/rophnan.png",
  //                       ),
  //                       fit: BoxFit.cover)),
  //             ),
  //             const SizedBox(
  //               width: 20,
  //             ),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "Your request to sell the Rophnan concert is Approved",
  //                     style: TextStyle(
  //                         color: blackColor,
  //                         fontSize: fontSize14,
  //                         fontWeight: FontWeight.w500),
  //                     softWrap: true,
  //                     overflow: TextOverflow.visible,
  //                   ),
  //                   Text(
  //                     "09:40 AM",
  //                     style: TextStyle(
  //                         color: locationTextColor,
  //                         fontSize: fontSize12,
  //                         fontWeight: FontWeight.w500),
  //                     softWrap: true,
  //                     overflow: TextOverflow.visible,
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 15,
  //         ),
  //         Row(
  //           children: [
  //             Container(
  //               height: 50,
  //               width: 72,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(5),
  //                   image: const DecorationImage(
  //                       image: AssetImage(
  //                         "images/tiles/rophnan.png",
  //                       ),
  //                       fit: BoxFit.cover)),
  //             ),
  //             const SizedBox(
  //               width: 20,
  //             ),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     request[0].cause,
  //                     style: TextStyle(
  //                         color: blackColor,
  //                         fontSize: fontSize14,
  //                         fontWeight: FontWeight.w500),
  //                     softWrap: true,
  //                     overflow: TextOverflow.visible,
  //                   ),
  //                   Text(
  //                     "09:40 AM",
  //                     style: TextStyle(
  //                         color: locationTextColor,
  //                         fontSize: fontSize12,
  //                         fontWeight: FontWeight.w500),
  //                     softWrap: true,
  //                     overflow: TextOverflow.visible,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             TextButton(
  //                 style: ButtonStyle(
  //                     backgroundColor: MaterialStateProperty.all(primaryColor)),
  //                 onPressed: () {
  //                   showDialog(
  //                       context: context,
  //                       builder: (context) => CancelResellDialog());
  //                 },
  //                 child: Text(
  //                   "Cancel",
  //                   style: TextStyle(
  //                     color: whiteColor,
  //                     fontSize: fontSize12,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ))
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget buildEmptyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "noResult.png",
            height: 123,
            width: 120,
          ),
          const SizedBox(
            height: 36,
          ),
          Text(
            "No Refund Request Found",
            style: TextStyle(
                color: blackColor,
                fontSize: fontSize16,
                fontWeight: FontWeight.w600),
          ),
          Text(
            "You havent' requested refund for your tickets yet.",
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

  Widget buildInitialInput({required List<ReturnTicket> request}) {
    return ListView.builder(
        itemCount: request.length,
        padding: EdgeInsets.symmetric(vertical: 4),
        itemBuilder: (BuildContext context, int index) {
          var ticket = request[index];
          return ListTile(
            leading: Image.network(
              ticket.event.coverImageUrl,
              errorBuilder: (context, error, stackTrace) {
                // Handle error, e.g., display a placeholder image or error message
                return Icon(Icons.error); // Placeholder icon for error
              },
            ),
            title: Text(
              ticket.event.eventName,
              style: TextStyle(
                fontSize: fontSize16,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            subtitle: Text(
              formatDate(ticket.event.eventDate),
              style: TextStyle(
                fontSize: fontSize12,
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            onTap: () async {
              print(ticket.event.eventId);
              await pref.storeEventId(ticket.event.eventId);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EventDetailScreen()));
            },
            trailing: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => CancelResellDialog(
                          requestId: ticket.id,
                        ));
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: fontSize12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
  }
}
