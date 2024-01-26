import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // atribut
  final String uid;
  final String name;
  final String username;
  final String email;
  final String type;

  /* constructor object yang 
  bertujuan untuk menginisialisasi atribut 
  agar tidak bernilai NULL */
  const UserModel(
      {required this.uid,
      required this.name,
      required this.username,
      required this.email,
      required this.type});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot["uid"],
      name: snapshot["name"],
      username: snapshot["username"],
      email: snapshot["email"],
      type: snapshot["type"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'type': type
    };
  }
}
