import 'package:cloud_firestore/cloud_firestore.dart';

class TransportService {
  Future<List<Map<String, dynamic>>> getTransports() async {
    try {
      CollectionReference transportations =
          FirebaseFirestore.instance.collection('transportations');
      QuerySnapshot querySnapshot = await transportations.get();

      List<Map<String, dynamic>> transports = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          if (documentSnapshot.exists) {
            transports.add(documentSnapshot.data() as Map<String, dynamic>);
          }
        }
        return transports;
      } else {
        print('No documents found in the collection');
        return [];
      }
    } catch (e) {
      print('Error retrieving transportation data: $e');
      return [];
    }
  }
}
