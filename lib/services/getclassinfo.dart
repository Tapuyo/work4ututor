import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassInfoNotifier with ChangeNotifier {
  Map<String, dynamic> _classdetails = {};

  Map<String, dynamic> get classinfo => _classdetails;

  void getClassInfo(String docId) {
    try {
      FirebaseFirestore.instance
          .collection('classes')
          .doc(docId)
          .snapshots()
          .listen((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;

          _classdetails = {
            'docid': documentSnapshot.id,
            'subjectID': data['subjectID'] ?? '',
          };
        } else {
          _classdetails = {};
        }
        notifyListeners();
      });
    } catch (e) {
      _classdetails = {};
      notifyListeners();
    }
  }
}
