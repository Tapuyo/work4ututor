import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:universal_html/html.dart' as html;

Future<void> updateUserStatus(
  String uid,
  String status,
  String reason,
  String email,
  String role,
) async {
  try {
    await FirebaseFirestore.instance.collection('user').doc(uid).set({
      "status": status,
    }, SetOptions(merge: true));
    addCancelledAccounts(uid, reason, email, role);
    html.window.alert('Account Cancelled Successfuly');
  } catch (error) {
    html.window.alert('Cancellation Failed: $error');
  }
}

addCancelledAccounts(String uID, reason, email, role) {
  FirebaseFirestore.instance.collection('cancelledaccounts').add({
    'datecancelled': DateTime.now(),
    'emailadd': email,
    'reason': reason,
    'role': role,
    'userID': uID
  });
}
