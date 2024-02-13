import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MaterialNotifier with ChangeNotifier {
  List<Map<String, dynamic>> _materials = [];

  List<Map<String, dynamic>> get materials => _materials;

  void getMaterials(String classid) {
    try {
      FirebaseFirestore.instance
          .collection('classMaterial')
          .where('classid', isEqualTo: classid)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        _materials = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        notifyListeners();
      });
    } catch (e) {
      _materials = [];
      notifyListeners();
    }
  }
}
