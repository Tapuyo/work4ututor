// ignore_for_file: unused_local_variable

import 'dart:js';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../data_class/studentinfoclass.dart';

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
        userID: snapshot.get('userID') ?? '',
        contact: snapshot.get('contact') ?? '',
        emailadd: snapshot.get('emailadd') ?? '',
        profilelink: snapshot.get('profileurl') ?? '',
        dateregistered: snapshot.get('dateregistered').toDate() ?? '',
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

class StudentGuardianData {
  final String uid;
  StudentGuardianData({required this.uid});

  Stream<List<StudentGuardianClass>> get guardianinfo {
    return FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .collection('guardianName')
        .snapshots()
        .map(_getGuardian);
  }

  List<StudentGuardianClass> _getGuardian(QuerySnapshot snapshot) {
    return snapshot.docs.map((guardians) {
      return StudentGuardianClass(
        docID: guardians.id,
        address: guardians['address'] ?? '',
        contact: guardians['contact'] ?? '',
        country: guardians['country'] ?? '',
        guardianMiddlename: guardians['guardianMiddleName'] ?? '',
        email: guardians['emailadd'] ?? '',
        guardianFirstname: guardians['guardianFirstName'] ?? '',
        guardianLastname: guardians['guardianLastName'] ?? '',
      );
    }).toList();
  }
}

// class UpdateStudentinfo {
//   final String uid;
//   final String subuid;
//   UpdateStudentinfo({required this.uid, required this.subuid});

Future<void> updateStudentInfo(
  String uid,
  String name,
  String middlename,
  String lastname,
  List<String> language,
  String contact,
  String emailadd,
  String address,
  String country,
) async {
  try {
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "language": language,
      "address": address,
      "country": country,
      "studentFirstName": name,
      "studentMiddleName": middlename,
      "studentLastName": lastname,
      "contact": contact,
      "emailadd": emailadd,
    }, SetOptions(merge: true));
    html.window.alert('Update Successful');
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}

// }
Future<void> updateImage(String uID, String path) async {
  // Select a new image from the device's file picker
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  if (result == null || result.files.isEmpty) {
    // No image selected
    return;
  }

  // Get a reference to the Firebase Storage
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  // Get the directory path from the existing image path
  // String directoryPath = path.substring(0, path.lastIndexOf('/'));

  // Upload the updated image to Firebase Storage with the new name
  // String newPath = '$directoryPath/$newName.jpg';
  // Get the existing image reference
  firebase_storage.Reference existingImageRef = storage.ref().child(path);

  // Get the download URL of the existing image
  String url = await existingImageRef.getDownloadURL();

  // Download the existing image
  // http.Response response = await http.get(Uri.parse(url));

  // Upload the updated image to Firebase Storage, replacing the existing one
  firebase_storage.Reference updatedImageRef = storage.ref().child(path);

  try {
    // Upload the new image file
    await updatedImageRef.putData(result.files.first.bytes!);

    // Get the updated download URL
    String updatedImageUrl = await updatedImageRef.getDownloadURL();
    updatelink(uID, path);
    html.window.alert('Image Updated Succesfully');
  } catch (e) {
    print('Error Updating Image: $e');
  }
}

Future<void> updateGuardianInfo(
  String uid,
  String subID,
  String name,
  String middlename,
  String lastname,
  String contact,
  String emailadd,
  String address,
  String country,
) async {
  try {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .collection('guardianName')
        .doc(subID)
        .set({
      "address": address,
      "country": country,
      "guardianFirstName": name,
      "guardianMiddleName": middlename,
      "guardianLastName": lastname,
      "contact": contact,
      "emailadd": emailadd,
    });
    html.window.alert('Update Successful');
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}

Future<void> updatelink(
  String uid,
  String path,
) async {
  try {
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "profileurl": path,
    }, SetOptions(merge: true));
    html.window.alert('Update Successful');
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}

Future<void> _updateEmailAndPassword(String email, String password) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;

  if (user != null) {
    try {
      // Update email
      await user.updateEmail(email);

      // Update password
      await user.updatePassword(password);

      html.window.alert('Update Successful');
    } catch (error) {
      html.window.alert('Update Failed: $error');
    }
  }
}
