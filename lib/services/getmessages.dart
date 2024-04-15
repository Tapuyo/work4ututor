// ignore_for_file: unused_import

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:universal_html/html.dart' as html;

import '../data_class/chatmessageclass.dart';

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
        messageStatus: data['messageStatus'] ?? [],
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
        noofclasses: data['noofclasses'] ?? '',
        subjectID: data['subjectID'] ?? '',
        type: data['type'] ?? '',
        classPrice: data['classPrice'] ?? '',
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
    'noofclasses': '',
    'subjectID': '',
    'classPrice': '',
    'type': 'message',
    'userID': userID
  });
}

Future<void> updatemessagestatusInfo(
    bool isTutor, String messageID, String count) async {
  try {
    if (isTutor) {
      await FirebaseFirestore.instance
          .collection('messageparticipants')
          .doc(messageID)
          .update({
        "messageDate": DateTime.now(),
        "messageStatus.tutorRead": count,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('messageparticipants')
          .doc(messageID)
          .update({
        "messageDate": DateTime.now(),
        "messageStatus.studentRead": count,
      });
    }

    debugPrint('Read');
  } catch (error) {
    debugPrint('Error: $error');
  }
}
