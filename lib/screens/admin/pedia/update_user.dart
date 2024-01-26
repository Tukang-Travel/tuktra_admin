import 'package:tuktra_admin/utils/constant.dart';
import 'package:tuktra_admin/services/user_service.dart';
import 'package:tuktra_admin/utils/navigation_utils.dart';
import 'package:tuktra_admin/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUser extends StatefulWidget {
  final String? userId;
  const UpdateUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  String? receivedId;
  UserService userService = UserService();

  Map<String, dynamic>? user;

  Map<String, dynamic> userData = {
    'name': '',
    'username': '',
    'email': '',
    'profile': '',
    'type': '',
  };

  void _updateUser(String? uid, String? type) async {
    print(uid);
    try {
      if(type == '2') {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'type': 'admin',
        });
      }
      else {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'type': 'user',
        });
      }
      print('User data updated successfully');
    } catch (e) {
      print('Error updating user data: $e');
    }

    NavigationUtils.pushRemoveTransition(context, MainScreen(page: 0));
  }

  var isLoading = false;
  TextEditingController usernameTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();
  TextEditingController roleController = TextEditingController();
  late Future<Map<String, dynamic>> _user;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int selectRole = 1;

  final List<Map<String, dynamic>> _roles = [{'Pilih Peran': 1}, {'Admin': 2}, {'User': 3}];

  @override
  void initState() {
    super.initState();
    receivedId = widget.userId;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<dynamic> results = await Future.wait([
      userService.getUser(receivedId!),
    ]);
    
    setState(() {
      user = results[0];
      userData['name'] = user?['name'];
      userData['username'] = user?['username'];
      userData['email'] = user?['email'];
      userData['type'] = user?['type'];
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 80.0, top: 80.0, right: 80.0, bottom: 20.0),
                  child: Image.asset(
                    'asset/images/default_profile.png',
                    width: 150,
                    height: 150,
                  )
                ),
              ),
              Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        width: w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 35,
                            ),
                            
                            // username/ email text field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(1, 1),
                                    color: Color.fromARGB(128, 170, 188, 192),
                                  )
                                ]
                              ),
                              child: TextFormField(
                                enabled: false,
                                decoration: formInputDecoration('${userData['username']}', const Icon(Icons.person_rounded, color: Colors.grey,), true, Colors.grey[400])
                              ),
                            ),
                        
                            const SizedBox(
                              height: 20,
                            ),
                            // email textfield
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(1, 1),
                                    color: Color.fromARGB(128, 170, 188, 192),
                                  )
                                ]
                              ),
                              child: TextFormField(
                                enabled: false,
                                decoration: formInputDecoration('${userData['email']}', const Icon(Icons.email_rounded, color: Colors.grey,), true, Colors.grey[400])
                              ),
                            ),
                            const SizedBox(height: 20),
                            // user role
                            userData['type'] == 'admin' ?
                              DropdownButtonFormField<int>(
                                value: _roles[1].values.first,
                                onChanged: (int? selectedRole) {
                                  if (selectedRole != null) {
                                    setState(() {
                                      selectRole = selectedRole;
                                      roleController.text = (_roles.firstWhere((role) => role.values.first == selectedRole).values.first).toString();
                                    });
                                    print(roleController.text);
                                  }
                                },
                                items: _roles.map((Map<String, dynamic> role) {
                                  return DropdownMenuItem<int>(
                                    value: role.values.first,
                                    child: Text(role.keys.first), 
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'Pilih Peran',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(128, 170, 188, 192),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(128, 170, 188, 192),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              )
                            :
                            DropdownButtonFormField<int>(
                                value: _roles[2].values.first,
                                onChanged: (int? selectedRole) {
                                if (selectedRole != null) {
                                  setState(() {
                                    selectRole = selectedRole;
                                    roleController.text = (_roles.firstWhere((role) => role.values.first == selectedRole).values.first).toString();
                                  });
                                  print(roleController.text);
                                }
                            },
                            items: _roles.map((Map<String, dynamic> role) {
                              return DropdownMenuItem<int>(
                                  value: role.values.first,
                                  child: Text(role.keys.first), 
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Pilih Peran',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(128, 170, 188, 192),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(128, 170, 188, 192),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15.0,),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                      _updateUser(receivedId!, roleController.text);
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  backgroundColor: const Color.fromARGB(255, 82, 114, 255)
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                  child: Text(
                                    'Ubah',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],),
                  ),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 35.0, left: 30.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(page: 0),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.easeInOut;
          
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var fadeAnimation = animation.drive(tween);
          
                      return FadeTransition(opacity: fadeAnimation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 1000),
                  ),
                  (route) => false,
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
      )
    );
  }
}