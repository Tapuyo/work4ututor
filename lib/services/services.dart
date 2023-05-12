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

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  //collection reference
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference tutorCollection =
      FirebaseFirestore.instance.collection('tutor');
  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('student');
  final CollectionReference enrolleeCollection =
      FirebaseFirestore.instance.collection('studentsEnrolled');

  List<TutorInformation> _getTutorInformation(QuerySnapshot snapshot) {
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

  //
//   Stream<List<TutorInformation>> getListUserCampaigns() async* {
// final collection = FirebaseFirestore.instance.collection('student');
// final List list_of_users = await collection.get().then((value) => value.docs);
// for (int i = 0; i < list_of_users.length; i++) {
//   FirebaseFirestore.instance.collection("UserData")
//       .doc(list_of_users[i].id.toString())
//       .collection("studentsEnrolled")
//       .snapshots()
//       .listen(CreateListofAllUserCampaigns);
// }
// yield UserCampaignList;
//   }

  Stream<List<StudentsList>> get enrolleelist {
    return enrolleeCollection
        .doc('YnLdZm2n7bPZSTbXS0VvHgG0Jor2')
        .collection('students')
        .snapshots()
        .map(_getStudentsEnrolled);
  }

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

  addDayoffs() async {
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
