import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
      .collection('tutor')
      .add({'firstName': tEmail, 'lastName': tPassword, 'userID': 'Tutor'});
}

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  //collection reference
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference tutorCollection =
      FirebaseFirestore.instance.collection('tutor');
  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('tutor');

  Future updateUserData(String email, String password, String role) async {
    return await dataCollection.doc(uid).set({
      'email': email,
      'password': password,
      'role': role,
    });
  }

  Future updateTutorData(
    String name,
    String lastname,
  ) async {
    return await tutorCollection.doc(uid).set({
      "language": [],
      "birthPlace": "",
      "certificates": "",
      "country": "",
      "dateSign": "",
      "extensionName": "",
      "firstName": name,
      "imageID": "",
      "lastName": lastname,
      "middleName": "",
      "presentation": "",
      "promotionalMessage": "",
      "resume": "",
      "status": "unsubscribe",
      "tutorID": uid,
      "userID": "",
      "withdrawal": "",
    });
  }

  Future updateStudentData(
    String name,
    String lastname,
  ) async {
    return await studentCollection.doc(uid).set({
      "language": [],
      "birthPlace": "",
      "certificates": "",
      "country": "",
      "dateSign": "",
      "extensionName": "",
      "firstName": name,
      "imageID": "",
      "lastName": lastname,
      "middleName": "",
      "presentation": "",
      "promotionalMessage": "",
      "resume": "",
      "status": "unsubscribe",
      "tutorID": uid,
      "userID": "",
      "withdrawal": "",
    });
  }
}
