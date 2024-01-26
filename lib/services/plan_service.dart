import 'package:cloud_firestore/cloud_firestore.dart';

class PlanService {
  Future<Map<String, dynamic>?> getPlan(String id) async {
    try {
      CollectionReference plans =
          FirebaseFirestore.instance.collection('planners');
      DocumentSnapshot planDocument = await plans.doc(id).get();

      if (planDocument.exists) {
        return planDocument.data() as Map<String, dynamic>;
      } else {
        print('Plan not found');
        return null;
      }
    } catch (e) {
      print('Error retrieving plan data: $e');
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?> getPlans(
      String userId) async {
    try {
      Query<Map<String, dynamic>> plansQuery = FirebaseFirestore.instance
          .collection('planners')
          .where('userid', isEqualTo: userId);

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await plansQuery.get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> planList = [];

      for (var document in querySnapshot.docs) {
        planList.add(document);
      }

      return planList;
    } catch (e) {
      print('Error retrieving plan data: $e');
      return null;
    }
  }

  Future<void> insertPlanner(String title, String source, String destination,
      String startDate, String endDate, int budget, int people, String userId) async {
    Map<String, dynamic> plan = {
      'title': title,
      'source': source,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'budget': budget,
      'people': people,
      'userid': userId
    };
    try {
      await FirebaseFirestore.instance.collection('planners').add(plan);
    } catch (e) {
      print('Error inserting plan: $e');
    }
  }

  Future<void> deletePlanner(String id) async {
    try {
      await FirebaseFirestore.instance.collection('planners').doc(id).delete();
    } catch (e) {
      print('Error deleting plan: $e');
    }
  }

  Future<void> updatePlanner(
      String id,
      String title,
      String source,
      String destination,
      String startDate,
      String endDate,
      int budget,
      int people) async {
    Map<String, dynamic> plan = {
      'title': title,
      'source': source,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'budget': budget,
      'people': people,
    };
    try {
      await FirebaseFirestore.instance
          .collection('planners')
          .doc(id)
          .update(plan);
    } catch (e) {
      print('Error updating plan: $e');
    }
  }

  Future<void> insertItinerary(
      String id, List<Map<String, dynamic>>? days) async {
    try {
      if (days != null) {
        List<dynamic> convertedDays = days.cast<dynamic>();
        await FirebaseFirestore.instance.collection('planners').doc(id).update({
          'days': FieldValue.arrayUnion(convertedDays),
        });
      }
    } catch (e) {
      print('Error inserting itinerary: $e');
    }
  }

  Future<void> insertSubItinerary(
      String id, String dayNum, Map<String, dynamic> itinerary) async {
    CollectionReference plans =
        FirebaseFirestore.instance.collection('planners');

    // Get the document reference
    DocumentReference docRef = plans.doc(id);

    // Get the current data of the document
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    // Find the day with the specified dayNumber
    var day = data['days']
        ?.firstWhere((day) => day['day'] == dayNum, orElse: () => {});

    // If the day is found, append the new itinerary
    if (day.isNotEmpty) {
      day['itineraries'] = [...day['itineraries'], itinerary];
    }

    // Update the document in Firebase
    await docRef.update({'days': data['days']});
  }

  Future<void> updateSubItinerary(String id, int dayIdx, int itineraryIdx,
      Map<String, dynamic> itinerary) async {
    try {
      print('Updating...');

      // Get the current document data
      var documentSnapshot =
          await FirebaseFirestore.instance.collection('planners').doc(id).get();
      var data = documentSnapshot.data();

      // Get the current itineraries
      List<Map<String, dynamic>> currentItineraries =
          List.from(data?['days'][dayIdx]['itineraries']);

      // Update the specific itinerary at the given index
      currentItineraries[itineraryIdx] = itinerary;

      // Update the 'itineraries' field in the 'days' map
      data?['days'][dayIdx]['itineraries'] = currentItineraries;

      // Update the entire 'days' field in Firestore
      await FirebaseFirestore.instance.collection('planners').doc(id).update({
        'days': data?['days'],
      });

      print('Itinerary updated successfully!');
    } catch (e) {
      print('Error updating itinerary: $e');
    }
  }

  Future<void> deleteSubItinerary(
      String id, int dayIdx, int itineraryIdx) async {
    try {
      // Get the current document data
      var documentSnapshot =
          await FirebaseFirestore.instance.collection('planners').doc(id).get();
      var data = documentSnapshot.data();

      // Get the current itineraries
      List<Map<String, dynamic>> currentItineraries =
          List.from(data?['days'][dayIdx]['itineraries']);

      // Ensure the itineraryIdx is within bounds
      if (itineraryIdx >= 0 && itineraryIdx < currentItineraries.length) {
        // Remove the itinerary at the specified index
        currentItineraries.removeAt(itineraryIdx);

        // Update the 'itineraries' field in the 'days' map
        data?['days'][dayIdx]['itineraries'] = currentItineraries;

        // Update the entire 'days' field in Firestore
        await FirebaseFirestore.instance.collection('planners').doc(id).update({
          'days': data?['days'],
        });

        print('Itinerary deleted successfully!');
      } else {
        print('Invalid itinerary index');
      }
    } catch (e) {
      print('Error deleting itinerary: $e');
    }
  }
}
