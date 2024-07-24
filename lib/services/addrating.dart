import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final CollectionReference reviewCollection =
    FirebaseFirestore.instance.collection('myreview');

Future<bool> addTutorRating(
  String classID,
  double rating,
  String review,
  String studentID,
  String studentname,
  String tutorid,
  String tutorName,
) async {
  try {
    await reviewCollection.add({
      'classID': classID,
      'totalRating': rating,
      'review': review,
      'datereview': DateTime.now(),
      'studentID': studentID,
      'studentName': studentname,
      'tutorID': tutorid,
      'tutorName': tutorName,
    });
    return true;
  } catch (e) {
    return false;
  }
}
Future<bool> addClassRating(
  String classID,
  double rating,
  String review,
  String studentID,
  String studentname,
  String tutorid,
  String tutorName,
) async {
  try {
    await reviewCollection.add({
      'classID': classID,
      'totalRating': rating,
      'review': review,
      'datereview': DateTime.now(),
      'studentID': studentID,
      'studentName': studentname,
      'tutorID': tutorid,
      'tutorName': tutorName,
    });
    return true;
  } catch (e) {
    return false;
  }
}
Future<bool> updateClassStatus(
  String classID,
  double rating,
  String review,
  String studentID,
  String studentname,
  String tutorid,
  String tutorName,
) async {
  try {
    await reviewCollection.add({
      'classID': classID,
      'totalRating': rating,
      'review': review,
      'datereview': DateTime.now(),
      'studentID': studentID,
      'studentName': studentname,
      'tutorID': tutorid,
      'tutorName': tutorName,
    });
    return true;
  } catch (e) {
    return false;
  }
}