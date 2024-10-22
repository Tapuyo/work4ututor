import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data_class/tutor_info_class.dart';

class TutorService {
  final CollectionReference tutorCollection;

  TutorService({required this.tutorCollection});

  TutorInformation _getTutorInformation(DocumentSnapshot doc) {
    final tutordata = doc.data() as Map<String, dynamic>;
    final firstName = tutordata['firstName'] ?? '';
    return TutorInformation(
      contact: tutordata['contact'] ?? '',
      birthPlace: tutordata['birthPlace'] ?? '',
      country: tutordata['country'] ?? '',
      certificates: (tutordata['certificates'] as List<dynamic>).cast<String>(),
      resume: (tutordata['resume'] as List<dynamic>).cast<String>(),
      promotionalMessage: tutordata['promotionalMessage'] ?? '',
      withdrawal: tutordata['withdrawal'] ?? '',
      status: tutordata['status'] ?? '',
      extensionName: tutordata['extensionName'] ?? '',
      dateSign: (tutordata['dateSign'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
      firstName: firstName,
      imageID: tutordata['imageID'] ?? '',
      language: (tutordata['language'] as List<dynamic>).cast<String>(),
      lastname: tutordata['lastName'] ?? '',
      middleName: tutordata['middleName'] ?? '',
      presentation: (tutordata['presentation'] as List<dynamic>).cast<String>(),
      tutorID: tutordata['tutorID'] ?? '',
      userId: tutordata['userID'] ?? '',
      age: tutordata['age'] ?? '',
      applicationID: tutordata['applicationID'] ?? '',
      birthCity: tutordata['birthCity'] ?? '',
      birthdate: (tutordata['birthdate'] as Timestamp).toDate(),
      emailadd: tutordata['emailadd'] ?? '',
      city: tutordata['city'] ?? '',
      servicesprovided:
          (tutordata['servicesprovided'] as List<dynamic>).cast<String>(),
      timezone: tutordata['timezone'] ?? '',
      validIds: (tutordata['validIDs'] as List<dynamic>).cast<String>(),
      certificatestype:
          (tutordata['certificatestype'] as List<dynamic>).cast<String>(),
      resumelinktype: (tutordata['resumetype'] as List<dynamic>).cast<String>(),
      validIDstype: (tutordata['validIDstype'] as List<dynamic>).cast<String>(),
      citizenship: (tutordata['citizenship'] as List<dynamic>).cast<String>(),
      gender: tutordata['gender'] ?? '',
    );
  }

  Stream<List<TutorInformation>> get tutorlist {
    return tutorCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _getTutorInformation(doc)).toList();
    });
  }

  Future<List<TutorInformation>> getAllTutors() async {
    try {
      QuerySnapshot snapshot = await tutorCollection.get();
      return snapshot.docs.map((doc) => _getTutorInformation(doc)).toList();
    } catch (e) {
      print('Error getting documents: $e');
      return []; // Handle errors
    }
  }
}

class TutorInformationScreen extends StatefulWidget {
  const TutorInformationScreen({super.key});

  @override
  _TutorInformationScreenState createState() => _TutorInformationScreenState();
}

class _TutorInformationScreenState extends State<TutorInformationScreen> {
  final TutorService tutorService = TutorService(
    tutorCollection: FirebaseFirestore.instance.collection('tutor'),
  );
  Future<List<TutorInformation>>? _tutorsFuture;

  void _fetchAllTutors() {
    setState(() {
      _tutorsFuture = tutorService.getAllTutors();
    });
  }

  TextEditingController id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor Information'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: id,
            ),
            ElevatedButton(
              onPressed: () {
                _fetchAllTutors(); // Replace with the actual tutor ID
              },
              child: const Text('Fetch Tutor Information'),
            ),
            FutureBuilder<List<TutorInformation>>(
              future: _tutorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<TutorInformation>? tutors = snapshot.data;
                  if (tutors != null && tutors.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: tutors.length,
                        itemBuilder: (context, index) {
                          TutorInformation tutor = tutors[index];
                          return ListTile(
                            title: Text('${tutor.firstName} ${tutor.lastname}'),
                            subtitle: Text(tutor.emailadd),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text('No tutors found');
                  }
                } else {
                  return const Text('Press the button to fetch tutors information');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
