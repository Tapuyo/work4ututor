import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final CollectionReference transactionsCollection =
    FirebaseFirestore.instance.collection('transactions');
final CollectionReference paymentsCollection =
    FirebaseFirestore.instance.collection('paymentHistory');
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

Future<String> getPublicIp() async {
  final response = await http.get(Uri.parse('http://ip-api.com/json'));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return data['query']; // This contains the IP address
  } else {
    throw Exception('Failed to get IP address');
  }
}

// Future<void> addPaymentHistory(
//   String classID,
//   int totalClasses,
//   double classPrice,
//   List<String> voucher,
//   double vamount,
//   double vatamount,
//   String invoice,
//   String userId,
//   String classReference,
//   double totalPaid,
// ) async {
//   try {
//     String ipAddress = await getPublicIp();

//     await paymentsCollection.add({
//       'classId': classID,
//       'amountPaid': totalPaid,
//       'datePaid': DateTime.now(),
//       'status': 'Success',
//       'invoiceNo': invoice,
//       'location': ipAddress,
//       'paidBy': userId,
//       'voucherID': voucher,
//       'voucherAmount': vamount,
//       'totalClasses': totalClasses,
//       'classPrice': classPrice,
//       'classReference': classReference,
//       'vatAmount': vatamount,
//     });
//     debugPrint('added');
//   } catch (e) {
//     debugPrint('Error adding transaction: $e');
//   }
// }

Future<void> addPaymentHistory(
  String classID,
  int totalClasses,
  double classPrice,
  List<String> voucherIds,
  double vamount,
  double vatamount,
  String invoice,
  String userId,
  String classReference,
  double totalPaid,
) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  WriteBatch batch = firestore.batch();

  try {
    String ipAddress = await getPublicIp();

    // Add payment history document
    DocumentReference paymentDocRef = paymentsCollection.doc();
    batch.set(paymentDocRef, {
      'classId': classID,
      'amountPaid': totalPaid,
      'datePaid': DateTime.now(),
      'status': 'Success',
      'invoiceNo': invoice,
      'location': ipAddress,
      'paidBy': userId,
      'voucherID': voucherIds,
      'voucherAmount': vamount,
      'totalClasses': totalClasses,
      'classPrice': classPrice,
      'classReference': classReference,
      'vatAmount': vatamount,
    });
    CollectionReference vouchersCollection = firestore.collection('vouchers');
    for (var voucherId in voucherIds) {
      DocumentReference voucherDocRef = vouchersCollection.doc(voucherId);
      batch.update(voucherDocRef, {
        'vstatus': 'claimed', 
      });
    }

    // Commit the batch
    await batch.commit();
    debugPrint('success');
  } catch (e) {
    debugPrint('Error adding transaction: $e');
  }
}
