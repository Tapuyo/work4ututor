// ignore_for_file: unused_local_variable, empty_catches, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls, unused_element, no_leading_underscores_for_local_identifiers, null_argument_to_non_null_type

import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_html/html.dart' as html;
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../data_class/studentinfoclass.dart';

import 'package:firebase_storage/firebase_storage.dart';

import '../data_class/subject_teach_pricing.dart';

Future<String?> uploadData(String uid) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    Uint8List? file = result.files.first.bytes;
    String filename = result.files.first.name;

    Reference storageReference =
        FirebaseStorage.instance.ref().child("$uid/$filename");

    UploadTask uploadTask = storageReference.putData(file!);

    Completer<String?> completer = Completer<String?>(); // Create a Completer

    await uploadTask.whenComplete(() async {
      if (uploadTask.snapshot.state == TaskState.success) {
        // File uploaded successfully, get the download URL
        String downloadURL = await storageReference.getDownloadURL();
        completer.complete(downloadURL); // Set the Completer's value
      } else {
        // Handle the upload failure
        completer.complete(null); // Set the Completer's value
      }
    });

    return completer.future; // Return the Future from the Completer
  } else {
    // Handle the case where the user canceled file selection
    return null;
  }
}

Future<String> uploadStudentProfile(
    String uid, Uint8List selectedImage, String filename) async {
  if (selectedImage == null) {
    return "";
  }

  Reference storageReference =
      FirebaseStorage.instance.ref().child("$uid/$filename");

  UploadTask uploadTask = storageReference.putData(selectedImage);

  Completer<String> completer = Completer<String>();

  uploadTask.whenComplete(() async {
    // Use onComplete instead of whenComplete
    if (uploadTask.snapshot.state == TaskState.success) {
      String downloadURL = await storageReference.getDownloadURL();
      completer.complete(downloadURL);
    } else {
      completer.complete(null); // Consider using an error message
    }
  });

  return completer.future;
}

Future<String> uploadGuardianProfile(
    String uid, Uint8List selectedImage, String type, String filename) async {
  if (selectedImage == null) {
    return "";
  }

  Reference storageReference =
      FirebaseStorage.instance.ref().child("$uid/$type/$filename");

  UploadTask uploadTask = storageReference.putData(selectedImage);

  Completer<String> completer = Completer<String>();

  uploadTask.whenComplete(() async {
    // Use onComplete instead of whenComplete
    if (uploadTask.snapshot.state == TaskState.success) {
      String downloadURL = await storageReference.getDownloadURL();
      completer.complete(downloadURL);
    } else {
      completer.complete(null); // Consider using an error message
    }
  });

  return completer.future;
}

Future<List<String>> uploadGuardianIDList(String uid, String type,
    List<Uint8List?> selectedImages, List<String> filenames) async {
  List<String> downloadURLs = [];

  for (int i = 0; i < selectedImages.length; i++) {
    Uint8List selectedImage = selectedImages[i]!;
    String filename = filenames[i];

    Reference storageReference =
        FirebaseStorage.instance.ref().child("$uid/$type/$filename");

    UploadTask uploadTask = storageReference.putData(selectedImage);

    Completer<String> completer = Completer<String>(); // Create a Completer

    await uploadTask.whenComplete(() async {
      if (uploadTask.snapshot.state == TaskState.success) {
        // File uploaded successfully, get the download URL
        String downloadURL = await storageReference.getDownloadURL();
        completer.complete(downloadURL); // Set the Completer's value
      } else {
        // Handle the upload failure
        completer.complete(null); // Set the Completer's value
      }
    });

    downloadURLs.add(await completer.future);
  }

  return downloadURLs; // Return a list of download URLs
}

addUser(String tEmail, tPassword, uType) {
  FirebaseFirestore.instance
      .collection('user')
      .add({'email': tEmail, 'password': tPassword, 'role': uType});
  FirebaseFirestore.instance
      .collection('tutor')
      .add({'firstName': tEmail, 'lastName': tPassword, 'userID': 'Tutor'});
}

addTutorInfo(String tEmail, tPassword, uType) {
  FirebaseFirestore.instance
      .collection('user')
      .add({'email': tEmail, 'password': tPassword, 'role': uType});
  FirebaseFirestore.instance
      .collection('tutor')
      .add({'firstName': tEmail, 'lastName': tPassword, 'userID': 'Tutor'});
}

addStudentInfo(String tEmail, tPassword, uType) {
  FirebaseFirestore.instance
      .collection('user')
      .add({'email': tEmail, 'password': tPassword, 'role': uType});
  FirebaseFirestore.instance
      .collection('students')
      .add({'firstName': tEmail, 'lastName': tPassword, 'userID': 'Tutor'});
}

class StudentInfoData {
  final String uid;
  StudentInfoData({required this.uid});

  List<StudentInfoClass> _getStudentsInfo(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return [
      StudentInfoClass(
        languages: (snapshot.get('language') as List<dynamic>).cast<String>(),
        address: snapshot.get('address') ?? '',
        country: snapshot.get('country') ?? '',
        studentFirstname: snapshot.get('studentFirstName') ?? '',
        studentMiddlename: snapshot.get('studentMiddleName') ?? '',
        studentLastname: snapshot.get('studentLastName') ?? '',
        studentID: snapshot.get('studentID') ?? '',
        userID: snapshot.get('userID') ?? '',
        contact: snapshot.get('contact') ?? '',
        emailadd: snapshot.get('emailadd') ?? '',
        profilelink: snapshot.get('profileurl') ?? '',
        dateregistered: snapshot.get('dateregistered').toDate() ?? '',
        age: snapshot.get('age') ?? '',
        dateofbirth: snapshot.get('dateofbirth') ?? '',
        timezone: snapshot.get('timezone') ?? '',
      )
    ];
  }

  Stream<List<StudentInfoClass>> get getstudentinfo {
    return FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .snapshots()
        .map(_getStudentsInfo);
  }
}

class AllStudentInfoData {
  AllStudentInfoData();

  List<StudentInfoClass> _getallStudentsInfo(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      return StudentInfoClass(
        languages: (doc.get('language') as List<dynamic>).cast<String>(),
        address: doc.get('address') ?? '',
        country: doc.get('country') ?? '',
        studentFirstname: doc.get('studentFirstName') ?? '',
        studentMiddlename: doc.get('studentMiddleName') ?? '',
        studentLastname: doc.get('studentLastName') ?? '',
        studentID: doc.get('studentID') ?? '',
        userID: doc.get('userID') ?? '',
        contact: doc.get('contact') ?? '',
        emailadd: doc.get('emailadd') ?? '',
        profilelink: doc.get('profileurl') ?? '',
        dateregistered: doc.get('dateregistered').toDate() ?? '',
        age: doc.get('age') ?? '',
        dateofbirth: doc.get('dateofbirth') ?? '',
        timezone: doc.get('timezone') ?? '',
      );
    }).toList();
  }

  Stream<List<StudentInfoClass>> get getallstudentinfo {
    return FirebaseFirestore.instance
        .collection('students')
        .snapshots()
        .map(_getallStudentsInfo);
  }
}

class StudentGuardianData {
  final String uid;
  StudentGuardianData({required this.uid});

  Stream<List<StudentGuardianClass>> get guardianinfo {
    return FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .collection('guardianname')
        .snapshots()
        .map(_getGuardian);
  }

  List<StudentGuardianClass> _getGuardian(QuerySnapshot snapshot) {
    return snapshot.docs.map((guardians) {
      return StudentGuardianClass(
        docID: guardians.id,
        address: guardians['address'] ?? '',
        contact: guardians['guardianscontact'] ?? '',
        country: guardians['country'] ?? '',
        guardianMiddlename: guardians['guardianMiddleName'] ?? '',
        email: guardians['guardiansemail'] ?? '',
        guardianFirstname: guardians['guardiansfullname'] ?? '',
        guardianLastname: guardians['guardianLastName'] ?? '',
      );
    }).toList();
  }
}

Future<void> updateStudentInfo(
  String uid,
  String address,
  String country,
  String name,
  String middlename,
  String lastname,
  List<dynamic> language,
  String studentid,
  String userid,
  String contact,
  String? profileurl,
  DateTime dateregistered,
  String age,
  String dateofbirth,
  String timezone,
  String status,
) async {
  try {
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "language": language,
      "address": address,
      "country": country,
      "studentFirstName": name,
      "studentMiddleName": middlename,
      "studentLastName": lastname,
      "studentID": studentid,
      "userID": userid,
      "profileurl": profileurl,
      "contact": contact,
      "dateregistered": dateregistered,
      "age": age,
      "dateofbirth": dateofbirth,
      "timezone": timezone,
    }, SetOptions(merge: true));
    updateUserStatus(uid, status);
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}

Future<void> updateUserStatus(
  String uid,
  String status,
) async {
  try {
    await FirebaseFirestore.instance.collection('user').doc(uid).set({
      "status": status,
    }, SetOptions(merge: true));
  } catch (error) {}
}

Future<void> updateProfile(
  String uid,
  String profileurl,
) async {
  try {
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "profileurl": profileurl,
    }, SetOptions(merge: true));
    html.window.alert('Upload Successful');
  } catch (error) {
    html.window.alert('Upload Failed: $error');
  }
}

Future<void> updateTutorProfile(
  String uid,
  String profileurl,
) async {
  try {
    await FirebaseFirestore.instance.collection('tutor').doc(uid).set({
      "imageID": profileurl,
    }, SetOptions(merge: true));
    html.window.alert('Upload Successful');
  } catch (error) {
    html.window.alert('Upload Failed: $error');
  }
}

Future<String?> uploadTutorProfile(
    String uid, Uint8List selectedImage, String filename) async {
  if (selectedImage == null) {
    return "";
  }

  Reference storageReference =
      FirebaseStorage.instance.ref().child("$uid/$filename");

  UploadTask uploadTask = storageReference.putData(selectedImage);

  Completer<String?> completer = Completer<String?>(); // Create a Completer

  await uploadTask.whenComplete(() async {
    if (uploadTask.snapshot.state == TaskState.success) {
      // File uploaded successfully, get the download URL
      String downloadURL = await storageReference.getDownloadURL();
      completer.complete(downloadURL); // Set the Completer's value
    } else {
      // Handle the upload failure
      completer.complete(null); // Set the Completer's value
    }
  });

  return completer.future; // Return the Future from the Completer
}

Future<List<String?>> uploadTutorProfileList(String uid, String type,
    List<Uint8List?> selectedImages, List<String> filenames) async {
  List<String?> downloadURLs = [];

  for (int i = 0; i < selectedImages.length; i++) {
    Uint8List selectedImage = selectedImages[i]!;
    String filename = filenames[i];

    Reference storageReference =
        FirebaseStorage.instance.ref().child("$uid/$type/$filename");

    UploadTask uploadTask = storageReference.putData(selectedImage);

    Completer<String?> completer = Completer<String?>(); // Create a Completer

    await uploadTask.whenComplete(() async {
      if (uploadTask.snapshot.state == TaskState.success) {
        // File uploaded successfully, get the download URL
        String downloadURL = await storageReference.getDownloadURL();
        completer.complete(downloadURL); // Set the Completer's value
      } else {
        // Handle the upload failure
        completer.complete(null); // Set the Completer's value
      }
    });

    downloadURLs.add(await completer.future);
  }

  return downloadURLs; // Return a list of download URLs
}

Future<List<String?>> uploadTutorcertificateList(String uid, String type,
    List<Uint8List?> selectedImages, List<String> filenames) async {
  List<String?> downloadURLs = [];

  for (int i = 0; i < selectedImages.length; i++) {
    Uint8List selectedImage = selectedImages[i]!;
    String filename = filenames[i];

    Reference storageReference =
        FirebaseStorage.instance.ref().child("$uid/$type/$filename");

    UploadTask uploadTask = storageReference.putData(selectedImage);

    Completer<String?> completer = Completer<String?>(); // Create a Completer

    await uploadTask.whenComplete(() async {
      if (uploadTask.snapshot.state == TaskState.success) {
        // File uploaded successfully, get the download URL
        String downloadURL = await storageReference.getDownloadURL();
        completer.complete(downloadURL); // Set the Completer's value
      } else {
        // Handle the upload failure
        completer.complete(null); // Set the Completer's value
      }
    });

    downloadURLs.add(await completer.future);
  }

  return downloadURLs; // Return a list of download URLs
}

Future<List<String?>> uploadTutorresumeList(String uid, String type,
    List<Uint8List?> selectedImages, List<String> filenames) async {
  List<String?> downloadURLs = [];

  for (int i = 0; i < selectedImages.length; i++) {
    Uint8List selectedImage = selectedImages[i]!;
    String filename = filenames[i];

    Reference storageReference =
        FirebaseStorage.instance.ref().child("$uid/$type/$filename");

    UploadTask uploadTask = storageReference.putData(selectedImage);

    Completer<String?> completer = Completer<String?>(); // Create a Completer

    await uploadTask.whenComplete(() async {
      if (uploadTask.snapshot.state == TaskState.success) {
        // File uploaded successfully, get the download URL
        String downloadURL = await storageReference.getDownloadURL();
        completer.complete(downloadURL); // Set the Completer's value
      } else {
        // Handle the upload failure
        completer.complete(null); // Set the Completer's value
      }
    });

    downloadURLs.add(await completer.future);
  }

  return downloadURLs; // Return a list of download URLs
}

Future<List<String?>> uploadTutorvideoList(String uid, String type,
    List<Uint8List?> selectedImages, List<String> filenames) async {
  List<String?> downloadURLs = [];

  for (int i = 0; i < selectedImages.length; i++) {
    Uint8List selectedImage = selectedImages[i]!;
    String filename = filenames[i];

    Reference storageReference =
        FirebaseStorage.instance.ref().child("$uid/$type/$filename");

    UploadTask uploadTask = storageReference.putData(selectedImage);

    Completer<String?> completer = Completer<String?>(); // Create a Completer

    await uploadTask.whenComplete(() async {
      if (uploadTask.snapshot.state == TaskState.success) {
        // File uploaded successfully, get the download URL
        String downloadURL = await storageReference.getDownloadURL();
        completer.complete(downloadURL); // Set the Completer's value
      } else {
        // Handle the upload failure
        completer.complete(null); // Set the Completer's value
      }
    });

    downloadURLs.add(await completer.future);
  }

  return downloadURLs; // Return a list of download URLs
}

Future<void> updateStudentInfowGuardian(
    String uid,
    String address,
    String country,
    String name,
    String middlename,
    String lastname,
    List<dynamic> language,
    String studentid,
    String userid,
    String contact,
    String profileurl,
    DateTime dateregistered,
    String age,
    String dateofbirth,
    String timezone,
    String guardiansfullname,
    String guardianscontact,
    String guardiansemail,
    String guardiansbday,
    String guardiansge, // Provide updated course data
    String status,
    List<String> ids,
    String guardianpicture) async {
  try {
    // Update the main student document
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "language": language,
      "address": address,
      "country": country,
      "studentFirstName": name,
      "studentMiddleName": middlename,
      "studentLastName": lastname,
      "studentID": studentid,
      "userID": userid,
      "contact": contact,
      "dateregistered": dateregistered,
      "age": age,
      "dateofbirth": dateofbirth,
      "timezone": timezone,
    }, SetOptions(merge: true));

    // Get a reference to the "courses" subcollection
    final coursesCollectionRef = FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .collection('guardianname');

    // Query the first document in the "courses" subcollection
    QuerySnapshot coursesSnapshot = await coursesCollectionRef.limit(1).get();

    if (coursesSnapshot.docs.isNotEmpty) {
      // Update the first course document found
      final firstCourseDoc = coursesSnapshot.docs.first;
      await firstCourseDoc.reference.set({
        "guardiansfullname": guardiansfullname,
        "guardianscontact": guardianscontact,
        "guardiansemail": guardiansemail,
        "guardiansbirthday": guardiansbday,
        "guardiansge": guardiansge,
        "guardianids": ids,
        "guardianpicture": guardianpicture,
      }, SetOptions(merge: true));

      await updateUserStatus(uid, status);
    } else {
      html.window.alert('No guardian found in the subcollection');
    }
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}

// }
Future<String?> updateTutorInformation(
  String uid,
  String address,
  String country,
  String birthCountry,
  String birthCity,
  String city,
  String name,
  String middlename,
  String lastname,
  List<dynamic> language,
  String tutorIDNumber,
  String userid,
  String contact,
  DateTime dateregistered,
  String age,
  String dateofbirth,
  String timezone,
  String applicationID,
  List<SubjectTeach> mycourses,
  String status,
  String promotionalMessage,
  String profileurl,
  List<String?> certificates,
  List<String?> certificatestype,
  List<String?> resumelink,
  List<String?> resumelinktype,
  List<String?> presentationlink,
  List<String?> validIDs,
  List<String?> validIDstypes,
  List<String?> servicesprovided,
) async {
  try {
    // Update the main student document
    await FirebaseFirestore.instance.collection('tutor').doc(uid).set({
      "age": age,
      "applicationID": applicationID,
      "birthPlace": birthCountry,
      "birthCity": birthCity,
      "birthdate": dateofbirth,
      "certificates": certificates,
      "certificatestype": certificatestype,
      "country": country,
      "city": city,
      "contact": contact,
      "dateSign": dateregistered,
      "extensionName": "",
      "language": language,
      "timezone": timezone,
      "firstName": name,
      "lastName": lastname,
      "middleName": middlename,
      "promotionalMessage": promotionalMessage,
      "tutorID": tutorIDNumber,
      "userID": userid,
      "imageID": profileurl,
      "resume": resumelink,
      "resumetype": resumelinktype,
      "presentation": presentationlink,
      "validIDs": validIDs,
      "validIDstype": validIDstypes,
      "servicesprovided": servicesprovided,
      "withdrawal": "",
    }, SetOptions(merge: true));

    // Get a reference to the "mycourses" subcollection
    final coursesCollectionRef = FirebaseFirestore.instance
        .collection('tutor')
        .doc(uid)
        .collection('mycourses');

    // Clear the existing documents in the subcollection
    await coursesCollectionRef.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    // Add all the new SubjectTeach objects to the subcollection
    for (int i = 0; i < mycourses.length; i++) {
      await coursesCollectionRef.add({
        "subjectname": mycourses[i].subjectname,
        "price2": mycourses[i].price2,
        "price3": mycourses[i].price3,
        "price5": mycourses[i].price5,
      });
    }
    await updateUserStatus(uid, status);
    return 'success';
  } catch (error) {
    return error.toString();
  }
}

Future<void> updateImage(String uID, String path) async {
  // Select a new image from the device's file picker
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  if (result == null || result.files.isEmpty) {
    // No image selected
    return;
  }

  // Get a reference to the Firebase Storage
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  // Get the directory path from the existing image path
  // String directoryPath = path.substring(0, path.lastIndexOf('/'));

  // Upload the updated image to Firebase Storage with the new name
  // String newPath = '$directoryPath/$newName.jpg';
  // Get the existing image reference
  firebase_storage.Reference existingImageRef = storage.ref().child(path);

  // Get the download URL of the existing image
  String url = await existingImageRef.getDownloadURL();

  // Download the existing image
  // http.Response response = await http.get(Uri.parse(url));

  // Upload the updated image to Firebase Storage, replacing the existing one
  firebase_storage.Reference updatedImageRef = storage.ref().child(path);

  try {
    // Upload the new image file
    await updatedImageRef.putData(result.files.first.bytes!);

    // Get the updated download URL
    String updatedImageUrl = await updatedImageRef.getDownloadURL();
    updatelink(uID, path);
    html.window.alert('Image Updated Succesfully');
  } catch (e) {}
}

Future<void> updateGuardianInfo(
  String uid,
  String subID,
  String name,
  String middlename,
  String lastname,
  String contact,
  String emailadd,
  String address,
  String country,
) async {
  try {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .collection('guardianName')
        .doc(subID)
        .set({
      "address": address,
      "country": country,
      "guardianFirstName": name,
      "guardianMiddleName": middlename,
      "guardianLastName": lastname,
      "contact": contact,
      "emailadd": emailadd,
    });
    html.window.alert('Update Successful');
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}

Future<void> updatetutorprofile(
  String uid,
  String path,
) async {
  try {
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "profileurl": path,
    }, SetOptions(merge: true));
    html.window.alert('Update Successful');
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}

Future<void> updatelink(
  String uid,
  String path,
) async {
  try {
    await FirebaseFirestore.instance.collection('students').doc(uid).set({
      "profileurl": path,
    }, SetOptions(merge: true));
    html.window.alert('Update Successful');
  } catch (error) {
    html.window.alert('Update Failed: $error');
  }
}

Future<void> _updateEmailAndPassword(String email, String password) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;

  if (user != null) {
    try {
      // Update email
      await user.updateEmail(email);

      // Update password
      await user.updatePassword(password);

      html.window.alert('Update Successful');
    } catch (error) {
      html.window.alert('Update Failed: $error');
    }
  }
}

Future<String?> updateTutorCertificates(
  String uid,
  List<String?> certificates,
  List<String?> certificatestype,
) async {
  try {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('tutor').doc(uid).get();
    final currentCertificates =
        List<String?>.from(docSnapshot.data()?['certificates'] ?? []);
    final currentCertificateTypes =
        List<String?>.from(docSnapshot.data()?['certificatestype'] ?? []);

    final updatedCertificates = [...currentCertificates, ...certificates];
    final updatedCertificateTypes = [
      ...currentCertificateTypes,
      ...certificatestype
    ];

    await FirebaseFirestore.instance.collection('tutor').doc(uid).update({
      "certificates": updatedCertificates,
      "certificatestype": updatedCertificateTypes,
    });

    return 'success';
  } catch (error) {
    return error.toString();
  }
}

Future<String?> updateTutorResume(
  String uid,
  List<String?> resume,
  List<String?> resumetype,
) async {
  try {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('tutor').doc(uid).get();
    final currentCertificates =
        List<String?>.from(docSnapshot.data()?['resume'] ?? []);
    final currentCertificateTypes =
        List<String?>.from(docSnapshot.data()?['resumetype'] ?? []);

    final updatedResume = [...currentCertificates, ...resume];
    final updatedType = [...currentCertificateTypes, ...resumetype];

    await FirebaseFirestore.instance.collection('tutor').doc(uid).update({
      "resume": updatedResume,
      "resumetype": updatedType,
    });

    return 'success';
  } catch (error) {
    return error.toString();
  }
}

Future<String?> updateTutorVideo(
  String uid,
  List<String?> video,
) async {
  try {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('tutor').doc(uid).get();
    final currentCertificates =
        List<String?>.from(docSnapshot.data()?['presentation'] ?? []);

    final updatedVideo = [...currentCertificates, ...video];

    await FirebaseFirestore.instance.collection('tutor').doc(uid).update({
      "presentation": updatedVideo,
    });

    return 'success';
  } catch (error) {
    return error.toString();
  }
}

Future<String?> updateTutorInfoOffer(
  String uid,
  String promotionalMessage,
  List<String?> servicesprovided,
  List<String?> video,
  List<String?> resume,
  List<String?> resumetype,
  List<String?> certificates,
  List<String?> certificatestype,
) async {
  try {
    //
    final docSnapshot =
        await FirebaseFirestore.instance.collection('tutor').doc(uid).get();

    //
    final currentResume =
        List<String?>.from(docSnapshot.data()?['resume'] ?? []);
    final currentResumeTypes =
        List<String?>.from(docSnapshot.data()?['resumetype'] ?? []);

    final updatedResume = [...currentResume, ...resume];
    final updatedType = [...currentResumeTypes, ...resumetype];
    //
    final currentCertificates =
        List<String?>.from(docSnapshot.data()?['certificates'] ?? []);
    final currentCertificateTypes =
        List<String?>.from(docSnapshot.data()?['certificatestype'] ?? []);

    final updatedCertificates = [...currentCertificates, ...certificates];
    final updatedCertificateTypes = [
      ...currentCertificateTypes,
      ...certificatestype
    ];
    //
    final currentVideos =
        List<String?>.from(docSnapshot.data()?['presentation'] ?? []);

    final updatedVideo = [...currentVideos, ...video];
    //
    await FirebaseFirestore.instance.collection('tutor').doc(uid).update({
      "promotionalMessage": promotionalMessage,
      "servicesprovided": servicesprovided,
      "presentation": updatedVideo,
      "resume": updatedResume,
      "resumetype": updatedType,
      "certificates": updatedCertificates,
      "certificatestype": updatedCertificateTypes,
    });

    return 'success';
  } catch (error) {
    return error.toString();
  }
}

Future<void> deleteFileCertificate(
    List<String> fileUrl, String uid, List<int> itemsToRemove) async {
  try {
    for (String fileUrl in fileUrl) {
      Reference ref = FirebaseStorage.instance.refFromURL(fileUrl);

      await ref.delete().then((value) async {
        try {
          final DocumentReference docRef =
              FirebaseFirestore.instance.collection('tutor').doc(uid);

          // Get the current document snapshot
          DocumentSnapshot snapshot = await docRef.get();
          if (!snapshot.exists) {
            print('Document does not exist');
            return;
          }

          // Ensure that the data retrieved from Firestore is Map<String, dynamic>
          Map<String, dynamic> data =
              snapshot.data() as Map<String, dynamic>? ?? {};

          // Get the current arrays from the document and ensure they are List<dynamic>
          List<dynamic> certificates =
              (data['certificates'] as List<dynamic>?) ?? [];
          List<dynamic> certificatestype =
              (data['certificatestype'] as List<dynamic>?) ?? [];

          // Remove items at specified indexes from the arrays
          itemsToRemove.sort(
              (a, b) => b.compareTo(a)); // Sort indexes in descending order
          for (int index in itemsToRemove) {
            if (index >= 0 && index < certificates.length) {
              certificates.removeAt(index);
            }
            if (index >= 0 && index < certificatestype.length) {
              certificatestype.removeAt(index);
            }
          }

          // Update the Firestore document with the modified arrays
          await docRef.update({
            'certificates': certificates,
            'certificatestype': certificatestype,
          });

          print('Indexes removed from array fields successfully');
        } catch (e) {
          print('Error removing indexes from array fields: $e');
        }
      });
    }
    print('File deleted successfully');
  } catch (e) {
    print('Error deleting file: $e');
  }
}

Future<void> deleteFileResume(
    List<String> fileUrl, String uid, List<int> itemsToRemove) async {
  try {
    for (String fileUrl in fileUrl) {
      Reference ref = FirebaseStorage.instance.refFromURL(fileUrl);

      await ref.delete().then((value) async {
        try {
          final DocumentReference docRef =
              FirebaseFirestore.instance.collection('tutor').doc(uid);

          // Get the current document snapshot
          DocumentSnapshot snapshot = await docRef.get();
          if (!snapshot.exists) {
            print('Document does not exist');
            return;
          }

          // Ensure that the data retrieved from Firestore is Map<String, dynamic>
          Map<String, dynamic> data =
              snapshot.data() as Map<String, dynamic>? ?? {};

          // Get the current arrays from the document and ensure they are List<dynamic>
          List<dynamic> resume = (data['resume'] as List<dynamic>?) ?? [];
          List<dynamic> resumetype =
              (data['resumetype'] as List<dynamic>?) ?? [];

          // Remove items at specified indexes from the arrays
          itemsToRemove.sort(
              (a, b) => b.compareTo(a)); // Sort indexes in descending order
          for (int index in itemsToRemove) {
            if (index >= 0 && index < resume.length) {
              resume.removeAt(index);
            }
            if (index >= 0 && index < resumetype.length) {
              resumetype.removeAt(index);
            }
          }

          // Update the Firestore document with the modified arrays
          await docRef.update({
            'resume': resume,
            'resumetype': resumetype,
          });

          print('Indexes removed from array fields successfully');
        } catch (e) {
          print('Error removing indexes from array fields: $e');
        }
      });
    }
    print('File deleted successfully');
  } catch (e) {
    print('Error deleting file: $e');
  }
}

Future<void> deleteFileVideo(
    List<String> fileUrl, String uid, List<int> itemsToRemove) async {
  try {
    for (String fileUrl in fileUrl) {
      Reference ref = FirebaseStorage.instance.refFromURL(fileUrl);

      await ref.delete().then((value) async {
        try {
          final DocumentReference docRef =
              FirebaseFirestore.instance.collection('tutor').doc(uid);

          // Get the current document snapshot
          DocumentSnapshot snapshot = await docRef.get();
          if (!snapshot.exists) {
            print('Document does not exist');
            return;
          }

          // Ensure that the data retrieved from Firestore is Map<String, dynamic>
          Map<String, dynamic> data =
              snapshot.data() as Map<String, dynamic>? ?? {};

          // Get the current arrays from the document and ensure they are List<dynamic>
          List<dynamic> presentation =
              (data['presentation'] as List<dynamic>?) ?? [];

          // Remove items at specified indexes from the arrays
          itemsToRemove.sort(
              (a, b) => b.compareTo(a)); // Sort indexes in descending order
          for (int index in itemsToRemove) {
            if (index >= 0 && index < presentation.length) {
              presentation.removeAt(index);
            }
          }

          // Update the Firestore document with the modified arrays
          await docRef.update({
            'presentation': presentation,
          });

          print('Indexes removed from array fields successfully');
        } catch (e) {
          print('Error removing indexes from array fields: $e');
        }
      });
    }
    print('File deleted successfully');
  } catch (e) {
    print('Error deleting file: $e');
  }
}
