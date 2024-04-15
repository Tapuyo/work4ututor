import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingNotifier with ChangeNotifier {
  List<Map<String, dynamic>>? _rate = [];

  List<Map<String, dynamic>>? get rate => _rate;

  Future<List<Map<String, dynamic>>?> getRating(String tutorID) async {
    Completer<List<Map<String, dynamic>>?> completer = Completer();

    try {
      FirebaseFirestore.instance
          .collection('myreview')
          .where('tutorID', isEqualTo: tutorID)
          .get()
          .then((QuerySnapshot querySnapshot) {
        _rate = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        notifyListeners();
        completer.complete(_rate);
      }).catchError((error) {
        _rate = null;
        notifyListeners();
        completer.complete(_rate);
      });
    } catch (e) {
      _rate = null;
      notifyListeners();
      completer.complete(_rate);
    }

    return completer.future;
  }
}
