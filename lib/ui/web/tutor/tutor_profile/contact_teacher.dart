// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/data_class/subject_class.dart';

import '../../../../data_class/chatmessageclass.dart';
import '../../../../services/getmessages.dart';
import '../../../../services/sendinquiryproccess.dart';
import '../../../../utils/themes.dart';

class ContactTeacher extends StatefulWidget {
  final String studentdata;
  final dynamic tutordata;
  final List<dynamic> tutorteach;
  const ContactTeacher(
      {super.key,
      required this.studentdata,
      required this.tutordata,
      required this.tutorteach});

  @override
  State<ContactTeacher> createState() => _ContactTeacherState();
}

class _ContactTeacherState extends State<ContactTeacher> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // StreamProvider<List<StudentsList>>.value(
        //   value: DatabaseService(uid: '').enrolleelist,
        //   catchError: (context, error) {
        //     print('Error occurred: $error');
        //     return [];
        //   },
        //   initialData: const [],
        // ),
        StreamProvider<List<ChatMessage>>.value(
          value: GetMessageList(uid: widget.studentdata, role: 'student')
              .getmessageinfo,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),
      ],
      child: ContactTeacherBody(
        studentdata: widget.studentdata,
        tutordata: widget.tutordata,
        tutorteach: widget.tutorteach,
      ),
    );
  }
}

class ContactTeacherBody extends StatefulWidget {
  final dynamic studentdata;
  final dynamic tutordata;
  final List<dynamic> tutorteach;
  const ContactTeacherBody(
      {super.key,
      required this.studentdata,
      required this.tutordata,
      required this.tutorteach});

  @override
  State<ContactTeacherBody> createState() => _ContactTeacherBodyState();
}

class _ContactTeacherBodyState extends State<ContactTeacherBody> {
  final TextEditingController subjectnameController = TextEditingController();

  final TextEditingController numberofclassController = TextEditingController();
  final TextEditingController myMessage = TextEditingController();

  List<String> provided = [
    '4',
    '6',
    '7',
    '8',
    '9',
  ];
  List<String> subjects = [];
  final int startHour = 0;
  final int endHour = 24;
  String dateselected = '';
  @override
  void initState() {
    super.initState();
    for (dynamic tutor in widget.tutorteach) {
      if (tutor is Map<String, dynamic> && tutor.containsKey('subjectname')) {
        subjects.add(tutor['subjectname']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagelist = Provider.of<List<ChatMessage>>(context);
    final subjectlist = Provider.of<List<Subjects>>(context);
    print(subjectlist.length);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: 400,
        height: 400,
        child: Column(
          children: [
            SizedBox(
              width: 400,
              height: 100,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/5836.png',
                      width: 200.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Custom Classes',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Select your subject and how many classes you want and ask for the pricing.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Subject to Avail',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: TypeAheadField(
                          hideOnEmpty: false,
                          textFieldConfiguration: TextFieldConfiguration(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            autofocus: false,
                            controller: subjectnameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Subject',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return subjects.where((item) => item
                                .toLowerCase()
                                .contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(
                                suggestion.toString(),
                              ),
                            );
                          },
                          onSuggestionSelected: (selectedItem) {
                            setState(() {
                              subjectnameController.text =
                                  selectedItem.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Number of Classes',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 150,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: TypeAheadField(
                          hideOnEmpty: false,
                          textFieldConfiguration: TextFieldConfiguration(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            autofocus: false,
                            controller: numberofclassController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ex. 2',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return provided.where((item) => item
                                .toLowerCase()
                                .contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(
                                suggestion.toString(),
                              ),
                            );
                          },
                          onSuggestionSelected: (selectedItem) {
                            setState(() {
                              numberofclassController.text =
                                  selectedItem.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Message to Tutor',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 400,
              height: 120,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: TextFormField(
                controller: myMessage,
                textAlignVertical: TextAlignVertical.top,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.grey,
                  hintText: 'Add Message',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    inherit: true,
                  ),
                  alignLabelWithHint: true,
                  hintMaxLines: 10,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorLight,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
                onPressed: () async {
                  Subjects subjectid = subjectlist.firstWhere(
                    (element) =>
                        element.subjectName == subjectnameController.text,
                  );
                  bool isMessageFound = messagelist.any(
                    (message) =>
                        message.tutorID == widget.tutordata['userId'] &&
                        message.studentID == widget.studentdata,
                  );

                  if (isMessageFound) {
                    ChatMessage uniqueId = messagelist.firstWhere(
                      (message) =>
                          message.tutorID == widget.tutordata['userId'] &&
                          message.studentID == widget.studentdata,
                    );

                    String result = await sendInquiryToDatabasefoundcontact(
                        widget.tutordata['userId'],
                        widget.studentdata,
                        myMessage.text,
                        subjectid.subjectId,
                        numberofclassController.text,
                        uniqueId.chatID);
                    if (result == 'success') {
                      setState(() {
                        CoolAlert.show(
                          context: context,
                          width: 200,
                          type: CoolAlertType.success,
                          title: 'Inquiry Sent',
                          text: 'You can view the inquiry in the messages!',
                          autoCloseDuration: const Duration(seconds: 1),
                        );
                      });
                    } else {
                      CoolAlert.show(
                        context: context,
                        width: 200,
                        type: CoolAlertType.error,
                        title: 'Oops...',
                        text: result.toString(),
                        backgroundColor: Colors.black,
                      );
                    }
                  } else {
                    String result = await sendInquiryToDatabase(
                        widget.tutordata['userId'],
                        widget.studentdata,
                        myMessage.text,
                        subjectid.subjectId,
                        numberofclassController.text);
                    if (result == 'success') {
                      setState(() {
                        CoolAlert.show(
                          context: context,
                          width: 200,
                          type: CoolAlertType.success,
                          title: 'Inquiry Sent',
                          text: 'You can view the inquiry in the messages!',
                          autoCloseDuration: const Duration(seconds: 1),
                        );
                      });
                    } else {
                      CoolAlert.show(
                        context: context,
                        width: 200,
                        type: CoolAlertType.error,
                        title: 'Oops...',
                        text: result.toString(),
                        backgroundColor: Colors.black,
                      );
                    }
                  }
                },
                child: const Text(
                  'Send Inquiry',
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
