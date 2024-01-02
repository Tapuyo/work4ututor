import 'package:cloud_firestore/cloud_firestore.dart';

import '../data_class/subject_teach_pricing.dart';

Future<String?> updatePersonalTutorInformation(
  String uid,
  String country,
  String birthCountry,
  String birthCity,
  String city,
  String name,
  String middlename,
  String lastname,
  List<dynamic> language,
  String userid,
  String contact,
  String age,
  String dateofbirth,
  String timezone,
  String profileurl,
) async {
  if (profileurl == '') {
    try {
      // Update the main student document
      await FirebaseFirestore.instance.collection('tutor').doc(uid).set({
        "age": age,
        "birthPlace": birthCountry,
        "birthCity": birthCity,
        "birthdate": dateofbirth,
        "country": country,
        "city": city,
        "contact": contact,
        "language": language,
        "timezone": timezone,
        "firstName": name,
        "lastName": lastname,
        "middleName": middlename,
        "userID": userid,
        "withdrawal": "",
      }, SetOptions(merge: true));
      return 'success';
    } catch (error) {
      return error.toString();
    }
  } else {
    try {
      // Update the main student document
      await FirebaseFirestore.instance.collection('tutor').doc(uid).set({
        "age": age,
        "birthPlace": birthCountry,
        "birthCity": birthCity,
        "birthdate": dateofbirth,
        "country": country,
        "city": city,
        "contact": contact,
        "language": language,
        "timezone": timezone,
        "firstName": name,
        "lastName": lastname,
        "middleName": middlename,
        "userID": userid,
        "imageID": profileurl,
        "withdrawal": "",
      }, SetOptions(merge: true));
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }
}

Future<String?> updateSubjectTeach(String uid, String subjectId,
    String newPrice2, String newPrice3, String newPrice5) async {
  try {
    await FirebaseFirestore.instance
        .collection('tutor')
        .doc(uid)
        .collection('mycourses')
        .doc(subjectId) // Use the subjectId as the document ID
        .set({
      'price2': newPrice2,
      'price3': newPrice3,
      'price5': newPrice5,
    }, SetOptions(merge: true));
    return 'success';
  } catch (e) {
    return e.toString();
  }
}

Future<String?> deleteSubjectTeach(String uid, String subjectId) async {
  try {
    await FirebaseFirestore.instance
        .collection('tutor')
        .doc(uid)
        .collection('mycourses')
        .doc(subjectId) // Use the subjectId as the document ID
        .delete();
    return 'success';
  } catch (e) {
    return e.toString();
  }
}

Future<String?> addSubjectTeach(
    String uid, List<SubjectTeach> subjectTeachList) async {
  try {
    final coursesCollectionRef = FirebaseFirestore.instance
        .collection('tutor')
        .doc(uid)
        .collection('mycourses');

    // Add all the new SubjectTeach objects to the subcollection
    for (int i = 0; i < subjectTeachList.length; i++) {
      // Check if a document with the same subjectname exists
      final querySnapshot = await coursesCollectionRef
          .where('subjectname', isEqualTo: subjectTeachList[i].subjectname)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no document with the same subjectname found, add a new one
        await coursesCollectionRef.add({
          "subjectname": subjectTeachList[i].subjectname,
          "price2": subjectTeachList[i].price2,
          "price3": subjectTeachList[i].price3,
          "price5": subjectTeachList[i].price5,
        });
      }
    }
    return 'success';
  } catch (e) {
    return e.toString();
  }
}


// Future<void> addSubjectTeach(String uid, String subjectName, String price2, String price3, String price5) async {
//   try {
//     await FirebaseFirestore.instance
//         .collection('tutor')
//         .doc(uid)
//         .collection('mycourses')
//         .add({
//       'subjectname': subjectName,
//       'price2': price2,
//       'price3': price3,
//       'price5': price5,
//     });
//     print('SubjectTeach added successfully');
//   } catch (e) {
//     print('Error adding SubjectTeach: $e');
//   }
// }

