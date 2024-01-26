import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tuktra_admin/screens/admin/pedia/user_screen.dart';
import 'package:tuktra_admin/screens/admin/profile/admin_profile_screen.dart';
import 'package:tuktra_admin/screens/admin/profile/edit_admin_profile_screen.dart';
import 'package:tuktra_admin/services/user_service.dart';
import 'package:tuktra_admin/utils/navigation_utils.dart';

class MainScreen extends StatefulWidget {
  final int? page;

  const MainScreen({super.key, required this.page});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int? currScreenCount = 0;
Widget currScreen = Container();

class _MainScreenState extends State<MainScreen> {
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    userService.getUserDetails();
  }

  Map<String, dynamic>? user;

  final List<Widget> ownerScreens = [
    const UserScreen(),
    const AdminProfileScreen()
  ];

  final List<IconData> ownerIcons = [
    Icons.home_filled,
    Icons.person,
  ];

  final List<String> ownerMenus = ['Users', 'Profile'];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<dynamic> results = await Future.wait([
      userService.getUser(userService.currUser!.uid),
    ]);

    setState(() {
      user = results[0];
    });

    setState(() {
      
      currScreen = const UserScreen();
      currScreenCount = widget.page;

      switch (currScreenCount) {
        case 1:
          currScreen = const AdminProfileScreen();
          break;
        default:
          currScreen = const UserScreen();
          break;
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currScreen,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Stack(children: [
          GNav(
            selectedIndex: currScreenCount!,
            // tab button hover color
            tabBorderRadius: 30,
            color: const Color.fromARGB(189, 121, 140, 223),
            gap:
                8, // the tab button gap between icon and text  // unselected icon color
            activeColor: Colors.white, // selected icon and text color
            iconSize:
                24, // tab button icon size // selected tab background color
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 20), // navigation bar padding
            tabBackgroundColor: const Color.fromARGB(255, 82, 114, 255),
            tabs: [
                for (int i = 0; i < ownerScreens.length; i++)
                  GButton(
                    margin: i % 2 == 0
                        ? const EdgeInsets.only(left: 50.0)
                        : const EdgeInsets.only(right: 50.0),
                    icon: ownerIcons[i],
                    text: ownerMenus[i],
                    onPressed: () {
                      setState(() {
                        currScreen = ownerScreens[i];
                        currScreenCount = i;
                      });
                    },
                  ),
            ],
          ),
        ]),
      ),
    );
  }
}
