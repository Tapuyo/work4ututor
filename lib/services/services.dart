// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import '../data_class/studentsEnrolledclass.dart';
import '../data_class/subject_teach_pricing.dart';
import '../data_class/tutor_info_class.dart';

Future<String?> uploadData(String uid) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    Uint8List? file = result.files.first.bytes;
    String filename = result.files.first.name;

    UploadTask task = FirebaseStorage.instance
        .ref()
        .child("students/$filename")
        .putData(file!);

    // Wait for the upload task to complete
    await task;

    // Generate and return the download URL
    String downloadURL = await task.snapshot.ref.getDownloadURL();
    return downloadURL;
  } else {
    return null; // Return null in case of an error
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
      .add({'firstName': tEmail, 'lastName': tPassword, 'userID': 'Student'});
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
      FirebaseFirestore.instance.collection('students');
  final CollectionReference enrolleeCollection =
      FirebaseFirestore.instance.collection('studentsEnrolled');

  List<TutorInformation> _getTutorInformation(QuerySnapshot snapshot) {
    return snapshot.docs.map((tutordata) {
      return TutorInformation(
        contact: tutordata['contact'] ?? '',
        birthPlace: tutordata['birthPlace'] ?? '',
        country: tutordata['country'] ?? '',
        certificates:
            (tutordata['certificates'] as List<dynamic>).cast<String>(),
        resume: tutordata['resume'] ?? '',
        promotionalMessage: tutordata['promotionalMessage'] ?? '',
        withdrawal: tutordata['withdrawal'] ?? '',
        status: tutordata['status'] ?? '',
        extensionName: tutordata['extensionName'] ?? '',
        dateSign: tutordata['dateSign']?.toDate() ?? '',
        firstName: tutordata['firstName'] ?? '',
        imageID: tutordata['imageID'] ?? '',
        language: (tutordata['language'] as List<dynamic>).cast<String>(),
        lastname: tutordata['lastName'] ?? '',
        middleName: tutordata['middleName'] ?? '',
        presentation:
            (tutordata['presentation'] as List<dynamic>).cast<String>(),
        tutorID: tutordata['tutorID'] ?? '',
        userId: tutordata['userID'] ?? '',
        age: tutordata['age'] ?? '',
        applicationID: tutordata['applicationID'] ?? '',
        birthCity: tutordata['birthCity'] ?? '',
        birthdate: tutordata['birthdate'] ?? '',
        emailadd: tutordata['emailadd'] ?? '',
        city: tutordata['city'] ?? '',
        servicesprovided:
            (tutordata['servicesprovided'] as List<dynamic>).cast<String>(),
        timezone: tutordata['timezone'] ?? '',
        validIds: (tutordata['validIDs'] as List<dynamic>).cast<String>(),
        certificatestype:
            (tutordata['certificatestype'] as List<dynamic>).cast<String>(),
        resumelinktype:
            (tutordata['resumetype'] as List<dynamic>).cast<String>(),
        validIDstype:
            (tutordata['validIDstype'] as List<dynamic>).cast<String>(),
      );
    }).toList();
  }

  Stream<List<TutorInformation>> get tutorlist {
    return tutorCollection.snapshots().map(_getTutorInformation);
  }

  List<StudentsList> _getStudentsEnrolled(QuerySnapshot snapshot) {
    return snapshot.docs.map((enrolleedata) {
      return StudentsList(
        address: enrolleedata['address'] ?? '',
        dateEnrolled: enrolleedata['dateEnrolled'] ?? '',
        numberofClasses: enrolleedata['numberofClasses'] ?? '',
        price: enrolleedata['price'] ?? '',
        status: enrolleedata['status'] ?? '',
        studentID: enrolleedata['studentID'] ?? '',
        studentName: enrolleedata['studentName'] ?? '',
        subjectName: enrolleedata['subjectName'] ?? '',
      );
    }).toList();
  }

  Stream<List<StudentsList>> get enrolleelist {
    return enrolleeCollection
        .doc('YnLdZm2n7bPZSTbXS0VvHgG0Jor2')
        .collection('students')
        .snapshots()
        .map(_getStudentsEnrolled);
  }

  Future updateUserData(String email, String role) async {
    return await dataCollection
        .doc(uid)
        .set({'email': email, 'role': role, 'status': 'unfinished'});
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

  Future updateTutorData(
    String email,
  ) async {
    final tutorDocumentRef = tutorCollection.doc(uid);
    await tutorDocumentRef.set({
      "language": [],
      "birthPlace": "",
      "certificates": [],
      "country": "",
      "dateSign": "",
      "emailadd": email,
      "extensionName": "",
      "firstName": '',
      "imageID": "",
      "lastName": "",
      "middleName": "",
      "presentation": "",
      "promotionalMessage": "",
      "resume": "",
      "status": "unsubscribe",
      "tutorID": "",
      "userID": uid,
      "withdrawal": "",
    });
  }

  Future updateStudentData(String email) async {
    // Reference to the student document
    final studentDocumentRef = studentCollection.doc(uid);

    // Set the initial data for the document
    await studentDocumentRef.set({
      "userID": uid,
      "studentMiddleName": '',
      "studentLastName": "",
      "studentID": "",
      "studentFirstName": "",
      "profileurl": "",
      "language": [],
      "emailadd": email,
      "dateregistered": DateTime.now(),
      "dateofbirth": '',
      "country": "",
      "contact": "",
      "age": "",
      "address": "",
      "timezone": "",
    });

    // Create the "enrolledclasses" collection
    await studentDocumentRef.collection("enrolledclasses").add({
      // Add data specific to the "enrolledclasses" collection
      // Example: {"className": "Math 101", "instructor": "John Doe"}
    });

    // Create the "guardianname" collection
    await studentDocumentRef.collection("guardianname").add({
      // Add data specific to the "guardianname" collection
      // Example: {"guardianName": "Alice Smith", "relationship": "Parent"}
    });

    // Create the "myconversation" collection
    await studentDocumentRef.collection("myconversation").add({
      // Add data specific to the "myconversation" collection
      // Example: {"message": "Hello, world!", "timestamp": Timestamp.now()}
    });
  }

  // Future updateStudentData(String email) async {
  //   return await studentCollection.doc(uid).set({
  //     "userID": uid,
  //     "studentMiddleName": '',
  //     "studentLastName": "",
  //     "studentID": "",
  //     "studentFirstName": "",
  //     "profileurl": "",
  //     "language": [],
  //     "emailadd": email,
  //     "dateregistered": DateTime.now(),
  //     "dateofbirth": '',
  //     "country": "",
  //     "contact": "",
  //     "age": "",
  //     "address": "",
  //   });
  // }

  getTutorInfo() async {
    try {
      await FirebaseFirestore.instance
          .collection('tutor')
          .where(uid, isEqualTo: uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((tutordata) {
          return tutordata['status'].toString();
        });
      });
    } catch (e) {
      return null;
    }
  }
  //Adding Schedule to database

  addTutoravailbaleDays() async {
    return await FirebaseFirestore.instance
        .collection('tutorSchedule')
        .doc(uid)
        .update({
      'availableDays': [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ],
    });
  }

  addDayoffs(List<String> dayoffs, String dayoffid) async {
    return await FirebaseFirestore.instance
        .collection('tutorSchedule')
        .doc()
        .set({'uid': dayoffid, 'dayoffs': dayoffs});
  }

  addBlockDates() async {
    return await FirebaseFirestore.instance
        .collection('tutorSchedule')
        .doc(uid)
        .collection('blockDates')
        .doc()
        .set({
      'description': 'Vaction Holiday',
      'from': DateTime.now(),
      'to': DateTime.now()
    });
  }

  addTimea() async {
    return await FirebaseFirestore.instance
        .collection('tutorSchedule')
        .doc(uid)
        .collection('blockDates')
        .doc()
        .set({
      'description': 'Vaction Holiday',
      'from': DateTime.now(),
      'to': DateTime.now()
    });
  }

  addTimeavailable() async {
    return await FirebaseFirestore.instance
        .collection('tutorSchedule')
        .doc(uid)
        .collection('timeAvailable')
        .doc()
        .set({
      'description': 'Available Days',
      'from': DateFormat('HH:MM').format(DateTime.now()),
      'to': DateFormat('HH:MM').format(DateTime.now())
    });
  }
}

class TutorInfoData {
  final String uid;
  TutorInfoData({required this.uid});

  List<TutorInformation> _getTutorInfo(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return [
      TutorInformation(
        contact: snapshot.get('contact') ?? '',
        birthPlace: snapshot.get('birthPlace') ?? '',
        country: snapshot.get('country') ?? '',
        certificates:
            (snapshot.get('certificates') as List<dynamic>).cast<String>(),
        resume: snapshot.get('resume') ?? '',
        promotionalMessage: snapshot.get('promotionalMessage') ?? '',
        withdrawal: snapshot.get('withdrawal') ?? '',
        status: snapshot.get('status') ?? '',
        extensionName: snapshot.get('extensionName') ?? '',
        dateSign: snapshot.get('dateSign')?.toDate() ?? '',
        firstName: snapshot.get('firstName') ?? '',
        imageID: snapshot.get('imageID') ?? '',
        language: (snapshot.get('language') as List<dynamic>).cast<String>(),
        lastname: snapshot.get('lastName') ?? '',
        middleName: snapshot.get('middleName') ?? '',
        presentation:
            (snapshot.get('presentation') as List<dynamic>).cast<String>(),
        tutorID: snapshot.get('tutorID') ?? '',
        userId: snapshot.get('userID') ?? '',
        age: snapshot.get('age') ?? '',
        applicationID: snapshot.get('applicationID') ?? '',
        birthCity: snapshot.get('birthCity') ?? '',
        birthdate: snapshot.get('birthdate') ?? '',
        emailadd: snapshot.get('emailadd') ?? '',
        city: snapshot.get('city') ?? '',
        servicesprovided:
            (snapshot.get('servicesprovided') as List<dynamic>).cast<String>(),
        timezone: snapshot.get('timezone') ?? '',
        validIds: (snapshot.get('validIDs') as List<dynamic>).cast<String>(),
        certificatestype:
            (snapshot.get('certificatestype') as List<dynamic>).cast<String>(),
        resumelinktype:
            (snapshot.get('resumetype') as List<dynamic>).cast<String>(),
        validIDstype:
            (snapshot.get('validIDstype') as List<dynamic>).cast<String>(),
      )
    ];
  }

  Stream<List<TutorInformation>> get gettutorinfo {
    return FirebaseFirestore.instance
        .collection('tutor')
        .doc(uid)
        .snapshots()
        .map(_getTutorInfo);
  }

  Stream<List<SubjectTeach>> get gettutorsubjects {
    return FirebaseFirestore.instance
        .collection('tutor')
        .doc(uid)
        .collection('mycourses')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> courseDoc) {
        Map<String, dynamic> courseData = courseDoc.data();
        return SubjectTeach(
          subjectid: courseDoc.id,
          subjectname: courseData['subjectname'] ?? '',
          price2: courseData['price2'] ?? '',
          price3: courseData['price3'] ?? '',
          price5: courseData['price5'] ?? '',
        );
      }).toList();
    });
  }
}
