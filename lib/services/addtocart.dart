import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> addtoCart(
  String studentid,
  String classno,
  String tutorid,
  String subject,
  String classprice,
) async {
  try {
    await FirebaseFirestore.instance.collection('mycart').add({
      'studentid': studentid,
      'classno': classno,
      'tutorid': tutorid,
      'subjectid': subject,
      'classPrice': classprice,
    });
    return true;
  } catch (e) {
    return false;
  }
}
