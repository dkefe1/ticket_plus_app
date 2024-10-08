import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:ticketing_app/features/home/data/models/category.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';
import 'package:ticketing_app/features/home/presentation/screens/indexScreen.dart';

class PersonalizeFeedScreen extends StatefulWidget {
  const PersonalizeFeedScreen({super.key});

  @override
  State<PersonalizeFeedScreen> createState() => _PersonalizeFeedScreenState();
}

class _PersonalizeFeedScreenState extends State<PersonalizeFeedScreen> {
  final prefs = PrefService();
  bool isSelected = false;
  List<String> interests = [
    'Concert',
    'Seminar',
    'Sports',
    'Spiritual Event',
    'Theaters',
    'Workshop',
    'Exhibition and Museum',
    'Family and kids event',
    'Festivals',
    'Party',
    'Tour and Travel'
  ];
  List<String> myFeed = [];

  @override
  void initState() {
    super.initState();
    loadMyFeedFromPrefs();
  }

  Future<void> loadMyFeedFromPrefs() async {
    final savedFeed = await prefs.getStringList();
    setState(() {
      myFeed = savedFeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EventBloc, EventState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is EventCategorySuccessfulState) {
            return buildInitialInput(categories: state.category);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required List<EventCategory> categories}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text("Personalize Your Experience",
              style: TextStyle(
                color: blackColor,
                fontSize: fontSize24,
                fontWeight: FontWeight.w600,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Text(
                "Tell us your preference to get customized concert recommendations tailored just for you. You can always change it later",
                style: TextStyle(
                  color: bodyColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w400,
                )),
          ),
          Expanded(
            child: Wrap(
              spacing: 18,
              children: categories.map((category) {
                final isSelected = myFeed.contains(category.category_name);
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      if (isSelected) {
                        myFeed.remove(category.category_name);
                      } else {
                        myFeed.add(category.category_name);
                        print(myFeed.toString());
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : whiteColor,
                      border: isSelected
                          ? const Border(
                              bottom: BorderSide.none,
                              top: BorderSide.none,
                              right: BorderSide.none,
                              left: BorderSide.none,
                            )
                          : Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      category.category_name,
                      style: TextStyle(
                          color: isSelected ? whiteColor : blackColor,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: submitButton(
                  text: "Finish",
                  disable: false,
                  onInteraction: () async {
                    await prefs.storeStringList(myFeed);
                    prefs.personalize();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => IndexScreen(pageIndex: 0)));
                  }))
        ],
      ),
    );
  }
}
