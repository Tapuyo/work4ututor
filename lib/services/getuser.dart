import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:universal_html/html.dart' as html;
import '../data_class/user_class.dart';

class GetUsersData {
  final String uid;
  GetUsersData({required this.uid});

  List<UserData> _getUser(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return [
      UserData(
        email: snapshot.get('email') ?? '',
        status: snapshot.get('status') ?? '',
        role: snapshot.get('role') ?? '',
        uid: snapshot.id,
      )
    ];
  }

  Stream<List<UserData>> get getUserinfo {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .snapshots()
        .map(_getUser);
  }
}

Future<void> updateEmailAndPassword(String email, String password) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;

  if (user != null) {
    try {
      // Update email
      await user.updateEmail(email);

      // Update password
      await user.updatePassword(password);

      html.window.alert('Update Successful');
    } catch (error) {
      html.window.alert('Update Failed: $error');
    }
  }
}
