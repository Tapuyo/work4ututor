import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data_class/chatmessageclass.dart';

class MessageNotifier with ChangeNotifier {
  List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void getHistory(String userid, userType) {
    try {
      if (userType == 'student') {
        FirebaseFirestore.instance
            .collection('messageparticipants')
            .where('studentID', isEqualTo: userid)
            .where('messageStatus.studentRead', isEqualTo: '1')
            .snapshots()
            .listen((QuerySnapshot querySnapshot) {
          _messages = querySnapshot.docs.map((doc1) {
            final doc = doc1.data() as Map<String, dynamic>;
            final DateTime date = doc['messageDate']?.toDate();

            return ChatMessage(
              chatID: doc1.id,
              lastmessage: doc['lastmessage'] ?? '',
              messageStatus: doc['messageStatus'] ?? [],
              studentFav: doc['studentFav'] ?? '',
              studentID: doc['studentID'] ?? '',
              tutorFav: doc['tutorFav'] ?? '',
              tutorID: doc['tutorID'] ?? '',
              messageDate: date,
            );
          }).toList();
          notifyListeners();
        });
      } else {
        FirebaseFirestore.instance
            .collection('messageparticipants')
            .where('tutorID', isEqualTo: userid)
            .where('messageStatus.tutorRead', isEqualTo: '1')
            .snapshots()
            .listen((QuerySnapshot querySnapshot) {
          _messages = querySnapshot.docs.map((doc1) {
            final doc = doc1.data() as Map<String, dynamic>;
            final DateTime date = doc['messageDate']?.toDate();

            return ChatMessage(
              chatID: doc1.id,
              lastmessage: doc['lastmessage'] ?? '',
              messageStatus: doc['messageStatus'] ?? [],
              studentFav: doc['studentFav'] ?? '',
              studentID: doc['studentID'] ?? '',
              tutorFav: doc['tutorFav'] ?? '',
              tutorID: doc['tutorID'] ?? '',
              messageDate: date,
            );
          }).toList();
          notifyListeners();
        });
      }
    } catch (e) {
      _messages = [];
      notifyListeners();
    }
  }
}
