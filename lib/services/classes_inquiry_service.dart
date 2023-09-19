import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_class/classes_inquiry_model.dart';
import '../data_class/reviewclass.dart';
import '../provider/classes_inquirey_provider.dart';
import '../provider/tutor_reviews_provider.dart';

class ClassesInquiry {
  static Future<void> getClassesInquiry(
      BuildContext context, String userId) async {
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

class IndividualReviews {
  static Future<void> getReviews(BuildContext context, String userId) async {
    List<ReviewModel> reviewdata = [];
    final provider = context.read<IndividualReviewProvider>();

    provider.setLoading(true);
    await FirebaseFirestore.instance
        .collection('review')
        .where('tutorID', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) async {
                ReviewModel classes = ReviewModel(
                    classID: doc['classID'],
                    comment: doc['comment'],
                    datereview: doc['dateReview'].toDate(),
                    rating: doc['rating'],
                    reviewID: doc['reviewID'],
                    studentID: doc['studentID'],
                    subjectID: doc['subjectID'],
                    tutorID: doc['tutorID']);
                reviewdata.add(classes);
              })
            });

    provider.setIndividualReviews(reviewdata);
    provider.setLoading(false);
  }

  static DateTime convertTimeStampToDateTime(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateToTimeStamp;
  }
}
