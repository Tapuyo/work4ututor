// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../data_class/studentsEnrolledclass.dart';
import '../data_class/tutor_info_class.dart';

uploadData() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    Uint8List? file = result.files.first.bytes;
    String filename = result.files.first.name;

    UploadTask task =
        FirebaseStorage.instance.ref().child("userID/$filename").putData(file!);
    // print("Uploaded");
    return filename;
  } else {
    // print("Error");
  }
}

addUser(String tEmail, tPassword, uType) {
  FirebaseFirestore.instance
      .collection('user')
      .add({'email': tEmail, 'password': tPassword, 'role': uType});
  FirebaseFirestore.instance
      .collection('tutor')
      .add({'firstName': tEmail, 'lastName': tPassword, 'userID': 'Tutor'});
}

addTutorInfo(String tEmail, tPassword, uType) {
  FirebaseFirestore.instance
      .collection('user')
      .add({'email': tEmail, 'password': tPassword, 'role': uType});
  FirebaseFirestore.instance
      .collection('tutor')
      .add({'firstName': tEmail, 'lastName': tPassword, 'userID': 'Tutor'});
}

addStudentInfo(String tEmail, tPassword, uType) {
  FirebaseFirestore.instance
      .collection('user')
      .add({'email': tEmail, 'password': tPassword, 'role': uType});
  FirebaseFirestore.instance
      .collection('students')
      .add({'firstName': tEmail, 'lastName': tPassword, 'userID': 'Tutor'});
}

class ClassesData {
  final String uid;
  ClassesData({required this.uid});
  final CollectionReference classCollection =
      FirebaseFirestore.instance.collection('classes');

  List<TutorInformation> _getClass(QuerySnapshot snapshot) {
    
    return snapshot.docs.map((tutordata) {
      return TutorInformation(
        birthPlace: tutordata['birthPlace'] ?? '',
        country: tutordata['country'] ?? '',
        certificates: tutordata['certificates'] ?? '',
        resume: tutordata['resume'] ?? '',
        promotionalMessage: tutordata['promotionalMessage'] ?? '',
        withdrawal: tutordata['withdrawal'] ?? '',
        status: tutordata['status'] ?? '',
        extensionName: tutordata['extensionName'] ?? '',
        dateSign: DateTime.now().toString(),
        firstName: tutordata['firstName'] ?? '',
        imageID: tutordata['imageID'] ?? '',
        language: tutordata['language'] ?? '',
        lastname: tutordata['lastName'] ?? '',
        middleName: tutordata['middleName'] ?? '',
        presentation: tutordata['presentation'] ?? '',
        tutorID: tutordata['tutorID'] ?? '',
        userId: tutordata['userID'] ?? '',
      );
    }).toList();
  }

  Stream<List<TutorInformation>> get classlist {
    return classCollection.snapshots().map(_getClass);
  }
}
