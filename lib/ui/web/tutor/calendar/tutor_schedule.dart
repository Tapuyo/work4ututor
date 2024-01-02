// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:work4ututor/data_class/studentinfoclass.dart';
import 'package:work4ututor/ui/web/tutor/calendar/setup_calendar.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/init_provider.dart';
import '../../../../services/getenrolledclasses.dart';
import '../../../../utils/themes.dart';

class TableBasicsExample1 extends StatefulWidget {
  final String uID;
  const TableBasicsExample1({Key? key, required this.uID}) : super(key: key);

  @override
  State<TableBasicsExample1> createState() => _TableBasicsExample1State();
}

class _TableBasicsExample1State extends State<TableBasicsExample1> {
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
    return TableBasicsExample(
      uID: widget.uID,
    );
  }
}

class TableBasicsExample extends StatefulWidget {
  final String uID;

  const TableBasicsExample({super.key, required this.uID});

  @override
  State<TableBasicsExample> createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  Map<DateTime, List> _events = {};
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

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool daystatus = false;
  String selectedDate = DateFormat('MMMM dd,').format(DateTime.now());
  int count = 0;
  @override
  void initState() {
    super.initState();
    getDataFromTutorScheduleCollection(
      widget.uID,
    );
    getDataFromTutorScheduleCollectionavilableTime(
      widget.uID,
    );
    getDataFromTutorScheduleCollectionBlockDateTime(
      widget.uID,
    );
    getDataFromTutorScheduleCollectionAvailableDateTime(
      widget.uID,
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
        timeAvailableQuerySnapshot.docs.forEach((timeAvailableDoc) {
          // Access the data within each document in the subcollection
          Map<String, dynamic> data =
              timeAvailableDoc.data() as Map<String, dynamic>;
          // Do something with the data...
          setState(() {
            // Extract the "timefrom" and "timeend" fields
            String timefrom = data['timeAvailableFrom'];
            String timeend = data['timeAvailableTo'];
          });
        });
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
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Access the data fields you need
        String uid = data['uid'] ?? [];
        List<dynamic> dateoffselected = data['dateoffselected'] != null
            ? List<dynamic>.from(data['dateoffselected'])
            : [];

        // Convert the timestamp strings to DateTime objects
        setState(() {
          dayOffs = List<String>.from(data['dayoffs'] ?? []);

          if (dateoffselected != null) {
            dayOffsdate = dateoffselected
                .map((dateString) => DateTime.tryParse(dateString))
                .where((date) => date != null)
                .cast<DateTime>()
                .toList();
          }
        });
      });
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
        timeAvailableQuerySnapshot.docs.forEach((timeDoc) {
          Map<String, dynamic> timeData =
              timeDoc.data() as Map<String, dynamic>;

          // Create a TimeAvailability instance from the map
          TimeAvailability timeAvailability =
              TimeAvailability.fromMap(timeData);

          setState(() {
            timeFrom = timeAvailability.timeAvailableFrom;
            timeTo = timeAvailability.timeAvailableTo;
          });
        });
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

  ScrollController _controller1 = ScrollController();
  ScrollController _controller2 = ScrollController();
  Set<int> selectedIndices = Set<int>();
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
      print('${blocking.blockDate} ${blocking.timeFrom} ${blocking.timeTo}');
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
    List<Widget> timeCards = generateTimeCards();
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
                    children: [
                      const Text(
                        "SCHEDULE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 35,
                        width: 160,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color.fromRGBO(1, 118, 132, 1),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            foregroundColor:
                                const Color.fromRGBO(1, 118, 132, 1),
                            disabledBackgroundColor: Colors.white,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.deepPurple, // your color here
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            // ignore: prefer_const_constructors
                            textStyle: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  var height =
                                      MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0), // Adjust the radius as needed
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    content: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          15.0), // Same radius as above
                                      child: Container(
                                        color: Colors
                                            .white, // Set the background color of the circular content

                                        child: Stack(
                                          children: <Widget>[
                                            SizedBox(
                                              height: height - 300,
                                              width: 800,
                                              child: CalendarSetup(
                                                userinfo: tutorinfodata.first,
                                              ),
                                            ),
                                            Positioned(
                                              top: 10.0,
                                              right: 10.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  getDataFromTutorScheduleCollection(
                                                      widget.uID);
                                                  getDataFromTutorScheduleCollectionBlockDateTime(
                                                      widget.uID);
                                                  getDataFromTutorScheduleCollectionavilableTime(
                                                      widget.uID);
                                                  Navigator.of(context).pop(
                                                      false); // Close the dialog
                                                },
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                            size: 15,
                            color: kColorPrimary,
                          ),
                          label: const Text(
                            'Set Up Calendar',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                                      width: .5),
                                ),
                                weekendDecoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: const Color(0xFF616161),
                                      width: .5),
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
                                    if (isSameDay(date,
                                            highlightedDate.scheduledate) &&
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: kCalendarColorFB,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: Center(
                                            child: Text(
                                              '$count',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 8),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 15,
                                          height: 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: kCalendarColorAB,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: null,
                                        ),
                                        Container(
                                          width: 15,
                                          height: 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: kCalendarColorB,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: null,
                                        ),
                                      ],
                                    );
                                  } else if (count > 0 && blockcount == 0) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: kCalendarColorFB,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: Center(
                                            child: Text(
                                              '$count',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 8),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 15,
                                          height: 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: kCalendarColorAB,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: kCalendarColorAB,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: null,
                                        ),
                                      ],
                                    );
                                  } else if (isDayOffdate(date) == false &&
                                      count == 0 &&
                                      blockcount > 0) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: kCalendarColorAB,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: null,
                                        ),
                                        Container(
                                          width: 15,
                                          height: 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: kCalendarColorB,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
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
                                    margin: const EdgeInsets.only(
                                        top: 5, left: 5, right: 5),
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
                    ),
                    const SizedBox(
                      // height: MediaQuery.of(context).size.height,
                      // child: const VerticalDivider(),
                      width: 5,
                    ),
                    Flexible(
                        flex: size.width > 1350 ? 2 : 3,
                        child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: tableLedger(context))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ClipRect(
            child: SizedBox(
              width: size.width - 310,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
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
                                width: 800,
                                height: 600,
                                child: daystatus == false
                                    ? SizedBox(
                                        width: 800,
                                        height: 600,
                                        child: Row(children: [
                                          SizedBox(
                                            width: 60,
                                            child: ScrollConfiguration(
                                              behavior:
                                                  ScrollConfiguration.of(context)
                                                      .copyWith(
                                                          scrollbars: false),
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
                                                  final timeText =
                                                      time.format(context);
          
                                                  TextStyle textStyle = TextStyle(
                                                    fontWeight: time.minute == 0
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    fontSize: time.minute == 0
                                                        ? 12
                                                        : 8, // Adjust the font size as needed
                                                  );
          
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 0,
                                                            bottom: 0,
                                                            top: 0),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 55,
                                                          child: Tooltip(
                                                            message:
                                                                index.toString(),
                                                            child: Text(
                                                              time.minute == 0
                                                                  ? timeText
                                                                  : time.minute %
                                                                              15 ==
                                                                          0
                                                                      ? timeText
                                                                      : '',
                                                              textAlign:
                                                                  time.minute == 0
                                                                      ? TextAlign
                                                                          .start
                                                                      : TextAlign
                                                                          .center,
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
                                                final isSelectable =
                                                    isTimeWithinRange(time);
                                                final timeText =
                                                    time.format(context);
          
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
                                                    filteredSchedules
                                                        .any((booking) {
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
          
                                                  // Manually compare the hours and minutes
                                                  return (time.hour >
                                                              timeFrom.hour ||
                                                          (time.hour ==
                                                                  timeFrom.hour &&
                                                              time.minute >=
                                                                  timeFrom
                                                                      .minute)) &&
                                                      (time.hour < timeTo.hour ||
                                                          (time.hour ==
                                                                  timeTo.hour &&
                                                              time.minute <=
                                                                  timeTo.minute));
                                                });
                                                if (isTimeInBookings) {
                                                  // Display only the timeFrom from the booking
                                                  final isTimefrom =
                                                      filteredSchedules
                                                          .any((booking) {
                                                    String from24Hour =
                                                        convertTo24HourFormat(
                                                            booking.timefrom);
                                                    final timeFrom = TimeOfDay(
                                                      hour: int.parse(from24Hour
                                                          .split(':')[0]),
                                                      minute: (int.parse(from24Hour
                                                                  .split(':')[1]
                                                                  .split(
                                                                      ' ')[0]) +
                                                              4) ~/
                                                          5 *
                                                          5,
                                                    );
                                                    // Manually compare the hours and minutes
                                                    return (time.hour ==
                                                            timeFrom.hour &&
                                                        time.minute ==
                                                            timeFrom.minute);
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
                                                            scheduledate:
                                                                DateTime.now(),
                                                            timefrom: '',
                                                            timeto: '',
                                                            type: '');
                                                    for (var booking
                                                        in filteredSchedules) {
                                                      String from24Hour =
                                                          convertTo24HourFormat(
                                                              booking.timefrom);
                                                      final timeFrom = TimeOfDay(
                                                        hour: int.parse(from24Hour
                                                            .split(':')[0]),
                                                        minute: (int.parse(from24Hour
                                                                    .split(':')[1]
                                                                    .split(
                                                                        ' ')[0]) +
                                                                4) ~/
                                                            5 *
                                                            5,
                                                      );
                                                         bookingIndex = filteredSchedules.indexOf(booking);
          
                                                      if (timeFrom.hour ==
                                                              time.hour &&
                                                          timeFrom.minute ==
                                                              time.minute) {
                                                        currentbooking = booking;
                                                        break;
                                                      }
                                                    }
                                                    if (currentbooking
                                                            .subjectinfo !=
                                                        null) {
                                                      for (var booking
                                                          in filteredSchedules) {
                                                        String from24Hour =
                                                            convertTo24HourFormat(
                                                                booking.timefrom);
                                                        final timeFrom =
                                                            TimeOfDay(
                                                          hour: int.parse(
                                                              from24Hour
                                                                  .split(':')[0]),
                                                          minute: (int.parse(from24Hour
                                                                      .split(
                                                                          ':')[1]
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
                                                          selectedbookingdata =
                                                              booking;
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
                                                                        String
                                                                            from24Hour =
                                                                            convertTo24HourFormat(
                                                                                booking.timefrom);
                                                                        final timeFrom =
                                                                            TimeOfDay(
                                                                          hour: int.parse(
                                                                              from24Hour.split(':')[0]),
                                                                          minute: (int.parse(from24Hour.split(':')[1].split(' ')[0]) +
                                                                                  4) ~/
                                                                              5 *
                                                                              5,
                                                                        );
                                                                        if (timeFrom.hour ==
                                                                                time
                                                                                    .hour &&
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
                                                              message: currentbooking
                                                                          .type ==
                                                                      'blocked'
                                                                  ? 'Blocked'
                                                                  : 'Booked',
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0), // Circular border radius
                                                                child: Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  width: currentbooking
                                                                              .type ==
                                                                          'blocked'
                                                                      ? 740
                                                                      : 740,
                                                                  height: 132,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: currentbooking
                                                                                .type ==
                                                                            'blocked'
                                                                        ? Colors
                                                                            .redAccent
                                                                        : kColorSecondary,
                                                                    border: Border
                                                                        .all(
                                                                      color:isHovered[bookingIndex] 
                                                                          ? kColorPrimary
                                                                          : Colors
                                                                              .yellow,
                                                                      width:
                                                                          isHovered[bookingIndex]
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
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      Visibility(
                                                                        visible: currentbooking
                                                                                .type !=
                                                                            'blocked',
                                                                        child:
                                                                            Text(
                                                                          currentbooking.studentinfo !=
                                                                                  null
                                                                              ? '${currentbooking.studentinfo!.studentFirstname} ${currentbooking.studentinfo!.studentLastname}'
                                                                              : '',
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  18,
                                                                              fontWeight:
                                                                                  FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible: currentbooking
                                                                                .type !=
                                                                            'blocked',
                                                                        child:
                                                                            Text(
                                                                          currentbooking.subjectinfo !=
                                                                                  null
                                                                              ? '${currentbooking.subjectinfo!.subjectName} Class ${currentbooking.session}'
                                                                              : '',
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight:
                                                                                  FontWeight.w400),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        currentbooking.type ==
                                                                                'blocked'
                                                                            ? 'Blocked'
                                                                            : 'Booked',
                                                                        style: TextStyle(
                                                                            color: currentbooking.type == 'blocked'
                                                                                ? Colors
                                                                                    .black
                                                                                : Colors
                                                                                    .white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
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
                                                      for (var booking
                                                          in filteredSchedules) {
                                                        String from24Hour =
                                                            convertTo24HourFormat(
                                                                booking.timefrom);
                                                        final timeFrom =
                                                            TimeOfDay(
                                                          hour: int.parse(
                                                              from24Hour
                                                                  .split(':')[0]),
                                                          minute: (int.parse(from24Hour
                                                                      .split(
                                                                          ':')[1]
                                                                      .split(
                                                                          ' ')[0]) +
                                                                  4) ~/
                                                              5 *
                                                              5,
                                                        );
                                                         bookingIndex = filteredSchedules.indexOf(booking);
                                                        if (timeFrom.hour ==
                                                                time.hour &&
                                                            timeFrom.minute ==
                                                                time.minute) {
                                                          selectedbookingdata =
                                                              booking;
                                                          break;
                                                        }
                                                      }
                                                      int intervals = 0;
                                                      final isTimefrom =
                                                          filteredSchedules
                                                              .any((booking) {
                                                        String from24Hour =
                                                            convertTo24HourFormat(
                                                                booking.timefrom);
                                                        String to24Hour =
                                                            convertTo24HourFormat(
                                                                booking.timeto);
                                                        final timeFrom =
                                                            TimeOfDay(
                                                          hour: int.parse(
                                                              from24Hour
                                                                  .split(':')[0]),
                                                          minute: (int.parse(from24Hour
                                                                      .split(
                                                                          ':')[1]
                                                                      .split(
                                                                          ' ')[0]) +
                                                                  4) ~/
                                                              5 *
                                                              5,
                                                        );
                                                        final timeTo = TimeOfDay(
                                                          hour: int.parse(to24Hour
                                                              .split(':')[0]),
                                                          minute: (int.parse(to24Hour
                                                                      .split(
                                                                          ':')[1]
                                                                      .split(
                                                                          ' ')[0]) +
                                                                  4) ~/
                                                              5 *
                                                              5,
                                                        );
                                                        int totalMinutes = (timeTo
                                                                        .hour -
                                                                    timeFrom
                                                                        .hour) *
                                                                60 +
                                                            (timeTo.minute -
                                                                timeFrom.minute);
          
                                                        // Calculate how many 5-minute intervals are there
                                                        intervals =
                                                            (totalMinutes / 5)
                                                                .floor();
                                                        return (time.hour ==
                                                                timeFrom.hour &&
                                                            time.minute ==
                                                                timeFrom.minute);
                                                      });
                                                      return Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: isSelectable
                                                                ? () {
                                                                    setState(() {
                                                                      for (var booking
                                                                          in filteredSchedules) {
                                                                        String
                                                                            from24Hour =
                                                                            convertTo24HourFormat(
                                                                                booking.timefrom);
                                                                        final timeFrom =
                                                                            TimeOfDay(
                                                                          hour: int.parse(
                                                                              from24Hour.split(':')[0]),
                                                                          minute: (int.parse(from24Hour.split(':')[1].split(' ')[0]) +
                                                                                  4) ~/
                                                                              5 *
                                                                              5,
                                                                        );
                                                                        if (timeFrom.hour ==
                                                                                time
                                                                                    .hour &&
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
                                                              message: currentbooking
                                                                          .type ==
                                                                      'blocked'
                                                                  ? 'Blocked'
                                                                  : 'Booked',
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0), // Circular border radius
                                                                child: Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  width: 740,
                                                                  height: currentbooking
                                                                              .type ==
                                                                          'blocked'
                                                                      ? intervals *
                                                                          13
                                                                      : 132,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: currentbooking
                                                                                .type ==
                                                                            'blocked'
                                                                        ? Colors
                                                                            .redAccent
                                                                        : kColorSecondary,
                                                                    border: Border
                                                                        .all(
                                                                      color: isHovered[bookingIndex]
                                                                          ? kColorPrimary
                                                                              
                                                                          : Colors
                                                                              .yellow,
                                                                      width:
                                                                          isHovered[bookingIndex]
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
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      Text(
                                                                        currentbooking.type ==
                                                                                'blocked'
                                                                            ? 'Blocked'
                                                                            : 'Booked',
                                                                        style: TextStyle(
                                                                            color: currentbooking.type == 'blocked'
                                                                                ? Colors
                                                                                    .black
                                                                                : Colors
                                                                                    .white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
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
                                                    // SizedBox(
                                                    //   width: 55,
                                                    //   child: Tooltip(
                                                    //     message: index.toString(),
                                                    //     child: Text(
                                                    //       time.minute == 0
                                                    //           ? timeText
                                                    //           : timeText,
                                                    //       textAlign: time
                                                    //                   .minute ==
                                                    //               0
                                                    //           ? TextAlign.start
                                                    //           : TextAlign.center,
                                                    //       style: textStyle,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    InkWell(
                                                      onTap: isSelectable
                                                          ? () {}
                                                          : null,
                                                      child: Tooltip(
                                                        message: isSelectable
                                                            ? 'Available'
                                                            : 'Not Available',
                                                        child: Container(
                                                          width: 740,
                                                          height:
                                                              indexSelect == index
                                                                  ? 200
                                                                  : 12,
                                                          color: isSelectable
                                                              ? indexSelect ==
                                                                      index
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .green[50]
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
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
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
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedbooking == null
                                      ? 'Select Information'
                                      : 'Information(${selectedbooking?.timefrom} to ${selectedbooking?.timeto})',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 364,
                              height: 600,
                              child: selectedbooking == null
                                  ? Column(
                                      children: [
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                "Select a schedule",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : selectedbooking!.type == 'class'
                                      ? Column(
                                          children: [
                                            Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: selectedbooking!
                                                                .studentinfo!
                                                                .profilelink !=
                                                            ''
                                                        ? Image.network(
                                                            selectedbooking!
                                                                .studentinfo!
                                                                .profilelink,
                                                            fit: BoxFit.cover,
                                                            width: 150.0,
                                                            height:
                                                                150.0, // You can adjust the fit as needed.
                                                          )
                                                        : Image.asset(
                                                            'assets/images/5836.png',
                                                            width: 250.0,
                                                            height: 150.0,
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                                  Text(
                                                    '${selectedbooking!.studentinfo!.studentFirstname} ${selectedbooking!.studentinfo!.studentLastname}',
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                  Text(
                                                    selectedbooking!
                                                        .studentinfo!.studentID,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    selectedbooking!
                                                        .subjectinfo!.subjectName,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Class ${selectedbooking!.session}',
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Class Materials',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 100,
                                                    child: Text(
                                                      'No Materials Found',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  const Text(
                                                    'Class Link',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 100,
                                                    child: Text(
                                                      'Click Link Below',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          kColorPrimary, // Text color
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 15),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Reschedule',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  ElevatedButton(
                                                    onPressed: () {
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
                                                            minute: int.parse(
                                                                from24Hour
                                                                    .split(':')[1]
                                                                    .split(
                                                                        ' ')[0]),
                                                          );
                                                          String time =
                                                              convertTo24HourFormat(
                                                                  selectedbooking!
                                                                      .timefrom);
                                                          final timetodelete =
                                                              TimeOfDay(
                                                            hour: int.parse(time
                                                                .split(':')[0]),
                                                            minute: int.parse(
                                                                from24Hour
                                                                    .split(':')[1]
                                                                    .split(
                                                                        ' ')[0]),
                                                          );
          
                                                          if (timeFrom.hour ==
                                                                  timetodelete
                                                                      .hour &&
                                                              timeFrom.minute ==
                                                                  timetodelete
                                                                      .minute) {
                                                            filteredSchedules
                                                                .remove(booking);
                                                            break;
                                                          }
                                                        }
                                                      });
                                                    },
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                      foregroundColor:
                                                          kColorPrimary,
                                                      backgroundColor: Colors
                                                          .white, // Text color
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 15),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.block,
                                                color: Colors.red,
                                                size: 150,
                                              ),
                                              Text(
                                                "Block Time",
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
                ],
              ),
            ),
          ),
          // SizedBox(
          //   width: size.width - 310,
          //   height: 500,
          //   child: Stack(
          //     children: <Widget>[
          //       Positioned(
          //         left: 0,
          //         top: 0,
          //         child: Container(
          //           width: MediaQuery.of(context).size.width,
          //           height: MediaQuery.of(context).size.height,
          //           color: Colors.orange[300],
          //         ),
          //       ),
          //       Positioned(
          //         left: containerX,
          //         top: containerY,
          //         child: GestureDetector(
          //           onPanUpdate: (details) {
          //             setState(() {
          //               // Update the position of the container based on drag gestures
          //               containerX += details.delta.dx;
          //               containerY += details.delta.dy;
          //             });
          //           },
          //           child: Container(
          //             width: 100.0,
          //             height: 100.0,
          //             color: Colors.blue,
          //             child: Center(child: Text('Drag Me')),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  List<Widget> generateTimeCards() {
    List<Widget> cards = [];
    DateFormat format = DateFormat('h:mm a');
    DateTime currentTime = format.parse(timeFrom);
    DateTime endTime = format.parse(timeTo);

    while (currentTime.isBefore(endTime)) {
      // Create a card for the current time
      Widget timeCard = buildTimeCard(currentTime, format);

      cards.add(timeCard);

      // Increment the time by the interval
      currentTime = currentTime.add(Duration(minutes: intervalMinutes));

      if (currentTime.isBefore(endTime)) {
        // Add a break time if there is still time left
        Widget breakCard = buildBreakCard(currentTime, format);
        cards.add(breakCard);
        currentTime = currentTime.add(Duration(minutes: breakMinutes));
      }
    }

    return cards;
  }

  Widget buildTimeCard(DateTime time, DateFormat format) {
    String timeText = format.format(time);
    String timeend =
        format.format(time.add(Duration(minutes: intervalMinutes)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          timeText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Text(
          '-',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          timeend,
          style: const TextStyle(
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
            color: kCalendarColorAB,
            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  // CircleAvatar(
                  //   radius: 25.0,
                  //   backgroundColor: Colors.transparent,
                  //   child: Image.asset(
                  //     'assets/images/login.png',
                  //     width: 300.0,
                  //     height: 100.0,
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  Text(
                    'Available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Text(
    //       timeText,
    //       style: TextStyle(
    //         fontSize: 18,
    //         fontWeight: FontWeight.w800,
    //       ),
    //     ),
    //     Text(
    //       '-',
    //       style: TextStyle(
    //         fontSize: 18,
    //         fontWeight: FontWeight.w800,
    //       ),
    //     ),
    //     Text(
    //       timeend,
    //       style: TextStyle(
    //         fontSize: 18,
    //         fontWeight: FontWeight.w800,
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget buildBreakCard(DateTime time, DateFormat format) {
    String breakText = 'Break';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          breakText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

CalendarBuilders calendarBuilder() {
  return CalendarBuilders(
    todayBuilder: (
      context,
      day,
      focusedDay,
    ) {
      return buildCalendarDay(
          day: DateTime.now().day.toString(),
          text: '3',
          backColor: Colors.green);
    },
  );
}

Container buildCalendarDay({
  required String day,
  required Color backColor,
  required String text,
}) {
  return Container(
    color: backColor,
    width: 100,
    height: 55,
    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(
            Icons.circle,
            size: 20,
            color: Colors.red,
          ),
          Text(day, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    ),
  );
}

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
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: const [
        //       Text(
        //         "Legend",
        //         style: TextStyle(
        //           fontSize: 18,
        //           fontWeight: FontWeight.w800,
        //         ),
        //       ),
        //       Spacer(),
        //       Icon(
        //         Icons.list_alt_outlined,
        //         size: 20,
        //         color: Colors.black54,
        //       ),
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       Container(
        //         width: 20,
        //         height: 20,
        //         decoration: BoxDecoration(
        //           color: kCalendarColorAB,
        //           borderRadius: BorderRadius.circular(100),
        //         ),
        //       ),
        //       const SizedBox(
        //         width: 5,
        //       ),
        //       const Text(
        //         "Available",
        //         style: TextStyle(
        //           color: ksecondarytextColor,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(
        //   height: 5,
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       Container(
        //         width: 20,
        //         height: 20,
        //         decoration: BoxDecoration(
        //           color: kCalendarColorFB,
        //           borderRadius: BorderRadius.circular(100),
        //         ),
        //       ),
        //       const SizedBox(
        //         width: 5,
        //       ),
        //       const Text(
        //         "Fully Booked",
        //         style: TextStyle(
        //           color: ksecondarytextColor,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(
        //   height: 5,
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       Container(
        //         width: 20,
        //         height: 20,
        //         decoration: BoxDecoration(
        //           color: kCalendarColorB,
        //           borderRadius: BorderRadius.circular(100),
        //         ),
        //       ),
        //       const SizedBox(
        //         width: 5,
        //       ),
        //       const Text(
        //         "Blocked",
        //         style: TextStyle(
        //           color: ksecondarytextColor,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(
        //   height: 50,
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              Text(
                "Ledger",
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(.1),
                ),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kCalendarColorAB,
                  ),
                  child: null,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(.1),
                ),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kCalendarColorFB,
                  ),
                  child: null,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(.1),
                ),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kCalendarColorB,
                  ),
                  child: null,
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

class Bookings {
  final DateTime dateschedule;
  final String timeFrom;
  final String timeTo;
  final String timeinfo;

  Bookings(
      {required this.dateschedule,
      required this.timeFrom,
      required this.timeTo,
      required this.timeinfo});
}
