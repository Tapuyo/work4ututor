class ChatMessage {
  String chatID;
  String lastmessage;
  Map messageStatus;
  String studentFav;
  String studentID;
  String tutorFav;
  String tutorID;
  DateTime messageDate;
  ChatMessage(
      {required this.chatID,
      required this.lastmessage,
      required this.messageStatus,
      required this.studentFav,
      required this.studentID,
      required this.tutorFav,
      required this.tutorID,
      required this.messageDate});
}

class MessageContent {
  String messageID;
  String messageContent;
  DateTime dateSent;
  String userID;
  String type;
  String noofclasses;
  String subjectID;
  String classPrice;
  MessageContent(
      {required this.messageID,
      required this.messageContent,
      required this.dateSent,
      required this.type,
      required this.noofclasses,
      required this.subjectID,
      required this.classPrice,
      required this.userID});
}
