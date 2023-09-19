import 'package:work4ututor/data_class/studentinfoclass.dart';
import 'package:work4ututor/data_class/tutor_info_class.dart';

class ClassesData {
  final String classid;
  final String subjectID;
  final String tutorID;
  final String studentID;
  List<ClassesMaterials> materials;
  List<Schedule> schedule;
  List<Score> score;
  final String status;
  final String totalClasses;
  final String completedClasses;
  final String pendingClasses;
  final DateTime dateEnrolled;
  List<StudentInfoClass> studentinfo;
  List<TutorInformation> tutorinfo;
  List<SubjectClass> subjectinfo;

  ClassesData({
    required this.classid,
    required this.subjectID,
    required this.tutorID,
    required this.studentID,
    required this.materials,
    required this.schedule,
    required this.score,
    required this.status,
    required this.totalClasses,
    required this.completedClasses,
    required this.pendingClasses,
    required this.dateEnrolled,
    required this.studentinfo,
    required this.tutorinfo,
    required this.subjectinfo,
  });
}

class ClassesMaterials {
  final String materialID;
  final String session;
  final List<String> materials;

  ClassesMaterials({
    required this.materialID,
    required this.session,
    required this.materials,
  });
}

class Schedule {
  final String scheduleID;
  final String session;
  final DateTime schedule;

  Schedule({
    required this.scheduleID,
    required this.session,
    required this.schedule,
  });
}

class Score {
  final String scoreID;
  final String score;
  final String comment;

  Score({
    required this.scoreID,
    required this.score,
    required this.comment,
  });
}

class SubjectClass {
  final String docID;
  final String subjectID;
  final String subjectName;
  final DateTime datecreated;

  SubjectClass({
    required this.docID,
    required this.subjectID,
    required this.subjectName,
    required this.datecreated,
  });
}

class ScheduleData {
  final String studentID;
  final String tutorID;
  final String classID;
  final String scheduleID;
  TutorInformation tutorinfo;
  StudentInfoClass studentinfo;
  SubjectClass subjectinfo;
  final String session;
  final DateTime schedule;

  ScheduleData({
    required this.studentID,
    required this.tutorID,
    required this.classID,
    required this.scheduleID,
    required this.tutorinfo,
    required this.studentinfo,
    required this.subjectinfo,
    required this.session,
    required this.schedule,
  });
}
