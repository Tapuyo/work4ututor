// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addClassFinished( double classPrice,
     String classId,
   double disburseAmount,
   String disburseId,
   String studentID,
   String tutorID) async {
  

  CollectionReference collection =
      FirebaseFirestore.instance.collection('tutorPayment');

  await collection
      .add({
        'adminReady': false,
        'classAmount': classPrice,
        'classId': classId,
        'dateDisburse': null,
        'dateclassFinished': DateTime.now(),
        'disburseAmount': disburseAmount,
        'disburseId': disburseId,
        'disburseStatus': "Invalid",
        'location': "192.183.168",
        'studentID': studentID,
        'studentStatus': "Pending",
        'tutorID': tutorID,
        'tutorStatus': "Completed"
      })
      .then((value) => print("Data Added"))
      .catchError((error) => print("Failed to add data: $error"));
}
Future<String?> updateScheduleAndAddClassFinished(
  String documentId,
  DateTime oldDate,
  double classPrice,
  String classId,
  double disburseAmount,
  String disburseId,
  String studentID,
  String tutorID
) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Update the schedule collection
    QuerySnapshot querySnapshot = await firestore
        .collection('schedule')
        .where('scheduleID', isEqualTo: documentId)
        .where('schedule', isEqualTo: oldDate)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there is only one document with the given scheduleID and schedule date
      String docIdToUpdate = querySnapshot.docs[0].id;

      // Update schedule document
      await firestore.collection('schedule').doc(docIdToUpdate).update({
        'classstatus': 'finish',
        'tutorStatus': 'Completed',
      });

      // Add document to tutorPayment collection
      CollectionReference collection = firestore.collection('tutorPayment');

      await collection.add({
        'adminReady': false,
        'classAmount': classPrice,
        'classId': classId,
        'dateDisburse': null,
        'dateclassFinished': DateTime.now(),
        'disburseAmount': disburseAmount,
        'disburseId': disburseId,
        'disburseStatus': "Invalid",
        'location': "192.183.168",
        'studentID': studentID,
        'studentStatus': "Pending",
        'tutorID': tutorID,
        'tutorStatus': "Completed"
      });

      return 'Success';
    } else {
      return 'No matching schedule document found';
    }
  } catch (error) {
    return error.toString();
  }
}


Future<void> updateDocuments(
  List<String> documentIds,
) async {
  WriteBatch batch = FirebaseFirestore.instance.batch();
  CollectionReference collection =
      FirebaseFirestore.instance.collection('tutorPayment');

  for (var documentId in documentIds) {
    batch.update(collection.doc(documentId), {
      'dateDisburse': Timestamp.now(),
      'disburseStatus': "Pending",
    });
  }

  await batch
      .commit()
      .then((value) => print("Batch update successful"))
      .catchError((error) => print("Batch update failed: $error"));
}

Future<String> updateAndAddToClaimHistory(
    List<Map<String, dynamic>> documentIds,
    String bankAccount,
    double amounttoDisburse,
    commisionFee,
    totalAmount) async {
  try {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    CollectionReference tutorPaymentCollection =
        FirebaseFirestore.instance.collection('tutorPayment');
    CollectionReference claimHistoryCollection =
        FirebaseFirestore.instance.collection('claimHistory');

    // Update documents in tutorPayment collection
    for (var documentId in documentIds) {
      batch.update(tutorPaymentCollection.doc(documentId['id']), {
        'adminReady': true,
        'disburseStatus': "Pending",
      });
    }

    // Prepare array data for claimHistory collection
    List<Map<String, dynamic>> claimData = documentIds.map((documentId) {
      return {
        'docId': documentId['id'],
        'disburseID': documentId['disburseId'],
        'classId': documentId['classId'],
        'disburseamount': documentId['disburseAmount'],
      };
    }).toList();

    // Add documents to claimHistory collection
    batch.set(claimHistoryCollection.doc(), {
      'claimData': claimData,
      'dateRequested': Timestamp.now(),
      'totalAmount': totalAmount,
      'commisionFee': commisionFee,
      'amountTodisburse': amounttoDisburse,
      'withdrawalCharge': null,
      'accountUse': bankAccount,
      'dateDisburse': null,
      'status': "Pending",
    });

    // Commit the batched write operation
    await batch.commit();

    return 'Success';
  } catch (error) {
    // Handle errors
    return error.toString();
  }
}
