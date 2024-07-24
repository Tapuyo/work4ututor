import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardDetailsNotifier with ChangeNotifier {
  List<Map<String, dynamic>> _carddetails = [];

  List<Map<String, dynamic>> get cards => _carddetails;

  void getCards(String tutorid) {
    try {
      FirebaseFirestore.instance
          .collection('tutorAccounts')
          .where('tutorId', isEqualTo: tutorid)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        _carddetails = querySnapshot.docs.map((doc) {
          final Timestamp timestamp = doc['dateRegistered'];
          final DateTime date = timestamp.toDate();

          return {
            'id': doc.id,
            'accountHolder': doc['accountHolder'] ?? '',
            'dateRegistered': date.toString(),
            'accountNumber': doc['accountNumber'] ?? '',
            'address': doc['address'] ?? '',
            'bankName': doc['bankName'] ?? '',
            'ifscCode': doc['ifscCode'] ?? '',
            'tutorId': doc['tutorId'] ?? '',
          };
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      _carddetails = [];
      notifyListeners();
    }
  }
}
