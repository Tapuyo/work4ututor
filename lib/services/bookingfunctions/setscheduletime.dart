import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


Future<String?> setClassSchedule(
  String uid,
  String session,
  timefrom,
  timeto,
  DateTime dateschedule,
  String subjectId,
) async {
  try {
    // Create a reference to the student's document in the 'classes' collection
    final CollectionReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('schedule');

    String formattedDate = DateFormat('MMddyyyy').format(dateschedule);
    final CollectionReference scheduleCollectionRef = docRef;
    Map<String, dynamic> schdeduledata = {
      'scheduleID': uid,
      'schedule': timefrom,
      //   'schedule': formatTimewDate(
      //     DateFormat('MMMM d, yyyy').format(dateschedule),
      //     timefrom)
      // .toString(),
      'session': session.toString(),
      'timefrom': timefrom,
      'timeto': timeto,
      //      'timefrom':  formatTimewDate(
      //         DateFormat('MMMM d, yyyy').format(dateschedule),
      //         timefrom)
      //     .toString(),
      // 'timeto': formatTimewDate(
      //         DateFormat('MMMM d, yyyy').format(dateschedule),
      //         timeto)
      //     .toString(),
      'classstatus': 'unfinish',
      'meetinglink': '$uid$formattedDate$timefrom'.replaceAll(' ', ''),
      'rating': '',
      'subjectId': subjectId,
      'studentStatus': 'Pending',
      'tutorStatus': 'Pending',
    };

    await scheduleCollectionRef.add(schdeduledata).then((value) {
      updateStatus(uid, 'Ongoing');
    });

    return 'success';
  } catch (e) {
    return e.toString();
  }
}

Future<String> updateStatus(String documentId, String newStatus) async {
  try {
    // Retrieve the current status
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('classes')
        .doc(documentId)
        .get();

    if (documentSnapshot.exists) {
      String currentStatus = documentSnapshot['status'];

      // Check if the current status is 'Completed'
      if (currentStatus == 'Completed') {
        return 'Cannot update status. Class has already been completed.';
      } else if (currentStatus == 'Cancelled') {
        return 'Cannot update status. Class has already been cancelled.';
      }

      // If not 'Completed', proceed with updating the status
      await FirebaseFirestore.instance
          .collection('classes')
          .doc(documentId)
          .update({
        'status': newStatus,
      });

      return 'Success';
    } else {
      return 'Document not found';
    }
  } catch (error) {
    return 'Error updating status: $error';
  }
}

Future<String?> updateSchedule(String documentId, oldtimefrom, oldtimeto,
    timefrom, timeto, DateTime oldDate, DateTime newSchedule) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('schedule')
        .where('scheduleID', isEqualTo: documentId)
        .where('schedule', isEqualTo: oldtimefrom)
        .where('timefrom', isEqualTo: oldtimefrom)
        .where('timeto', isEqualTo: oldtimeto)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there is only one document with the given scheduleID and scheduledate
      String docIdToUpdate = querySnapshot.docs[0].id;

      await FirebaseFirestore.instance
          .collection('schedule')
          .doc(docIdToUpdate)
          .update({
        'schedule': timefrom,
        'timefrom': timefrom,
        'timeto': timeto,
      });

      return 'Success';
    } else {
      return 'Error updating';
    }
  } catch (error) {
    return error.toString();
  }
}

Future<String?> updateScheduleStatus(
  String documentId,
  DateTime currentDate,
  String paymentId,
) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('schedule')
        .where('scheduleID', isEqualTo: documentId)
        .where('schedule', isEqualTo: currentDate)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there is only one document with the given scheduleID and scheduledate
      String docIdToUpdate = querySnapshot.docs[0].id;

      // Update schedule collection
      await firestore.collection('schedule').doc(docIdToUpdate).update({
        'studentStatus': 'Completed',
      });

      // Update tutorPayment collection
      await firestore.collection('tutorPayment').doc(paymentId).update({
        'studentStatus': 'Completed',
      });

      return 'Success';
    } else {
      return null;
    }
  } catch (error) {
    return error.toString();
  }
}

Future<String?> addRateClass(
  String documentId,
  DateTime oldDate,
  String ratecount,
) async {
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
        'rating': ratecount,
      });

      return 'Success';
    } else {
      return null;
    }
  } catch (error) {
    return error.toString();
  }
}

Future<String> adminNotification(
    String type, String message, String classID, List<String> userIds) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference notificationCollection =
        firestore.collection('adminnotification');

    Map<String, dynamic> notificationData = {
      'dateNotify': DateTime.now(),
      'notificationContent': message,
      'type': type,
      'classID': classID,
      'userIDs': userIds,
      'status': 'unread',
    };

    await notificationCollection.add(notificationData);

    return 'Success';
  } catch (e) {
    return 'Error: $e';
  }
}
