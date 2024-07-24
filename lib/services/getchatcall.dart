import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CallChatNotifier with ChangeNotifier {
  List<Map<String, dynamic>> _chatdetails = [];

  List<Map<String, dynamic>> get chats => _chatdetails;

  void getChats(String chatId) {
    try {
      FirebaseFirestore.instance
          .collection('files')
          .where('chatId', isEqualTo: chatId)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        _chatdetails = querySnapshot.docs.map((doc) {
           final Timestamp timestamp = doc['name'];
          final DateTime date = timestamp.toDate();

          return {
            'docid': doc.id,
            'chatId': doc['chatId'] ?? '',
            'downloadUrl': doc['downloadUrl'] ?? '',
            'name': timestamp,
            'type': doc['type'] ?? '',
          };
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      _chatdetails = [];
      notifyListeners();
    }
  }
}
