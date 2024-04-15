import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final CollectionReference transactionsCollection =
    FirebaseFirestore.instance.collection('transactions');

Future<void> addTransactionInFirestore(
  String classID,
  int totalClasses,
  double totalPrice,
) async {
  try {
    await transactionsCollection.add({
      'classID': classID,
      'totalClasses': totalClasses,
      'totalPrice': totalPrice,
      'datepaid': DateTime.now(),
      'status': 'Paid',
      'type': 'Payment',
    });
    debugPrint('Transaction added to Firestore');
  } catch (e) {
    debugPrint('Error adding transaction: $e');
  }
}
