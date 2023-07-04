// import 'package:flutter/material.dart';
// import 'package:popover/popover.dart';

// class PopoverExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Popover Example')),
//         body: const SafeArea(
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Button(),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Button extends StatefulWidget {
//   const Button({Key? key}) : super(key: key);

//   @override
//   State<Button> createState() => _ButtonState();
// }

// class _ButtonState extends State<Button> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//       ),
//       child: TextFormField(
//         style: const TextStyle(),
//         onTap: () {
//           showPopover(
//             context: context,
//             bodyBuilder: (context) => const ListItems(),
//             onPop: () => print('Popover was popped!'),
//             direction: PopoverDirection.left,
//             width: 200,
//             height: 400,
//             arrowHeight: 15,
//             arrowWidth: 30,
//           );
//         },
//         decoration: const InputDecoration(hintText: "Search Client"),
//       ),
//     );
//   }
// }

// class ListItems extends StatelessWidget {
//   const ListItems({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scrollbar(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: ListView(
//           padding: const EdgeInsets.all(8),
//           children: [
//             TextFormField(
//               decoration: const InputDecoration(hintText: "search"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


//sample for getenrolled

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import '../data_class/classesdataclass.dart';
// import '../data_class/studentinfoclass.dart';
// import '../data_class/tutor_info_class.dart';

// class EnrolledClass {
//   final String uid;
//   final String role;

//   EnrolledClass({required this.uid, required this.role});

//   List<ClassesData> _getStudentsInfo(QuerySnapshot<Object?> snapshot) {
//     List<ClassesData> studentInfoList = [];
//     for (var doc in snapshot.docs) {
//       var classesData = _createClassesDataFromDocument(doc);

//       // Check if the uid matches the studentID or tutorID
//       if (classesData.studentID == uid || classesData.tutorID == uid) {
//         studentInfoList.add(classesData);
//       }
//     }

//     return studentInfoList;
//   }

//   ClassesData _createClassesDataFromDocument(
//       DocumentSnapshot<Object?> snapshot) {
//     var data = snapshot.data() as Map<String, dynamic>;
//     var subcollectionNames = ['materials', 'schedule', 'score'];

//     List<ClassesMaterials> finalmaterials = [];
//     List<Schedule> finalschedule = [];
//     List<Score> finalscore = [];
//     List<StudentInfoClass> studentinfo = [];
//     List<TutorInformation> tutorinfo = [];
//     List<SubjectClass> subjectinfo = [];

//     FirebaseFirestore.instance
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

//     FirebaseFirestore.instance
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

//     FirebaseFirestore.instance
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
//             String schedule = subdata['schedule'] ?? '';
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

//     return query.snapshots().map(_getStudentsInfo);
//   }
// }