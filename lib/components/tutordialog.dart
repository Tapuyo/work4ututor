import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_information_signup.dart';

import '../utils/themes.dart';

class DialogShow extends StatelessWidget {
  final String response;
  const DialogShow(this.response, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: null,
        content: null,
        actions: <Widget>[
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/notification.png',
                  width: 300.0,
                  height: 100.0,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Work4ututor Notification",
                  style: TextStyle(
                    color: Color.fromRGBO(1, 118, 132, 1),
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  response.toString(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (response.toString().contains(
                        "The email address is already in use by another account!")) {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TutorInfo()),
                      );
                    }
                  },
                  child: const Text('OK'),
                ),
                 SizedBox(
                width: 600,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 130,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorPrimary,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      onPressed: () {},
                      child: const Text('Update'),
                    ),
                  ),
                ),
              )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context, String response) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: const Text('Work4utuTor Alert'),
              content: Text(response.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TutorInfo()),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}

addsubject(BuildContext context) {
  String? subjectName;
  String? SubjectDescription;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        context = context;
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: null,
            content: null,
            actions: <Widget>[
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/notification.png',
                      width: 300.0,
                      height: 100.0,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      " Work4uTutor Notification",
                      style: TextStyle(
                        // textStyle: Theme.of(context).textTheme.headlineMedium,
                        color:  Color.fromRGBO(1, 118, 132, 1),
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 400,
                          height: 45,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(242, 242, 242, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.grey,
                              hintText: 'Subject Name',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter name of Subject' : null,
                            onChanged: (val) {
                              subjectName = val;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 400,
                          height: 80,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(242, 242, 242, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.grey,
                              hintText: 'Description',
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (val) => val!.isEmpty
                                ? 'Enter subject Description'
                                : null,
                            onChanged: (val) {
                              SubjectDescription = val;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        height: 50,
                        width: 300,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color.fromRGBO(1, 118, 132, 1),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(103, 195, 208, 1),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Color.fromRGBO(
                                    1, 118, 132, 1), // your color here
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            // ignore: prefer_const_constructors
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                          },
                          // icon: const Icon(
                          //   Icons.send,
                          //   size: 30,
                          // ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

showCalendar(BuildContext context) {
  String? subjectName;
  String? SubjectDescription;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        context = context;
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: const Text('Select a date'),
            content: TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2021, 01, 01),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(DateTime.now(), day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                // DateTime.now() = selectedDay;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop(_selectedDate);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
}

chooseLanguage(BuildContext context) {
  var ulanguages = [
    'Filipino',
    'English',
    'Russian',
    'Chinese',
    'Japanese',
  ];
  var dropdownvalue;
  List<String> tlanguages = [];
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        context = context;
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: null,
            content: null,
            actions: <Widget>[
              Container(
                width: 350,
                height: 350,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/notification.png',
                        width: 300.0,
                        height: 100.0,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                     const Text(
                        " Work4uTutor Notification",
                        style: TextStyle(
                          // textStyle: Theme.of(context).textTheme.headlineMedium,
                          color:  Color.fromRGBO(1, 118, 132, 1),
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 300,
                            height: 60,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                ),
                                value: dropdownvalue,
                                hint: const Text("Language to teach"),
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                items: ulanguages.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  tlanguages.add(value.toString());
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromRGBO(1, 118, 132, 1),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromRGBO(103, 195, 208, 1),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color.fromRGBO(
                                      1, 118, 132, 1), // your color here
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              // ignore: prefer_const_constructors
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            // icon: const Icon(
                            //   Icons.send,
                            //   size: 30,
                            // ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
