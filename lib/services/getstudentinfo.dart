// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:wokr4ututor/ui/web/search_tutor/find_tutors.dart';
import 'package:wokr4ututor/ui/web/signup/student_information_signup.dart';

import '../data_class/studentinofclass.dart';
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

class StudentInfoData {
  final String uid;
  StudentInfoData({required this.uid});

  List<StudentInfoClass> _getStudentsInfo(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return [
      StudentInfoClass(
        languages: (snapshot.get('language') as List<dynamic>).cast<String>(),
        address: snapshot.get('address') ?? '',
        country: snapshot.get('country') ?? '',
        studentFirstname: snapshot.get('studentFirstName') ?? '',
        studentMiddlename: snapshot.get('studentMiddleName') ?? '',
        studentLastname: snapshot.get('studentLastName') ?? '',
        studentID: snapshot.get('studentID') ?? '',
        userID: snapshot.get('userId') ?? '',
        contact: snapshot.get('contact') ?? '',
        emailadd: snapshot.get('emailadd') ?? '',
        profilelink: snapshot.get('profileurl') ?? '',
      )
    ];
  }

  Stream<List<StudentInfoClass>> get getstudentinfo {
    return FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .snapshots()
        .map(_getStudentsInfo);
  }
}
