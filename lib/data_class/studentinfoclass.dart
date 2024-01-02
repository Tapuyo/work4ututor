class StudentInfoClass {
  final String address;
  final String age;
  final String contact;
  final String country;
  final String dateofbirth;
  final DateTime dateregistered;
  final String studentFirstname;
  final String studentMiddlename;
  final String studentLastname;
  final String studentID;
  final String userID;
  final String emailadd;
  final List<String> languages;
  final String profilelink;
  final String timezone;

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
    required this.dateregistered,
    required this.age,
    required this.dateofbirth,
    required this.timezone,
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

class RecentUser {
  final String? icon, name, date, posts, role, email;

  RecentUser(
      {this.icon, this.name, this.date, this.posts, this.role, this.email});
}

List recentUsers = [
  RecentUser(
    icon: "assets/icons/xd_file.svg",
    name: "Melvin Jhon Selma",
    role: "Philippines",
    email: "de***ak@huawei.com",
    date: "01-03-2021",
    posts: "Registered",
  ),
  RecentUser(
    icon: "assets/icons/Figma_file.svg",
    name: "Sarrah Avelino",
    role: "Philippines",
    email: "se****k1@google.com",
    date: "27-02-2021",
    posts: "Registered",
  ),
  RecentUser(
    icon: "assets/icons/doc_file.svg",
    name: "James Lebron",
    role: "Philippines",
    email: "ne****tr@google.com",
    date: "23-02-2021",
    posts: "Registered",
  ),
];
