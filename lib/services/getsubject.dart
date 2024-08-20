import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data_class/subject_class.dart';

class SubjectInfoNotifier with ChangeNotifier {
  Subjects _subjectdetails =
      Subjects(subjectId: '', subjectName: '', dateTime: '', subjectStatus: '');

  Subjects get subjectinfo => _subjectdetails;

  void getClassInfo(String docId) {
    try {
      FirebaseFirestore.instance
          .collection('subjects')
          .where('subjectid', isEqualTo: docId)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Assuming you only want the first matching document
          final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          final data = documentSnapshot.data() as Map<String, dynamic>;

          _subjectdetails = Subjects(
              dateTime: data['datetime'].toString(),
              subjectId: data['subjectid'],
              subjectName: data['subjectName'],
              subjectStatus: data['subjectStatus']);
        } else {
          _subjectdetails = Subjects(
              subjectId: '', subjectName: '', dateTime: '', subjectStatus: '');
        }
        notifyListeners();
      });
    } catch (e) {
      _subjectdetails = Subjects(
          subjectId: '', subjectName: '', dateTime: '', subjectStatus: '');
      notifyListeners();
    }
  }
}
