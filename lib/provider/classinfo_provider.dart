import 'package:flutter/material.dart';

import '../data_class/classesdataclass.dart';

class ViewClassDisplayProvider with ChangeNotifier {
  bool _openClassinfo = false;

  bool get openClassInfo => _openClassinfo;

  void setViewClassinfo(bool set) {
    _openClassinfo = set;
    notifyListeners();
  }
}

class SelectedClassInfoProvider with ChangeNotifier {
 ClassesData _selectedclass = ClassesData(
      classid: '',
      subjectID: '',
      tutorID: '',
      studentID: '',
      materials: [],
      schedule: [],
      score: [],
      status: '',
      totalClasses: '',
      completedClasses: '',
      pendingClasses: '',
      dateEnrolled: DateTime.now(),
      studentinfo: [],
      tutorinfo: [],
      subjectinfo: [],
      price: 0);

  ClassesData get selectedclass => _selectedclass;

  void setSelectedClass(ClassesData set) {
    _selectedclass = set;
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
