import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TutorNotifier extends ChangeNotifier {
  String _timezone = '';
  String get timezone => _timezone;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Assume you have a tutor ID

  void getlistenToTutor(String tutorId) {
    _firestore.collection('tutor').doc(tutorId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data.containsKey('timezone')) {
          _timezone = data['timezone'];
          notifyListeners();
        } else {
          _timezone = '';
          notifyListeners();
        }
      }
    });
  }
}

class StudentNotifier extends ChangeNotifier {
  String _timezone = '';
  String get timezone => _timezone;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Assume you have a tutor ID

  void getlistenToTutor(String studentid) {
    _firestore.collection('students').doc(studentid).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data.containsKey('timezone')) {
          _timezone = data['timezone'];
          notifyListeners();
        } else {
          _timezone = '';
          notifyListeners();
        }
      }
    });
  }
}