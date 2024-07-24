// ignore_for_file: file_names, unused_local_variable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../data_class/subject_class.dart';

class SubjectServices {
  final CollectionReference subjectcollection =
      FirebaseFirestore.instance.collection('subjects');

  List<Subjects> _subject(QuerySnapshot snapshot) {
    final subjectList = snapshot.docs.map((subjectData) {
      bool status = subjectData['subjectStatus'] == 'Active';
      // Check if firstName is not empty
      if (status) {
        String subjectIdx, subjectNamex, tutorIdx, dateTimex, imagex;
        subjectIdx = subjectData['subjectid'] ?? '';
        subjectNamex = subjectData['subjectName'] ?? '';
        dateTimex = ( subjectData['datetime'] as Timestamp).toDate().toString();
        imagex = subjectData['subjectStatus'] ?? '';
        return Subjects(
          subjectId: subjectIdx,
          subjectName: subjectNamex,
          dateTime: dateTimex,
          subjectStatus: imagex,
        );
      } else {
        return null;
      }
    }).toList();
    return subjectList
        .where((tutor) => tutor != null)
        .cast<Subjects>()
        .toList();
  }

  Stream<List<Subjects>> get subjectList {
    return subjectcollection.snapshots().map(_subject);
  }

  Future<int> getSubjectCount() async {
    QuerySnapshot querySnapshot = await subjectcollection.get();
    return querySnapshot.docs.length;
  }

  String generateRandomString(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  Future<String> addSubject({
    required String subjectName,
    required String totalTutors,
    required String dateTime,
    required String subjectStatus,
  }) async {
    try {
      int count = await getSubjectCount();
      String randomString =
          generateRandomString(5); // Length of the random part
      String subjectId = '$randomString${count + 1}';

      await subjectcollection.add({
        'subjectid': subjectId,
        'subjectName': subjectName,
        'totaltutors': totalTutors,
        'datetime': dateTime,
        'subjectStatus': subjectStatus,
      });
      return "Subject added successfully with ID $subjectId";
    } catch (e) {
      return "Failed to add subject: $e";
    }
  }
}
