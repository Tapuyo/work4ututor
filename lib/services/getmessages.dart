import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wokr4ututor/data_class/chatmessageclass.dart';

import 'package:universal_html/html.dart' as html;

class GetMessageList {
  final String uid;
  final String role;

  GetMessageList({required this.uid, required this.role});

  List<ChatMessage> _getStudentsInfo(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return [
      ChatMessage(
        chatID: snapshot.id,
        lastmessage: data['lastmessage'] ?? '',
        messageStatus: data['messageStatus'] ?? '',
        studentFav: data['studentFav'] ?? '',
        studentID: data['studentID'] ?? '',
        tutorFav: data['tutorFav'] ?? '',
        tutorID: data['tutorID'] ?? '',
        messageDate: data['messageDate']?.toDate() ?? '',
      ),
    ];
  }

  Stream<List<ChatMessage>> get getmessageinfo {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('messageparticipants');

    Query query;

    if (role == 'student') {
      query = collection.where('studentID', isEqualTo: uid);
    } else if (role == 'tutor') {
      query = collection.where('tutorID', isEqualTo: uid);
    } else {
      query = collection;
    }

    return query.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map(_getStudentsInfo).expand((x) => x).toList());
  }
}

class GetMessageConversation {
  final String chatID;
  final String userID;

  GetMessageConversation({required this.chatID, required this.userID});

  List<MessageContent> _getStudentsInfo(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return [
      MessageContent(
        messageID: data['messageID'] ?? '',
        messageContent: data['messageContent'] ?? '',
        userID: data['userID'] ?? '',
        dateSent: data['dateSent']?.toDate() ?? '',
      ),
    ];
  }

  Stream<List<MessageContent>> get getmessage {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('messaging');

    Query query;
    query = collection.where('messageID', isEqualTo: chatID);

    return query.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map(_getStudentsInfo).expand((x) => x).toList());
  }
}

sendmessage(String messageContent, messageID, userID) async {
  return await FirebaseFirestore.instance.collection('messaging').add({
    'dateSent': DateTime.now(),
    'messageContent': messageContent,
    'messageID': messageID,
    'userID': userID
  });
}

Future<void> updatemessagestatusInfo(
  String messageID,
) async {
  debugPrint(messageID);
  try {
    await FirebaseFirestore.instance
        .collection('messageparticipants')
        .doc(messageID)
        .set({
      "messageStatus": 'read',
    }, SetOptions(merge: true));
    debugPrint('Update Successful');
  } catch (error) {
    debugPrint('Update Failed: $error');
  }
}
