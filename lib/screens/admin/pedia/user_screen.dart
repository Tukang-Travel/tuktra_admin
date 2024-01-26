import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuktra_admin/screens/admin/pedia/insert_pedia.dart';
import 'package:tuktra_admin/screens/admin/pedia/insert_user.dart';
import 'package:tuktra_admin/screens/admin/pedia/update_user.dart';
import 'package:tuktra_admin/utils/alert.dart';
import 'package:tuktra_admin/utils/navigation_utils.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Alert alert = Alert();
  @override
  Widget build(BuildContext context) {
    // UserModel user = Provider.of<UserProvider>(context).user;

    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0),
                child: Text(
                  'Pengguna',
                  style: TextStyle(
                    fontSize: 35.0,
                  ),
                ),
              ),
              const SizedBox(height: 15.0,),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder( 
                        pageBuilder: (context, animation, secondaryAnimation) => const InsertUser(),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 82, 114, 255),
                    foregroundColor: Colors.white,
                    elevation: 3, // Elevation (shadow)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // BorderRadius
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Button padding
                    fixedSize: const Size(300, 50),
                  ), 
                  child: const Text(
                    'Tambah Pengguna Baru',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0,),
        
              // users list
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Container(
                  height: h * 0.6,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Access the documents in the collection
                      var items = snapshot.data!.docs;

                      return ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemCount: items.length,
                        separatorBuilder: (context, _) => const SizedBox(width: 8.0,),
                        itemBuilder: (context, index) {
                          var item = items[index].data() as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: 
                            //snapshot.data?[index]['id'] != user?['id'] ?
                              Card(
                                child: Container(
                                  height: 150.0,
                                  width: 150.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 160.0,
                                              child: Text(
                                                '${item['username']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(255, 80, 80, 80),
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15.0,),
                                            ElevatedButton(
                                              onPressed: () {
                                                String id = item['uid'];

                                                NavigationUtils.pushRemoveTransition(context, UpdateUser(userId: id));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color.fromARGB(255, 82, 114, 255),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                ),
                                                fixedSize: const Size(25, 25),
                                                padding: EdgeInsets.zero
                                              ),
                                              child: const Icon(
                                                Icons.edit,
                                                size: 20.0,
                                              ),
                                            ),
                                            const SizedBox(width: 10.0,),
                                            
                                            ElevatedButton(
                                              onPressed: () {
                                                // popup delete user
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                )
                                              ),
                                              child: const Icon(
                                                Icons.delete,
                                                size: 20.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text(
                                          item['email'],
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 80, 80, 80),
                                            fontSize: 15.0
                                          ),
                                        ),
                                        const SizedBox(height: 5.0,),
                                        Text(
                                          item['type'][0].toString().toUpperCase() + item['type'].toString().substring(1),
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 80, 80, 80),
                                            fontSize: 15.0
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              )
                              // :
                              // const SizedBox.shrink()
                            ,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
