class StudentInfoClass {
  final String address;
  final String country;
  final String studentFirstname;
  final String studentMiddlename;
  final String studentLastname;
  final String studentID;
  final String userID;
  final String contact;
  final String emailadd;
  final List<String> languages;
  final String profilelink;

  StudentInfoClass({
    required this.contact,
    required this.emailadd,
    required this.languages,
    required this.address,
    required this.country,
    required this.studentFirstname,
    required this.studentMiddlename,
    required this.studentLastname,
    required this.studentID,
    required this.userID,
    required this.profilelink,
  });
}

class StudentGuardianClass {
  final String docID;
  final String address;
  final String contact;
  final String guardianFirstname;
  final String guardianMiddlename;
  final String guardianLastname;
  final String email;
  final String country;
  StudentGuardianClass({
    required this.docID,
    required this.address,
    required this.country,
    required this.guardianFirstname,
    required this.guardianMiddlename,
    required this.guardianLastname,
    required this.email,
    required this.contact,
  });
}
