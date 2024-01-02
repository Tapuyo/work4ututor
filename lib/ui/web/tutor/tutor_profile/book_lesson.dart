// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../data_class/chatmessageclass.dart';
import '../../../../data_class/subject_class.dart';
import '../../../../services/bookingfunctions/addnewbooking.dart';
import '../../../../services/getmessages.dart';
import '../../../../services/sendinquiryproccess.dart';
import '../../../../utils/themes.dart';

class BookLesson extends StatefulWidget {
  final dynamic subject;
  final String noofclasses;
  final String studentdata;
  final dynamic tutordata;
  final List<dynamic> tutorteach;
  const BookLesson(
      {super.key,
      required this.studentdata,
      required this.tutordata,
      required this.tutorteach,
      required this.subject,
      required this.noofclasses});

  @override
  State<BookLesson> createState() => _BookLessonState();
}

class _BookLessonState extends State<BookLesson> {
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
      child: BookLessonBody(
        studentdata: widget.studentdata,
        tutordata: widget.tutordata,
        tutorteach: widget.tutorteach,
      ),
    );
  }
}

class BookLessonBody extends StatefulWidget {
  final String studentdata;
  final dynamic tutordata;
  final List<dynamic> tutorteach;
  final book;
  const BookLessonBody(
      {super.key,
      this.book,
      required this.studentdata,
      required this.tutordata,
      required this.tutorteach});

  @override
  State<BookLessonBody> createState() => _BookLessonBodyState();
}

class _BookLessonBodyState extends State<BookLessonBody> {
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
                          'Payment Area',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'This area will be updated for payment area just a sample.',
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
            Center(
              child: Container(
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
                      (element) => element.subjectName == 'Math',
                    );
                    List<String> idList = [
                      widget.tutordata['userId'],
                      widget.studentdata,
                    ];
                    String result = await addNewBooking(
                        widget.tutordata['userId'],
                        widget.studentdata,
                        myMessage.text,
                        subjectid.subjectId,
                        3,
                        idList);
                    if (result == 'success') {
                      setState(() {
                        CoolAlert.show(
                          context: context,
                          width: 200,
                          type: CoolAlertType.success,
                          title: 'Booking Added',
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
                  },
                  child: const Text(
                    'Pay Now',
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
