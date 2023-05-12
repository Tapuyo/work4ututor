import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/data_class/classes_inquiry_model.dart';
import 'package:wokr4ututor/provider/classes_inquirey_provider.dart';
import 'package:wokr4ututor/provider/user_id_provider.dart';

class ClassesInquiry {
  static Future<void> getClassesInquiry(BuildContext context, String userId) async {
    
    List<ClassesInquiryModel> classesInquiry = [];
    final provider = context.read<ClassesInquiryProvider>();

    provider.setLoading(true);
    await FirebaseFirestore.instance
        .collection('classInquiry')
        .where('tutorId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) async {

                ClassesInquiryModel classes = ClassesInquiryModel(
                    uid: doc.id,
                    className: doc['className'],
                    dateTime: doc['dateTime'].toDate(),
                    message: doc['message'],
                    studentId: doc['studentId'],
                    studentName: doc['studentName'],
                    tutorId: doc['tutorId']);
                classesInquiry.add(classes);
              })
            });

    provider.setClassesInquiry(classesInquiry);
    provider.setLoading(false);
  }

  static DateTime convertTimeStampToDateTime(int timeStamp) {
     var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
     return dateToTimeStamp;
   }
}
