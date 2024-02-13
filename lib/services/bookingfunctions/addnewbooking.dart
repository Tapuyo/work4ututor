import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> addNewBooking(String tutorID, String studentID, String message,
    String subjectID, int numberOfClasses, List<String> userIds) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Check if both tutorID and studentID exist in messageparticipants
    QuerySnapshot query = await firestore
        .collection('messageparticipants')
        .where('tutorID', isEqualTo: tutorID)
        .where('studentID', isEqualTo: studentID)
        .get();

    if (query.docs.isNotEmpty) {
      // If both tutorID and studentID are found, proceed with adding new data

      WriteBatch batch = firestore.batch();

      CollectionReference classesCollection = firestore.collection('classes');
      // CollectionReference messageParticipantsCollection =
      //     firestore.collection('messageparticipants');
      CollectionReference notificationCollection =
          firestore.collection('notification');

      Map<String, dynamic> notificationData = {
        'dateNotify': DateTime.now(),
        'notificationContent': message,
        'type': 'new class',
        'userIDs': userIds,
        'status': 'unread',
      };

      Map<String, dynamic> classesData = {
        'completedClasses': '0',
        'dateEnrolled': DateTime.now(),
        'pendingClasses': numberOfClasses.toString(),
        'status': 'Pending',
        'studentID': studentID,
        'subjectID': subjectID,
        'totalClasses': numberOfClasses.toString(),
        'tutorID': tutorID,
      };
      await classesCollection.add(classesData);
      await notificationCollection.add(notificationData);

      await batch.commit();

      return 'success';
    } else {
      WriteBatch batch = firestore.batch();

      CollectionReference classesCollection = firestore.collection('classes');
      CollectionReference messageParticipantsCollection =
          firestore.collection('messageparticipants');
      CollectionReference notificationCollection =
          firestore.collection('notification');

      Map<String, dynamic> messageData = {
        'lastMessage': '',
        'messageDate': DateTime.now(),
        'messageStatus': 'unread',
        'studentFav': 'no',
        'studentID': studentID,
        'tutorFav': 'no',
        'tutorID': tutorID,
      };

      Map<String, dynamic> notificationData = {
        'dateNotify': DateTime.now(),
        'notificationContent': message,
        'type': 'new class',
        'userIDs': userIds,
      };

      Map<String, dynamic> classesData = {
        'completedClasses': '0',
        'dateEnrolled': DateTime.now(),
        'pendingClasses': numberOfClasses.toString(),
        'status': 'Pending',
        'studentID': studentID,
        'subjectID': subjectID,
        'totalClasses': numberOfClasses.toString(),
        'tutorID': tutorID,
      };
      await classesCollection.add(classesData);
      await messageParticipantsCollection.add(messageData);
      await notificationCollection.add(notificationData);

      await batch.commit();

      return 'success';
    }
  } catch (e) {
    return 'Error: $e';
  }
}
