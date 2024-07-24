import 'package:cloud_firestore/cloud_firestore.dart';
import '../data_class/tutor_info_class.dart';

Future<TutorInformation?> getTutorInfo(String tutorID) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('tutor').doc(tutorID).get();

    if (snapshot.exists) {
      return _getTutorInfo(snapshot);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

TutorInformation? _getTutorInfo(
    DocumentSnapshot<Map<String, dynamic>> snapshot) {
  TutorInformation? data1;
  try {
    return TutorInformation(
      contact: snapshot.get('contact') ??
          '', // Provide default value if contact is null
      birthPlace: snapshot.get('birthPlace') ?? '',
      country: snapshot.get('country') ?? '',
      certificates:
          (snapshot.get('certificates') as List<dynamic>).cast<String>(),
      resume: snapshot.get('resume') ?? '',
      promotionalMessage: snapshot.get('promotionalMessage') ?? '',
      withdrawal: snapshot.get('withdrawal') ?? '',
      status: snapshot.get('status') ?? '',
      extensionName: snapshot.get('extensionName') ?? '',
      dateSign: (snapshot.get('dateSign') as Timestamp).toDate(),
      firstName: snapshot.get('firstName') ?? '',
      imageID: snapshot.get('imageID') ?? '',
      language: (snapshot.get('language') as List<dynamic>).cast<String>(),
      lastname: snapshot.get('lastName') ?? '',
      middleName: snapshot.get('middleName') ?? '',
      presentation:
          (snapshot.get('presentation') as List<dynamic>).cast<String>(),
      tutorID: snapshot.get('tutorID') ?? '',
      userId: snapshot.get('userID') ?? '',
      age: snapshot.get('age') ?? '',
      applicationID: snapshot.get('applicationID') ?? '',
      birthCity: snapshot.get('birthCity') ?? '',
      birthdate:(snapshot.get('birthdate') as Timestamp).toDate(),
      emailadd: snapshot.get('emailadd') ?? '',
      city: snapshot.get('city') ?? '',
      servicesprovided:
          (snapshot.get('servicesprovided') as List<dynamic>).cast<String>(),
      timezone: snapshot.get('timezone') ?? '',
      validIds: (snapshot.get('validIDs') as List<dynamic>).cast<String>(),
      certificatestype:
          (snapshot.get('certificatestype') as List<dynamic>).cast<String>(),
      resumelinktype:
          (snapshot.get('resumetype') as List<dynamic>).cast<String>(),
      validIDstype:
          (snapshot.get('validIDstype') as List<dynamic>).cast<String>(),
      citizenship:
          (snapshot.get('citizenship') as List<dynamic>).cast<String>(),
      gender: snapshot.get('gender') ?? '',
    );
  } catch (e) {
    print("Error occurred while parsing TutorInformation: $e");
    return data1; // Return default or empty TutorInformation object
  }
}
