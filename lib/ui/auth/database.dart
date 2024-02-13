// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../services/services.dart';
import '../web/tutor/calendar/setup_calendar.dart';

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

  Future addDayoffs(List<String> dayoffs) async {
    try {
      //create a new document for the user with the uid
      await DatabaseService(uid: userUID).addDayoffs(
        dayoffs,
        userUID,
      );
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

Future<String?> addDayOffDates(
    String uid, List<String> dayoffs, List<DateTime> dateoffselected) async {
  try {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('tutorSchedule').doc(uid);
    final DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      final dynamic data = doc.data();
      if (data != null &&
          data['dayoffs'] is List<dynamic> &&
          data['dateoffselected'] is List<dynamic>) {
        final List<dynamic> currentDayoffs = data['dayoffs'];
        final List<dynamic> currentDateOffSelected = data['dateoffselected'];

        if (!listsAreEqual(dayoffs, currentDayoffs) ||
            !datesAreEqual(dateoffselected, currentDateOffSelected)) {
          await docRef.update({
            'uid': uid,
            'dayoffs': dayoffs,
            'dateoffselected':
                dateoffselected.map((date) => date.toIso8601String()).toList(),
          });

          return 'success';
        } else {
          return 'Dayoffs and DateOffSelected are already up to date';
        }
      }
    }

    // Create a new document if it doesn't exist or if 'dayoffs' or 'dateoffselected' is not a list
    await docRef.set({
      'uid': uid,
      'dayoffs': dayoffs,
      'dateoffselected':
          dateoffselected.map((date) => date.toIso8601String()).toList(),
    });

    return 'success';
  } catch (e) {
    print(e.toString());
    return null;
  }
}

bool listsAreEqual(List<String> list1, List<dynamic> list2) {
  if (list1.length != list2.length) {
    return false;
  }

  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }

  return true;
}

bool datesAreEqual(List<DateTime> list1, List<dynamic> list2) {
  if (list1.length != list2.length) {
    return false;
  }

  for (int i = 0; i < list1.length; i++) {
    final dateAsString = list2[i] as String;
    final dateFromDatabase = DateTime.tryParse(dateAsString);

    if (dateFromDatabase == null || list1[i] != dateFromDatabase) {
      return false;
    }
  }

  return true;
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

Future<String?> deleteDayOffDates(String uid) async {
  try {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('tutorSchedule').doc(uid);
    final DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      await docRef.update({
        'dayoffs': FieldValue.delete(),
        'dateoffselected': FieldValue.delete(),
      });

      return 'success';
    } else {
      // The document with the provided UID doesn't exist
      return 'Document does not exist';
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String?> addOrUpdateTimeAvailability(
    String uid, TimeAvailability timeAvailability) async {
  try {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('tutorSchedule').doc(uid);

    // Create a reference to the "timeavailable" subcollection
    final CollectionReference timeAvailableCollectionRef =
        docRef.collection('timeavailable');

    // Delete all existing documents within the "timeavailable" subcollection
    QuerySnapshot existingDocs = await timeAvailableCollectionRef.get();
    for (QueryDocumentSnapshot doc in existingDocs.docs) {
      await doc.reference.delete();
    }

    // Add a new document to the "timeavailable" subcollection
    await timeAvailableCollectionRef.add(timeAvailability.toMap());

    return 'success';
  } catch (e) {
    print('Error adding/updating subcollection: $e');
    return e.toString();
  }
}

Future<String?> addOrUpdateTimeAvailabilityWithDate(
    String uid, List<DateTimeAvailability> timeAvailability) async {
  try {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('tutorSchedule').doc(uid);

    // Create a reference to the "timeavailable" subcollection
    final CollectionReference timeAvailableCollectionRef =
        docRef.collection('timedateavailable');

    // Get existing documents within the "timeavailable" subcollection
    QuerySnapshot existingDocs = await timeAvailableCollectionRef.get();

    if (existingDocs.docs.isEmpty) {
      // If the subcollection is empty, add the timeAvailability to it
      for (DateTimeAvailability availability in timeAvailability) {
        await timeAvailableCollectionRef.add(availability.toMap());
      }
    } else {
      // Check if formatted selectedDate is already present in existingDocs
      for (DateTimeAvailability availability in timeAvailability) {
        // Format the selectedDate for comparison
        DateTime formattedSelectedDate =
            availability.selectedDate; // Convert Timestamp to DateTime

        bool selectedDateExists = existingDocs.docs.any(
            (doc) => doc['selectedDate'].toDate() == formattedSelectedDate);

        // If selectedDate doesn't exist, add it to the subcollection
        if (!selectedDateExists) {
          await timeAvailableCollectionRef.add(availability.toMap());
        }
      }
    }

    return 'success';
  } catch (e) {
    print('Error adding/updating subcollection: $e');
    return e.toString();
  }
}

Future<String?> blockTimeWithDate(
    String uid, List<BlockDate> blockdates) async {
  try {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('tutorSchedule').doc(uid);

    // Create a reference to the "timeavailable" subcollection
    final CollectionReference blockCollectionRef =
        docRef.collection('blockdatetime');

    // Get existing documents within the "timeavailable" subcollection
    QuerySnapshot existingDocs = await blockCollectionRef.get();

    if (existingDocs.docs.isEmpty) {
      // If the subcollection is empty, add the timeAvailability to it
      for (BlockDate blocks in blockdates) {
        await blockCollectionRef.add(blocks.toMap());
      }
    } else {
      // If the subcollection is not empty, check if there's data with a specific condition
      bool dataNotFound = true; // Set this flag based on your condition

      if (dataNotFound) {
        // Add the timeAvailability to the list in this case
        for (BlockDate blocks in blockdates) {
          await blockCollectionRef.add(blocks.toMap());
        }
      }
    }

    return 'success';
  } catch (e) {
    print('Error adding/updating subcollection: $e');
    return e.toString();
  }
}
