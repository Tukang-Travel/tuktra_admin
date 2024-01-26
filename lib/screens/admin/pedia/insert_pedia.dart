import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuktra_admin/screens/main_screen.dart';
import 'package:tuktra_admin/services/pedia_service.dart';
import 'package:tuktra_admin/services/user_service.dart';
import 'package:tuktra_admin/utils/alert.dart';
import 'package:tuktra_admin/utils/constant.dart';
import 'package:tuktra_admin/utils/navigation_utils.dart';
import 'package:tuktra_admin/utils/utils.dart';

class InsertPedia extends StatefulWidget {
  const InsertPedia({super.key});

  @override
  State<InsertPedia> createState() => _InsertPediaState();
}

class _InsertPediaState extends State<InsertPedia> {
  UserService userService = UserService();
  PediaService pediaService = PediaService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<File> _pickedImages = [];

  List<String> _types = [];
  final List<String> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    getTagsTemplate();
  }

  Future<void> getTagsTemplate() async {
    final List<Map<String, dynamic>> temp =
        await UserService().getPreferencesTemplate();
    setState(() {
      _types = temp.map((e) => e['name'].toString()).toList();
    });
  }

  Future<void> _pickImage() async {
    final pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 50,
    );

    if (pickedFiles.isNotEmpty) {
      try {
        // Check if the picked files are images
        List<File> imageFiles = [];
        for (var pickedFile in pickedFiles) {
          String imagePath = pickedFile.path;
          if (await isImageFile(imagePath)) {
            imageFiles.add(File(imagePath));
          } else {
            if (context.mounted) {
              Alert.alertValidation('File harus merupakan gambar!', context);
            }
            return;
          }
        }

        setState(() {
          _pickedImages = imageFiles;
        });
      } catch (e) {
        if (context.mounted) {
          Alert.alertValidation('Terjadi kesalahan saat memilih gambar: $e', context);
        }
      }
    } else {
      if (context.mounted) {
        Alert.alertValidation('Tidak ada gambar yang dipilih.', context);
      }
    }
  }

  Future<bool> isImageFile(String filePath) async {
    final imageExtensions = [
      'jpg',
      'jpeg',
      'png'
    ]; // Add more extensions if needed

    // Check the file extension
    final extension = filePath.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  void _addType(String type) {
    if (type.isNotEmpty && !_selectedTypes.contains(type)) {
      setState(() {
        _selectedTypes.add(type);
        typeTxt.clear();
      });
    }
  }

  Future<void> _insertPedia() async {
    setState(() {
      isLoading = true;
    });

    try {
      await pediaService.insertPedia(
        userService.currUser!.uid,
        descTxt.text,
        _pickedImages,
        _selectedTypes,
        titleTxt.text,
      );

      if (context.mounted) {
        NavigationUtils.pushRemoveTransition(context, const MainScreen(page: 0,));
        Alert.successMessage("Pedia berhasil ditambahkan.", context);
      }
    } catch (error) {
      if (context.mounted) {
        Alert.alertValidation(error as String, context);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController titleTxt = TextEditingController();
  TextEditingController descTxt = TextEditingController();
  TextEditingController typeTxt = TextEditingController();
  bool checked = false;
  bool isLoading = false;

  @override
  void dispose() {
    titleTxt.dispose();
    descTxt.dispose();
    typeTxt.dispose();
    checked = false;
    isLoading = false;
    _pickedImages = [];
    _types = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 70.0, bottom: 10.0, left: 5.0),
                    child: Text(
                      'Unggah Pedia Baru',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0, left: 5.0),
                    child: Text(
                      'Promosikan tempat wisatamu dengan menunggah pedia yang mendeskripsikan usaha wisatamu!',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 81, 81, 81)),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: RichText(
                              text: const TextSpan(
                                  text: 'Judul ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
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
                              controller: titleTxt,
                              decoration: InputDecoration(
                                  hintText: 'Judul',
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
                            height: 10.0,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: RichText(
                              text: const TextSpan(
                                  text: 'Deskripsi ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
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
                              controller: descTxt,
                              maxLines: null,
                              decoration: InputDecoration(
                                  hintText: 'Deskripsikan tempat wisatamu...',
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
                            height: 10.0,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: RichText(
                              text: const TextSpan(
                                  text: 'Foto Tempat Wisata ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     _pickImage();
                          //   },
                          //   child: Container(
                          //     width: 350.0,
                          //     height: 175.0,
                          //     decoration: BoxDecoration(
                          //       color: const Color.fromARGB(255, 188, 188, 188),
                          //       borderRadius: BorderRadius.circular(20.0),
                          //     ),
                          //     child: Center(
                          //       child: Text(
                          //         'Pilih Foto',
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.w500,
                          //           fontSize: 18.0,
                          //           color: Colors.white
                          //         ),
                          //       )
                          //     ),
                          //   ),
                          // ),

                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _pickImage();
                                },
                                child: Container(
                                  width: 350.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 188, 188, 188),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Pilih Foto',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 1.0,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _pickedImages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Image.file(_pickedImages[index],
                                      height: 100, width: 100);
                                },
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10.0,
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Tags Terpilih',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              _selectedTypes.isNotEmpty
                                  ? Wrap(
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children: _selectedTypes.map((type) {
                                        return Chip(
                                          label: Text(type),
                                          onDeleted: () {
                                            setState(() {
                                              _selectedTypes.remove(type);
                                            });
                                          },
                                        );
                                      }).toList(),
                                    )
                                  : const Text(
                                      'Tidak ada Tag yang terpilih/dimasukkan'),
                              const SizedBox(height: 16.0),
                              const Text(
                                'Rekomendasi Tags',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                height: 250.0,
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                          childAspectRatio: 2.5),
                                  itemCount: _types.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final type = _types[index];
                                    return TagCheckbox(
                                      text: type,
                                      checked: false,
                                      onChanged: (bool? value) {
                                        _addType(type);
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: RichText(
                                  text: const TextSpan(
                                    text: 'Tags',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
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
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                      )
                                    ]),
                                child: TextFormField(
                                  controller: typeTxt,
                                  decoration: InputDecoration(
                                    hintText: 'Tags',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                128, 170, 188, 192),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          _addType(typeTxt.text.trim());
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if(titleTxt.text.isEmpty) {
                            Alert.alertValidation("Judul harus diisi!", context);
                          }
                          else if(descTxt.text.isEmpty) {
                            Alert.alertValidation("Deskripsi harus diisi!", context);
                          }
                          else if(_selectedTypes.isEmpty) {
                            Alert.alertValidation("Tag harus dipilih!", context);
                          }
                          else if(_pickedImages.isEmpty) {
                            Alert.alertValidation("Foto harus dipilih!", context);
                          } 
                          else {
                            _insertPedia();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 82, 114, 255)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        child: Text(
                          'Buat',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 30.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                onPressed: () {
                  NavigationUtils.pushRemoveTransition(
                      context, const MainScreen(page: 0));
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
