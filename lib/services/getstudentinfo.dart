// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_html/html.dart' as html;
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:wokr4ututor/data_class/subject_teach_pricing.dart';

import '../data_class/studentinfoclass.dart';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadData(String uid) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    Uint8List? file = result.files.first.bytes;
    String filename = result.files.first.name;

    Reference storageReference =
        FirebaseStorage.instance.ref().child("$uid/$filename");

    UploadTask uploadTask = storageReference.putData(file!);

    Completer<String?> completer = Completer<String?>(); // Create a Completer

    await uploadTask.whenComplete(() async {
      if (uploadTask.snapshot.state == TaskState.success) {
        // File uploaded successfully, get the download URL
        String downloadURL = await storageReference.getDownloadURL();
        completer.complete(downloadURL); // Set the Completer's value
      } else {
        // Handle the upload failure
        print("Upload failed");
        completer.complete(null); // Set the Completer's value
      }
    });

    return completer.future; // Return the Future from the Completer
  } else {
    // Handle the case where the user canceled file selection
    print("Error");
    return null;
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
        age: snapshot.get('age') ?? '',
        dateofbirth: snapshot.get('dateofbirth') ?? '',
        timezone: snapshot.get('timezone') ?? '',
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

Future<void> updateStudentInfo(
  String uid,
  String address,
  String country,
  String name,
  String middlename,
  String lastname,
  List<dynamic> language,
  String studentid,
  String userid,
  String contact,
  String profileurl,
  DateTime dateregistered,
  String age,
  String dateofbirth,
  String timezone,
  String status,
) async {
  try {
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "language": language,
      "address": address,
      "country": country,
      "studentFirstName": name,
      "studentMiddleName": middlename,
      "studentLastName": lastname,
      "studentID": studentid,
      "userID": userid,
      "contact": contact,
      "dateregistered": dateregistered,
      "age": age,
      "dateofbirth": dateofbirth,
      "timezone": timezone,
    }, SetOptions(merge: true));
    updateUserStatus(uid, status);
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}

Future<void> updateUserStatus(
  String uid,
  String status,
) async {
  try {
    await FirebaseFirestore.instance.collection('user').doc(uid).set({
      "status": status,
    }, SetOptions(merge: true));
    html.window.alert('Upload Successful');
  } catch (error) {
    html.window.alert('Upload Failed: $error');
  }
}
Future<void> updateProfile(
  String uid,
  String profileurl,
) async {
  try {
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "profileurl": profileurl,
    }, SetOptions(merge: true));
    html.window.alert('Upload Successful');
  } catch (error) {
    html.window.alert('Upload Failed: $error');
  }
}
Future<void> updateTutorProfile(
  String uid,
  String profileurl,
) async {
  try {
    await FirebaseFirestore.instance.collection('tutor').doc(uid).set({
      "imageID": profileurl,
    }, SetOptions(merge: true));
    html.window.alert('Upload Successful');
  } catch (error) {
    html.window.alert('Upload Failed: $error');
  }
}
Future<String?> uploadTutorProfile(String uid) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    Uint8List? file = result.files.first.bytes;
    String filename = result.files.first.name;

    Reference storageReference =
        FirebaseStorage.instance.ref().child("$uid/$filename");

    UploadTask uploadTask = storageReference.putData(file!);

    Completer<String?> completer = Completer<String?>(); // Create a Completer

    await uploadTask.whenComplete(() async {
      if (uploadTask.snapshot.state == TaskState.success) {
        // File uploaded successfully, get the download URL
        String downloadURL = await storageReference.getDownloadURL();
        completer.complete(downloadURL); // Set the Completer's value
      } else {
        // Handle the upload failure
        print("Upload failed");
        completer.complete(null); // Set the Completer's value
      }
    });

    return completer.future; // Return the Future from the Completer
  } else {
    // Handle the case where the user canceled file selection
    print("Error");
    return null;
  }
}

Future<void> updateStudentInfowGuardian(
    String uid,
    String address,
    String country,
    String name,
    String middlename,
    String lastname,
    List<dynamic> language,
    String studentid,
    String userid,
    String contact,
    String profileurl,
    DateTime dateregistered,
    String age,
    String dateofbirth,
    String timezone,
    String guardiansfullname,
    String guardianscontact,
    String guardiansemail,
    String guardiansbday,
    String guardiansge, // Provide updated course data
    String status,
    ) async {
  try {
    // Update the main student document
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "language": language,
      "address": address,
      "country": country,
      "studentFirstName": name,
      "studentMiddleName": middlename,
      "studentLastName": lastname,
      "studentID": studentid,
      "userID": userid,
      "contact": contact,
      "dateregistered": dateregistered,
      "age": age,
      "dateofbirth": dateofbirth,
      "timezone": timezone,
    }, SetOptions(merge: true));

    // Get a reference to the "courses" subcollection
    final coursesCollectionRef = FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .collection('guardianname');

    // Query the first document in the "courses" subcollection
    QuerySnapshot coursesSnapshot = await coursesCollectionRef.limit(1).get();

    if (coursesSnapshot.docs.isNotEmpty) {
      // Update the first course document found
      final firstCourseDoc = coursesSnapshot.docs.first;
      await firstCourseDoc.reference.set({
        "guardiansfullname": guardiansfullname,
        "guardianscontact": guardianscontact,
        "guardiansemail": guardiansemail,
        "guardiansbirthday": guardiansbday,
        "guardiansge": guardiansge,
      },SetOptions(merge: true));

      updateUserStatus(uid, status);
    } else {
      html.window.alert('No guardian found in the subcollection');
    }
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}


// }
 Future<void> updateTutorInformation(
    String uid,
    String address,
    String country,
    String name,
    String middlename,
    String lastname,
    List<dynamic> language,
    String tutorIDNumber,
    String userid,
    String contact,
    DateTime dateregistered,
    String age,
    String dateofbirth,
    String timezone,
    String applicationID,
    List<SubjectTeach> mycourses,
    String status,
  ) async {
    try {
      // Update the main student document
      await FirebaseFirestore.instance.collection('tutor').doc(uid).set({
        "language": language,
        "timezone": timezone,
        "certificates": "",
        "country": country,
        "dateSign": dateregistered,
        "birthdate": dateofbirth,
        "age": age,
        "extensionName": "",
        "firstName": name,
        // "imageID": profileurl,
        "lastName": lastname,
        "middleName": middlename,
        "applicationID": applicationID,
        // "presentation": presentationlink,
        // "promotionalMessage": promotionalMessage,
        // "resume": resumelink,
        "tutorID": tutorIDNumber,
        "userID": userid,
        "withdrawal": "",
      }, SetOptions(merge: true));

      // Get a reference to the "mycourses" subcollection
      final coursesCollectionRef = FirebaseFirestore.instance
          .collection('tutor')
          .doc(uid)
          .collection('mycourses');

      // Clear the existing documents in the subcollection
      await coursesCollectionRef.get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      // Add all the new SubjectTeach objects to the subcollection
      for (int i = 0; i < mycourses.length; i++) {
        await coursesCollectionRef.add({
          "subjectname": mycourses[i].subjectname,
          "price2": mycourses[i].price2,
          "price3": mycourses[i].price3,
          "price5": mycourses[i].price5,
        });
      }
      updateUserStatus(uid, status);
    } catch (error) {
      html.window.alert('Update Failed: $error');
    }
  }


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
Future<void> updatetutorprofile(
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
