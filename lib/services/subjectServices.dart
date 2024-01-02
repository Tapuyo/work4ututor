// ignore_for_file: file_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import '../data_class/subject_class.dart';

class SubjectServices {
  final CollectionReference subjectcollection =
      FirebaseFirestore.instance.collection('subjects');

  List<Subjects> _subject(QuerySnapshot snapshot) {
    return snapshot.docs.map((subjectData) {
      String subjectIdx, subjectNamex, tutorIdx, dateTimex, imagex;
      subjectIdx = subjectData['subjectid'] ?? '';
      subjectNamex = subjectData['subjectName'] ?? '';
      tutorIdx = subjectData['totaltutors'] ?? '';
      dateTimex = subjectData['datetime'].toString();
      imagex = subjectData['subjectStatus'] ?? '';
      return Subjects(
        subjectId: subjectIdx,
        subjectName: subjectNamex,
        totalTutors: tutorIdx,
        dateTime: '',
        subjectStatus: imagex,
      );
    }).toList();
  }

  Stream<List<Subjects>> get subjectList {
    return subjectcollection.snapshots().map(_subject);
  }
}
