import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final CollectionReference starredMessagesCollection =
    FirebaseFirestore.instance.collection('starredmessages');

Future<void> updateStarredMessagesInFirestore(
    List<String> starredMessageIds, String userId) async {
  try {
    await starredMessagesCollection.doc(userId).set({
      'messageIds': FieldValue.arrayUnion(starredMessageIds),
    });
  } catch (e) {
    print('Error updating list: $e');
  }
}

class StarMessagesNotifier with ChangeNotifier {
  // final CollectionReference starredMessagesCollection =
  //     FirebaseFirestore.instance.collection('starredmessages');

  List<String> _starMessages = [];

  List<String> get starMessages => _starMessages;

  // void fetchPreferredTutors(String userID) async {
  //   try {
  //     DocumentSnapshot messageDoc =
  //         await starredMessagesCollection.doc(userID).get();

  //     if (messageDoc.exists) {
  //       _starMessages = List<String>.from(messageDoc['messageIds']);
  //       notifyListeners(); // Notify listeners again to update the UI
  //     } else {
  //       _starMessages = [];
  //       notifyListeners(); // Notify listeners again to update the UI
  //     }
  //   } catch (e) {
  //     _starMessages = [];
  //     notifyListeners(); // Notify listeners again to update the UI
  //   }
  // }

  void fetchPreferredTutors(String uid) async {
    try {
      FirebaseFirestore.instance
          .collection('starredmessages')
          .doc(uid)
          .snapshots()
          .listen((DocumentSnapshot doc) {
        if (doc.exists) {
          _starMessages = List<String>.from(doc['messageIds']);
        } else {
          _starMessages = [];
        }
        notifyListeners();
      });
    } catch (e) {
      _starMessages;
      notifyListeners();
    }
  }
}
