import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> updateStudentInformation(
    String uid,
    String country,
    String city,
    String contact,
    String timezone,
    List<String> citizenship,
    List<String> language,
    String profileurl) async {
  if (profileurl == '') {
    try {
      await FirebaseFirestore.instance.collection('students').doc(uid).set({
        "country": country,
        "city": city,
        "contact": contact,
        "language": language,
        "timezone": timezone,
        "citizenship": citizenship,
      }, SetOptions(merge: true));
      return 'success';
    } catch (error) {
      return error.toString();
    }
  } else {
    try {
      // Update the main student document
      await FirebaseFirestore.instance.collection('students').doc(uid).set({
        "country": country,
        "city": city,
        "contact": contact,
        "language": language,
        "timezone": timezone,
        "citizenship": citizenship,
        "profileurl": profileurl,
      }, SetOptions(merge: true));
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }
}
