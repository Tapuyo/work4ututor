// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data_class/voucherclass.dart';

class GetVouchers {
  String uid;
  GetVouchers({required this.uid});

  Stream<List<Voucherclass>> get voucherlist {
    return FirebaseFirestore.instance
        .collection('vouchers')
        .doc(uid)
        .collection('myvouchers')
        .snapshots()
        .map(_getVoucher);
  }

  List<Voucherclass> _getVoucher(QuerySnapshot snapshot) {
    return snapshot.docs.map((cardtask) {
      return Voucherclass(
        docID: cardtask.id,
        amount: cardtask['amount'] ?? '',
        expiryDate: cardtask['expiryDate'].toDate() ?? '',
        startDate: cardtask['startDate'].toDate() ?? '',
        voucherName: cardtask['vName'] ?? '',
        vstatus: cardtask['vstatus'] ?? '',
      );
    }).toList();
  }

  void getUserBooks() async {
    await FirebaseFirestore.instance
        .collection('vouchers')
        .doc(uid)
        .collection("myvouchers")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {});
    });
  }
}

// class VoucherProvider with ChangeNotifier {
//   List<Voucherclass> _vouchers = [];
//   bool _isLoading = true;

//   List<Voucherclass> get vouchers => _vouchers;
//   bool get isLoading => _isLoading;

//   Future<void> fetchVouchers(String uid) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('vouchers')
//           .where('vOwner',
//               isEqualTo: uid) // Assuming vouchers are filtered by user ID
//           .get();

//       _vouchers = snapshot.docs.map((doc) {
//         return Voucherclass(
//           amount: doc['amount'] ?? '',
//           expiryDate: doc['expiryDate'].toDate() ?? DateTime.now(),
//           startDate: doc['startDate'].toDate() ?? DateTime.now(),
//           voucherName: doc['vName'] ?? '',
//           vstatus: doc['vstatus'] ?? '',
//         );
//       }).toList();
//     } catch (e) {
//       print('Error fetching vouchers: $e');
//     }

//     _isLoading = false;
//     notifyListeners();
//   }
// }
class VoucherProvider with ChangeNotifier {
  List<Voucherclass> _voucherdetails = [];

  List<Voucherclass> get vouchers => _voucherdetails;

  void fetchVouchers(String studentid) {
    try {
      FirebaseFirestore.instance
          .collection('vouchers')
          .where('vOwner', isEqualTo: studentid)
          .where('vstatus', isEqualTo: 'unclaimed')
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        _voucherdetails = querySnapshot.docs.map((doc) {
          return Voucherclass(
            docID: doc.id,
            amount: doc['amount'] ?? '',
            expiryDate: doc['expiryDate'].toDate() ?? DateTime.now(),
            startDate: doc['startDate'].toDate() ?? DateTime.now(),
            voucherName: doc['vName'] ?? '',
            vstatus: doc['vstatus'] ?? '',
          );
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      _voucherdetails = [];
      notifyListeners();
    }
  }
}
