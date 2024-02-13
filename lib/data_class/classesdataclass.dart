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
  final String timefrom;
  final String timeto;
  final String classstatus;
  final String meetinglink;

  Schedule({
    required this.scheduleID,
    required this.session,
    required this.schedule,
    required this.timefrom,
    required this.timeto,
    required this.classstatus,
    required this.meetinglink,
  });

  // Convert Schedule instance to a map
  Map<String, dynamic> toMap() {
    return {
      'scheduleID': scheduleID,
      'session': session,
      'schedule': schedule.toIso8601String(), // Convert DateTime to String
      'timefrom': timefrom,
      'timeto': timeto,
      'classstatus': classstatus,
      'meetinglink': meetinglink,
    };
  }
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
  final String subjectStatus;
  final String totaltutors;
  final DateTime datecreated;

  SubjectClass({
    required this.docID,
    required this.subjectID,
    required this.subjectName,
    required this.subjectStatus,
    required this.totaltutors,
    required this.datecreated,
  });
}

class ScheduleData {
  final String studentID;
  final String tutorID;
  final String classID;
  final String scheduleID;
  final TutorInformation? tutorinfo;
  final StudentInfoClass? studentinfo;
  final SubjectClass? subjectinfo;
  final String session;
  final DateTime scheduledate;
  final String timefrom;
  final String timeto;
  final String type;

  ScheduleData({
    required this.studentID,
    required this.tutorID,
    required this.classID,
    required this.scheduleID,
    required this.tutorinfo,
    required this.studentinfo,
    required this.subjectinfo,
    required this.session,
    required this.scheduledate,
    required this.timefrom,
    required this.timeto,
    required this.type,
  });
}
