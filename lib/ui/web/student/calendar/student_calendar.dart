// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:work4ututor/data_class/voucherclass.dart';
import 'package:work4ututor/services/getvouchers.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/init_provider.dart';
import '../../../../provider/schedulenotifier.dart';
import '../../../../services/getenrolledclasses.dart';
import '../../../../services/getmaterials.dart';
import '../../../../services/getschedules.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';
import '../../terms/termpage.dart';
import '../../tutor/calendar/setup_calendar.dart';
import '../../tutor/tutor_profile/view_file.dart';
import 'package:universal_html/html.dart' as html;

// class StudentCalendar extends StatefulWidget {
//   final String uID;
//   const StudentCalendar({Key? key, required this.uID}) : super(key: key);

//   @override
//   State<StudentCalendar> createState() => _StudentCalendarState();
// }

// class _StudentCalendarState extends State<StudentCalendar> {
// //  TableCalendarController _calendarController;
//   List<DateTime> highlightedDatesList = [
//     DateTime(2023, 6, 10),
//     DateTime(2023, 6, 15),
//     DateTime(2023, 6, 20),
//   ];

//   CalendarFormat _calendarFormat = CalendarFormat.month;

//   DateTime _focusedDay = DateTime.now();

//   DateTime _selectedDay = DateTime.now();

//   String selectedDate = DateFormat('MMMM dd,').format(DateTime.now());

//   int count = 0;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return MultiProvider(
//       providers: [
//         // StreamProvider<List<Schedule>>.value(
//         //   value: ScheduleEnrolledClass(
//         //     uid: widget.uID,
//         //     role: 'student',
//         //   ).getenrolled,
//         //   catchError: (context, error) {
//         //     print('Error occurred: $error');
//         //     return [];
//         //   },
//         //   initialData: const [],
//         // ),
//         // StreamProvider<List<ClassesData>>.value(
//         //   value: EnrolledClass(uid: widget.uID, role: 'student').getenrolled,
//         //   catchError: (context, error) {
//         //     return [];
//         //   },
//         //   initialData: const [],
//         // ),
//       ],
//       child: const StudentCalendarBody(),
//     );
//   }
// }

class StudentCalendar extends StatefulWidget {
  final String uID;
  const StudentCalendar({Key? key, required this.uID}) : super(key: key);

  @override
  State<StudentCalendar> createState() => _StudentCalendarState();
}

class _StudentCalendarState extends State<StudentCalendar> {
  List<DateTimeAvailability> dateavailabledateselected = [];

  List<String> dayOffs = [];
  List<DateTime> dayOffsdate = []; // Specify the day-offs as dates
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

  List<ClassesData> futureclassdata = [];
  @override
  void initState() {
    super.initState();
    // getfutureclass();
    // print('Future Data: ${futureclassdata.length}');
    _controller1.addListener(() {
      _controller2.jumpTo(_controller1.offset);
    });

    _controller2.addListener(() {
      _controller1.jumpTo(_controller2.offset);
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  List<bool> isHovered = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();

  DateTime _selectedDay = DateTime.now();

  String selectedDate = DateFormat('MMMM dd,').format(DateTime.now());

  int count = 0;
  int? indexSelect;

  bool daystatus = false;
  ScrollController updatescrollController1 = ScrollController();
  ScrollController _controller1 = ScrollController();
  ScrollController _controller2 = ScrollController();

  ScheduleData? selectedbooking;
  ScheduleData? selectedbookingdata;
  String timeFrom = '12:00 AM';
  String timeTo = '11:59 PM';
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

    return isWithinRange;
  }

  Future<void> fetchFileData(String filepath) async {
    // Reference to the file in Firebase Storage
    Reference ref = FirebaseStorage.instance.ref(filepath);

    // Get the download URL
    String downloadURL = await ref.getDownloadURL();

    // Create an anchor element (a) with the download URL
    html.AnchorElement(href: downloadURL)
      ..target = 'blank'
      ..click();
  }

  String getFileNameFromUrl(String downloadUrl) {
    Uri uri = Uri.parse(downloadUrl);
    List<String> pathSegments = uri.pathSegments;

    // The last path segment contains the encoded filename
    String lastSegment = pathSegments.last;

    // Decode the filename
    String decodedFileName = Uri.decodeFull(lastSegment);

    // Extract only the filename without the path
    String filenameOnly = decodedFileName.split('/').last;

    return filenameOnly;
  }

  getfilteredschedule(List<ScheduleData> filteredSchedules) {
    filteredSchedules.where((schedule) {
      DateTime now = DateTime.now();
      DateTime scheduleDate = schedule.scheduledate;

      return DateFormat('yyyy-MM-dd').format(scheduleDate) ==
          DateFormat('yyyy-MM-dd').format(_selectedDay);
    }).toList();
    for (var schedule in filteredSchedules) {
      isHovered.add(false);
    }
  }

  List<ScheduleData> filteredSchedules = [];

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

  void getfutureclass() async {
    var futureclassdatatemp =
        await EnrolledClassFuture(uid: widget.uID, role: 'student')
            .getenrolled();

    if (mounted) {
      setState(() {
        futureclassdata = futureclassdatatemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final int listIndex = context.select((InitProvider s) => s.listIndex);

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
            elevation: 4,
            child: Container(
              height: 50,
              width: ResponsiveBuilder.isDesktop(context)
                  ? size.width - 300
                  : size.width - 30,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(-0.1, 0), // 0% from the top center
                  end: Alignment.centerRight, // 86% to the bottom center
                  // transform: GradientRotation(1.57), // 90 degrees rotation
                  colors: secondaryHeadercolors, // Add your desired colors here
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Calendar",
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
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            child: SizedBox(
              width: ResponsiveBuilder.isDesktop(context)
                  ? size.width - 300
                  : size.width - 30,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: ResponsiveBuilder.isDesktop(context)
                        ? size.width - 300
                        : ResponsiveBuilder.isTablet(context)
                            ? size.width - 230
                            : size.width - 30,
                    height: 500,
                    child: MouseRegion(
                      onHover: (event) {},
                      cursor: SystemMouseCursors.click,
                      child: Consumer<List<Schedule>>(
                          builder: (context, scheduleListdata, _) {
                        dynamic data = scheduleListdata;
                        getfutureclass();
                        List<ClassesData> enrolledlist = futureclassdata;
                        List<ScheduleData> scheduleList1 =
                            getCombinedSchedule(enrolledlist);
                        filteredSchedules = scheduleList1.where((schedule) {
                          DateTime scheduleDate = schedule.scheduledate;
                          return DateFormat('yyyy-MM-dd')
                                  .format(scheduleDate) ==
                              DateFormat('yyyy-MM-dd').format(_selectedDay);
                        }).toList();

                        for (var schedule in filteredSchedules) {
                          isHovered.add(false);
                        }
                        List<Schedule> scheduleList = scheduleListdata
                            .where((schedule) => enrolledlist.any((enrolled) =>
                                enrolled.classid == schedule.scheduleID))
                            .toList();
                        // for (Schedule schedule in scheduleListdata) {
                        //   if (enrolledlist.any((enrolled) =>
                        //       enrolled.classid == schedule.scheduleID.toString())) {
                        //     scheduleList.add(schedule);
                        //   }
                        // }
                        // if (enrolledlist.isEmpty) {
                        //   return const Center(
                        //       child: CircularProgressIndicator(
                        //     strokeWidth: 6,
                        //     color: Color.fromRGBO(1, 118, 132, 1),
                        //   ));
                        // }
                        return TableCalendar(
                          shouldFillViewport: false,
                          firstDay: DateTime(1950, 8),
                          lastDay: DateTime(5000),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          daysOfWeekHeight: 60,
                          rowHeight: 60,
                          headerStyle: HeaderStyle(
                            titleTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(
                                    -0.1, 0), // 0% from the top center
                                end: Alignment
                                    .centerRight, // 86% to the bottom center
                                // transform: GradientRotation(1.57), // 90 degrees rotation
                                colors:
                                    secondaryHeadercolors, // Add your desired colors here
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            formatButtonVisible: false,
                            leftChevronIcon: const Icon(
                              Icons.arrow_left_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            rightChevronIcon: const Icon(
                              Icons.arrow_right_outlined,
                              color: Colors.white,
                              size: 28,
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
                                color: kColorGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          calendarStyle: CalendarStyle(
                            // Weekend dates color (Sat & Sun Column)
                            weekendTextStyle: const TextStyle(
                                color: kColorGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
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
                              color: kColorGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            // highlighted color for today
                            todayDecoration: BoxDecoration(
                              color: kSecondarybuttonblue,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xFF616161),
                              ),
                            ),
                            // highlighted color for selected day
                            selectedDecoration: BoxDecoration(
                              color: kSecondarybuttonblue,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xFF616161),
                              ),
                            ),
                          ),
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                selectedbooking = null;
                                selectedbookingdata = null;
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            }
                          },
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, _) {
                              int count = 0;
                              String date1 = '';
                              for (var highlightedDate in scheduleList) {
                                if (isSameDay(date, highlightedDate.schedule)) {
                                  date1 = highlightedDate.scheduleID;
                                  count++;
                                }
                              }

                              if (count > 0) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: ResponsiveBuilder.isDesktop(context)
                ? size.width - 300
                : size.width - 30,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMMM, dd').format(_selectedDay),
                                style: TextStyle(
                                  fontSize: ResponsiveBuilder.isDesktop(context)
                                      ? 18
                                      : 16,
                                  fontWeight: FontWeight.w800,
                                  color: kColorGrey,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                daystatus == false
                                    ? "(${(filteredSchedules.length)} Classes today)"
                                    : 'Day Off',
                                style: TextStyle(
                                  fontSize: ResponsiveBuilder.isDesktop(context)
                                      ? 18
                                      : 16,
                                  fontWeight: FontWeight.normal,
                                  color: kColorGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: ResponsiveBuilder.isDesktop(context)
                                ? size.width - 720
                                : ResponsiveBuilder.isTablet(context)
                                    ? size.width - 450
                                    : size.width - 30,
                            height: 600,
                            child: SizedBox(
                              width: ResponsiveBuilder.isDesktop(context)
                                  ? size.width - 870
                                  : ResponsiveBuilder.isTablet(context)
                                      ? size.width - 600
                                      : size.width - 30,
                              height: 600,
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
                                              left: 5,
                                              right: 0,
                                              bottom: 0,
                                              top: 0),
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
                                      final isSelectable =
                                          isTimeWithinRange(time);
                                      // Check if the time is in the bookings list
                                      final isTimeInBookings =
                                          filteredSchedules.any((booking) {
                                        String from24Hour =
                                            convertTo24HourFormat(
                                                booking.timefrom);
                                        String to24Hour = convertTo24HourFormat(
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
                                          hour:
                                              int.parse(to24Hour.split(':')[0]),
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
                                                    time.minute <=
                                                        timeTo.minute));
                                      });
                                      if (isTimeInBookings) {
                                        // Display only the timeFrom from the booking
                                        final isTimefrom =
                                            filteredSchedules.any((booking) {
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
                                          for (var booking
                                              in filteredSchedules) {
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
                                                timeFrom.minute ==
                                                    time.minute) {
                                              currentbooking = booking;
                                              break;
                                            }
                                          }
                                          if (currentbooking.subjectinfo !=
                                              null) {
                                            for (var booking
                                                in filteredSchedules) {
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
                                                  timeFrom.minute ==
                                                      time.minute) {
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
                                                              String
                                                                  from24Hour =
                                                                  convertTo24HourFormat(
                                                                      booking
                                                                          .timefrom);
                                                              final timeFrom =
                                                                  TimeOfDay(
                                                                hour: int.parse(
                                                                    from24Hour
                                                                        .split(
                                                                            ':')[0]),
                                                                minute: (int.parse(from24Hour
                                                                            .split(':')[1]
                                                                            .split(' ')[0]) +
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
                                                                final materialNotifier =
                                                                    Provider.of<
                                                                            MaterialNotifier>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                materialNotifier
                                                                    .getMaterials(
                                                                        selectedbooking!
                                                                            .classID);
                                                                break;
                                                              }
                                                            }
                                                          });
                                                        }
                                                      : null,
                                                  onHover: (isHovered) {
                                                    setState(() {
                                                      this.isHovered[
                                                              bookingIndex] =
                                                          isHovered;
                                                    });
                                                  },
                                                  child: Tooltip(
                                                    message: 'Booked',
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0), // Circular border radius
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        width: 740,
                                                        height: 132,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              kColorSecondary,
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
                                                            Visibility(
                                                              visible:
                                                                  currentbooking
                                                                          .type !=
                                                                      'blocked',
                                                              child: Text(
                                                                currentbooking
                                                                            .tutorinfo !=
                                                                        null
                                                                    ? '${currentbooking.tutorinfo!.firstName} ${currentbooking.tutorinfo!.lastname}'
                                                                    : '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible:
                                                                  currentbooking
                                                                          .type !=
                                                                      'blocked',
                                                              child: Text(
                                                                currentbooking
                                                                            .subjectinfo !=
                                                                        null
                                                                    ? '${currentbooking.subjectinfo!.subjectName} Class ${currentbooking.session}'
                                                                    : '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                            Text(
                                                              currentbooking
                                                                          .type ==
                                                                      'blocked'
                                                                  ? 'Blocked'
                                                                  : 'Booked',
                                                              style: TextStyle(
                                                                  color: currentbooking
                                                                              .type ==
                                                                          'blocked'
                                                                      ? Colors
                                                                          .black
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
                                                width: 740,
                                                height: indexSelect == index
                                                    ? 200
                                                    : 12,
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
                            ),
                          ),
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
                                style: TextStyle(
                                    fontSize:
                                        ResponsiveBuilder.isDesktop(context)
                                            ? 18
                                            : 16,
                                    fontWeight: FontWeight.w800,
                                    color: kColorGrey),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: selectedbooking!.studentinfo!
                                                        .profilelink !=
                                                    ''
                                                ? Image.network(
                                                    selectedbooking!
                                                        .tutorinfo!.imageID,
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
                                            '${selectedbooking!.tutorinfo!.firstName} ${selectedbooking!.tutorinfo!.lastname}',
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            selectedbooking!.tutorinfo!.tutorID,
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
                                          const Spacer(),
                                          const Text(
                                            'Class Materials',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Consumer<List<Schedule>>(builder:
                                              (context, scheduleListdata, _) {
                                            if (scheduleListdata.isEmpty) {
                                              return Center(
                                                child: Text(
                                                  '(Link will be attached when student set class schedule!)',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.blue.shade200,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              );
                                            }
                                            dynamic data = scheduleListdata;
                                            // ClassesData?
                                            //     newclassdata =
                                            //     widget.enrolledClass;
                                            List<Schedule> filtereddata = data
                                                .where((element) =>
                                                    element.scheduleID ==
                                                    selectedbooking!.classID)
                                                .toList();
                                            filtereddata.sort((a, b) => a
                                                .schedule
                                                .compareTo(b.schedule));
                                            Schedule selectedSchedule =
                                                filtereddata.firstWhere(
                                              (schedule) =>
                                                  schedule.schedule ==
                                                      selectedbooking!
                                                          .scheduledate &&
                                                  schedule.timefrom ==
                                                      selectedbooking!.timefrom,
                                              orElse: () => throw Exception(
                                                  'No matching schedule found.'),
                                            );
                                            int index = filtereddata
                                                .indexOf(selectedSchedule);
                                            return Consumer<MaterialNotifier>(
                                                builder: (context,
                                                    materialNotifier, _) {
                                              if (materialNotifier
                                                  .materials.isEmpty) {
                                                return SizedBox(
                                                  width: 600,
                                                  child: Center(
                                                    child: Text(
                                                      '(No materials added!)',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors
                                                              .blue.shade200,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                ); // Show loading indicator
                                              }
                                              List<Map<String, dynamic>>
                                                  materialsdata =
                                                  materialNotifier.materials
                                                      .where((element) =>
                                                          element['classno'] ==
                                                          index.toString())
                                                      .toList();
                                              if (materialsdata.isEmpty) {
                                                return Container(
                                                    width: 600,
                                                    child: Center(
                                                      child: Text(
                                                        '(No materials added!)',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors
                                                                .blue.shade200,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    )); // Show loading indicator
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        width: 600,
                                                        height: 120,
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              iconSize: 12,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              splashRadius: 1,
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_back_ios, // Left arrow icon
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              onPressed: () {
                                                                // Scroll to the left
                                                                updatescrollController1
                                                                    .animateTo(
                                                                  updatescrollController1
                                                                          .offset -
                                                                      100.0, // Adjust the value as needed
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500), // Adjust the duration as needed
                                                                  curve: Curves
                                                                      .ease,
                                                                );
                                                              },
                                                            ),
                                                            Expanded(
                                                              child: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                controller:
                                                                    updatescrollController1, // Assign the ScrollController to the ListView
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount:
                                                                    materialsdata
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  if (materialsdata[
                                                                              index]
                                                                          [
                                                                          'extension'] ==
                                                                      'Image') {
                                                                    return FutureBuilder(
                                                                        future: FirebaseStorage
                                                                            .instance
                                                                            .ref(materialsdata[index][
                                                                                'reference'])
                                                                            .getDownloadURL(),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot.connectionState ==
                                                                              ConnectionState.waiting) {
                                                                            return Container(
                                                                                height: 60,
                                                                                width: 60,
                                                                                child: const Center(
                                                                                    child: CircularProgressIndicator(
                                                                                  strokeWidth: 2,
                                                                                  color: Color.fromRGBO(1, 118, 132, 1),
                                                                                ))); // Display a loading indicator while waiting for the file to download
                                                                          } else if (snapshot.hasError) {
                                                                            return Text('Error: ${snapshot.error}');
                                                                          }

                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10.0, right: 10),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        showDialog(
                                                                                            barrierDismissible: false,
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              var height = MediaQuery.of(context).size.height;
                                                                                              return AlertDialog(
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                                                ),
                                                                                                contentPadding: EdgeInsets.zero,
                                                                                                content: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(15.0), // Same radius as above
                                                                                                  child: Container(
                                                                                                    color: Colors.white, // Set the background color of the circular content

                                                                                                    child: Stack(
                                                                                                      children: <Widget>[
                                                                                                        SizedBox(
                                                                                                          height: height,
                                                                                                          width: 900,
                                                                                                          child: ViewFile(imageURL: snapshot.data.toString()),
                                                                                                        ),
                                                                                                        Positioned(
                                                                                                          top: 10.0,
                                                                                                          right: 10.0,
                                                                                                          child: GestureDetector(
                                                                                                            onTap: () {
                                                                                                              Navigator.of(context).pop(false); // Close the dialog
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
                                                                                      child: Container(
                                                                                        height: 60,
                                                                                        width: 60,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          color: Colors.grey.shade200,
                                                                                        ),
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                                          child: Image.network(
                                                                                            snapshot.data.toString(),
                                                                                            fit: BoxFit.cover,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Center(
                                                                                      child: Tooltip(
                                                                                        message: getFileNameFromUrl(snapshot.data.toString()),
                                                                                        child: SizedBox(
                                                                                          height: 60,
                                                                                          width: 60,
                                                                                          child: TextButton(
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                fetchFileData(snapshot.data.toString());
                                                                                              });
                                                                                            },
                                                                                            child: Text(
                                                                                              getFileNameFromUrl(snapshot.data.toString()),
                                                                                              style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        });
                                                                  } else if (materialsdata[
                                                                              index]
                                                                          [
                                                                          'extension'] ==
                                                                      'pdf') {
                                                                    return FutureBuilder(
                                                                        future: FirebaseStorage
                                                                            .instance
                                                                            .ref(materialsdata[index][
                                                                                'reference'])
                                                                            .getDownloadURL(),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot.connectionState ==
                                                                              ConnectionState.waiting) {
                                                                            return Container(
                                                                                height: 60,
                                                                                width: 60,
                                                                                child: const Center(
                                                                                    child: CircularProgressIndicator(
                                                                                  strokeWidth: 2,
                                                                                  color: Color.fromRGBO(1, 118, 132, 1),
                                                                                ))); // Display a loading indicator while waiting for the file to download
                                                                          } else if (snapshot.hasError) {
                                                                            return Text('Error: ${snapshot.error}');
                                                                          }
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10.0, right: 10),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        showDialog(
                                                                                            barrierDismissible: false,
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              var height = MediaQuery.of(context).size.height;
                                                                                              return AlertDialog(
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                                                ),
                                                                                                contentPadding: EdgeInsets.zero,
                                                                                                content: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(15.0), // Same radius as above
                                                                                                  child: Container(
                                                                                                    color: Colors.white, // Set the background color of the circular content

                                                                                                    child: Stack(
                                                                                                      children: <Widget>[
                                                                                                        SizedBox(
                                                                                                          height: height,
                                                                                                          width: 900,
                                                                                                          child: TermPage(pdfurl: snapshot.data.toString()),
                                                                                                        ),
                                                                                                        Positioned(
                                                                                                          top: 10.0,
                                                                                                          right: 10.0,
                                                                                                          child: GestureDetector(
                                                                                                            onTap: () {
                                                                                                              Navigator.of(context).pop(false); // Close the dialog
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
                                                                                      child: Container(
                                                                                        height: 60,
                                                                                        width: 60,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          color: Colors.grey.shade200, // You can adjust the fit as needed.
                                                                                        ),
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                                          child: const Icon(
                                                                                            Icons.picture_as_pdf,
                                                                                            size: 48,
                                                                                            color: Colors.red,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Center(
                                                                                      child: Tooltip(
                                                                                        message: getFileNameFromUrl(snapshot.data.toString()),
                                                                                        child: SizedBox(
                                                                                          height: 60,
                                                                                          width: 60,
                                                                                          child: TextButton(
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                fetchFileData(snapshot.data.toString());
                                                                                              });
                                                                                            },
                                                                                            child: Text(
                                                                                              getFileNameFromUrl(snapshot.data.toString()),
                                                                                              style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        });
                                                                  } else {
                                                                    return FutureBuilder(
                                                                        future: FirebaseStorage
                                                                            .instance
                                                                            .ref(materialsdata[index][
                                                                                'reference'])
                                                                            .getDownloadURL(),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot.connectionState ==
                                                                              ConnectionState.waiting) {
                                                                            return Container(
                                                                                height: 60,
                                                                                width: 60,
                                                                                child: const Center(
                                                                                    child: CircularProgressIndicator(
                                                                                  strokeWidth: 2,
                                                                                  color: Color.fromRGBO(1, 118, 132, 1),
                                                                                ))); // Display a loading indicator while waiting for the file to download
                                                                          } else if (snapshot.hasError) {
                                                                            return Text('Error: ${snapshot.error}');
                                                                          }
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10.0, right: 10),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        showDialog(
                                                                                            barrierDismissible: false,
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              var height = MediaQuery.of(context).size.height;
                                                                                              return AlertDialog(
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                                                ),
                                                                                                contentPadding: EdgeInsets.zero,
                                                                                                content: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(15.0), // Same radius as above
                                                                                                  child: Container(
                                                                                                    color: Colors.white, // Set the background color of the circular content

                                                                                                    child: Stack(
                                                                                                      children: <Widget>[
                                                                                                        SizedBox(
                                                                                                          height: height,
                                                                                                          width: 900,
                                                                                                          child: ViewFile(imageURL: snapshot.data.toString()),
                                                                                                        ),
                                                                                                        Positioned(
                                                                                                          top: 10.0,
                                                                                                          right: 10.0,
                                                                                                          child: GestureDetector(
                                                                                                            onTap: () {
                                                                                                              Navigator.of(context).pop(false); // Close the dialog
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
                                                                                      child: Container(
                                                                                        height: 60,
                                                                                        width: 60,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          color: Colors.grey.shade200, // You can adjust the fit as needed.
                                                                                        ),
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                                          child: const Icon(
                                                                                            FontAwesomeIcons.fileWord,
                                                                                            size: 48,
                                                                                            color: Colors.blue,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Center(
                                                                                      child: Tooltip(
                                                                                        message: getFileNameFromUrl(snapshot.data.toString()),
                                                                                        child: SizedBox(
                                                                                          height: 60,
                                                                                          width: 60,
                                                                                          child: TextButton(
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                fetchFileData(snapshot.data.toString());
                                                                                              });
                                                                                            },
                                                                                            child: Text(
                                                                                              getFileNameFromUrl(snapshot.data.toString()),
                                                                                              style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        });
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            IconButton(
                                                              iconSize: 12,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              splashRadius: 1,
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios, // Right arrow icon
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              onPressed: () {
                                                                // Scroll to the right
                                                                updatescrollController1
                                                                    .animateTo(
                                                                  updatescrollController1
                                                                          .offset +
                                                                      100.0, // Adjust the value as needed
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500), // Adjust the duration as needed
                                                                  curve: Curves
                                                                      .ease,
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              );
                                            });
                                          }),
                                          const Spacer(),
                                          const Text(
                                            'Class Link',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 100,
                                            child: Center(
                                              child: Consumer<List<Schedule>>(
                                                  builder: (context,
                                                      scheduleListdata, _) {
                                                if (scheduleListdata.isEmpty) {
                                                  return Center(
                                                    child: Text(
                                                      '(Link will be attached when student set class schedule!)',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors
                                                              .blue.shade200,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  );
                                                }
                                                dynamic data = scheduleListdata;
                                                // ClassesData?
                                                //     newclassdata =
                                                //     widget.enrolledClass;
                                                List<Schedule> filtereddata =
                                                    data
                                                        .where((element) =>
                                                            element
                                                                .scheduleID ==
                                                            selectedbooking!
                                                                .classID)
                                                        .toList();
                                                filtereddata.sort((a, b) => a
                                                    .schedule
                                                    .compareTo(b.schedule));
                                                Schedule selectedSchedule =
                                                    filtereddata.firstWhere(
                                                  (schedule) =>
                                                      schedule.schedule ==
                                                          selectedbooking!
                                                              .scheduledate &&
                                                      schedule.timefrom ==
                                                          selectedbooking!
                                                              .timefrom,
                                                  orElse: () => throw Exception(
                                                      'No matching schedule found.'),
                                                );
                                                int index = filtereddata
                                                    .indexOf(selectedSchedule);
                                                if (selectedSchedule
                                                        .meetinglink !=
                                                    '') {
                                                  return Center(
                                                    child: MouseRegion(
                                                      cursor: SystemMouseCursors
                                                          .click,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // const VideoCall videoCall = VideoCall(chatID: '123', uID: '456');

                                                          // Replace 'your_flutter_app_port' with the actual port your Flutter web app is running on
                                                          String url =
                                                              'http://localhost:58586/tutorsList';

                                                          // Open the URL in a new tab
                                                          // html.window.open('/videoCall', "");
                                                          // html.window.open('/tutorslist', "");
                                                          //  const VideoCall(chatID: '', uID: '',);
                                                        },
                                                        child: Text(
                                                          'work4ututor/${filtereddata[index].meetinglink}',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.blue
                                                                  .shade200,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return Center(
                                                  child: Text(
                                                    '(Link will be attached when student set class schedule!)',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors
                                                            .blue.shade200,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                );
                                              }),
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
        ],
      ),
    );
  }
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
