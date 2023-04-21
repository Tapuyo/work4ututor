import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wokr4ututor/services/services.dart';
class UserDataService{
  final String userUID;
  UserDataService({required this.userUID});

  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('tutor');

   Future addScheduleTimeavailable() async {
    try {
      //create a new document for the user with the uid
      await DatabaseService(uid: userUID)
          .addTutoravailbaleDays();
      return userUID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  
  Future addDayoffs() async {
    try {
      //create a new document for the user with the uid
      await DatabaseService(uid: userUID)
          .addDayoffs();
      return userUID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
