import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/common/errorFlushbar.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/eventDetailScreen.dart';

final pref = PrefService();
List<String> searchedItems = [];
List<String> searchSuggestionList = [];
bool resultsDisplayed = false;

Widget searchField({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
}) {
  controller.addListener(() {
    final query = controller.text;
    if (query.isNotEmpty) {
      BlocProvider.of<EventBloc>(context).add(GetSearchEvent(query));
    }
  });
  return TextFormField(
    controller: controller,
    onTap: () {
      // final eventBloc = BlocProvider.of<EventBloc>(context);

      showSearch(
          context: context,
          delegate:
              MySearchDelegate(eventBloc: BlocProvider.of<EventBloc>(context)));
    },
    onFieldSubmitted: (query) async {
      if (query.isNotEmpty) {
        BlocProvider.of<EventBloc>(context).add(GetSearchEvent(query));
      }
    },
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      hintText: hintText,
      hintStyle: TextStyle(
          color: hintColor, fontSize: fontSize14, fontWeight: FontWeight.w400),
      prefixIcon: Icon(icon),
      prefixIconColor: hintColor,
      filled: true,
      fillColor: inputFieldColor,
      disabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primaryColor,
          ),
          borderRadius: BorderRadius.circular(15)),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: dangerColor),
      ),
    ),
  );
}

class MySearchDelegate extends SearchDelegate {
  final EventBloc eventBloc;
  bool searchTriggered = false;
  late Timer _debounce;
  MySearchDelegate({required this.eventBloc}) {
    _debounce = Timer(Duration.zero, () {});
  }

  void triggerSearch(String query) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        eventBloc.add(GetSearchEvent(query));
      }
    });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(toolbarHeight: 100),
      primaryColor: Colors.green,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        // hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          if (resultsDisplayed) {
            close(context, null);
            BlocProvider.of<EventBloc>(context).add(GetEventListEvent());
          } else {
            close(context, null);
          }
        },
        icon: const Icon(Icons.arrow_back),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        query.isEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  if (query.isEmpty) {
                    close(context, null);
                  } else {
                    query = '';
                  }
                },
              )
            : ElevatedButton(
                onPressed: () async {
                  final searchText = query;
                  if (searchText.isNotEmpty) {
                    searchedItems.add(query);
                    print(searchedItems.toString());
                    await pref.storeSearchSuggestion(searchedItems);
                    searchSuggestionList = await pref.getSearchSuggestion();
                    print(searchSuggestionList.toString() + "0000000000");
                    BlocProvider.of<EventBloc>(context)
                        .add(GetSearchEvent(searchText));
                    showResults(
                        context); // This method needs to be called so that it automatically displays the searched Items list.
                  }
                },
                child: Text(
                  'Search',
                  style: TextStyle(color: primaryColor),
                ),
              ),
      ];
  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty)
      return Center(
        child: Text("Search by Event Name, artist, genre, band, ..."),
      );
    return BlocBuilder<EventBloc, EventState>(
      bloc: eventBloc,
      builder: (_, state) {
        print(state);
        if (state is SearchEventLoadingState) {
          resultsDisplayed = true;
          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
            semanticsLabel: "Searching",
          ));
        } else if (state is SearchEventSuccessfulState) {
          var searchResults = state.event;
          resultsDisplayed = true;
          return searchResults.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/noResult.png",
                        height: 120,
                        width: 120,
                      ),
                      const Text(
                        "No Results Found",
                        style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "There is no result with your search \nplease try again.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: locationTextColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: fontSize14),
                              children: [
                            TextSpan(
                                text: searchResults.length.toString(),
                                style: TextStyle(color: primaryColor)),
                            TextSpan(
                                text: " results found",
                                style: TextStyle(color: notificationBodyColor))
                          ])),
                      const SizedBox(
                        height: 15,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await pref.removeEventId();
                              await pref
                                  .storeEventId(searchResults[index].event_id);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EventDetailScreen()));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 109,
                                  width: 163,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              searchResults[index]
                                                  .cover_image_url))),
                                ),
                                Text(
                                  searchResults[index].event_name,
                                  style: TextStyle(
                                      color: blackColor,
                                      fontSize: fontSize14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  searchResults[index].region,
                                  style: TextStyle(
                                      color: locationTextColor,
                                      fontSize: fontSize10,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
        } else if (state is SearchEventFailureState) {
          resultsDisplayed = true;
          errorFlushbar(context: context, message: state.error);
          return Center(
              child: Text("Couldn't display your Search, \nPlease Try again"));
        } else {
          return Container(
              // child: Text('Click Search')
              );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> searchSuggestion = searchSuggestionList.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    if (searchSuggestion.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Searches",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.delete)
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                color: hintColor,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Searches",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: blackColor,
                  fontSize: fontSize18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () async {
                  searchSuggestionList.clear();
                  searchSuggestion.clear();
                  await pref.clearAllSearchSuggestions();
                  searchedItems.clear();
                  showSearch(
                      context: context,
                      delegate: MySearchDelegate(
                          eventBloc: BlocProvider.of<EventBloc>(context)));
                },
                icon: Icon(Icons.delete, color: hintColor),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              color: hintColor,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchSuggestion.length,
              itemBuilder: (BuildContext context, int index) {
                final searchedItem = searchSuggestion[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: InkWell(
                    onTap: () {
                      query = searchedItem;
                      BlocProvider.of<EventBloc>(context)
                          .add(GetSearchEvent(searchedItem));
                      showResults(context);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.search,
                            color: bodyColor,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                searchSuggestion[index],
                                style: TextStyle(
                                  color: bodyColor,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  searchSuggestionList.remove(searchedItem);
                                  searchSuggestion.remove(searchedItem);
                                  await pref
                                      .removeSearchSuggestion(searchedItem);
                                  searchedItems.remove(searchedItem);
                                  showSearch(
                                      context: context,
                                      delegate: MySearchDelegate(
                                          eventBloc: BlocProvider.of<EventBloc>(
                                              context)));
                                },
                                icon: Icon(Icons.delete, color: hintColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
