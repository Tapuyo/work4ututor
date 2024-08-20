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
        _cart = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['docid'] = doc.id; // Include the document ID in the map
          return data;
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      _cart = [];
      notifyListeners();
    }
  }
}


Future<String> deleteCartItem(String docId) async {
  try {
    await FirebaseFirestore.instance.collection('mycart').doc(docId).delete();
    print("Document with ID: $docId deleted successfully.");
    return 'success';
  } catch (e) {
    return 'failed';
  }
}
