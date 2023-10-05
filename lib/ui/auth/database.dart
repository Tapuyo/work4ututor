// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/services.dart';

class UserDataService {
  final String userUID;
  UserDataService({required this.userUID});

  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('tutor');

  Future addScheduleTimeavailable() async {
    try {
      //create a new document for the user with the uid
      await DatabaseService(uid: userUID).addTutoravailbaleDays();
      return userUID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future addDayoffs() async {
    try {
      //create a new document for the user with the uid
      await DatabaseService(uid: userUID).addDayoffs();
      return userUID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future addTimeavailable() async {
    try {
      //create a new document for the user with the uid
      await DatabaseService(uid: userUID).addTimeavailable();
      return userUID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

Future<String?> addDayOffDates(String uid, List<String> dayoffs) async {
  try {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('tutorSchedule').doc(uid);
    final DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      final dynamic data = doc.data();
      if (data != null && data['dayoffs'] is List<dynamic>) {
        final List<dynamic> currentDayoffs = data['dayoffs'];

        final Set<String> currentDayoffsSet = Set.from(currentDayoffs);

        final List<String> newDayoffsToAdd = dayoffs
            .where((newDayoff) => !currentDayoffsSet.contains(newDayoff))
            .toList();

        if (newDayoffsToAdd.isNotEmpty) {
          currentDayoffsSet.addAll(newDayoffsToAdd);

          await docRef.update({
            'dayoffs': currentDayoffsSet.toList(),
          });

          return 'success';
        } else {
          return 'No new dayoffs to add';
        }
      }
    }

    // Create a new document if it doesn't exist or if 'dayoffs' is not a list
    await docRef.set({
      'dayoffs': dayoffs,
    });

    return 'success';
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<String?> addBlockDates(String uid, List<String> dayoffs) async {
  try {
    //create a new document for the user with the uid
    await FirebaseFirestore.instance.collection('tutorSchedule').doc(uid).set({
      'dayoffs': dayoffs,
    });
    return 'success';
  } catch (e) {
    print(e.toString());
    return null;
  }
}
