class TutorInformation {
  final String age;
  final String applicationID;
  final String birthCity;
  final DateTime birthdate;
  final String birthPlace;
  List<dynamic> certificates;
  List<dynamic> certificatestype;
  final String city;
  final String country;
  final String gender;
  List<dynamic> language;
  List<dynamic> citizenship;
  final DateTime dateSign;
  final String emailadd;
  final String extensionName;
  final String firstName;
  final String imageID;
  final String lastname;
  final String middleName;
  List<dynamic> presentation;
  final String promotionalMessage;
  List<dynamic> resume;
  List<dynamic> resumelinktype;
  List<dynamic> servicesprovided;
  List<dynamic> validIds;
  List<dynamic> validIDstype;
  final String timezone;
  final String status;
  final String tutorID;
  final String userId;
  final String withdrawal;
  final String contact;

  TutorInformation({
    required this.certificatestype,
    required this.resumelinktype,
    required this.validIDstype,
    required this.contact,
    required this.age,
    required this.applicationID,
    required this.birthCity,
    required this.birthdate,
    required this.city,
    required this.emailadd,
    required this.timezone,
    required this.language,
    required this.gender,
    required this.citizenship,
    required this.validIds,
    required this.servicesprovided,
    required this.birthPlace,
    required this.certificates,
    required this.country,
    required this.dateSign,
    required this.extensionName,
    required this.firstName,
    required this.imageID,
    required this.lastname,
    required this.middleName,
    required this.presentation,
    required this.promotionalMessage,
    required this.resume,
    required this.status,
    required this.tutorID,
    required this.userId,
    required this.withdrawal,
  });
}
