import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> setClassSchedule(
  String uid,
  String session,
  timefrom,
  timeto,
  DateTime dateschedule,
) async {
  try {
    // Create a reference to the student's document in the 'classes' collection
    final CollectionReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('schedule');

    // Create a reference to the "blockdatetime" subcollection
    final CollectionReference scheduleCollectionRef = docRef;
    Map<String, dynamic> schdeduledata = {
      'scheduleID': uid,
      'schedule': dateschedule,
      'session': session.toString(),
      'timefrom': timefrom,
      'timeto': timeto,
    };

    await scheduleCollectionRef.add(schdeduledata).then((value) {
      updateStatus(uid, 'Ongoing');
    });

    return 'success';
  } catch (e) {
    print('Error adding schedule to subcollection: $e');
    return e.toString();
  }
}

void updateStatus(String documentId, String newStatus) {
  FirebaseFirestore.instance.collection('classes').doc(documentId).update({
    'status': newStatus,
  }).then((_) {
    print('Status updated successfully!');
  }).catchError((error) {
    print('Error updating status: $error');
  });
}

Future<String?> updateSchedule(String documentId, oldtimefrom, oldtimeto,
    timefrom, timeto, DateTime oldDate, DateTime newSchedule) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('schedule')
        .where('scheduleID', isEqualTo: documentId)
        .where('schedule', isEqualTo: oldDate)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there is only one document with the given scheduleID and scheduledate
      String docIdToUpdate = querySnapshot.docs[0].id;

      await FirebaseFirestore.instance
          .collection('schedule')
          .doc(docIdToUpdate)
          .update({
            'schedule': newSchedule,
            'timefrom': timefrom,
            'timeto': timeto,
          });

      print('Status updated successfully!');
      return 'Success';
    } else {
      print('Document with scheduleID $documentId and scheduledate $oldDate not found.');
      return null;
    }
  } catch (error) {
    print('Error updating schedule: $error');
    return error.toString();
  }
}

