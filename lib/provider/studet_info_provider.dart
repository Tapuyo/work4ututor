import 'package:flutter/material.dart';
import '../data_class/studentinfoclass.dart';

class StudentInfoProvider with ChangeNotifier {
  late StudentInfoClass _studentData;

  StudentInfoProvider() {
    _studentData = StudentInfoClass(
        userID: '',
        age: '',
        studentID: '',
        studentMiddlename: '',
        studentLastname: '',
        address: '',
        contact: '',
        dateofbirth: '',
        country: '',
        dateregistered: DateTime.now(),
        languages: [],
        emailadd: '',
        profilelink: '',
        studentFirstname: '',
        timezone: '',
        citizenship: [],
        gender: ''); // Initialize _studentData in the constructor
  }

  StudentInfoClass get studentData => _studentData;

  void setStudentData(StudentInfoClass data) {
    _studentData = data;
    notifyListeners();
  }
}
