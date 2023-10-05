// // Import your data class

// import 'package:flutter/material.dart';

// import '../data_class/tutor_info_class.dart';
// import '../services/services.dart';

// class TutorInfoProvider extends ChangeNotifier {
//   List<TutorInformation> _tutorInfoList = [];

//   List<TutorInformation> get tutorInfoList => _tutorInfoList;

//   // Add a method to update the data
//   void updateTutorInfoList(List<TutorInformation> newData) {
//     _tutorInfoList = newData;
//     notifyListeners();
//   }

//   // Add a method to fetch the data from the stream
//   Future<void> fetchTutorInfoData(String uid) async {
//     try {
//       // Replace with your actual data fetching logic using streams
//       List<TutorInformation> data = await TutorInfoData(uid: uid).gettutorinfo;
//       updateTutorInfoList(data);
//     } catch (error) {
//       // Handle errors if needed
//       print('Error fetching data: $error');
//     }
//   }
// }
