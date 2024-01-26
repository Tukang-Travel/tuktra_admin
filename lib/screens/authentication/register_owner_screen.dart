import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuktra_admin/provider/user_provider.dart';
import 'package:tuktra_admin/screens/authentication/login_owner_screen.dart';
import 'package:tuktra_admin/screens/main_screen.dart';
import 'package:tuktra_admin/screens/welcome_screen.dart';
import 'package:tuktra_admin/services/user_service.dart';
import 'package:tuktra_admin/utils/alert.dart';
import 'package:tuktra_admin/utils/navigation_utils.dart';
import 'package:tuktra_admin/utils/utils.dart';

class RegisterOwnerScreen extends StatefulWidget {
  const RegisterOwnerScreen({super.key});

  @override
  State<RegisterOwnerScreen> createState() => _RegisterOwnerScreenState();
}

class _RegisterOwnerScreenState extends State<RegisterOwnerScreen> {
  UserService userService = UserService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameTxt = TextEditingController();
  TextEditingController usernameTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();
  TextEditingController passTxt = TextEditingController();
  TextEditingController conTxt = TextEditingController();

  bool isLoading = false;
  bool isGoogle = false;

  @override
  void dispose() {
    super.dispose();
    nameTxt.dispose();
    usernameTxt.dispose();
    emailTxt.dispose();
    passTxt.dispose();
    conTxt.dispose();
  }

  void _successfulLogin() async {
    await Provider.of<UserProvider>(context, listen: false).refreshUser();
    if (context.mounted) {
      NavigationUtils.pushRemoveTransition(
          context,
          const MainScreen(
            page: 0,
          ));
    }
  }

  void _regisAuth() async {
    if(nameTxt.text.isEmpty) {
      Alert.alertValidation('Nama harus diisi!', context);
      setState(() {
        isLoading = false;
      });
    } 
    else if(usernameTxt.text.isEmpty) {
      Alert.alertValidation('Username harus diisi!', context);
      setState(() {
        isLoading = false;
      });
    }
    else if(emailTxt.text.isEmpty) {
      Alert.alertValidation('Email harus diisi!', context);
      setState(() {
        isLoading = false;
      });
    }
    else if(passTxt.text.isEmpty) {
      Alert.alertValidation('Kata sandi harus diisi!', context);
      setState(() {
        isLoading = false;
      });
    }
    else if(conTxt.text.isEmpty) {
      Alert.alertValidation('Konfirmasi kata sandi harus diisi!', context);
      setState(() {
        isLoading = false;
      });
    } 
    else if(passTxt.text != conTxt.text) {
      Alert.alertValidation('Konfirmasi kata sandi tidak sesuai!', context);
      setState(() {
        isLoading = false;
      });
    }
    else {
      String apiResponse = await userService.register(
        nameTxt.text, usernameTxt.text, emailTxt.text, passTxt.text, 'owner');
      if (apiResponse == 'Success') {
        _successfulLogin();
      } else {
        setState(() {
          isLoading = !isLoading;
        });
        if (context.mounted) {
          Alert.alertValidation(apiResponse, context);
        }
      }
    }
  }

  void _loginGoogleAuth(String type) async {
    String apiResponse = await userService.googleLoginRegister(type);
    if (apiResponse == 'Success') {
      // save user info and redirect to home
      _successfulLogin();
    } else {
      setState(() {
        isGoogle = !isGoogle;
        isLoading = !isLoading;
      });
      if (context.mounted) {
        Alert.alertValidation(apiResponse, context);
      }
    }
  }

  /* fungsi build dari parent class StatefulWidget
    diimplementasikan dengan tampilan yang berbeda pada 
    tiap child class
   */
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 40.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () {
                NavigationUtils.pushRemoveTransition(
                    context, const LoginOwnerScreen());
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 110.0),
                            child: Container(
                              child: Column(
                                children: [
                                  const Card(
                                    color: Colors.black,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          Text("Daftar sebagai Owner",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          Container(
                                              width: w,
                                              height:
                                                  100.0, // one third of the page
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'asset/images/tuktra_logo.png'),
                                                    fit: BoxFit.cover),
                                              )),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                    offset: Offset(1, 1),
                                                    color: Color.fromARGB(
                                                        128, 170, 188, 192),
                                                  )
                                                ]),
                                            child: TextFormField(
                                              controller: nameTxt,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(
                                                    Icons.abc_rounded,
                                                    color: Color.fromARGB(
                                                        255, 82, 114, 255),
                                                  ),
                                                  hintText: 'Name',
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      128,
                                                                      170,
                                                                      188,
                                                                      192),
                                                              width: 1.0),
                                                      borderRadius: BorderRadius
                                                          .circular(20)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    128,
                                                                    170,
                                                                    188,
                                                                    192),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 10,
                                          ),

                                          // username text field
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                    offset: Offset(1, 1),
                                                    color: Color.fromARGB(
                                                        128, 170, 188, 192),
                                                  )
                                                ]),
                                            child: TextFormField(
                                              controller: usernameTxt,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(
                                                    Icons.person_rounded,
                                                    color: Color.fromARGB(
                                                        255, 82, 114, 255),
                                                  ),
                                                  hintText: 'Username',
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      128,
                                                                      170,
                                                                      188,
                                                                      192),
                                                              width: 1.0),
                                                      borderRadius: BorderRadius
                                                          .circular(20)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    128,
                                                                    170,
                                                                    188,
                                                                    192),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 10,
                                          ),

                                          // email text field
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                    offset: Offset(1, 1),
                                                    color: Color.fromARGB(
                                                        128, 170, 188, 192),
                                                  )
                                                ]),
                                            child: TextFormField(
                                              controller: emailTxt,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(
                                                    Icons.email_rounded,
                                                    color: Color.fromARGB(
                                                        255, 82, 114, 255),
                                                  ),
                                                  hintText: 'Email',
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      128,
                                                                      170,
                                                                      188,
                                                                      192),
                                                              width: 1.0),
                                                      borderRadius: BorderRadius
                                                          .circular(20)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    128,
                                                                    170,
                                                                    188,
                                                                    192),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // password text field
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                    offset: Offset(1, 1),
                                                    color: Color.fromARGB(
                                                        128, 170, 188, 192),
                                                  )
                                                ]),
                                            child: TextFormField(
                                              controller: passTxt,
                                              obscureText: true,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(
                                                    Icons.password_rounded,
                                                    color: Color.fromARGB(
                                                        255, 82, 114, 255),
                                                  ),
                                                  hintText: 'Password',
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              128, 170, 188, 192),
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              128,
                                                              170,
                                                              188,
                                                              192),
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(20))),
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //password confirmation
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                    offset: Offset(1, 1),
                                                    color: Color.fromARGB(
                                                        128, 170, 188, 192),
                                                  )
                                                ]),
                                            child: TextFormField(
                                              controller: conTxt,
                                              obscureText: true,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(
                                                    Icons.password_rounded,
                                                    color: Color.fromARGB(
                                                        255, 82, 114, 255),
                                                  ),
                                                  hintText: 'Confirm Password',
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              128, 170, 188, 192),
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              128,
                                                              170,
                                                              188,
                                                              192),
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(20))),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 5.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isGoogle = true;
                                                          isLoading = true;
                                                          _loginGoogleAuth(
                                                              'owner');
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        elevation: 5,
                                                        shadowColor:
                                                            Colors.black,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15.0,
                                                                horizontal:
                                                                    30.0),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (isLoading &&
                                                              isGoogle)
                                                            const CircularProgressIndicator()
                                                          else
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    'asset/images/google_logo.webp',
                                                                    width: 20.0,
                                                                    height:
                                                                        20.0,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8.0),
                                                                  const Text(
                                                                    'Google',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18.0,
                                                                    ),
                                                                  ),
                                                                ])
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 5.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          setState(() {
                                                            isLoading = true;
                                                            _regisAuth();
                                                          });
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                82, 114, 255),
                                                        elevation: 5,
                                                        shadowColor:
                                                            Colors.black,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15.0,
                                                                horizontal:
                                                                    20.0),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          //const SizedBox(width: 8.0),
                                                          if (isLoading &&
                                                              !isGoogle)
                                                            const CircularProgressIndicator()
                                                          else
                                                            const Center(
                                                              child: Text(
                                                                'DAFTAR',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
