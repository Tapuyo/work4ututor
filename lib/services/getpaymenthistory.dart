import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentHistoryNotifier with ChangeNotifier {
  List<Map<String, dynamic>> _payments = [];

  List<Map<String, dynamic>> get history => _payments;

  void getHistory(String userid, userType) {
    try {
      FirebaseFirestore.instance
          .collection('paymentHistory')
          .where('paidBy', isEqualTo: userid)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        _payments = querySnapshot.docs.map((doc) {
          final Timestamp timestamp = doc['datePaid'];
          final DateTime date = timestamp.toDate();
          return {
            'id': doc.id,
            'invoice': doc['invoiceNo'],
            'date': date.toString(),
            'amount': doc['amountPaid'],
            'status': doc['status'],
            'classId': doc['classId'],
            'location': doc['location'],
            'paidBy': doc['paidBy'],
          };
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      _payments = [];
      notifyListeners();
    }
  }
}
