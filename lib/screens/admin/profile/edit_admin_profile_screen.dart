import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuktra_admin/screens/main_screen.dart';
import 'package:tuktra_admin/services/user_service.dart';
import 'package:tuktra_admin/utils/alert.dart';
import 'package:tuktra_admin/utils/navigation_utils.dart';
import 'package:tuktra_admin/utils/utils.dart';

class EditAdminProfileScreen extends StatefulWidget {
  const EditAdminProfileScreen({
    super.key,
    required this.profile,
    required this.userId,
    required this.initialName,
    required this.initialUsername,
    required this.initialEmail,
  });

  final String profile;
  final String userId;
  final String initialName;
  final String initialUsername;
  final String initialEmail;

  @override
  State<EditAdminProfileScreen> createState() => _EditAdminProfileScreenState();
}

class _EditAdminProfileScreenState extends State<EditAdminProfileScreen> {
  UserService userService = UserService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameTxt = TextEditingController();
  TextEditingController usernameTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();

  bool isLoading = false;
  String newProfile = "";

  @override
  void dispose() {
    super.dispose();
    nameTxt.dispose();
    usernameTxt.dispose();
    emailTxt.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Set initial values for title and tags
    nameTxt.text = widget.initialName;
    usernameTxt.text = widget.initialUsername;
    emailTxt.text = widget.initialEmail;
  }

  // Function to update the feed in Firestore
  void _updateProfile() async {
    // Validate the name and username
    String updatedName = nameTxt.text.trim();
    String updatedUsername = usernameTxt.text.trim();

    if (updatedName.isEmpty) {
      Alert.alertValidation('Nama harus diisi!', context);
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (updatedUsername.isEmpty) {
      Alert.alertValidation('Username harus diisi!', context);
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Call updateProfile with the new profile image path
    String result = await UserService().updateProfile(
      widget.userId,
      updatedName,
      updatedUsername,
      newProfile,
    );

    // Close the screen
    NavigationUtils.pushRemoveTransition(context, const MainScreen(page: 4));
    Alert.successMessage('Profil berhasil diperbaharui.', context);
  }

  // Function to open image cropper
  Future<void> cropImage(String imagePath) async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Crop Photo',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Crop Photo',
      ),
    );

    

    if (croppedFile != null) {
      setState(() {
        newProfile = croppedFile.path;
      });
    }
  }

  // Helper method to build the profile image widget
  Widget buildProfileImage() {
    return Image.asset(
      'asset/images/default_profile.png',
      width: 150,
      height: 150,
    );
  }

  // Helper method to build the network profile image widget
  Widget buildNetworkProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Image.network(
        widget.profile,
        width: 100,
        height: 100,
      ),
    );
  }

  // Helper method to build the local profile image widget
  Widget buildLocalProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Image.file(
        File(newProfile),
        width: 100,
        height: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 150.0, left: 40.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const AutoSizeText(
            'Ubah Profil',
            maxLines: 10,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              height: 1.2,
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
                          widget.profile == "" && newProfile.isEmpty
                              ? Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 80.0,
                                      top: 80.0,
                                      right: 80.0,
                                      bottom: 5.0,
                                    ),
                                    child: buildProfileImage(),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 80.0,
                                      top: 80.0,
                                      right: 80.0,
                                      bottom: 5.0,
                                    ),
                                    child: newProfile.isEmpty
                                        ? buildNetworkProfileImage()
                                        : buildLocalProfileImage(),
                                  ),
                                ),
                          Center(
                              child: TextButton(
                            onPressed: () async {
                              // Open the image picker
                              final pickedFile = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );

                              if (pickedFile != null) {
                                // Show the image cropper
                                await cropImage(pickedFile.path);
                              }
                            },
                            child: const Text(
                              "Ubah Foto",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 82, 114, 255)),
                            ),
                          )),
                          const SizedBox(
                            height: 20,
                          ),

                          // email text field
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
                                ]),
                            child: TextFormField(
                              controller: emailTxt,
                              enabled: false,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ),
                                  hintText: 'Email',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

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
                                ]),
                            child: TextFormField(
                              controller: nameTxt,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ),
                                  hintText: 'Nama',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          // username text field
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
                                ]),
                            child: TextFormField(
                              controller: usernameTxt,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ),
                                  hintText: 'Username',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: Align(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                      _updateProfile(); // Added the function call here
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 82, 114, 255),
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isLoading)
                                      const CircularProgressIndicator()
                                    else
                                      const Center(
                                        child: Text(
                                          'UBAH',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
