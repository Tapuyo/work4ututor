// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// import '../data_class/classesdataclass.dart';
// import '../data_class/studentinfoclass.dart';
// import '../data_class/tutor_info_class.dart';

// class EnrolledClass {
//   final String uid;
//   final String role;

//   EnrolledClass({required this.uid, required this.role});

//   Future<List<ClassesData>> _getStudentsInfo(
//       QuerySnapshot<Object?> snapshot) async {
//     List<ClassesData> studentInfoList = [];
//     for (var doc in snapshot.docs) {
//       var classesData = await _createClassesDataFromDocument(
//           doc); // Wait for the data to be fetched

//       // Check if the uid matches the studentID or tutorID
//       if (classesData.studentID == uid || classesData.tutorID == uid) {
//         studentInfoList.add(classesData);
//       }
//     }

//     return studentInfoList;
//   }

//   Future<ClassesData> _createClassesDataFromDocument(
//       DocumentSnapshot<Object?> snapshot) async {
//     var data = snapshot.data() as Map<String, dynamic>;
//     var subcollectionNames = ['materials', 'schedule', 'score'];

//     List<ClassesMaterials> finalmaterials = [];
//     List<Schedule> finalschedule = [];
//     List<Score> finalscore = [];
//     List<StudentInfoClass> studentinfo = [];
//     List<TutorInformation> tutorinfo = [];
//     List<SubjectClass> subjectinfo = [];

//     await FirebaseFirestore.instance
//         .collection('students')
//         .doc(uid)
//         .get()
//         .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
//       var data = querySnapshot.data() as Map<String, dynamic>;

//       StudentInfoClass tempinfo = StudentInfoClass(
//         languages: (data['language'] as List<dynamic>).cast<String>(),
//         address: data['address'] ?? '',
//         country: data['country'] ?? '',
//         studentFirstname: data['studentFirstName'] ?? '',
//         studentMiddlename: data['studentMiddleName'] ?? '',
//         studentLastname: data['studentLastName'] ?? '',
//         studentID: data['studentID'] ?? '',
//         userID: data['userID'] ?? '',
//         contact: data['contact'] ?? '',
//         emailadd: data['emailadd'] ?? '',
//         profilelink: data['profileurl'] ?? '',
//       );
//       studentinfo.add(tempinfo);
//       debugPrint('Student Fetching ${(studentinfo.length)}');
//     }).catchError((error) {
//       debugPrint('Student Fetching $error');
//     });

//     await FirebaseFirestore.instance
//         .collection('tutor')
//         .doc(data['tutorID'])
//         .get()
//         .then((DocumentSnapshot<Map<String, dynamic>> tutorsnapshot) {
//       var tutordata = tutorsnapshot.data();

//       if (tutordata != null) {
//         TutorInformation temptutorinfo = TutorInformation(
//           birthPlace: tutordata['birthPlace'] ?? '',
//           country: tutordata['country'] ?? '',
//           certificates:
//               (tutordata['certificates'] as List<dynamic>).cast<String>(),
//           resume: tutordata['resume'] ?? '',
//           promotionalMessage: tutordata['promotionalMessage'] ?? '',
//           withdrawal: tutordata['withdrawal'] ?? '',
//           status: tutordata['status'] ?? '',
//           extensionName: tutordata['extensionName'] ?? '',
//           dateSign: tutordata['dateSign']?.toDate() ?? '',
//           firstName: tutordata['firstName'] ?? '',
//           imageID: tutordata['imageID'] ?? '',
//           language: (tutordata['language'] as List<dynamic>).cast<String>(),
//           lastname: tutordata['lastName'] ?? '',
//           middleName: tutordata['middleName'] ?? '',
//           presentation: tutordata['presentation'] ?? '',
//           tutorID: tutordata['tutorID'] ?? '',
//           userId: tutordata['userID'] ?? '',
//         );
//         tutorinfo.add(temptutorinfo);
//       }
//       debugPrint('Tutor Fetching ${(tutorinfo.length)}');
//     }).catchError((error) {
//       debugPrint('Tutor Fetching $error');
//     });

//     await FirebaseFirestore.instance
//         .collection('subjects')
//         .where('subjectId', isEqualTo: data['subjectID'])
//         .get()
//         .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
//       for (var documentSnapshot in querySnapshot.docs) {
//         var data = documentSnapshot.data();

//         SubjectClass tempsubjectinfo = SubjectClass(
//           docID: documentSnapshot.id,
//           subjectID: data['subjectId'] ?? '',
//           subjectName: data['subjectName'] ?? '',
//           subjectimage: data['image'] ?? '',
//           description: data['subjectDescription'] ?? '',
//           tutorID: data['tutorId'] ?? '',
//           datecreated: data['datetime'].toDate() ?? '',
//         );
//         subjectinfo.add(tempsubjectinfo);
//       }
//       debugPrint('Subject Fetching ${(subjectinfo.length)}');
//     }).catchError((error) {
//       debugPrint('Subject Fetching $error');
//     });

//     for (var subcollectionName in subcollectionNames) {
//       var subcollection = snapshot.reference.collection(subcollectionName);
//       subcollection.get().then((subcollectionSnapshot) {
//         for (var subdoc in subcollectionSnapshot.docs) {
//           if (subcollectionName == 'materials') {
//             var subdata = subdoc.data();
//             String session = subdata['session'] ?? '';
//             List<String> materials =
//                 (subdata['material'] as List<dynamic>).cast<String>();
//             ClassesMaterials tempmaterials = ClassesMaterials(
//               materialID: subdoc.id,
//               session: session,
//               materials: materials,
//             );
//             finalmaterials.add(tempmaterials);
//           } else if (subcollectionName == 'schedule') {
//             var subdata = subdoc.data();
//             String session = subdata['session'] ?? '';
//             DateTime schedule = subdata['schedule'].toDate() ?? '';
//             Schedule tempschedule = Schedule(
//               scheduleID: subdoc.id,
//               session: session,
//               schedule: schedule,
//             );
//             finalschedule.add(tempschedule);
//           } else if (subcollectionName == 'score') {
//             var subdata = subdoc.data();
//             String score = subdata['score'] ?? '';
//             String comment = subdata['comment'] ?? '';
//             Score tempscore = Score(
//               scoreID: subdoc.id,
//               score: score,
//               comment: comment,
//             );
//             finalscore.add(tempscore);
//           }
//         }
//       });
//     }
//     return ClassesData(
//       classid: snapshot.id,
//       subjectID: data['subjectID'] ?? '',
//       tutorID: data['tutorID'] ?? '',
//       studentID: data['studentID'] ?? '',
//       materials: finalmaterials,
//       schedule: finalschedule,
//       score: finalscore,
//       status: data['status'] ?? '',
//       totalClasses: data['totalClasses'] ?? '',
//       completedClasses: data['completedClasses'] ?? '',
//       pendingClasses: data['pendingClasses'] ?? '',
//       dateEnrolled: data['dateEnrolled'].toDate() ?? '',
//       studentinfo: studentinfo,
//       tutorinfo: tutorinfo,
//       subjectinfo: subjectinfo,
//     );
//   }

//   Stream<List<ClassesData>> get getenrolled {
//     CollectionReference classesCollection =
//         FirebaseFirestore.instance.collection('classes');
//     Query query;

//     if (role == 'student') {
//       query = classesCollection.where('studentID', isEqualTo: uid);
//     } else if (role == 'tutor') {
//       query = classesCollection.where('tutorID', isEqualTo: uid);
//     } else {
//       query = classesCollection; // Set a default query if needed
//     }

//     return query.snapshots().asyncMap(
//         _getStudentsInfo); // Use asyncMap to await the asynchronous function
//   }
// }

// ignore_for_file: unused_element

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_class/classesdataclass.dart';
import '../data_class/studentinfoclass.dart';
import '../data_class/tutor_info_class.dart';
import '../provider/schedulenotifier.dart';

class ScheduleEnrolledClass {
  final String uid;
  final String role;

  ScheduleEnrolledClass({required this.uid, required this.role});

  Stream<List<Schedule>> get getenrolled {
    return FirebaseFirestore.instance
        .collection('schedule')
        .snapshots()
        .map(_createClassesDataFromDocument);
  }

  List<Schedule> _createClassesDataFromDocument(QuerySnapshot snapshot) {
    return snapshot.docs.map((subdata) {
      String session = subdata['session'] ?? '';
      String scheduleID = subdata['scheduleID'] ?? '';
      String timefrom = subdata['timefrom'] ?? '';
      String timeto = subdata['timeto'] ?? '';
      DateTime schedule = subdata['schedule'].toDate() ?? DateTime.now();
      String classstatus = subdata['classstatus'] ?? '';
      String meetinglink = subdata['meetinglink'] ?? '';
      return Schedule(
        scheduleID: scheduleID,
        session: session,
        schedule: schedule,
        timefrom: timefrom,
        timeto: timeto,
        classstatus: classstatus,
        meetinglink: meetinglink,
      );
    }).toList();
  }
}

class ScheduleEnrolledClassData {
  final String uid;
  final String role;
  final BuildContext context;

  ScheduleEnrolledClassData(
      {required this.context, required this.uid, required this.role});

  StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<ScheduleData>>
      _transformer() {
    return StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
        List<ScheduleData>>.fromHandlers(
      handleData: (QuerySnapshot<Map<String, dynamic>> snapshot,
          EventSink<List<ScheduleData>> sink) async {
        List<ScheduleData> studentInfoList = [];
        for (var doc in snapshot.docs) {
          var classesData = await _createClassesDataFromDocument(doc);
          studentInfoList.addAll(classesData);
        }
        sink.add(studentInfoList);
      },
    );
  }

  List<ScheduleData> _createClassesDataFromDocument(
      DocumentSnapshot<Object?> snapshot) {
    var streamController = StreamController<List<ScheduleData>>();

    var data = snapshot.data() as Map<String, dynamic>;
    var subcollectionNames = ['materials', 'schedule', 'score'];

    List<ClassesMaterials> finalmaterials = [];
    List<Schedule> finalschedule = [];
    List<Score> finalscore = [];
    List<StudentInfoClass> studentinfo = [];
    List<TutorInformation> tutorinfo = [];
    List<SubjectClass> subjectinfo = [];

    FirebaseFirestore.instance
        .collection('students')
        .doc(data['studentID'])
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
      var data = querySnapshot.data() as Map<String, dynamic>;

      StudentInfoClass tempinfo = StudentInfoClass(
        languages: (data['language'] as List<dynamic>).cast<String>(),
        address: data['address'] ?? '',
        country: data['country'] ?? '',
        studentFirstname: data['studentFirstName'] ?? '',
        studentMiddlename: data['studentMiddleName'] ?? '',
        studentLastname: data['studentLastName'] ?? '',
        studentID: data['studentID'] ?? '',
        userID: data['userID'] ?? '',
        contact: data['contact'] ?? '',
        emailadd: data['emailadd'] ?? '',
        profilelink: data['profileurl'] ?? '',
        dateregistered: data['dateregistered'].toDate() ?? '',
        age: data['age'] ?? '',
        dateofbirth: data['dateofbirth'] ?? '',
        timezone: data['timezone'] ?? '',
      );
      studentinfo.add(tempinfo);
      debugPrint('Student Fetching ${(studentinfo.length)}');
    }).catchError((error) {
      debugPrint('Student Fetching $error');
    });

    FirebaseFirestore.instance
        .collection('tutor')
        .doc(data['tutorID'])
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> tutorsnapshot) {
      var tutordata = tutorsnapshot.data();

      if (tutordata != null) {
        TutorInformation temptutorinfo = TutorInformation(
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
          presentation: tutordata['presentation'] ?? '',
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
          contact: tutordata['contact'] ?? '',
          certificatestype:
              (tutordata['certificatestype'] as List<dynamic>).cast<String>(),
          resumelinktype:
              (tutordata['resumetype'] as List<dynamic>).cast<String>(),
          validIDstype:
              (tutordata['validIDstype'] as List<dynamic>).cast<String>(),
        );
        tutorinfo.add(temptutorinfo);
      }
      debugPrint('Tutor Fetching ${(tutorinfo.length)}');
    }).catchError((error) {
      debugPrint('Tutor Fetching $error');
    });

    FirebaseFirestore.instance
        .collection('subjects')
        .where('subjectid', isEqualTo: data['subjectID'])
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      for (var documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data();

        SubjectClass tempsubjectinfo = SubjectClass(
          docID: documentSnapshot.id,
          subjectID: data['subjectid'] ?? '',
          subjectName: data['subjectName'] ?? '',
          datecreated: data['datetime'].toDate() ?? '',
          subjectStatus: data['subjectStatus'] ?? '',
          totaltutors: data['totaltutors'] ?? '',
        );
        subjectinfo.add(tempsubjectinfo);
      }
      debugPrint('Subject Fetching ${(subjectinfo.length)}');
    }).catchError((error) {
      debugPrint('Subject Fetching $error');
    });

    FirebaseFirestore.instance
        .collection('schedule')
        .where('scheduleID', isEqualTo: snapshot.id)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      for (var documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data();

        String session = data['session'] ?? '';
        DateTime schedule = data['schedule'].toDate() ?? DateTime.now();
        Schedule tempschedinfo = Schedule(
          scheduleID: data['scheduleID'] ?? '',
          session: session,
          schedule: schedule,
          timefrom: data['timefrom'] ?? '',
          timeto: data['timeto'] ?? '',
          classstatus:  data['classstatus'] ?? '',
          meetinglink:  data['meetinglink'] ?? '',
        );
        finalschedule.add(tempschedinfo);
      }
      debugPrint('Schedule Fetching ${(finalschedule.length)}');
    }).catchError((error) {
      debugPrint('Subject Fetching $error');
    });
    List<ClassesData> enrolledClasses = [];
    enrolledClasses.add(ClassesData(
      classid: snapshot.id,
      subjectID: data['subjectID'] ?? '',
      tutorID: data['tutorID'] ?? '',
      studentID: data['studentID'] ?? '',
      materials: finalmaterials,
      schedule: finalschedule,
      score: finalscore,
      status: data['status'] ?? '',
      totalClasses: data['totalClasses'] ?? '',
      completedClasses: data['completedClasses'] ?? '',
      pendingClasses: data['pendingClasses'] ?? '',
      dateEnrolled: data['dateEnrolled'].toDate() ?? '',
      studentinfo: studentinfo,
      tutorinfo: tutorinfo,
      subjectinfo: subjectinfo,
    ));
    List<ScheduleData> schedule = [];

    for (var classesData in enrolledClasses) {
      List<Schedule> scheduleDataList = classesData.schedule;
      for (var scheduleItem in scheduleDataList) {
        String studentID = classesData.studentID;
        String tutorID = classesData.tutorID;
        String classID = classesData.classid;
        String scheduleID = scheduleItem.scheduleID;
        String session = scheduleItem.session;
        DateTime scheduleDateTime = scheduleItem.schedule;
        String timefrom = scheduleItem.timefrom;
        String timeto = scheduleItem.timeto;
        ScheduleData tempsched = ScheduleData(
            studentID: studentID,
            tutorID: tutorID,
            classID: classID,
            scheduleID: scheduleID,
            tutorinfo: classesData.tutorinfo.first,
            studentinfo: classesData.studentinfo.first,
            subjectinfo: classesData.subjectinfo.first,
            session: session,
            scheduledate: scheduleDateTime,
            timefrom: timefrom,
            timeto: timeto,
            type: 'class');
        schedule.add(tempsched);
      }
    }
    return schedule;
  }

  void updateScheduleList(BuildContext context, List<ScheduleData> newList) {
    Provider.of<ScheduleListNotifier>(context, listen: false)
        .setScheduleList(newList);
  }

  Stream<List<ScheduleData>> get getenrolled {
    CollectionReference classesCollection =
        FirebaseFirestore.instance.collection('classes');
    Query query;

    if (role == 'student') {
      query = classesCollection.where('studentID', isEqualTo: uid);
    } else if (role == 'tutor') {
      query = classesCollection.where('tutorID', isEqualTo: uid);
    } else {
      query = classesCollection;
    }

    return query.snapshots().transform(_transformer());
  }
}
