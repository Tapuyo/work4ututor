import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wokr4ututor/data_class/subject_class.dart';

class SubjectServices {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('subjects');

  List<Subjects> _subject(QuerySnapshot snapshot) {
    return snapshot.docs.map((subjectData) {
      return Subjects(
          subjectDescription: subjectData['subjectDescription'] ?? '',
          subjectId: subjectData['subjectId'] ?? '',
          subjectName: subjectData['subjectName'] ?? '',
          tutorId: subjectData['tutorId'] ?? '',
          dateTime: subjectData['dateTime'],
          image: subjectData['image'] ?? '');
    }).toList();
  }

  Stream<List<Subjects>> get subjectList {
    return ref.snapshots().map(_subject);
  }
}
