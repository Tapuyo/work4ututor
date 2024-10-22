import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/init_provider.dart';
import '../../../../services/getenrolledclasses.dart';
import '../../../../utils/themes.dart';
import '../calendar/setup_calendar.dart';

class ViewScheduleData extends StatefulWidget {
  final dynamic data;
  const ViewScheduleData({super.key, required this.data});
  @override
  State<ViewScheduleData> createState() => _ViewScheduleDataState();
}

class _ViewScheduleDataState extends State<ViewScheduleData> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<ClassesData>>.value(
          value: EnrolledClass(uid: widget.data['userId'], role: 'tutor', targetTimezone: '',)
              .getenrolled,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),
      ],
      child: CalendarDialog(
        data: widget.data,
      ),
    );
  }
}

class CalendarDialog extends StatefulWidget {
  final dynamic data;

  const CalendarDialog({super.key, required this.data});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  final DateTime _selectedDate = DateTime.now();
  final int startHour = 0;
  final int endHour = 24;
  String dateselected = '';
  List<String> dayOffs = [];
  List<DateTime> dayOffsdate = []; // Specify the day-offs as dates

  // Function to check if a date is a day off (red)
  //list var
  int listItemCount = 24 * 60 ~/ 5;
  List<TimeOfDay> indexCollection = [];
  int? indexSelect;
  TimeOfDay? selectedTime;
  bool isDayOff(DateTime date) {
    return dayOffs.contains(DateFormat('EEEE').format(date));
  }

  bool isDayOffdate(DateTime date) {
    date = DateTime(
        date.year, date.month, date.day); // Removing the time component
    return dayOffsdate.any((dayOff) =>
        dayOff.year == date.year &&
        dayOff.month == date.month &&
        dayOff.day == date.day);
  }

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool daystatus = false;
  String selectedDate = DateFormat('MMMM dd,').format(DateTime.now());
  int count = 0;
  @override
  void initState() {
    super.initState();
    getDataFromTutorScheduleCollection(
      widget.data['userId'],
    );
    getDataFromTutorScheduleCollectionavilableTime(
      widget.data['userId'],
    );
    getDataFromTutorScheduleCollectionBlockDateTime(
      widget.data['userId'],
    );
    getDataFromTutorScheduleCollectionAvailableDateTime(
      widget.data['userId'],
    );
    _controller1.addListener(() {
      _controller2.jumpTo(_controller1.offset);
    });

    _controller2.addListener(() {
      _controller1.jumpTo(_controller2.offset);
    });
  }

  Future<void> getTimeAvailableForSpecificUID(String uid) async {
    try {
      // Query the "tutorSchedule" collection where 'uid' is equal to the provided UID
      QuerySnapshot tutorScheduleQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('tutorSchedule')
          .where('uid', isEqualTo: uid)
          .get();

      // Loop through the documents in the "tutorSchedule" collection
      tutorScheduleQuerySnapshot.docs.forEach((tutorScheduleDoc) async {
        // Access the 'timeavailable' subcollection for this specific document
        QuerySnapshot timeAvailableQuerySnapshot =
            await tutorScheduleDoc.reference.collection('timeavailable').get();

        // Now, you can work with the documents in the "timeavailable" subcollection
        for (var timeAvailableDoc in timeAvailableQuerySnapshot.docs) {
          // Access the data within each document in the subcollection
          Map<String, dynamic> data =
              timeAvailableDoc.data() as Map<String, dynamic>;
          // Do something with the data...
          setState(() {
            // Extract the "timefrom" and "timeend" fields
            String timefrom = data['timeAvailableFrom'];
            String timeend = data['timeAvailableTo'];
          });
        }
      });
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  Future<void> getDataFromTutorScheduleCollection(String uid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tutorSchedule')
          .where('uid', isEqualTo: uid)
          .get();

      // Loop through the documents in the collection
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Access the data fields you need
        String uid = data['uid'] ?? [];
        List<dynamic> dateoffselected = data['dateoffselected'] != null
            ? List<dynamic>.from(data['dateoffselected'])
            : [];

        // Convert the timestamp strings to DateTime objects
        setState(() {
          dayOffs = List<String>.from(data['dayoffs'] ?? []);

          dayOffsdate = dateoffselected
              .map((dateString) => DateTime.tryParse(dateString))
              .where((date) => date != null)
              .cast<DateTime>()
              .toList();
                });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  String timeFrom = '12:00 AM';
  String timeTo = '11:59 PM';
  Future<void> getDataFromTutorScheduleCollectionavilableTime(
      String uid) async {
    try {
      // Get the tutorSchedule document for the specified UID
      QuerySnapshot tutorScheduleQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('tutorSchedule')
          .where('uid', isEqualTo: uid)
          .get();

      // Loop through the documents in the tutorSchedule collection
      tutorScheduleQuerySnapshot.docs.forEach((doc) async {
        // Get the reference to the "timeavailable" subcollection
        CollectionReference timeAvailableCollection =
            doc.reference.collection('timeavailable');

        // Query documents within the "timeavailable" subcollection
        QuerySnapshot timeAvailableQuerySnapshot =
            await timeAvailableCollection.get();

        // Loop through the documents in the "timeavailable" subcollection
        for (var timeDoc in timeAvailableQuerySnapshot.docs) {
          Map<String, dynamic> timeData =
              timeDoc.data() as Map<String, dynamic>;

          // Create a TimeAvailability instance from the map
          TimeAvailability timeAvailability =
              TimeAvailability.fromMap(timeData);

          setState(() {
            timeFrom = timeAvailability.timeAvailableFrom;
            timeTo = timeAvailability.timeAvailableTo;
          });
        }
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<BlockDate> blocktime = [];
  Future<void> getDataFromTutorScheduleCollectionBlockDateTime(
      String uid) async {
    List<BlockDate> dateTimeAvailabilities = [];

    try {
      // Get the tutorSchedule document for the specified UID
      QuerySnapshot tutorScheduleQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('tutorSchedule')
          .where('uid', isEqualTo: uid)
          .get();

      // Loop through the documents in the tutorSchedule collection
      for (QueryDocumentSnapshot doc in tutorScheduleQuerySnapshot.docs) {
        // Get the reference to the "timeavailable" subcollection
        CollectionReference timeAvailableCollection =
            doc.reference.collection('blockdatetime');

        // Query documents within the "timeavailable" subcollection
        QuerySnapshot timeAvailableQuerySnapshot =
            await timeAvailableCollection.get();

        // Loop through the documents in the "timeavailable" subcollection
        for (QueryDocumentSnapshot timeDoc in timeAvailableQuerySnapshot.docs) {
          Map<String, dynamic> timeData =
              timeDoc.data() as Map<String, dynamic>;

          // Create a TimeAvailability instance from the map
          BlockDate timeAvailability = BlockDate.fromMap(timeData);

          dateTimeAvailabilities.add(timeAvailability);
        }
      }

      setState(() {
        blocktime = dateTimeAvailabilities;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<DateTimeAvailability> dateavailabledateselected = [];
  Future<void> getDataFromTutorScheduleCollectionAvailableDateTime(
      String uid) async {
    List<DateTimeAvailability> dateTimeAvailabilities = [];

    try {
      // Get the tutorSchedule document for the specified UID
      QuerySnapshot tutorScheduleQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('tutorSchedule')
          .where('uid', isEqualTo: uid)
          .get();

      // Loop through the documents in the tutorSchedule collection
      for (QueryDocumentSnapshot doc in tutorScheduleQuerySnapshot.docs) {
        // Get the reference to the "timeavailable" subcollection
        CollectionReference timeAvailableCollection =
            doc.reference.collection('timedateavailable');

        // Query documents within the "timeavailable" subcollection
        QuerySnapshot timeAvailableQuerySnapshot =
            await timeAvailableCollection.get();

        // Loop through the documents in the "timeavailable" subcollection
        for (QueryDocumentSnapshot timeDoc in timeAvailableQuerySnapshot.docs) {
          Map<String, dynamic> timeData =
              timeDoc.data() as Map<String, dynamic>;

          // Create a TimeAvailability instance from the map
          DateTimeAvailability timeAvailability =
              DateTimeAvailability.fromMap(timeData);

          dateTimeAvailabilities.add(timeAvailability);
        }
      }

      setState(() {
        dateavailabledateselected = dateTimeAvailabilities;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<ScheduleData> filteredSchedules = [];
  ScheduleData? selectedbooking;
  ScheduleData? selectedbookingdata;
  final int intervalMinutes = 50;
  final int breakMinutes = 10;
  String convertTo24HourFormat(String timeString) {
    final DateFormat inputFormat = DateFormat('h:mm a');
    final DateFormat outputFormat = DateFormat('HH:mm');
    final DateTime dateTime = inputFormat.parse(timeString);
    return outputFormat.format(dateTime);
  }

  bool isTimeWithinRange(TimeOfDay time) {
    List<DateTimeAvailability> selectedTimeRanges = [];

    for (var dateList in dateavailabledateselected) {
      if (isSameDay(dateList.selectedDate, _selectedDay)) {
        selectedTimeRanges.add(dateList);
      }
    }
    String from24Hour = '';
    String to24Hour = '';
    bool isWithinRange = false;
    if (selectedTimeRanges.isNotEmpty) {
      for (var selectedTimeRange in selectedTimeRanges) {
        String from24Hour =
            convertTo24HourFormat(selectedTimeRange.timeAvailableFrom);
        String to24Hour =
            convertTo24HourFormat(selectedTimeRange.timeAvailableTo);

        TimeOfDay from = TimeOfDay(
          hour: int.parse(from24Hour.split(':')[0]),
          minute: int.parse(from24Hour.split(':')[1]),
        );

        TimeOfDay to = TimeOfDay(
          hour: int.parse(to24Hour.split(':')[0]),
          minute: int.parse(to24Hour.split(':')[1]),
        );

        int currentTimeInMinutes = time.hour * 60 + time.minute;
        int fromTimeInMinutes = from.hour * 60 + from.minute;
        int toTimeInMinutes = to.hour * 60 + to.minute;

        if (currentTimeInMinutes >= fromTimeInMinutes &&
            currentTimeInMinutes <= toTimeInMinutes) {
          isWithinRange = true;
          break; // Exit the loop when the first valid range is found
        }
      }
    } else {
      from24Hour = convertTo24HourFormat(timeFrom);
      to24Hour = convertTo24HourFormat(timeTo);
      TimeOfDay from = TimeOfDay(
        hour: int.parse(from24Hour.split(':')[0]),
        minute: int.parse(from24Hour.split(':')[1]),
      );

      TimeOfDay to = TimeOfDay(
        hour: int.parse(to24Hour.split(':')[0]),
        minute: int.parse(to24Hour.split(':')[1]),
      );

      int currentTimeInMinutes = time.hour * 60 + time.minute;
      int fromTimeInMinutes = from.hour * 60 + from.minute;
      int toTimeInMinutes = to.hour * 60 + to.minute;

      if (currentTimeInMinutes >= fromTimeInMinutes &&
          currentTimeInMinutes <= toTimeInMinutes) {
        isWithinRange =
            true; // Exit the loop when the first valid range is found
      }
    }

    // TimeOfDay from = TimeOfDay(
    //   hour: int.parse(from24Hour.split(':')[0]),
    //   minute: int.parse(from24Hour.split(':')[1]),
    // );

    // TimeOfDay to = TimeOfDay(
    //   hour: int.parse(to24Hour.split(':')[0]),
    //   minute: int.parse(to24Hour.split(':')[1]),
    // );

    // int currentTimeInMinutes = time.hour * 60 + time.minute;
    // int fromTimeInMinutes = from.hour * 60 + from.minute;
    // int toTimeInMinutes = to.hour * 60 + to.minute;

    return isWithinRange;
  }

  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();
  Set<int> selectedIndices = <int>{};
  double containerX = 100.0; // Initial X position of the container
  double containerY = 100.0;

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  List<bool> isHovered = [];

  @override
  Widget build(BuildContext context) {
    int itemCount = 24 * 60 ~/ 5; // Number of items in the list
    List<TimeOfDay> timeList = List.generate(
      itemCount,
      (index) => TimeOfDay(hour: index * 5 ~/ 60, minute: (index * 5) % 60),
    );
    Size size = MediaQuery.of(context).size;
    final int listIndex = context.select((InitProvider s) => s.listIndex);
    List<TutorInformation> tutorinfodata =
        Provider.of<List<TutorInformation>>(context);
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
          String timefrom = scheduleItem.timefrom;
          String timeto = scheduleItem.timeto;
          ScheduleData tempsched = ScheduleData(
              studentID: studentID,
              tutorID: tutorID,
              classID: classID,
              scheduleID: scheduleID,
              tutorinfo: classesData.tutorinfo.first,
              studentinfo: classesData.studentinfo.first,
              subjectinfo: classesData.subjectinfo.first,
              session: session,
              scheduledate: scheduleDateTime,
              timefrom: timefrom,
              timeto: timeto,
              type: 'class');
          schedule.add(tempsched);
        }
      }
      // print('Schedule length ${(schedule.length)}');
      return schedule;
    }

    List<ScheduleData> scheduleList = getCombinedSchedule(enrolledClasses);
    for (var blocking in blocktime) {
      TutorInformation? data1;
      StudentInfoClass? data2;
      SubjectClass? data3;
      ScheduleData tempsched = ScheduleData(
          studentID: '',
          tutorID: '',
          classID: '',
          scheduleID: '',
          tutorinfo: data1,
          studentinfo: data2,
          subjectinfo: data3,
          session: '',
          scheduledate: blocking.blockDate,
          timefrom: blocking.timeFrom,
          timeto: blocking.timeTo,
          type: 'blocked');
      scheduleList.add(tempsched);
    }

    filteredSchedules = scheduleList.where((schedule) {
      DateTime scheduleDate = schedule.scheduledate;

      // Compare the date field of the schedule with the current date and time
      return DateFormat('yyyy-MM-dd').format(scheduleDate) ==
          DateFormat('yyyy-MM-dd').format(_selectedDay);
    }).toList();
    for (var schedule in filteredSchedules) {
      isHovered.add(false);
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width,
            height: 200,
            child: Card(
              margin: const EdgeInsets.fromLTRB(10, 5, 5, 0),
              elevation: 0.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                side: BorderSide(color: kColorPrimary, width: 4),
              ),
              child: MouseRegion(
                onHover: (event) {},
                cursor: SystemMouseCursors.click,
                child: TableCalendar(
                  shouldFillViewport: false,
                  firstDay: DateTime(1950, 8),
                  lastDay: DateTime(5000),
                  focusedDay: _focusedDay,
                  availableGestures: AvailableGestures.all,
                  availableCalendarFormats: const {
                    CalendarFormat.week: '',
                  },
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
                      borderRadius: BorderRadius.all(Radius.circular(5)),
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
                  // Calendar Dates styling
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    // Weekend days color (Sat,Sun)
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
                    // Weekend dates color (Sat & Sun Column)
                    weekendTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    outsideDaysVisible: true,
                    cellMargin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    rowDecoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    defaultDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: const Color(0xFF616161), width: .5),
                    ),
                    weekendDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: const Color(0xFF616161), width: .5),
                    ),
                    defaultTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    // highlighted color for today
                    todayDecoration: BoxDecoration(
                      color: kColorLight,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF616161),
                      ),
                    ),
                    // highlighted color for selected day
                    selectedDecoration: BoxDecoration(
                      color: kColorLight,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF616161),
                      ),
                    ),
                  ),
                  selectedDayPredicate: (day) {
                    // Use `selectedDayPredicate` to determine which day is currently selected.
                    // If this returns true, then `day` will be marked as selected.

                    // Using `isSameDay` is recommended to disregard
                    // the time-part of compared DateTime objects.
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        if (isDayOff(focusedDay)) {
                          daystatus = true;
                        } else if (isDayOffdate(focusedDay)) {
                          daystatus = true;
                        } else {
                          daystatus = false;
                        }
                      });
                    }
                  },

                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, _) {
                      int count = 0;
                      for (var highlightedDate in scheduleList) {
                        if (isSameDay(date, highlightedDate.scheduledate) &&
                            highlightedDate.type == 'class') {
                          count++;
                        }
                      }
                      int blockcount = 0;
                      for (var blockdata in blocktime) {
                        if (isSameDay(date, blockdata.blockDate)) {
                          blockcount++;
                        }
                      }
                      if (count > 0 && blockcount > 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kCalendarColorFB,
                                  borderRadius: BorderRadius.circular(7)),
                              child: Center(
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 8),
                                ),
                              ),
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kCalendarColorAB,
                                  borderRadius: BorderRadius.circular(7)),
                              child: null,
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kCalendarColorB,
                                  borderRadius: BorderRadius.circular(7)),
                              child: null,
                            ),
                          ],
                        );
                      } else if (count > 0 && blockcount == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kCalendarColorFB,
                                  borderRadius: BorderRadius.circular(7)),
                              child: Center(
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 8),
                                ),
                              ),
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kCalendarColorAB,
                                  borderRadius: BorderRadius.circular(7)),
                              child: null,
                            ),
                          ],
                        );
                      } else if (isDayOff(date)) {
                        return null;
                      } else if (isDayOffdate(date)) {
                        return null;
                      } else if (isDayOffdate(date) == false &&
                          count == 0 &&
                          blockcount == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kCalendarColorAB,
                                  borderRadius: BorderRadius.circular(7)),
                              child: null,
                            ),
                          ],
                        );
                      } else if (isDayOffdate(date) == false &&
                          count == 0 &&
                          blockcount > 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kCalendarColorAB,
                                  borderRadius: BorderRadius.circular(7)),
                              child: null,
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kCalendarColorB,
                                  borderRadius: BorderRadius.circular(7)),
                              child: null,
                            ),
                          ],
                        );
                      }

                      return null;
                    },
                    defaultBuilder: (context, date, events) {
                      // Check if the date is a day off
                      if (isDayOff(date)) {
                        return Container(
                          margin: const EdgeInsets.only(
                              top: 5, left: 5, right: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.redAccent[100],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xFF616161),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else if (isDayOffdate(date)) {
                        return Container(
                          margin: const EdgeInsets.only(
                              top: 5, left: 5, right: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.redAccent[100],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xFF616161),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return null;
                      }
                    },
                    todayBuilder: (context, date, _) {
                      return Container(
                        margin:
                            const EdgeInsets.only(top: 5, left: 5, right: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
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
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
                  },
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, 
                children: <
                    Widget>[
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    daystatus == false
                        ? "(${(filteredSchedules.where((schedule) => schedule.type == 'class').length)} Classes today)"
                        : 'Day Off',
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
                  width: size.width,
                  height: 350,
                  child: daystatus == false
                      ? SizedBox(
                  width: size.width,
                          height: 350,
                          child: Row(children: [
                            SizedBox(
                              width: 60,
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context)
                                    .copyWith(scrollbars: false),
                                child: ListView.builder(
                                  itemExtent: 12,
                                  controller: _controller2,
                                  itemCount: 24 * 60 ~/ 5,
                                  itemBuilder: (context, index) {
                                    final time = TimeOfDay(
                                        hour: index * 5 ~/ 60,
                                        minute: (index * 5) % 60);
                                    final isSelectable =
                                        isTimeWithinRange(time);
                                    final timeText = time.format(context);

                                    TextStyle textStyle = TextStyle(
                                      fontWeight: time.minute == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: time.minute == 0
                                          ? 12
                                          : 8, // Adjust the font size as needed
                                    );

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 0, bottom: 0, top: 0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 55,
                                            child: Tooltip(
                                              message: index.toString(),
                                              child: Text(
                                                time.minute == 0
                                                    ? timeText
                                                    : time.minute % 15 == 0
                                                        ? timeText
                                                        : '',
                                                textAlign: time.minute == 0
                                                    ? TextAlign.start
                                                    : TextAlign.center,
                                                style: textStyle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: _controller1,
                                itemCount: 24 * 60 ~/ 5,
                                itemBuilder: (context, index) {
                                  final time = TimeOfDay(
                                      hour: index * 5 ~/ 60,
                                      minute: (index * 5) % 60);
                                  final isSelectable = isTimeWithinRange(time);
                                  final timeText = time.format(context);

                                  TextStyle textStyle = TextStyle(
                                    fontWeight: time.minute == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: time.minute == 0
                                        ? 12
                                        : 8, // Adjust the font size as needed
                                  );
                                  // Check if the time is in the bookings list
                                  final isTimeInBookings =
                                      filteredSchedules.any((booking) {
                                    String from24Hour =
                                        convertTo24HourFormat(booking.timefrom);
                                    String to24Hour =
                                        convertTo24HourFormat(booking.timeto);
                                    final timeFrom = TimeOfDay(
                                      hour: int.parse(from24Hour.split(':')[0]),
                                      minute: (int.parse(from24Hour
                                                  .split(':')[1]
                                                  .split(' ')[0]) +
                                              4) ~/
                                          5 *
                                          5,
                                    );
                                    final timeTo = TimeOfDay(
                                      hour: int.parse(to24Hour.split(':')[0]),
                                      minute: (int.parse(to24Hour
                                                  .split(':')[1]
                                                  .split(' ')[0]) +
                                              4) ~/
                                          5 *
                                          5,
                                    );

                                    // Manually compare the hours and minutes
                                    return (time.hour > timeFrom.hour ||
                                            (time.hour == timeFrom.hour &&
                                                time.minute >=
                                                    timeFrom.minute)) &&
                                        (time.hour < timeTo.hour ||
                                            (time.hour == timeTo.hour &&
                                                time.minute <= timeTo.minute));
                                  });
                                  if (isTimeInBookings) {
                                    // Display only the timeFrom from the booking
                                    final isTimefrom =
                                        filteredSchedules.any((booking) {
                                      String from24Hour = convertTo24HourFormat(
                                          booking.timefrom);
                                      final timeFrom = TimeOfDay(
                                        hour:
                                            int.parse(from24Hour.split(':')[0]),
                                        minute: (int.parse(from24Hour
                                                    .split(':')[1]
                                                    .split(' ')[0]) +
                                                4) ~/
                                            5 *
                                            5,
                                      );
                                      // Manually compare the hours and minutes
                                      return (time.hour == timeFrom.hour &&
                                          time.minute == timeFrom.minute);
                                    });
                                    if (isTimefrom) {
                                      int bookingIndex = 0;
                                      TutorInformation? temp1;
                                      StudentInfoClass? temp2;
                                      SubjectClass? temp3;
                                      ScheduleData currentbooking =
                                          ScheduleData(
                                              studentID: '',
                                              tutorID: '',
                                              classID: '',
                                              scheduleID: '',
                                              tutorinfo: temp1,
                                              studentinfo: temp2,
                                              subjectinfo: temp3,
                                              session: '',
                                              scheduledate: DateTime.now(),
                                              timefrom: '',
                                              timeto: '',
                                              type: '');
                                      for (var booking in filteredSchedules) {
                                        String from24Hour =
                                            convertTo24HourFormat(
                                                booking.timefrom);
                                        final timeFrom = TimeOfDay(
                                          hour: int.parse(
                                              from24Hour.split(':')[0]),
                                          minute: (int.parse(from24Hour
                                                      .split(':')[1]
                                                      .split(' ')[0]) +
                                                  4) ~/
                                              5 *
                                              5,
                                        );
                                        bookingIndex =
                                            filteredSchedules.indexOf(booking);

                                        if (timeFrom.hour == time.hour &&
                                            timeFrom.minute == time.minute) {
                                          currentbooking = booking;
                                          break;
                                        }
                                      }
                                      if (currentbooking.subjectinfo != null) {
                                        for (var booking in filteredSchedules) {
                                          String from24Hour =
                                              convertTo24HourFormat(
                                                  booking.timefrom);
                                          final timeFrom = TimeOfDay(
                                            hour: int.parse(
                                                from24Hour.split(':')[0]),
                                            minute: (int.parse(from24Hour
                                                        .split(':')[1]
                                                        .split(' ')[0]) +
                                                    4) ~/
                                                5 *
                                                5,
                                          );
                                          if (timeFrom.hour == time.hour &&
                                              timeFrom.minute == time.minute) {
                                            selectedbookingdata = booking;
                                            break;
                                          }
                                        }

                                        return Row(
                                          children: [
                                            InkWell(
                                              onTap: isSelectable
                                                  ? () {
                                                      setState(() {
                                                        for (var booking
                                                            in filteredSchedules) {
                                                          String from24Hour =
                                                              convertTo24HourFormat(
                                                                  booking
                                                                      .timefrom);
                                                          final timeFrom =
                                                              TimeOfDay(
                                                            hour: int.parse(
                                                                from24Hour.split(
                                                                    ':')[0]),
                                                            minute: (int.parse(from24Hour
                                                                        .split(':')[
                                                                            1]
                                                                        .split(
                                                                            ' ')[0]) +
                                                                    4) ~/
                                                                5 *
                                                                5,
                                                          );
                                                          if (timeFrom.hour ==
                                                                  time.hour &&
                                                              timeFrom.minute ==
                                                                  time.minute) {
                                                            selectedbooking =
                                                                booking;
                                                            break;
                                                          }
                                                        }
                                                      });
                                                    }
                                                  : null,
                                              onHover: (isHovered) {
                                                setState(() {
                                                  this.isHovered[bookingIndex] =
                                                      isHovered;
                                                });
                                              },
                                              child: Tooltip(
                                                message: currentbooking.type ==
                                                        'blocked'
                                                    ? 'Blocked'
                                                    : 'Booked',
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0), // Circular border radius
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    width:
                                                        currentbooking.type ==
                                                                'blocked'
                                                            ?  size.width -380
                                                            : size.width -380,
                                                    height: 132,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          currentbooking.type ==
                                                                  'blocked'
                                                              ? Colors.redAccent
                                                              : kColorSecondary,
                                                      border: Border.all(
                                                        color: isHovered[
                                                                bookingIndex]
                                                            ? kColorPrimary
                                                            : Colors.yellow,
                                                        width: isHovered[
                                                                bookingIndex]
                                                            ? 3
                                                            : 1,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        //  Text(
                                                        //    '${selectedbookingdata!.timefrom} to ${selectedbookingdata!.timeto}',
                                                        //    style: const TextStyle(
                                                        //        fontSize:
                                                        //            16,
                                                        //        fontWeight:
                                                        //            FontWeight.w600),
                                                        //  ),
                                                        //  Visibility(
                                                        //    visible: currentbooking
                                                        //            .type !=
                                                        //        'blocked',
                                                        //    child:
                                                        //        Text(
                                                        //      currentbooking.studentinfo !=
                                                        //              null
                                                        //          ? '${currentbooking.studentinfo!.studentFirstname} ${currentbooking.studentinfo!.studentLastname}'
                                                        //          : '',
                                                        //      style: const TextStyle(
                                                        //          fontSize:
                                                        //              18,
                                                        //          fontWeight:
                                                        //              FontWeight.bold),
                                                        //    ),
                                                        //  ),
                                                        //  Visibility(
                                                        //    visible: currentbooking
                                                        //            .type !=
                                                        //        'blocked',
                                                        //    child:
                                                        //        Text(
                                                        //      currentbooking.subjectinfo !=
                                                        //              null
                                                        //          ? '${currentbooking.subjectinfo!.subjectName} Class ${currentbooking.session}'
                                                        //          : '',
                                                        //      style: const TextStyle(
                                                        //          fontSize:
                                                        //              16,
                                                        //          fontWeight:
                                                        //              FontWeight.w400),
                                                        //    ),
                                                        //  ),
                                                        Text(
                                                          currentbooking.type ==
                                                                  'blocked'
                                                              ? 'Blocked'
                                                              : 'Booked',
                                                          style: TextStyle(
                                                              color: currentbooking
                                                                          .type ==
                                                                      'blocked'
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        int bookingIndex = 0;
                                        for (var booking in filteredSchedules) {
                                          String from24Hour =
                                              convertTo24HourFormat(
                                                  booking.timefrom);
                                          final timeFrom = TimeOfDay(
                                            hour: int.parse(
                                                from24Hour.split(':')[0]),
                                            minute: (int.parse(from24Hour
                                                        .split(':')[1]
                                                        .split(' ')[0]) +
                                                    4) ~/
                                                5 *
                                                5,
                                          );
                                          bookingIndex = filteredSchedules
                                              .indexOf(booking);
                                          if (timeFrom.hour == time.hour &&
                                              timeFrom.minute == time.minute) {
                                            selectedbookingdata = booking;
                                            break;
                                          }
                                        }
                                        int intervals = 0;
                                        final isTimefrom =
                                            filteredSchedules.any((booking) {
                                          String from24Hour =
                                              convertTo24HourFormat(
                                                  booking.timefrom);
                                          String to24Hour =
                                              convertTo24HourFormat(
                                                  booking.timeto);
                                          final timeFrom = TimeOfDay(
                                            hour: int.parse(
                                                from24Hour.split(':')[0]),
                                            minute: (int.parse(from24Hour
                                                        .split(':')[1]
                                                        .split(' ')[0]) +
                                                    4) ~/
                                                5 *
                                                5,
                                          );
                                          final timeTo = TimeOfDay(
                                            hour: int.parse(
                                                to24Hour.split(':')[0]),
                                            minute: (int.parse(to24Hour
                                                        .split(':')[1]
                                                        .split(' ')[0]) +
                                                    4) ~/
                                                5 *
                                                5,
                                          );
                                          int totalMinutes = (timeTo.hour -
                                                      timeFrom.hour) *
                                                  60 +
                                              (timeTo.minute - timeFrom.minute);

                                          // Calculate how many 5-minute intervals are there
                                          intervals =
                                              (totalMinutes / 5).floor();
                                          return (time.hour == timeFrom.hour &&
                                              time.minute == timeFrom.minute);
                                        });
                                        return Row(
                                          children: [
                                            InkWell(
                                              onTap: isSelectable
                                                  ? () {
                                                      setState(() {
                                                        for (var booking
                                                            in filteredSchedules) {
                                                          String from24Hour =
                                                              convertTo24HourFormat(
                                                                  booking
                                                                      .timefrom);
                                                          final timeFrom =
                                                              TimeOfDay(
                                                            hour: int.parse(
                                                                from24Hour.split(
                                                                    ':')[0]),
                                                            minute: (int.parse(from24Hour
                                                                        .split(':')[
                                                                            1]
                                                                        .split(
                                                                            ' ')[0]) +
                                                                    4) ~/
                                                                5 *
                                                                5,
                                                          );
                                                          if (timeFrom.hour ==
                                                                  time.hour &&
                                                              timeFrom.minute ==
                                                                  time.minute) {
                                                            selectedbooking =
                                                                booking;
                                                            break;
                                                          }
                                                        }
                                                      });
                                                    }
                                                  : null,
                                              onHover: (isHovered) {
                                                setState(() {
                                                  this.isHovered[bookingIndex] =
                                                      isHovered;
                                                });
                                              },
                                              child: Tooltip(
                                                message: currentbooking.type ==
                                                        'blocked'
                                                    ? 'Blocked'
                                                    : 'Booked',
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0), // Circular border radius
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    width: size.width -380,
                                                    height:
                                                        currentbooking.type ==
                                                                'blocked'
                                                            ? intervals * 13
                                                            : 132,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          currentbooking.type ==
                                                                  'blocked'
                                                              ? Colors.redAccent
                                                              : kColorSecondary,
                                                      border: Border.all(
                                                        color: isHovered[
                                                                bookingIndex]
                                                            ? kColorPrimary
                                                            : Colors.yellow,
                                                        width: isHovered[
                                                                bookingIndex]
                                                            ? 3
                                                            : 1,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${selectedbookingdata!.timefrom} to ${selectedbookingdata!.timeto}',
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Text(
                                                          currentbooking.type ==
                                                                  'blocked'
                                                              ? 'Blocked'
                                                              : 'Booked',
                                                          style: TextStyle(
                                                              color: currentbooking
                                                                          .type ==
                                                                      'blocked'
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                    return const SizedBox.shrink();
                                  }
                                  return Row(
                                    children: [
                                      InkWell(
                                        onTap: isSelectable ? () {} : null,
                                        child: Tooltip(
                                          message: isSelectable
                                              ? 'Available'
                                              : 'Not Available',
                                          child: Container(
                                            width: size.width -380,
                                            height:
                                                indexSelect == index ? 200 : 12,
                                            color: isSelectable
                                                ? indexSelect == index
                                                    ? Colors.blue
                                                    : Colors.green[50]
                                                : Colors.grey[100],
                                            child: time.minute == 0
                                                ? const Center(
                                                    child: Divider(
                                                    thickness: .1,
                                                  ))
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ]),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.block,
                                color: Colors.red,
                                size: 150,
                              ),
                              Text(
                                "Day Off",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        )),
            ]),
          ),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //      const SizedBox(
          //       height: 5,
          //     ),
          //     Align(
          //       alignment: Alignment.topLeft,
          //       child: Text(
          //         dateselected.isEmpty
          //             ? DateFormat('MMMM dd,')
          //                 .format(DateTime.now())
          //                 .toString()
          //             : dateselected,
          //         textAlign: TextAlign.left,
          //         style: const TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 5,
          //     ),
          //     SizedBox(
          //       height: 375,
          //       width: 200,
          //       child: ListView.builder(
          //           itemCount: endHour - startHour + 1,
          //           itemBuilder: (context, index) {
          //             final hour = startHour + index;
          //             final timeString =
          //                 '${hour.toString().padLeft(2, '0')}:00';
          //             return Padding(
          //               padding: const EdgeInsets.all(10.0),
          //               child: Container(
          //                 padding: const EdgeInsets.all(5.0),
          //                 height: 50,
          //                 decoration: BoxDecoration(
          //                   color: Colors.white.withOpacity(.9),
          //                   borderRadius: BorderRadius.circular(5),
          //                   border: Border.all(
          //                     color: Colors.black45,
          //                     width: .5,
          //                   ),
          //                 ),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Row(
          //                       children: [
          //                         Text(
          //                           timeString,
          //                           style:
          //                               const TextStyle(color: Colors.blue),
          //                         ),
          //                         const Spacer(),
          //                         const Text(
          //                           'Available',
          //                           style: TextStyle(color: Colors.blue),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             );
          //           }),
          //     ),
          //   ],
          // ),
        ],
      ),
      // actions: [
      //   TextButton(
      //     onPressed: () {
      //       Navigator.of(context).pop(_selectedDate);
      //     },
      //     child: const Text('OK'),
      //   ),
      // ],
    );
  }
}
