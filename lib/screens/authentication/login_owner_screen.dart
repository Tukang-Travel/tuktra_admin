import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuktra_admin/provider/user_provider.dart';
import 'package:tuktra_admin/screens/authentication/register_owner_screen.dart';
import 'package:tuktra_admin/screens/main_screen.dart';
import 'package:tuktra_admin/screens/welcome_screen.dart';
import 'package:tuktra_admin/services/user_service.dart';
import 'package:tuktra_admin/utils/alert.dart';
import 'package:tuktra_admin/utils/navigation_utils.dart';
import 'package:tuktra_admin/utils/utils.dart';

class LoginOwnerScreen extends StatefulWidget {
  const LoginOwnerScreen({super.key});

  @override
  State<LoginOwnerScreen> createState() => _LoginOwnerScreenState();
}

class _LoginOwnerScreenState extends State<LoginOwnerScreen> {
  UserService userService = UserService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController usernameTxt = TextEditingController();
  TextEditingController passTxt = TextEditingController();

  bool isLoading = false;
  bool isGoogle = false;

  @override
  void dispose() {
    super.dispose();
    usernameTxt.dispose();
    passTxt.dispose();
  }

  void _loginAuth() async {
    if(usernameTxt.text.isEmpty) {
      Alert.alertValidation('Username harus diisi!', context);
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
    else {
      String apiResponse =
        await userService.login(usernameTxt.text, passTxt.text);
      if (apiResponse == 'Success') {
        // save user info and redirect to home
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

  /* didefinisikan variabel dengan tipe data User pada parameter fungsi dibawah */
  void _successfulLogin() async {
    // Set user data using the UserProvider
    // Provider.of<UserProvider>(context, listen: false).setUser(userData);

    await Provider.of<UserProvider>(context, listen: false).refreshUser();

    if (context.mounted) {
      NavigationUtils.pushRemoveTransition(
          context,
          const MainScreen(
            page: 0,
          ));
    }
  }

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
                  context, const WelcomeScreen());
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
                          padding: const EdgeInsets.only(top: 150.0),
                          child: Container(
                            child: Column(
                              children: [
                                const Card(
                                  color: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Text("Masuk sebagai Administator",
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
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        128,
                                                                        170,
                                                                        188,
                                                                        192),
                                                                width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Color.fromARGB(
                                                              128,
                                                              170,
                                                              188,
                                                              192),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
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
                                                            128, 170, 188, 192),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 5.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width * 0.75,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          isLoading = true;
                                                          _loginAuth();
                                                        });
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              82,
                                                              114,
                                                              255),
                                                      elevation: 5,
                                                      shadowColor: Colors.black,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15.0,
                                                          horizontal: 20.0),
                                                      shape:
                                                          RoundedRectangleBorder(
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
                                                              'MASUK',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18.0,
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
      ),
    );
  }
}
