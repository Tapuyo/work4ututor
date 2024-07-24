import 'package:cloud_firestore/cloud_firestore.dart';

class BookingResult {
  final String status;
  final String classId;
  final String classReference;

  BookingResult(
    this.status,
    this.classId,
    this.classReference,
  );
}

Future<int> getClassCount() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot classesSnapshot = await firestore.collection('classes').get();
  return classesSnapshot.size;
}

Future<BookingResult> addNewBooking(
    String tutorID,
    String studentID,
    String message,
    String subjectID,
    int numberOfClasses,
    List<String> userIds,
    double totalPrice) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    int classCount = await getClassCount();
    QuerySnapshot query = await firestore
        .collection('messageparticipants')
        .where('tutorID', isEqualTo: tutorID)
        .where('studentID', isEqualTo: studentID)
        .get();

    if (query.docs.isNotEmpty) {
      WriteBatch batch = firestore.batch();

      CollectionReference classesCollection = firestore.collection('classes');
      // CollectionReference messageParticipantsCollection =
      //     firestore.collection('messageparticipants');
      CollectionReference notificationCollection =
          firestore.collection('notification');
      CollectionReference messagingCollection =
          firestore.collection('messaging');

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
        'totalPrice': totalPrice,
        'classReference': '0${classCount + 1}'
      };
      DocumentReference classDocRef = await classesCollection.add(classesData);
      String classDocId = classDocRef.id;
      await notificationCollection.add(notificationData);
      String messageID = query.docs.first.id;

      Map<String, dynamic> sendMessageData = {
        'dateSent': DateTime.now(),
        'messageContent': 'New class is book checked classes for details!',
        'messageID': messageID,
        'noofclasses': '',
        'subjectID': '',
        'classPrice': '',
        'type': 'message',
        'userID': studentID
      };
      await messagingCollection.add(sendMessageData);
      await batch.commit();

      return BookingResult('success', classDocId,
          '0${classCount + 1}'); // Return 'success' and the ID of the added document
    } else {
      WriteBatch batch = firestore.batch();

      CollectionReference classesCollection = firestore.collection('classes');
      CollectionReference messageParticipantsCollection =
          firestore.collection('messageparticipants');
      CollectionReference notificationCollection =
          firestore.collection('notification');
      CollectionReference messagingCollection =
          firestore.collection('messaging');

      Map<String, dynamic> messageData = {
        'lastMessage': '',
        'messageDate': DateTime.now(),
        'messageStatus': {
          'studentRead': '0',
          'tutorRead': '0',
        },
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
        'totalPrice': totalPrice,
        'classReference': '0${classCount + 1}'
      };

      DocumentReference classDocRef = await classesCollection.add(classesData);
      String classDocId = classDocRef.id;
      DocumentReference messageDocRef =
          await messageParticipantsCollection.add(messageData);
      String messageID = messageDocRef.id;
      await notificationCollection.add(notificationData);
      Map<String, dynamic> sendMessageData = {
        'dateSent': DateTime.now(),
        'messageContent': 'Class is Book',
        'messageID': messageID,
        'noofclasses': '',
        'subjectID': '',
        'classPrice': '',
        'type': 'message',
        'userID': studentID
      };
      await messagingCollection.add(sendMessageData);

      await batch.commit();

      return BookingResult('success', classDocId,
          '0${classCount + 1}'); // Return 'success' and the ID of the added document
    }
  } catch (e) {
    return BookingResult('Error: $e', '', '');
  }
}
