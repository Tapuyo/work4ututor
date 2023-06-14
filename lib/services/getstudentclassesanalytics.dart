import 'package:cloud_firestore/cloud_firestore.dart';

import '../data_class/studentanalyticsclass.dart';

class StudentAnalytics {
  String uid;
  StudentAnalytics({required this.uid});
Stream<List<STUanalyticsClass>> get studentanalytics {
    return FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .collection('enrolledclasses')
        .snapshots()
        .map(_getstudentanalytics);
  }

  List<STUanalyticsClass> _getstudentanalytics(QuerySnapshot snapshot) {
    return snapshot.docs.map((data) {
      return STUanalyticsClass(
        classID: data['classID'] ?? '',
        classStatus: data['classStatus'] ?? '',
      );
    }).toList();
  }

}