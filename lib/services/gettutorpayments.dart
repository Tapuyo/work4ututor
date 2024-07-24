import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClaimableNotifier with ChangeNotifier {
  List<Map<String, dynamic>> _claimsdetails = [];

  List<Map<String, dynamic>> get claims => _claimsdetails;

  void getClaims(String userid, userType) {
    try {
      if (userType == 'tutor') {
        FirebaseFirestore.instance
            .collection('tutorPayment')
            .where('tutorID', isEqualTo: userid)
            .snapshots()
            .listen((QuerySnapshot querySnapshot) {
          _claimsdetails = querySnapshot.docs.map((doc) {
            final Timestamp timestamp = doc['dateclassFinished'];
            final DateTime date = timestamp.toDate();
            String? dateDisburse;
            if (doc['dateDisburse'] != null) {
              final Timestamp timestamp1 = doc['dateDisburse'];
              dateDisburse = timestamp1.toDate().toString();
            } else {
              dateDisburse = doc['dateDisburse'];
            }
            return {
              'id': doc.id,
              'classId': doc['classId'] ?? '',
              'dateclassFinished': date.toString(),
              'disburseAmount': doc['disburseAmount'] ?? '',
              'adminReady': doc['adminReady'] ?? '',
              'disburseId': doc['disburseId'] ?? '',
              'disburseStatus': doc['disburseStatus'] ?? '',
              'location': doc['location'] ?? '',
              'classAmount': doc['classAmount'] ?? '',
              'studentID': doc['studentID'] ?? '',
              'studentStatus': doc['studentStatus'] ?? '',
              'tutorID': doc['tutorID'] ?? '',
              'tutorStatus': doc['tutorStatus'] ?? '',
              'dateDisburse': dateDisburse,
            };
          }).toList();
          notifyListeners();
        });
      } else {
        FirebaseFirestore.instance
            .collection('tutorPayment')
            .where('studentID', isEqualTo: userid)
            .snapshots()
            .listen((QuerySnapshot querySnapshot) {
          _claimsdetails = querySnapshot.docs.map((doc) {
            final Timestamp timestamp = doc['dateclassFinished'];
            final DateTime date = timestamp.toDate();
            String? dateDisburse;
            if (doc['dateDisburse'] != null) {
              final Timestamp timestamp1 = doc['dateDisburse'];
              dateDisburse = timestamp1.toDate().toString();
            } else {
              dateDisburse = doc['dateDisburse'];
            }
            return {
              'id': doc.id,
              'classId': doc['classId'] ?? '',
              'dateclassFinished': date.toString(),
              'disburseAmount': doc['disburseAmount'] ?? '',
              'adminReady': doc['adminReady'] ?? '',
              'disburseId': doc['disburseId'] ?? '',
              'disburseStatus': doc['disburseStatus'] ?? '',
              'location': doc['location'] ?? '',
              'classAmount': doc['classAmount'] ?? '',
              'studentID': doc['studentID'] ?? '',
              'studentStatus': doc['studentStatus'] ?? '',
              'tutorID': doc['tutorID'] ?? '',
              'tutorStatus': doc['tutorStatus'] ?? '',
              'dateDisburse': dateDisburse,
            };
          }).toList();
          notifyListeners();
        });
      }
    } catch (e) {
      _claimsdetails = [];
      notifyListeners();
    }
  }
}
