import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/common/loadingContainer.dart';
import 'package:ticketing_app/features/guidelines/presentation/screens/aboutUs.dart';
import 'package:ticketing_app/features/guidelines/presentation/screens/helpCenter.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/screens/bookmark.dart';
import 'package:ticketing_app/features/home/presentation/screens/interests.dart';
import 'package:ticketing_app/features/home/presentation/screens/languageScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/logout.dart';
import 'package:ticketing_app/features/home/presentation/screens/personalInfo.dart';
import 'package:ticketing_app/features/home/presentation/screens/returnTicketScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final pref = PrefService();
  String full_name = "User";
  String phone = "0912345678";
  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    fetchUserInfo();
    super.initState();
  }

  Future<void> fetchUserInfo() async {
    final savedName = await pref.readName();
    final savedPhone = await pref.readPhone();

    setState(() {
      full_name = savedName;
      phone = savedPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: null,
          icon: SvgPicture.asset(
            "images/logoSecond.svg",
            height: 27,
            width: 27,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Account",
          style: TextStyle(
              color: blackColor,
              fontSize: fontSize18,
              fontWeight: FontWeight.w600),
        ),
        toolbarHeight: 80,
        surfaceTintColor: whiteColor,
      ),
      body: buildInitialInput(),
    );
  }

  Widget buildInitialInput() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Image.asset(
                  "images/profilePic.png",
                  height: 52,
                  width: 52,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      full_name,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: fontSize16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      phone,
                      style: TextStyle(
                          color: locationTextColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 27),
              child: Divider(
                color: dividerColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: SvgPicture.asset("images/bookmark.svg"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BookmarkScreen()));
              },
              title: Text(
                "Bookmarks",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => InterestsScreen()));
              },
              leading: SvgPicture.asset("images/interests.svg"),
              title: Text(
                "Interests",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReturnTicketScreen()));
              },
              leading: SvgPicture.asset("images/resell.svg"),
              title: Text(
                "Refund",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            Row(
              children: [
                Text(
                  "General",
                  style: TextStyle(
                      color: hintColor,
                      fontSize: fontSize12,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 30, top: 28, bottom: 23),
                    child: Divider(
                      color: dividerColor,
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              onTap: () {
                BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PersonalInfoScreen()));
              },
              leading: SvgPicture.asset("images/person.svg"),
              title: Text(
                "Personal Info",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LanguageScreen()));
              },
              leading: Icon(Icons.language),
              title: Text(
                "Language",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => NotificationScreen()));
            //   },
            //   leading: SvgPicture.asset("images/notification.svg"),
            //   title: Text(
            //     "Notification",
            //     style: TextStyle(
            //         color: blackColor,
            //         fontSize: fontSize16,
            //         fontWeight: FontWeight.w600),
            //   ),
            //   trailing: const Icon(Icons.arrow_forward_ios),
            // ),
            Row(
              children: [
                Text(
                  "About",
                  style: TextStyle(
                      color: hintColor,
                      fontSize: fontSize12,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 30, top: 28, bottom: 23),
                    child: Divider(
                      color: dividerColor,
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HelpCenterScreen()));
              },
              leading: SvgPicture.asset("images/helpCenter.svg"),
              title: Text(
                "Help Center",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutUsScreen()));
              },
              leading: SvgPicture.asset("images/about.svg"),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: TextStyle(
                        color: blackColor,
                        fontSize: fontSize16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Ticket+",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: fontSize16,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    barrierColor: blackColor.withOpacity(0.3),
                    builder: (context) {
                      return LogoutDialog();
                    });
              },
              leading: SvgPicture.asset("images/logout.svg"),
              title: Text(
                "Logout",
                style: TextStyle(
                    color: dangerColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                LoadingContainer(width: 52, height: 52, borderRadius: 300),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadingContainer(width: 150, height: 24, borderRadius: 10),
                    const SizedBox(
                      height: 4,
                    ),
                    LoadingContainer(width: 100, height: 20, borderRadius: 10),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 27),
              child: Divider(
                color: dividerColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: SvgPicture.asset("images/bookmark.svg"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BookmarkScreen()));
              },
              title: Text(
                "Bookmarks",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                BlocProvider.of<EventBloc>(context)
                  ..add(GetEventCategoryEvent());
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => InterestsScreen()));
              },
              leading: SvgPicture.asset("images/interests.svg"),
              title: Text(
                "Interests",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReturnTicketScreen()));
              },
              leading: SvgPicture.asset("images/resell.svg"),
              title: Text(
                "Return",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            Row(
              children: [
                Text(
                  "General",
                  style: TextStyle(
                      color: hintColor,
                      fontSize: fontSize12,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 30, top: 28, bottom: 23),
                    child: Divider(
                      color: dividerColor,
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => PersonalInfoScreen()));
              },
              leading: SvgPicture.asset("images/person.svg"),
              title: Text(
                "Personal Info",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => NotificationScreen()));
            //   },
            //   leading: SvgPicture.asset("images/notification.svg"),
            //   title: Text(
            //     "Notification",
            //     style: TextStyle(
            //         color: blackColor,
            //         fontSize: fontSize16,
            //         fontWeight: FontWeight.w600),
            //   ),
            //   trailing: const Icon(Icons.arrow_forward_ios),
            // ),
            Row(
              children: [
                Text(
                  "About",
                  style: TextStyle(
                      color: hintColor,
                      fontSize: fontSize12,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 30, top: 28, bottom: 23),
                    child: Divider(
                      color: dividerColor,
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HelpCenterScreen()));
              },
              leading: SvgPicture.asset("images/helpCenter.svg"),
              title: Text(
                "Help Center",
                style: TextStyle(
                    color: blackColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutUsScreen()));
              },
              leading: SvgPicture.asset("images/about.svg"),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: TextStyle(
                        color: blackColor,
                        fontSize: fontSize16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Ticket+",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: fontSize16,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    barrierColor: blackColor.withOpacity(0.3),
                    builder: (context) {
                      return LogoutDialog();
                    });
              },
              leading: SvgPicture.asset("images/logout.svg"),
              title: Text(
                "Logout",
                style: TextStyle(
                    color: dangerColor,
                    fontSize: fontSize16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
