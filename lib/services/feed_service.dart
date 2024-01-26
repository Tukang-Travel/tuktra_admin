import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadFeed(String userId, String username, String title,
      List<Map<String, dynamic>> content, List<String> tags) async {
    // Create a new document in the "feeds" collection
    CollectionReference feedsCollection =
        FirebaseFirestore.instance.collection('feeds');
    DocumentReference newFeedRef = feedsCollection.doc();

    // Add feed details to Firestore
    await newFeedRef.set({
      'feedId': newFeedRef.id, // Automatically generated ID from Firestore
      'userId': userId,
      'username': username,
      'title': title,
      'content': content,
      'tags': tags,
      'likes': [], // Initialize with an empty array
      'comments': [], // Initialize with an empty array
      'datePublished': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> uploadFiles(
      String title, List<File> files) async {
    List<Map<String, dynamic>> fileDetails = [];

    if (files.isNotEmpty) {
      // Create a folder in Firebase Storage using the title
      String folderPath = 'feeds/$title/';
      Reference storageRef = FirebaseStorage.instance.ref().child(folderPath);

      // Upload each file to the created folder
      for (File file in files) {
        String fileName = file.path.split('/').last;
        String fileType = _getFileExtensionType(fileName);

        UploadTask uploadTask = storageRef.child(fileName).putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        // Get the download URL of the uploaded file
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Add file details to the list
        fileDetails.add({
          'src': downloadURL,
          'type': fileType,
        });
      }
    }

    return fileDetails;
  }

  String _getFileExtensionType(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return 'image';
    } else if (['mp4', 'mov', 'avi'].contains(extension)) {
      return 'video';
    } else {
      // Default to 'other' or handle as needed
      return 'other';
    }
  }

  Future<String> likePost(
      String postId, String uid, List<dynamic> likes) async {
    String res = "Some error occurred";
    try {
      if (likes.any((like) => like.containsValue(uid))) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('feeds').doc(postId).update({
          'likes': FieldValue.arrayRemove([
            {'userId': uid}
          ])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('feeds').doc(postId).update({
          'likes': FieldValue.arrayUnion([
            {'userId': uid}
          ])
        });
      }
      logAnalyticsEvent(postId);
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //log user event
  void logAnalyticsEvent(String id) {
    FirebaseAnalytics.instance.logEvent(
      name: 'select_item',
      parameters: <String, dynamic>{
        'item_id': id,
      },
    );
  }

  // Post comment
  Future<String> postComment(
      String feedId, String text, String uid, String username) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('feeds').doc(feedId).update({
          'comments': FieldValue.arrayUnion([
            {
              'username': username,
              'userId': uid,
              'comment': text,
              'datePublished': DateTime.now(),
            }
          ])
        });
        res = 'success';
      } else {
        res = "Komentar tidak boleh kosong!";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deleteFeed(String feedId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('feeds').doc(feedId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Update Post
  Future<String> updateFeed(
      String feedId, String newTitle, List<String> newTags) async {
    String res = "Some error occurred";
    try {
      // if the likes list contains the user uid, we need to remove it
      _firestore
          .collection('feeds')
          .doc(feedId)
          .update({'title': newTitle, 'tags': newTags});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteFiles(String title) async {
    String folderPath = 'feeds/$title/';
    Reference storageRef = FirebaseStorage.instance.ref().child(folderPath);

    try {
      await storageRef.listAll().then((value) {
        for (var element in value.items) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        }
      });
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
