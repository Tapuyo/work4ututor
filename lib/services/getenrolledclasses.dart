import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work4ututor/services/timefromtimestamp.dart';
import 'package:work4ututor/services/timestampconverter.dart';

import '../data_class/classesdataclass.dart';
import '../data_class/studentinfoclass.dart';
import '../data_class/tutor_info_class.dart';

class EnrolledClass {
  final String uid;
  final String role;
  final String targetTimezone;

  EnrolledClass(
      {required this.uid, required this.role, required this.targetTimezone});

  StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<ClassesData>>
      _transformer() {
    return StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
        List<ClassesData>>.fromHandlers(
      handleData: (QuerySnapshot<Map<String, dynamic>> snapshot,
          EventSink<List<ClassesData>> sink) async {
        List<ClassesData> studentInfoList = [];
        for (var doc in snapshot.docs) {
          var classesData = await _createClassesDataFromDocument(doc);
          studentInfoList.add(classesData);
        }
        sink.add(studentInfoList);
      },
    );
  }

  Future<List<ClassesData>> _getStudentsInfo(
      QuerySnapshot<Object?> snapshot) async {
    List<ClassesData> studentInfoList = [];
    for (var doc in snapshot.docs) {
      var classesData = await _createClassesDataFromDocument(doc);
      studentInfoList.add(classesData);
    }

    return studentInfoList;
  }

  Future<ClassesData> _createClassesDataFromDocument(
      DocumentSnapshot<Object?> snapshot) async {
    var data = snapshot.data() as Map<String, dynamic>;

    List<ClassesMaterials> finalmaterials = [];
    List<Schedule> finalschedule = [];
    List<Score> finalscore = [];
    List<StudentInfoClass> studentinfo = [];
    List<TutorInformation> tutorinfo = [];
    List<SubjectClass> subjectinfo = [];

    await FirebaseFirestore.instance
        .collection('students')
        .doc(data['studentID'])
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
      var data = querySnapshot.data() as Map<String, dynamic>;

      StudentInfoClass tempinfo = StudentInfoClass(
        languages: (data['language'] as List<dynamic>).cast<String>(),
        citizenship: (data['citizenship'] as List<dynamic>).cast<String>(),
        gender: data['gender'] ?? '',
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
        dateregistered: (data['dateregistered'] as Timestamp).toDate(),
        age: data['age'] ?? '',
        dateofbirth: data['dateofbirth'] ?? '',
        timezone: data['timezone'] ?? '',
      );
      studentinfo.add(tempinfo);
    }).catchError((error) {
      debugPrint('Student Fetching $error');
    });

    await FirebaseFirestore.instance
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
          dateSign: (tutordata['dateSign'] as Timestamp).toDate(),
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
          birthdate: (tutordata['birthdate'] as Timestamp).toDate(),
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
          citizenship:
              (tutordata['citizenship'] as List<dynamic>).cast<String>(),
          gender: tutordata['gender'] ?? '',
        );
        tutorinfo.add(temptutorinfo);
      }
    }).catchError((error) {
      debugPrint('Tutor Fetching $error');
    });

    await FirebaseFirestore.instance
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
    }).catchError((error) {
      debugPrint('Subject Fetching $error');
    });

    await FirebaseFirestore.instance
        .collection('schedule')
        .where('scheduleID', isEqualTo: snapshot.id)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      for (var documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data();

        String session = data['session'] ?? '';
        // DateTime schedule = data['schedule'].toDate() ?? DateTime.now();
        DateTime schedule = formatTimewDatewZone(
            DateFormat('MMMM d, yyyy h:mm a')
                .format(DateTime.parse(data['schedule']).toLocal()),
            targetTimezone);
        String timefrom = updateTime(targetTimezone, data['timefrom']);
        String timeto = updateTime(targetTimezone, data['timeto']);

        Schedule tempschedinfo = Schedule(
          scheduleID: data['scheduleID'] ?? '',
          session: session,
          schedule: schedule,
          timefrom: timefrom,
          timeto: timeto,
          classstatus: data['classstatus'] ?? '',
          meetinglink: data['meetinglink'] ?? '',
          rating: data['rating'] ?? '',
          studentStatus: data['studentStatus'] ?? '',
          tutorStatus: data['tutorStatus'] ?? '',
        );
        finalschedule.add(tempschedinfo);
      }
    }).catchError((error) {
      debugPrint('Subject Fetching $error');
    });

    return ClassesData(
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
      price: data['totalPrice'] ?? 0,
    );
  }

  Stream<List<ClassesData>> get getenrolled {
    CollectionReference classesCollection =
        FirebaseFirestore.instance.collection('classes');
    Query query;

    if (role == 'student') {
      query = classesCollection.where('studentID', isEqualTo: uid);
    } else if (role == 'tutor') {
      query = classesCollection.where('tutorID', isEqualTo: uid);
    } else {
      query = classesCollection; // Set a default query if needed
    }

    return query.snapshots().transform(_transformer());
  }
}

class EnrolledClassFuture {
  final String uid;
  final String role;
  final String targetTimezone;

  EnrolledClassFuture(
      {required this.uid, required this.role, required this.targetTimezone});

  Future<List<ClassesData>> _getStudentsInfo(
      QuerySnapshot<Object?> snapshot) async {
    List<ClassesData> studentInfoList = [];
    for (var doc in snapshot.docs) {
      var classesData = await _createClassesDataFromDocument(doc);
      studentInfoList.add(classesData!);
    }

    return studentInfoList;
  }

  Future<ClassesData?> _createClassesDataFromDocument(
      DocumentSnapshot<Object?> snapshot) async {
    try {
      var data = snapshot.data() as Map<String, dynamic>;
      var subcollectionNames = ['materials', 'schedule', 'score'];

      List<ClassesMaterials> finalmaterials = [];
      List<Schedule> finalschedule = [];
      List<Score> finalscore = [];
      List<StudentInfoClass> studentinfo = [];
      List<TutorInformation> tutorinfo = [];
      List<SubjectClass> subjectinfo = [];

      await _fetchStudentInfo(data['studentID'], studentinfo);
      await _fetchTutorInfo(data['tutorID'], tutorinfo);
      await _fetchSubjectInfo(data['subjectID'], subjectinfo);
      await _fetchScheduleInfo(snapshot.id, finalschedule);

      return ClassesData(
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
        price: data['totalPrice'] ?? 0,
      );
    } catch (error) {
      // Handle errors as needed
      print('Error creating ClassesData: $error');
      return null;
    }
  }

  Future<void> _fetchStudentInfo(
      String studentId, List<StudentInfoClass> studentinfo) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();
      var data = querySnapshot.data() as Map<String, dynamic>;

      StudentInfoClass tempinfo = StudentInfoClass(
        languages: (data['language'] as List<dynamic>).cast<String>(),
        citizenship: (data['citizenship'] as List<dynamic>).cast<String>(),
        gender: data['gender'] ?? '',
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
        dateregistered: (data['dateregistered'] as Timestamp).toDate(),
        age: data['age'] ?? '',
        dateofbirth: data['dateofbirth'] ?? '',
        timezone: data['timezone'] ?? '',
      );
      studentinfo.add(tempinfo);
    } catch (error) {
      // Handle errors as needed
      debugPrint('Student Fetching $error');
    }
  }

  Future<void> _fetchTutorInfo(
      String tutorId, List<TutorInformation> tutorinfo) async {
    try {
      var tutorsnapshot = await FirebaseFirestore.instance
          .collection('tutor')
          .doc(tutorId)
          .get();
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
          dateSign: (tutordata['dateSign'] as Timestamp).toDate(),
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
          birthdate: (tutordata['birthdate'] as Timestamp).toDate(),
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
          citizenship:
              (tutordata['citizenship'] as List<dynamic>).cast<String>(),
          gender: tutordata['gender'] ?? '',
        );
        tutorinfo.add(temptutorinfo);
      }
    } catch (error) {
      // Handle errors as needed
      debugPrint('Tutor Fetching $error');
    }
  }

  Future<void> _fetchSubjectInfo(
      String subjectId, List<SubjectClass> subjectinfo) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .where('subjectid', isEqualTo: subjectId)
          .get();

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
    } catch (error) {
      // Handle errors as needed
      debugPrint('Subject Fetching $error');
    }
  }

  Future<void> _fetchScheduleInfo(
      String scheduleId, List<Schedule> finalschedule) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('schedule')
          .where('scheduleID', isEqualTo: scheduleId)
          .get();

      for (var documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data();

        String session = data['session'] ?? '';
        // DateTime schedule = data['schedule'].toDate() ?? DateTime.now();
        DateTime schedule = formatTimewDatewZone(
            DateFormat('MMMM d, yyyy h:mm a')
                .format(DateTime.parse(data['schedule']).toLocal()),
            targetTimezone);
        String timefrom = updateTime(targetTimezone, data['timefrom']);
        String timeto = updateTime(targetTimezone, data['timeto']);
        Schedule tempschedinfo = Schedule(
          scheduleID: data['scheduleID'] ?? '',
          session: session,
          schedule: schedule,
          timefrom: timefrom,
          timeto: timeto,
          classstatus: data['classstatus'] ?? '',
          meetinglink: data['meetinglink'] ?? '',
          rating: data['rating'] ?? '',
          studentStatus: data['studentStatus'] ?? '',
          tutorStatus: data['tutorStatus'] ?? '',
        );
        finalschedule.add(tempschedinfo);
      }
    } catch (error) {
      // Handle errors as needed
      debugPrint('Subject Fetching $error');
    }
  }

  Future<List<ClassesData>> getenrolled() async {
    CollectionReference classesCollection =
        FirebaseFirestore.instance.collection('classes');
    Query query;

    if (role == 'student') {
      query = classesCollection.where('studentID', isEqualTo: uid);
    } else if (role == 'tutor') {
      query = classesCollection.where('tutorID', isEqualTo: uid);
    } else {
      query = classesCollection; // Set a default query if needed
    }

    try {
      var snapshot = await query.get();
      var data = await _getStudentsInfo(snapshot);
      return data;
    } catch (error) {
      // Handle errors as needed
      return [];
    }
  }
}
