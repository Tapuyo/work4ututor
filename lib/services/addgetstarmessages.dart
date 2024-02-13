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
    print('List updated in Firestore');
  } catch (e) {
    print('Error updating list: $e');
  }
}


class StarMessagesNotifier with ChangeNotifier {
  final CollectionReference starredMessagesCollection =
      FirebaseFirestore.instance.collection('starredmessages');

  List<String> _starMessages = [];
  bool _isFetching = false;

  List<String> get starMessages => _starMessages;
  bool get isFetching => _isFetching;

  Future<void> fetchPreferredTutors(String userID) async {
    try {
      _isFetching = true; // Set the flag to true before fetching
      notifyListeners();

      DocumentSnapshot messageDoc = await starredMessagesCollection.doc(userID).get();

      if (messageDoc.exists) {
        _starMessages = List<String>.from(messageDoc['messageIds']);
      } else {
      }
    } catch (e) {
      print('Error getting starred messages: $e');
    } finally {
      _isFetching = false; // Set the flag back to false after fetching
      notifyListeners();
    }
  }
}