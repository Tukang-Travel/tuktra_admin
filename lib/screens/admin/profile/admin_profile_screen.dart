import 'package:flutter/material.dart';
import 'package:tuktra_admin/screens/authentication/login_owner_screen.dart';
import 'package:tuktra_admin/screens/admin/profile/edit_admin_profile_screen.dart';
import 'package:tuktra_admin/services/user_service.dart';
import 'package:tuktra_admin/utils/navigation_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class OwnerProfileMenu {
  late String menuName;
  late Widget menuWidget;
  late IconData menuIcon;

  OwnerProfileMenu({
    required this.menuName,
    required this.menuWidget,
    required this.menuIcon,
  });
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  UserService userService = UserService();

  bool isLoading = false;

  Map<String, dynamic>? user;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<dynamic> results = await Future.wait([
      userService.getUser(userService.currUser!.uid),
    ]);

    setState(() {
      user = results[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userService.currUser!.uid)
                .snapshots(),
                        builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              return Column(
                children: [
                  user?['profile'] == null ?
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 80.0,
                        top: 80.0,
                        right: 80.0,
                        bottom: 20.0,
                      ),
                      child: Image.asset(
                        'asset/images/default_profile.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  )
                  :
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 80.0,
                        top: 80.0,
                        right: 80.0,
                        bottom: 20.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.network(
                          user?['profile'],
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${user?['name']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 25.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '@${user?['username']}',
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String profile = "";
                      if(user?['profile'] != null) {
                        setState(() {
                          profile = user?['profile'];
                        });
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAdminProfileScreen(
                            profile: profile,
                            userId: userService.currUser!.uid,
                            initialName: snapshot.data!["name"],
                            initialUsername: snapshot.data!["username"],
                            initialEmail: snapshot.data!["email"],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 82, 114, 255),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 55.0,
                        vertical: 15.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Ubah Profil',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await userService.logout();
                      if (context.mounted) {
                        NavigationUtils.pushRemoveTransition(
                            context, const LoginOwnerScreen());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 55.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Keluar ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                        children: [WidgetSpan(child: Icon(Icons.logout_rounded))],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                ],
              );
                        },
                      ),
                    ],
                  ),
            )));
  }
}
