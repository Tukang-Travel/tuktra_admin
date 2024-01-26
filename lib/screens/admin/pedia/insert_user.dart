import 'package:tuktra_admin/utils/constant.dart';
import 'package:tuktra_admin/utils/alert.dart';
import 'package:tuktra_admin/utils/navigation_utils.dart';
import 'package:tuktra_admin/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:email_validator/email_validator.dart';

class InsertUser extends StatefulWidget {
  const InsertUser({super.key});

  @override
  State<InsertUser> createState() => _InsertUserState();
}

class _InsertUserState extends State<InsertUser> {
  var isLoading = false;
  TextEditingController nameTxt = TextEditingController();
  TextEditingController usernameTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();
  TextEditingController passTxt = TextEditingController();
  TextEditingController roleController = TextEditingController();

  Future<void> addUserDoc(String uid, email, name, type, username) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'name': name,
        'type': type,
        'uid': uid,
        'username': username
        // Add any additional fields you need
      });
      print('User data added to Firestore');
    } catch (e) {
      print('Error adding user data to Firestore: $e');
    }

  }

  void _insertUser(email, name, type, username, password) async {
    String typeName = "";
    bool validated = true;

    if(type == '2') {
      typeName = "admin";
    }
    else if(type == '3') {
      typeName = "owner";
    }
    else if(type == '4') {
      typeName = "user";
    }

    print('Type: $type TypeName: $typeName');

    if(name == "") {
      validated = false;
      Alert.alertValidation("Nama harus diisi!", context);
    }

    if(email == "") {
      validated = false;
      Alert.alertValidation("Email harus diisi!", context);
    }

    if(password == "") {
      validated = false;
      Alert.alertValidation("Kata sandi harus diisi!", context);
    }

    if(EmailValidator.validate(email) == false) {
      validated = false;
      Alert.alertValidation("Email harus valid!", context);
    }

    if(username == "") {
      validated = false;
      Alert.alertValidation("Username harus diisi!", context);
    }

    if(typeName == "") {
      validated = false;
      Alert.alertValidation("Peran user harus dipilih!", context);
    }
    
    if(validated) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await addUserDoc(userCredential.user!.uid, email, name, typeName, username);
        print('User signed up and data added to Firestore');
        NavigationUtils.pushRemoveTransition(context, MainScreen(page: 0));
      } catch (e) {
        print('Error signing up with user data: $e');
      }
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int selectRole = 1;

  final List<Map<String, dynamic>> _roles = [{'Pilih Peran': 1}, {'Admin': 2}, {'Owner': 3}, {'User': 4}];
  
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
                            
                            // name text field
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
                                controller: nameTxt,
                                decoration: formInputDecoration('Nama', const Icon(Icons.person, color: Color.fromARGB(255, 82, 114, 255),),true, Colors.white)
                              ),
                            ),
                            const SizedBox(
                              height: 20,
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
                                controller: usernameTxt,
                                decoration: formInputDecoration('Username', const Icon(Icons.person_rounded, color: Color.fromARGB(255, 82, 114, 255),),true, Colors.white)
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
                                controller: emailTxt,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: formInputDecoration('Email', const Icon(Icons.email_rounded, color: Color.fromARGB(255, 82, 114, 255),), true, Colors.white)
                              ),
                            ),
                            const SizedBox(height: 20),
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
                                controller: passTxt,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: formInputDecoration('Kata Sandi', const Icon(Icons.password_rounded, color: Color.fromARGB(255, 82, 114, 255),), true, Colors.white)
                              ),
                            ),
                            const SizedBox(height: 20),
                            // user role
                            DropdownButtonFormField<int>(
                              value: _roles[0].values.first,
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
                                      _insertUser(emailTxt.text, nameTxt.text, roleController.text, usernameTxt.text, passTxt.text);
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
                                    'Buat',
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