import 'package:flutter/material.dart';

class ViewClassDisplayProvider with ChangeNotifier {
  bool _openClassinfo = false;

  bool get openClassInfo => _openClassinfo;

  void setViewClassinfo(bool set) {
    _openClassinfo = set;
    notifyListeners();
  }
}

// class SearchTutor with ChangeNotifier {
//   String _name = '';
//   String get name => _name;
//   void setSearchTutorName(String set) {
//     _name = set;
//     notifyListeners();
//   }
// }
