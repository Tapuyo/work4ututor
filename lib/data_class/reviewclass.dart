class ReviewModel {
  String classID;
  String comment;
  DateTime datereview;
  String rating;
  String reviewID;
  String studentID;
  String subjectID;
  String tutorID;

  ReviewModel(
      {required this.classID,
      required this.comment,
      required this.datereview,
      required this.rating,
      required this.reviewID,
      required this.studentID,
      required this.subjectID,
      required this.tutorID});
}
