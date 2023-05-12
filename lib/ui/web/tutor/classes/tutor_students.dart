// ignore_for_file: unused_element, unused_local_variable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/data_class/studentsEnrolledclass.dart';
import 'package:wokr4ututor/ui/web/tutor/classes/view_classinfo.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../../../../provider/classinfo_provider.dart';

class StudentsEnrolled extends StatefulWidget {
  const StudentsEnrolled({super.key});

  @override
  State<StudentsEnrolled> createState() => _StudentsEnrolledState();
}

class _StudentsEnrolledState extends State<StudentsEnrolled> {
  String actionValue = 'View';
  String dropdownValue = 'English';
  String statusValue = 'Completed';
  Color buttonColor = kCalendarColorAB;
  DateTime? _fromselectedDate;
  DateTime? _toselectedDate;
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _fromselectedDate = pickedDate;
      });
    });
  }
  void _topickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _toselectedDate = pickedDate;
      });
    });
  }

  bool select = false;
  @override
  Widget build(BuildContext context) {
    final bool open = context.select((ViewClassDisplayProvider p) => p.openClassInfo);
    final enrolleelist = Provider.of<List<StudentsList>>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black45,
            width: .1,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(5.0),
            topLeft: Radius.circular(5.0),
          ),
        ),
        width: size.width - 320,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: size.width - 310,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorPrimary,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "STUDENTS ENROLLED",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 12,
                    child: Container(
                      width: size.width - 320,
                      height: 50,
                      child: Card(
                        elevation: 0.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          side: BorderSide(width: .1),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Date Enrolled:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 95,
                                    child: Text(
                                      _fromselectedDate == null
                                          ? 'From'
                                          : DateFormat.yMMMMd()
                                              .format(_fromselectedDate!),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _pickDateDialog();
                                    },
                                    child: const Icon(
                                      Icons.calendar_month,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 95,
                                    child: Text(
                                      _toselectedDate == null
                                          ? 'To'
                                          : DateFormat.yMMMMd()
                                              .format(_toselectedDate!),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _pickDateDialog();
                                    },
                                    child: const Icon(
                                      Icons.calendar_month,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ), const SizedBox(
                              width: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Status:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              width: 150,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: DropdownButton<String>(
                                elevation: 10,
                                value: statusValue,
                                onChanged: (statValue) {
                                  setState(() {
                                    statusValue = statValue!;
                                  });
                                },
                                underline: Container(),
                                items: <String>[
                                  'Completed',
                                  'Ongoing',
                                  'Cancelled',
                                ].map<DropdownMenuItem<String>>((String value1) {
                                  return DropdownMenuItem<String>(
                                    value: value1,
                                    child: Container(
                                      width: 110,
                                      child: Text(
                                        value1,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Subject:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              width: 150,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: DropdownButton<String>(
                                elevation: 10,
                                value: dropdownValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                underline: Container(),
                                items: <String>[
                                  'English',
                                  'Math',
                                  'Filipino',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      width: 110,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kColorPrimary,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                onPressed: () {},
                                child: const Text('Search'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
            Container(
              width: size.width - 320,
              height: size.height -80,
              child: Card(
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  side: BorderSide(width: .1),
                ),
                child: open == false ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        left: 10,
                        right: 10,
                        bottom: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            checkColor: Colors.black,
                            activeColor: Colors.green,
                            value: select,
                            onChanged: (value) {
                              setState(() {
                                select = value!;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          const Text(
                            "Date",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            // flex: 2,
                          ),
                          const Text(
                            "Subject",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            // flex: 1,
                          ),
                          const Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            // flex: 1,
                          ),
                          const Text(
                            "Classes",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            // flex: 3,
                          ),
                          const Text(
                            "Action",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            // flex: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      child: Divider(
                        height: 1,
                        thickness: 2,
                      ),
                    ),
                    Container(
                      width: size.width - 320,
                      height: size.height - 175,
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                color: (index % 2 == 0)
                                    ? Colors.white
                                    : Colors.grey[200],
                                child: InkWell(
                                  highlightColor: kCalendarColorFB,
                                  splashColor: kColorPrimary,
                                  focusColor: Colors.green.withOpacity(0.0),
                                  hoverColor: kColorLight,
                                  onTap: () {
                                    final provider =
                                      context.read<ViewClassDisplayProvider>();
                                  provider.setViewClassinfo(true);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 10,
                                      right: 10,
                                      bottom: 5.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.black,
                                          activeColor: Colors.red,
                                          value: select,
                                          onChanged: (value) {
                                            setState(() {
                                              select = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 275,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              radius: 20.0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Image.asset(
                                                'assets/images/login.png',
                                                width: 300.0,
                                                height: 100.0,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            title:  const Text(
                                              'Melvin Jhon Selma',
                                              style:  TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            subtitle: const Text(
                                              "Philippines",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 160,
                                          child: Text(
                                            DateFormat('MMMM dd, yyyy')
                                                .format(DateTime.now())
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const SizedBox(
                                          width: 120,
                                          child: Text(
                                            "Chemistry ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                            width: 120,
                                            child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: (index.isNegative)
                                                      ? Colors.white
                                                      : kCalendarColorFB,
                                                ),
                                                child: const Align(
                                                    alignment: Alignment.center,
                                                    child:
                                                        Text('Ongoing')))),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                            width: 160,
                                            child: Column(
                                              children: const [
                                                ListTile(
                                                  title: Text('3 Classes'),
                                                  subtitle: Text(
                                                      'Completed: 1 Class/Upcoming: 2 Classes'),
                                                )
                                              ],
                                            )),
                                        const Spacer(),
                                        // SizedBox(
                                        //     width: 200,
                                        //     child: Text(
                                        //         DateTime.now().toString())),
                                        // const Spacer(),
                                        SizedBox(
                                          width: 140,
                                          child: Container(
                                            width: 90,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: buttonColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: DropdownButton<String>(
                                                elevation: 10,
                                                value: actionValue,
                                                onChanged: (actValue) {
                                                  setState(() {
                                                    actionValue = actValue!;
                                                    if (actionValue ==
                                                        'View') {
                                                      buttonColor =
                                                          kCalendarColorAB;
                                                    } else if (actionValue ==
                                                        'Cancel') {
                                                      buttonColor =
                                                          kCalendarColorB;
                                                    } else {
                                                      buttonColor =
                                                          kCalendarColorFB;
                                                    }
                                                  });
                                                },
                                                underline: Container(),
                                                items: <String>[
                                                  'View',
                                                  'Cancel',
                                                  'Reschedule',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String actvalue) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: actvalue,
                                                    child: Container(
                                                      width: 90,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        actvalue,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ) : const ViewClassInfo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
