// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../provider/init_provider.dart';
import '../../../../services/getenrolledclasses.dart';
import '../../../../utils/themes.dart';
import '../../tutor/calendar/setup_calendar.dart';

class StudentCalendar extends StatefulWidget {
  const StudentCalendar({Key? key}) : super(key: key);

  @override
  State<StudentCalendar> createState() => _StudentCalendarState();
}

class _StudentCalendarState extends State<StudentCalendar> {
//  TableCalendarController _calendarController;
  List<DateTime> highlightedDatesList = [
    DateTime(2023, 6, 10),
    DateTime(2023, 6, 15),
    DateTime(2023, 6, 20),
  ];

  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();

  DateTime _selectedDay = DateTime.now();

  String selectedDate = DateFormat('MMMM dd,').format(DateTime.now());

  int count = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamProvider<List<ClassesData>>.value(
      value: EnrolledClass(uid: 'XuQyf7S8gCOJBu6gTIb0', role: 'student')
          .getenrolled,
      catchError: (context, error) {
        print('Error occurred: $error');
        return [];
      },
      initialData: const [],
      child: const StudentCalendarBody(),
    );
  }
}

class StudentCalendarBody extends StatefulWidget {
  const StudentCalendarBody({Key? key}) : super(key: key);

  @override
  State<StudentCalendarBody> createState() => _StudentCalendarBodyState();
}

class _StudentCalendarBodyState extends State<StudentCalendarBody> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();

  DateTime _selectedDay = DateTime.now();

  String selectedDate = DateFormat('MMMM dd,').format(DateTime.now());

  int count = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final int listIndex = context.select((InitProvider s) => s.listIndex);
    List<ClassesData> enrolledClasses = Provider.of<List<ClassesData>>(context);

    List<ScheduleData> getCombinedSchedule(List<ClassesData> enrolledClasses) {
      List<ScheduleData> schedule = [];

      for (var classesData in enrolledClasses) {
        List<Schedule> scheduleDataList = classesData.schedule;
        for (var scheduleItem in scheduleDataList) {
          String studentID = classesData.studentID;
          String tutorID = classesData.tutorID;
          String classID = classesData.classid;
          String scheduleID = scheduleItem.scheduleID;
          String session = scheduleItem.session;
          DateTime scheduleDateTime = scheduleItem.schedule;
          ScheduleData tempsched = ScheduleData(
              studentID: studentID,
              tutorID: tutorID,
              classID: classID,
              scheduleID: scheduleID,
              tutorinfo: classesData.tutorinfo.first,
              studentinfo: classesData.studentinfo.first,
              subjectinfo: classesData.subjectinfo.first,
              session: session,
              schedule: scheduleDateTime);
          schedule.add(tempsched);
        }
      }
      print('Schedule length ${(schedule.length)}');
      return schedule;
    }

    List<ScheduleData> scheduleList = getCombinedSchedule(enrolledClasses);

    List<ScheduleData> filteredSchedules = scheduleList.where((schedule) {
      DateTime now = DateTime.now();
      DateTime scheduleDate = schedule.schedule;

      // Compare the date field of the schedule with the current date and time
      return DateFormat('yyyy-MM-dd').format(scheduleDate) ==
          DateFormat('yyyy-MM-dd').format(_selectedDay);
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            elevation: 5,
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
                        "CALENDAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Spacer(),
                      // Container(
                      //   height: 35,
                      //   width: 150,
                      //   decoration: const BoxDecoration(
                      //     shape: BoxShape.rectangle,
                      //     color: Color.fromRGBO(1, 118, 132, 1),
                      //     borderRadius: BorderRadius.all(Radius.circular(25)),
                      //   ),
                      //   child: TextButton.icon(
                      //     style: TextButton.styleFrom(
                      //       padding: const EdgeInsets.all(10),
                      //       alignment: Alignment.center,
                      //       foregroundColor:
                      //           const Color.fromRGBO(1, 118, 132, 1),
                      //       disabledBackgroundColor: Colors.white,
                      //       backgroundColor: Colors.white,
                      //       shape: RoundedRectangleBorder(
                      //         side: const BorderSide(
                      //           color: Colors.deepPurple, // your color here
                      //           width: 1,
                      //         ),
                      //         borderRadius: BorderRadius.circular(24.0),
                      //       ),
                      //       // ignore: prefer_const_constructors
                      //       textStyle: TextStyle(
                      //         color: Colors.deepPurple,
                      //         fontSize: 12,
                      //         fontStyle: FontStyle.normal,
                      //         decoration: TextDecoration.none,
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return const CalendarSetup();
                      //         },
                      //       );
                      //     },
                      //     icon: const Icon(
                      //       Icons.calendar_month,
                      //       size: 15,
                      //       color: kColorPrimary,
                      //     ),
                      //     label: const Text(
                      //       'Set Up Calendar',
                      //       style: TextStyle(fontSize: 15),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                enrolledClasses.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 12,
                            child: SizedBox(
                              width: size.width - 320,
                              height: 500,
                              child: Card(
                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                elevation: 0.0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  side: BorderSide(
                                      color: kColorPrimary, width: 4),
                                ),
                                child: MouseRegion(
                                  onHover: (event) {},
                                  cursor: SystemMouseCursors.click,
                                  child: TableCalendar(
                                    shouldFillViewport: false,
                                    firstDay: DateTime(1950, 8),
                                    lastDay: DateTime(5000),
                                    focusedDay: _focusedDay,
                                    calendarFormat: _calendarFormat,
                                    daysOfWeekHeight: 60,
                                    rowHeight: 60,
                                    headerStyle: const HeaderStyle(
                                      titleTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w400),
                                      decoration: BoxDecoration(
                                        color: kColorPrimary,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      formatButtonVisible: false,
                                      leftChevronIcon: Icon(
                                        Icons.arrow_left_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      rightChevronIcon: Icon(
                                        Icons.arrow_right_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                    daysOfWeekStyle: const DaysOfWeekStyle(
                                      weekendStyle: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      weekdayStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    calendarStyle: CalendarStyle(
                                      weekendTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      outsideDaysVisible: true,
                                      cellMargin:
                                          const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      rowDecoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      defaultDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: const Color(0xFF616161),
                                          width: 0.5,
                                        ),
                                      ),
                                      weekendDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: const Color(0xFF616161),
                                          width: 0.5,
                                        ),
                                      ),
                                      defaultTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      todayDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: const Color(0xFF616161),
                                          width: 0.5,
                                        ),
                                      ),
                                      selectedDecoration: BoxDecoration(
                                        color: kColorPrimary,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: kColorPrimary,
                                          width: 0.2,
                                        ),
                                      ),
                                    ),
                                    selectedDayPredicate: (day) {
                                      return isSameDay(_selectedDay, day);
                                    },
                                    onDaySelected: (selectedDay, focusedDay) {
                                      if (!isSameDay(
                                          _selectedDay, selectedDay)) {
                                        setState(() {
                                          _selectedDay = selectedDay;
                                          _focusedDay = focusedDay;
                                        });
                                      }
                                    },
                                    calendarBuilders: CalendarBuilders(
                                      markerBuilder: (context, date, _) {
                                        int count = 0;
                                        for (var highlightedDate
                                            in scheduleList) {
                                          if (isSameDay(
                                              date, highlightedDate.schedule)) {
                                            count++;
                                          }
                                        }

                                        if (count > 0) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 18,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  color: kCalendarColorFB,
                                                ),
                                                child: Text(
                                                  '$count',
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          );
                                        }

                                        return null;
                                      },
                                      todayBuilder: (context, date, _) {
                                        return Container(
                                          margin: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: const Color(0xFF616161),
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            '${date.day}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    onPageChanged: (focusedDay) {
                                      _focusedDay = focusedDay;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: size.width - 310,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 6,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        //todos Update the date strings here
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMMM, dd').format(_selectedDay),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "(${(filteredSchedules.length)} Classes today)",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 600,
                          height: 500,
                          child: filteredSchedules.isNotEmpty
                              ? ListView.builder(
                                  itemCount: filteredSchedules.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 0.0,
                                          left: 10,
                                          right: 10,
                                          bottom: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "08:45",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: 500,
                                              child: Card(
                                                color: index % 2 == 0
                                                    ? kCalendarColorFB
                                                    : kCalendarColorAB,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 6.0, 20.0, 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 25.0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Image.asset(
                                                          'assets/images/login.png',
                                                          width: 300.0,
                                                          height: 100.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${(filteredSchedules[index].tutorinfo.firstName)} ${(filteredSchedules[index].tutorinfo.middleName == 'N/A' ? '' : (filteredSchedules[index].tutorinfo.middleName))} ${(filteredSchedules[index].tutorinfo.lastname)}',
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          Text(
                                                            filteredSchedules[
                                                                    index]
                                                                .subjectinfo
                                                                .subjectName,
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 12.0),
                                                        child: Text((() {
                                                          if (filteredSchedules[
                                                                      index]
                                                                  .session
                                                                  .toString() ==
                                                              '1') {
                                                            return "${(filteredSchedules[index].session.toString())}st Session";
                                                          } else if (filteredSchedules[
                                                                      index]
                                                                  .session
                                                                  .toString() ==
                                                              '2') {
                                                            return "${(filteredSchedules[index].session.toString())}nd Session";
                                                          } else if (filteredSchedules[
                                                                      index]
                                                                  .session
                                                                  .toString() ==
                                                              '3') {
                                                            return "${(filteredSchedules[index].session.toString())}rd Session";
                                                          } else {
                                                            return "${(filteredSchedules[index].session.toString())}th Session";
                                                          }
                                                        })()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/5836.png',
                                        width: 250.0,
                                        height: 150.0,
                                        fit: BoxFit.fill,
                                      ),
                                      const Text(
                                        "No Classes Today",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ]),
                    ),
                  ),
                ),
                Flexible(
                    flex: 6,
                    child: Column(
                      children: const [
                        // if (listIndex == 0) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 1) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 2) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 3) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 4) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 5) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 6) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 7) ...[
                        //   classClick(context)
                        // ] else ...[
                        //   classClick(context)
                        // ],
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// todayBuilder: (context, date, _) {
//   int count = 0;
//   for (var highlightedDate
//       in scheduleList) {
//     if (isSameDay(
//         date, highlightedDate.schedule)) {
//       count++;
//     }
//   }

//   if (count > 0) {
//     bool isTodayHighlighted = scheduleList
//         .any((highlightedDate) =>
//             isSameDay(
//                 date,
//                 highlightedDate
//                     .schedule));

//     if (isTodayHighlighted) {
//       return Container(
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           shape: BoxShape.rectangle,
//           borderRadius:
//               BorderRadius.circular(5),
//           border: Border.all(
//             color: kColorPrimary,
//             width: 0.2,
//           ),
//         ),
//         child: Center(
//           child: Text(
//             '${date.day}',
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.blue,
//       shape: BoxShape.rectangle,
//       borderRadius:
//           BorderRadius.circular(5),
//       border: Border.all(
//         color: kColorPrimary,
//         width: 0.2,
//       ),
//     ),
//     child: Center(
//       child: Text(
//         '${date.day}',
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   );
// },

// CalendarBuilders calendarBuilder() {
//   return CalendarBuilders(
//     todayBuilder: (
//       context,
//       day,
//       focusedDay,
//     ) {
//       return buildCalendarDay(
//           day: DateTime.now().day.toString(),
//           text: '3',
//           backColor: Colors.green);
//     },
//   );
// }

// Container buildCalendarDay({
//   required String day,
//   required Color backColor,
//   required String text,
// }) {
//   return Container(
//     color: backColor,
//     width: 100,
//     height: 55,
//     padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
//     child: Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           const Icon(
//             Icons.circle,
//             size: 20,
//             color: Colors.red,
//           ),
//           Text(day, style: const TextStyle(fontSize: 14, color: Colors.white)),
//         ],
//       ),
//     ),
//   );
// }

AnimatedContainer buildCalendarDayMarker({
  required String text,
  required Color backColor,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: backColor,
    ),
    width: 52,
    height: 13,
    child: Center(
      child: Text(
        text,
        style: const TextStyle().copyWith(
          color: Colors.white,
          fontSize: 10.0,
        ),
      ),
    ),
  );
}

Widget tableLedger(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              Text(
                "Legend",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacer(),
              Icon(
                Icons.list_alt_outlined,
                size: 20,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: kCalendarColorAB,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "Available",
                style: TextStyle(
                  color: ksecondarytextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: kCalendarColorFB,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "Fully Booked",
                style: TextStyle(
                  color: ksecondarytextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: kCalendarColorB,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "Blocked",
                style: TextStyle(
                  color: ksecondarytextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              Text(
                "Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacer(),
              Icon(
                Icons.summarize,
                size: 20,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(.1),
                ),
                child: const Icon(
                  Icons.event_available,
                  color: Colors.green,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Available Dates",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "0",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(.1),
                ),
                child: const Icon(
                  Icons.book,
                  color: Colors.blue,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Booked Dates",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "0",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(.1),
                ),
                child: const Icon(
                  Icons.block,
                  color: Colors.red,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Blocked Dates",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "0",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget listClasses(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width - 310,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                //todos Update the date strings here
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "March, 27",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "(3 Classes today)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 600,
                  height: 500,
                  child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: null,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "08:45",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Card(
                                  color: index % 2 == 0
                                      ? Colors.blue
                                      : Colors.green,
                                  margin: const EdgeInsets.fromLTRB(
                                      20.0, 6.0, 20.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25.0,
                                          backgroundColor: index % 2 == 0
                                              ? Colors.blue
                                              : Colors.green,
                                          child: Image.asset(
                                            'assets/images/login.png',
                                            width: 300.0,
                                            height: 100.0,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Melvin Jhon Selma",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text('Chemistry'),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.0),
                                          child: Text('First Class'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ]),
            ),
          ),
        ),
        const Flexible(flex: 6, child: Placeholder())
      ],
    ),
  );
}

Widget classClick(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Material(
    child: SizedBox(
      width: 600,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "08:45",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Card(
                      color: Colors.green,
                      margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.green,
                              child: Image.asset(
                                'assets/images/login.png',
                                width: 300.0,
                                height: 100.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  "Melvin Jhon Selma",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text('Chemistry'),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: Text('First Class'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    ),
  );
}
