import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartNotifier with ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  void getCart(String studentid) {
    try {
      FirebaseFirestore.instance
          .collection('mycart')
          .where('studentid', isEqualTo: studentid)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        _cart = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        notifyListeners();
      });
    } catch (e) {
      _cart = [];
      notifyListeners();
    }
  }
}
