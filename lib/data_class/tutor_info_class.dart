class TutorInformation {
  dynamic language = List<String>;
  final String birthPlace;
  dynamic certificates = List<String>;
  final String country;
  final String dateSign;
  final String extensionName;
  final String firstName;
  dynamic imageID = List<String>;
  final String lastname;
  final String middleName;
  final String presentation;
  final String promotionalMessage;
  final String resume;
  final String status;
  final String tutorID;
  final String userId;
  final String withdrawal;

  TutorInformation({
    required this.language,
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
