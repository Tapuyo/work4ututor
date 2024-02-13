import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> addNewNotification(String type,String message, List<String> userIds) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference notificationCollection =
        firestore.collection('notification');

    Map<String, dynamic> notificationData = {
      'dateNotify': DateTime.now(),
      'notificationContent': message,
      'type': type,
      'userIDs': userIds,
      'status': 'unread',
    };

    await notificationCollection.add(notificationData);

    return 'Success';
  } catch (e) {
    return 'Error: $e';
  }
}

Future<String> updateNotificationStatus(String notificationId, String userID) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference notificationRef =
        firestore.collection('notification').doc(notificationId);

    DocumentSnapshot notificationSnapshot = await notificationRef.get();

    if (notificationSnapshot.exists) {
      List<String> userIDs = List<String>.from(notificationSnapshot['userIDs']);
      if (userIDs.contains(userID)) {
        // Update status to 'read' if userID is found
        await notificationRef.update({'status': 'read'});
        return 'success';
      } else {
        return 'User ID not found in the notification';
      }
    } else {
      return 'Notification not found';
    }
  } catch (e) {
    return 'Error: $e';
  }
}