import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data_class/tutor_info_class.dart';

class DatabaseService1 {
  final String uid;
  DatabaseService1({required this.uid});

  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('tutor');

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
        lastname: tutordata['lastname'] ?? '',
        middleName: tutordata['middleName'] ?? '',
        presentation: tutordata['presentation'] ?? '',
        tutorID: tutordata['tutorID'] ?? '',
        userId: tutordata['userId'] ?? '',
      );
    }).toList();
  }

  Stream<List<TutorInformation>> get tutorlist{
  return dataCollection.snapshots().map(_getTutorInformation);
  
}

  Future<void> getTutorInfo() async {
    await FirebaseFirestore.instance
        .collection('tutor')
        .where(uid, isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((tutordata) {
        return tutordata['status'] ?? '';
      });
    });
  }
}
