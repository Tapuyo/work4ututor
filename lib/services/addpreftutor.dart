import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final CollectionReference preftutorCollection =
    FirebaseFirestore.instance.collection('preftutor');
Future<void> updateprefferdInFirestore(
    List<String> preftutorId, String studentID) async {
  try {
    await preftutorCollection.doc(studentID).set({
      'tutorId': FieldValue.arrayUnion(preftutorId),
    });
    print('List updated in Firestore');
  } catch (e) {
    print('Error updating list: $e');
  }
}

class PreferredTutorsNotifier with ChangeNotifier {
  final CollectionReference preftutorCollection =
      FirebaseFirestore.instance.collection('preftutor');

  List<String> _preferredTutors = [];
  bool _isFetching = false;

  List<String> get preferredTutors => _preferredTutors;
  bool get isFetching => _isFetching;

  Future<void> fetchPreferredTutors(String studentID) async {
    try {
      _isFetching = true; // Set the flag to true before fetching
      notifyListeners();

      DocumentSnapshot studentDoc = await preftutorCollection.doc(studentID).get();

      if (studentDoc.exists) {
        _preferredTutors = List<String>.from(studentDoc['tutorId']);
      } else {
        print('Document with ID $studentID does not exist in Firestore');
      }
    } catch (e) {
      print('Error getting preferred tutors: $e');
    } finally {
      _isFetching = false; // Set the flag back to false after fetching
      notifyListeners();
    }
  }
}