import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wokr4ututor/data_class/subject_class.dart';

class SubjectServices {
  final CollectionReference subjectcollection =
      FirebaseFirestore.instance.collection('subjects');

  List<Subjects> _subject(QuerySnapshot snapshot) {
    return snapshot.docs.map((subjectData) {
      String subjectDescriptionx,
          subjectIdx,
          subjectNamex,
          tutorIdx,
          dateTimex,
          imagex;
      subjectDescriptionx = subjectData['subjectDescription'] ?? '';
      subjectIdx = subjectData['subjectid'] ?? '';
      subjectNamex = subjectData['subjectName'] ?? '';
      tutorIdx = subjectData['tutorId'] ?? '';
      dateTimex = subjectData['datetime'].toString() ?? '';
      imagex = subjectData['image'] ?? '';
      return Subjects(
        subjectDescription: subjectDescriptionx,
        subjectId: subjectIdx,
        subjectName: subjectNamex,
        tutorId: tutorIdx,
        dateTime: '',
        image: imagex,
      );
    }).toList();
  }

  Stream<List<Subjects>> get subjectList {
    return subjectcollection.snapshots().map(_subject);
  }
}
