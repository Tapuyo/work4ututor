// ignore_for_file: unused_local_variable, prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:work4ututor/data_class/studentinfoclass.dart';
import 'package:work4ututor/ui/web/tutor/calendar/setup_calendar.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/init_provider.dart';
import '../../../../services/getcalendardata.dart';
import '../../../../services/getmaterials.dart';
import '../../../../services/timefromtimestamp.dart';
import '../../../../services/timestampconverter.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';
import '../../terms/termpage.dart';
import '../tutor_profile/view_file.dart';
import 'package:universal_html/html.dart' as html;

// class TableBasicsExample1 extends StatefulWidget {
//   final String uID;
//   final TutorInformation tutor;
//   const TableBasicsExample1({Key? key, required this.uID, required this.tutor})
//       : super(key: key);

//   @override
//   State<TableBasicsExample1> createState() => _TableBasicsExample1State();
// }

// class _TableBasicsExample1State extends State<TableBasicsExample1> {
//   String selectedDate = DateFormat('MMMM dd,').format(DateTime.now());

//   int count = 0;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return TableBasicsExample(
//       uID: widget.uID,
//       tutor: widget.tutor,
//     );
//   }
// }

class TableBasicsExample1 extends StatefulWidget {
  final String uID;
  final TutorInformation tutor;

  const TableBasicsExample1(
      {super.key, required this.uID, required this.tutor});

  @override
  State<TableBasicsExample1> createState() => _TableBasicsExample1State();
}

class _TableBasicsExample1State extends State<TableBasicsExample1> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartNotifier =
          Provider.of<TutorScheduleProvider>(context, listen: false);
      cartNotifier.getDataFromTutorScheduleCollectionAvailableTime(widget.uID);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timedatenotifier =
          Provider.of<TutorScheduleProvider>(context, listen: false);
      timedatenotifier.getDataFromTutorScheduleCollectionAvailableDateTime(
          widget.uID, widget.tutor.timezone);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final availtimedatenotifier =
          Provider.of<TutorScheduleProvider>(context, listen: false);
      availtimedatenotifier.fetchSchedule(
          widget.uID, 'tutor', widget.tutor.timezone);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final blocktimedatenotifier =
          Provider.of<TutorScheduleProvider>(context, listen: false);
      blocktimedatenotifier.getDataFromTutorScheduleCollectionBlockDateTime(
          widget.uID, widget.tutor.timezone);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dayofftimedatenotifier =
          Provider.of<TutorScheduleProvider>(context, listen: false);
      dayofftimedatenotifier.getDataFromTutorScheduleCollection(
          widget.uID, widget.tutor.timezone);
    });
    _controller1.addListener(() {
      _controller2.jumpTo(_controller1.offset);
    });

    _controller2.addListener(() {
      _controller1.jumpTo(_controller2.offset);
    });
    super.initState();
  }

  Future<void> fetchFileData(String filepath) async {
    Reference ref = FirebaseStorage.instance.ref(filepath);

    String downloadURL = await ref.getDownloadURL();

    html.AnchorElement(href: downloadURL)
      ..target = 'blank'
      ..click();
  }

  String timeFrom = '12:00 AM';
  String timeTo = '11:59 PM';

  List<BlockDate> blocktime = [];

  List<DateTimeAvailability> dateavailabledateselected = [];

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
        String from24Hourcompare = convertTo24HourFormat(selectedTimeRange.timeAvailableFrom);
        String to24Hourcompare = convertTo24HourFormat(selectedTimeRange.timeAvailableTo);
        TimeOfDay from = TimeOfDay(
          hour: int.parse(from24Hourcompare.split(':')[0]),
          minute: int.parse(from24Hourcompare.split(':')[1]),
        );

        TimeOfDay to = TimeOfDay(
          hour: int.parse(to24Hourcompare.split(':')[0]),
          minute: int.parse(to24Hourcompare.split(':')[1]),
        );

        int currentTimeInMinutes = time.hour * 60 + time.minute;
        int comparefromTimeInMinutes = from.hour * 60 + from.minute;
        int comparetoTimeInMinutes = to.hour * 60 + to.minute;

        if (comparefromTimeInMinutes > comparetoTimeInMinutes) {
          String from24Hour1 = convertTo24HourFormat(selectedTimeRange.timeAvailableFrom);
          String to24Hour1 = convertTo24HourFormat('11:59 PM');
          String from24Hour2 = convertTo24HourFormat('12:01 AM');
          String to24Hour2 = convertTo24HourFormat(selectedTimeRange.timeAvailableTo);
          TimeOfDay from1 = TimeOfDay(
            hour: int.parse(from24Hour1.split(':')[0]),
            minute: int.parse(from24Hour1.split(':')[1]),
          );

          TimeOfDay to1 = TimeOfDay(
            hour: int.parse(to24Hour1.split(':')[0]),
            minute: int.parse(to24Hour1.split(':')[1]),
          );
          //convert to int
          int fromTimeInMinutes1 = from1.hour * 60 + from.minute;
          int toTimeInMinutes1 = to1.hour * 60 + to.minute + 5;
          TimeOfDay from2 = TimeOfDay(
            hour: int.parse(from24Hour2.split(':')[0]),
            minute: int.parse(from24Hour2.split(':')[1]),
          );

          TimeOfDay to2 = TimeOfDay(
            hour: int.parse(to24Hour2.split(':')[0]),
            minute: int.parse(to24Hour2.split(':')[1]),
          );
          //convert to int
          int fromTimeInMinutes2 = from2.hour * 60 + from.minute - 60;
          int toTimeInMinutes2 = to2.hour * 60 + to.minute;
          if (currentTimeInMinutes >= fromTimeInMinutes2 &&
                  currentTimeInMinutes <= toTimeInMinutes2 ||
              currentTimeInMinutes >= fromTimeInMinutes1 &&
                  currentTimeInMinutes <= toTimeInMinutes1) {
            isWithinRange =
                true; // Exit the loop when the first valid range is found
          }
        } else {
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
      }
    } else {
      // from24Hour = convertTo24HourFormat(timeFrom);
      // to24Hour = convertTo24HourFormat(timeTo);
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

      // if (currentTimeInMinutes >= fromTimeInMinutes &&
      //     currentTimeInMinutes <= toTimeInMinutes) {
      //   isWithinRange =
      //       true; // Exit the loop when the first valid range is found
      // }

      // -----new implementation with time conversion-------
      String from24Hourcompare = convertTo24HourFormat(timeFrom);
      String to24Hourcompare = convertTo24HourFormat(timeTo);
      TimeOfDay from = TimeOfDay(
        hour: int.parse(from24Hourcompare.split(':')[0]),
        minute: int.parse(from24Hourcompare.split(':')[1]),
      );

      TimeOfDay to = TimeOfDay(
        hour: int.parse(to24Hourcompare.split(':')[0]),
        minute: int.parse(to24Hourcompare.split(':')[1]),
      );

      int currentTimeInMinutes = time.hour * 60 + time.minute;
      int comparefromTimeInMinutes = from.hour * 60 + from.minute;
      int comparetoTimeInMinutes = to.hour * 60 + to.minute;

      if (comparefromTimeInMinutes > comparetoTimeInMinutes) {
        String from24Hour1 = convertTo24HourFormat(timeFrom);
        String to24Hour1 = convertTo24HourFormat('11:59 PM');
        String from24Hour2 = convertTo24HourFormat('12:01 AM');
        String to24Hour2 = convertTo24HourFormat(timeTo);
        TimeOfDay from1 = TimeOfDay(
          hour: int.parse(from24Hour1.split(':')[0]),
          minute: int.parse(from24Hour1.split(':')[1]),
        );

        TimeOfDay to1 = TimeOfDay(
          hour: int.parse(to24Hour1.split(':')[0]),
          minute: int.parse(to24Hour1.split(':')[1]),
        );
        //convert to int
        int fromTimeInMinutes1 = from1.hour * 60 + from.minute;
        int toTimeInMinutes1 = to1.hour * 60 + to.minute + 5;
        TimeOfDay from2 = TimeOfDay(
          hour: int.parse(from24Hour2.split(':')[0]),
          minute: int.parse(from24Hour2.split(':')[1]),
        );

        TimeOfDay to2 = TimeOfDay(
          hour: int.parse(to24Hour2.split(':')[0]),
          minute: int.parse(to24Hour2.split(':')[1]),
        );
        //convert to int
        int fromTimeInMinutes2 = from2.hour * 60 + from.minute - 60;
        int toTimeInMinutes2 = to2.hour * 60 + to.minute;
        if (currentTimeInMinutes >= fromTimeInMinutes2 &&
                currentTimeInMinutes <= toTimeInMinutes2 ||
            currentTimeInMinutes >= fromTimeInMinutes1 &&
                currentTimeInMinutes <= toTimeInMinutes1) {
          isWithinRange =
              true; // Exit the loop when the first valid range is found
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
    }

    return isWithinRange;
  }

  ScrollController updatescrollController1 = ScrollController();
  ScrollController _controller1 = ScrollController();
  ScrollController _controller2 = ScrollController();
  ScrollController controller3 = ScrollController();

  Set<int> selectedIndices = Set<int>();
  double containerX = 100.0; // Initial X position of the container
  double containerY = 100.0;
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

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  List<bool> isHovered = [];
  List<Schedule> finalschedule = [];
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
    return schedule;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<TutorInformation> tutorinfodata =
        Provider.of<List<TutorInformation>>(context);
    List<ClassesData> enrolledClasses = Provider.of<List<ClassesData>>(context);

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
    // for (var schedule in filteredSchedules) {
    //   isHovered.add(false);
    // }
    List<Widget> timeCards = generateTimeCards();

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
              child: ResponsiveBuilder.isMobile(context)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ResponsiveBuilder.isDesktop(context)
                              ? size.width - 500
                              : ResponsiveBuilder.isTablet(context)
                                  ? size.width - 230
                                  : size.width - 30,
                          height: 500,
                          child: Card(
                            elevation: 1,
                            child: Consumer<TutorScheduleProvider>(
                                builder: (context, scheduletime, _) {
                              if (scheduletime.availableDateSelected != null) {
                                timeFrom = updateTime(
                                    widget.tutor.timezone,
                                    scheduletime.availableDateSelected!
                                        .timeAvailableFrom);
                                timeTo = updateTime(
                                    widget.tutor.timezone,
                                    scheduletime.availableDateSelected!
                                        .timeAvailableTo);
                              } else {
                                timeFrom = '12:00 AM';
                                timeTo = '11:59 PM';
                              }
                              if (scheduletime.dateavailabledateselected !=
                                  null) {
                                dateavailabledateselected =
                                    scheduletime.dateavailabledateselected!;
                              } else {
                                dateavailabledateselected = [];
                              }
                              if (scheduletime.blockdateselected != null) {
                                blocktime = scheduletime.blockdateselected!;
                              } else {
                                blocktime = [];
                              }
                              if (scheduletime.dayOffs != null ||
                                  scheduletime.dayOffsdate != null) {
                                dayOffs = scheduletime.dayOffs!;
                                dayOffsdate = scheduletime.dayOffsdate!;
                              } else {
                                dayOffs = [];
                                dayOffsdate = [];
                              }
                              if (scheduletime.finalschedule != null) {
                                finalschedule = scheduletime.finalschedule!;
                              } else {
                                finalschedule = [];
                              }
                              if (scheduletime.forlistdayoffsdate != null ||
                                  scheduletime.forlistdayoffsdate != []) {
                                print(scheduletime.forlistdayoffsdate);
                              } else {
                                print('way sulod');
                              }

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
                                  setState(() {
                                    selectedbooking = null;
                                  });
                                },

                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, date, _) {
                                    int count = 0;
                                    for (var highlightedDate in finalschedule) {
                                      if (isSameDay(
                                          date, highlightedDate.schedule)) {
                                        count++;
                                      }
                                    }
                                    int blockcount = 0;
                                    for (var blockdata in blocktime) {
                                      if (isSameDay(
                                          date, blockdata.blockDate)) {
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
                                            width: 12,
                                            height: 12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: kCalendarColorFB,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
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
                                            width: 12,
                                            height: 12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: kCalendarColorAB,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: null,
                                          ),
                                          Container(
                                            width: 12,
                                            height: 12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: calendarRed,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
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
                                            width: 12,
                                            height: 12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: kCalendarColorFB,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
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
                                            width: 12,
                                            height: 12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: kCalendarColorAB,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
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
                                            width: 12,
                                            height: 12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: kCalendarColorAB,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
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
                                            width: 12,
                                            height: 12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: kCalendarColorAB,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: null,
                                          ),
                                          Container(
                                            width: 12,
                                            height: 12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: calendarRed,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
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
                                          color: calendarRed,
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
                                          color: calendarRed,
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
                                          color: kColorGrey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
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
                              );
                            }),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: size.width - 30,
                            child: SingleChildScrollView(
                                controller: ScrollController(),
                                child: tableLedger(
                                    context, tutorinfodata, scheduleList))),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ResponsiveBuilder.isDesktop(context)
                              ? size.width - 500
                              : ResponsiveBuilder.isTablet(context)
                                  ? size.width - 230
                                  : size.width - 230,
                          height: 500,
                          child: MouseRegion(
                            onHover: (event) {},
                            cursor: SystemMouseCursors.click,
                            child: Consumer<TutorScheduleProvider>(
                                builder: (context, scheduletime, _) {
                              if (scheduletime.availableDateSelected != null) {
                                timeFrom = updateTime(
                                    widget.tutor.timezone,
                                    scheduletime.availableDateSelected!
                                        .timeAvailableFrom);
                                timeTo = updateTime(
                                    widget.tutor.timezone,
                                    scheduletime.availableDateSelected!
                                        .timeAvailableTo);
                              } else {
                                timeFrom = '12:00 AM';
                                timeTo = '11:59 PM';
                              }
                              if (scheduletime.dateavailabledateselected !=
                                  null) {
                                dateavailabledateselected =
                                    scheduletime.dateavailabledateselected!;
                              } else {
                                dateavailabledateselected = [];
                              }
                              if (scheduletime.blockdateselected != null) {
                                blocktime = scheduletime.blockdateselected!;
                              } else {
                                blocktime = [];
                              }
                              if (scheduletime.dayOffs != null ||
                                  scheduletime.dayOffsdate != null) {
                                dayOffs = scheduletime.dayOffs!;
                                dayOffsdate = scheduletime.dayOffsdate!;
                              } else {
                                dayOffs = [];
                                dayOffsdate = [];
                              }
                              if (scheduletime.finalschedule != null) {
                                finalschedule = scheduletime.finalschedule!;
                              } else {
                                finalschedule = [];
                              }
                               if (scheduletime.forlistdayoffsdate != null) {
                                print('Total length ${scheduletime.forlistdayoffsdate!.length}');
                              } else {
                                print('Walay Sulod');
                              }


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
                                  setState(() {
                                    selectedbooking = null;
                                  });
                                },

                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, date, _) {
                                    int count = 0;
                                    for (var highlightedDate in finalschedule) {
                                      if (isSameDay(
                                          date, highlightedDate.schedule)) {
                                        count++;
                                      }
                                    }
                                    int blockcount = 0;
                                    for (var blockdata in blocktime) {
                                      if (isSameDay(
                                          date, blockdata.blockDate)) {
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
                                                color: calendarRed,
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
                                                color: calendarRed,
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
                                          color: calendarRed,
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
                                          color: calendarRed,
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
                                          color: kColorGrey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
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
                              );
                            }),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                            width: 200,
                            child: SingleChildScrollView(
                                controller: ScrollController(),
                                child: tableLedger(
                                    context, tutorinfodata, scheduleList))),
                      ],
                    ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: ResponsiveBuilder.isDesktop(context)
                ? size.width - 300
                : size.width - 30,
            child: ResponsiveBuilder.isMobile(context)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: selectedbooking == null,
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: ResponsiveBuilder.isDesktop(context)
                                        ? size.width - 720
                                        : ResponsiveBuilder.isTablet(context)
                                            ? size.width - 450
                                            : size.width - 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('MMMM, dd')
                                              .format(_selectedDay),
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveBuilder.isDesktop(
                                                          context)
                                                      ? 18
                                                      : 16,
                                              fontWeight: FontWeight.w800,
                                              color: kColorGrey),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            ResponsiveBuilder.isDesktop(context)
                                                ? daystatus == false
                                                    ? "(${(filteredSchedules.where((schedule) => schedule.type == 'class').length)} Classes today)"
                                                    : '(Day Off)'
                                                : daystatus == false
                                                    ? "(${(filteredSchedules.where((schedule) => schedule.type == 'class').length)} Classes)"
                                                    : '(Day Off)',
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize:
                                                    ResponsiveBuilder.isDesktop(
                                                            context)
                                                        ? 18
                                                        : 16,
                                                fontWeight: FontWeight.normal,
                                                color: kColorGrey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                      width: ResponsiveBuilder.isDesktop(
                                              context)
                                          ? size.width - 720
                                          : ResponsiveBuilder.isTablet(context)
                                              ? size.width - 450
                                              : size.width - 30,
                                      height: 600,
                                      child: daystatus == false
                                          ? SizedBox(
                                              width: ResponsiveBuilder
                                                      .isDesktop(context)
                                                  ? size.width - 870
                                                  : ResponsiveBuilder.isTablet(
                                                          context)
                                                      ? size.width - 600
                                                      : size.width - 30,
                                              height: 600,
                                              child: Row(children: [
                                                SizedBox(
                                                  width: 60,
                                                  child: ScrollConfiguration(
                                                    behavior:
                                                        ScrollConfiguration.of(
                                                                context)
                                                            .copyWith(
                                                                scrollbars:
                                                                    false),
                                                    child: ListView.builder(
                                                      itemExtent: 12,
                                                      controller: _controller2,
                                                      itemCount: 24 * 60 ~/ 5,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final time = TimeOfDay(
                                                            hour:
                                                                index * 5 ~/ 60,
                                                            minute:
                                                                (index * 5) %
                                                                    60);
                                                        final isSelectable =
                                                            isTimeWithinRange(
                                                                time);
                                                        final timeText = time
                                                            .format(context);

                                                        TextStyle textStyle =
                                                            TextStyle(
                                                          color: kColorGrey,
                                                          fontWeight:
                                                              time.minute == 0
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                          fontSize: time
                                                                      .minute ==
                                                                  0
                                                              ? 12
                                                              : 8, // Adjust the font size as needed
                                                        );

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5,
                                                                  right: 0,
                                                                  bottom: 0,
                                                                  top: 0),
                                                          child: SizedBox(
                                                            width: 55,
                                                            height: 12,
                                                            child: Text(
                                                              time.minute == 0
                                                                  ? timeText
                                                                  : time.minute %
                                                                              15 ==
                                                                          0
                                                                      ? timeText
                                                                      : '',
                                                              textAlign:
                                                                  time.minute ==
                                                                          0
                                                                      ? TextAlign
                                                                          .start
                                                                      : TextAlign
                                                                          .center,
                                                              style: textStyle,
                                                            ),
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
                                                    itemBuilder:
                                                        (context, index) {
                                                      final time = TimeOfDay(
                                                          hour: index * 5 ~/ 60,
                                                          minute:
                                                              (index * 5) % 60);
                                                      final isSelectable =
                                                          isTimeWithinRange(
                                                              time);
                                                      final timeText =
                                                          time.format(context);

                                                      TextStyle textStyle =
                                                          TextStyle(
                                                        color: kColorGrey,
                                                        fontWeight: time
                                                                    .minute ==
                                                                0
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontSize: time.minute ==
                                                                0
                                                            ? 12
                                                            : 8, // Adjust the font size as needed
                                                      );
                                                      // Check if the time is in the bookings list
                                                      final isTimeInBookings =
                                                          filteredSchedules
                                                              .any((booking) {
                                                        String from24Hour =
                                                            convertTo24HourFormat(
                                                                booking
                                                                    .timefrom);
                                                        String to24Hour =
                                                            convertTo24HourFormat(
                                                                booking.timeto);
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
                                                        final timeTo =
                                                            TimeOfDay(
                                                          hour: int.parse(
                                                              to24Hour.split(
                                                                  ':')[0]),
                                                          minute: (int.parse(to24Hour
                                                                      .split(':')[
                                                                          1]
                                                                      .split(
                                                                          ' ')[0]) +
                                                                  4) ~/
                                                              5 *
                                                              5,
                                                        );

                                                        // Manually compare the hours and minutes
                                                        return (time.hour >
                                                                    timeFrom
                                                                        .hour ||
                                                                (time.hour ==
                                                                        timeFrom
                                                                            .hour &&
                                                                    time.minute >=
                                                                        timeFrom
                                                                            .minute)) &&
                                                            (time.hour <
                                                                    timeTo
                                                                        .hour ||
                                                                (time.hour ==
                                                                        timeTo
                                                                            .hour &&
                                                                    time.minute <=
                                                                        timeTo
                                                                            .minute));
                                                      });
                                                      if (isTimeInBookings) {
                                                        // Display only the timeFrom from the booking
                                                        final isTimefrom =
                                                            filteredSchedules
                                                                .any((booking) {
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
                                                          // Manually compare the hours and minutes
                                                          return (time.hour ==
                                                                  timeFrom
                                                                      .hour &&
                                                              time.minute ==
                                                                  timeFrom
                                                                      .minute);
                                                        });
                                                        if (isTimefrom) {
                                                          int bookingIndex = 0;
                                                          TutorInformation?
                                                              temp1;
                                                          StudentInfoClass?
                                                              temp2;
                                                          SubjectClass? temp3;
                                                          ScheduleData
                                                              currentbooking =
                                                              ScheduleData(
                                                                  studentID: '',
                                                                  tutorID: '',
                                                                  classID: '',
                                                                  scheduleID:
                                                                      '',
                                                                  tutorinfo:
                                                                      temp1,
                                                                  studentinfo:
                                                                      temp2,
                                                                  subjectinfo:
                                                                      temp3,
                                                                  session: '',
                                                                  scheduledate:
                                                                      DateTime
                                                                          .now(),
                                                                  timefrom: '',
                                                                  timeto: '',
                                                                  type: '');
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
                                                            bookingIndex =
                                                                filteredSchedules
                                                                    .indexOf(
                                                                        booking);

                                                            if (timeFrom.hour ==
                                                                    time.hour &&
                                                                timeFrom.minute ==
                                                                    time.minute) {
                                                              currentbooking =
                                                                  booking;
                                                              break;
                                                            }
                                                          }
                                                          if (currentbooking
                                                                  .subjectinfo !=
                                                              null) {
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
                                                                selectedbookingdata =
                                                                    booking;
                                                                break;
                                                              }
                                                            }

                                                            return Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      for (var booking
                                                                          in filteredSchedules) {
                                                                        String
                                                                            from24Hour =
                                                                            convertTo24HourFormat(booking.timefrom);
                                                                        final timeFrom =
                                                                            TimeOfDay(
                                                                          hour:
                                                                              int.parse(from24Hour.split(':')[0]),
                                                                          minute: (int.parse(from24Hour.split(':')[1].split(' ')[0]) + 4) ~/
                                                                              5 *
                                                                              5,
                                                                        );
                                                                        if (timeFrom.hour == time.hour &&
                                                                            timeFrom.minute ==
                                                                                time.minute) {
                                                                          selectedbooking =
                                                                              booking;
                                                                          final materialNotifier = Provider.of<MaterialNotifier>(
                                                                              context,
                                                                              listen: false);
                                                                          materialNotifier
                                                                              .getMaterials(selectedbooking!.classID);
                                                                          break;
                                                                        }
                                                                      }
                                                                    });
                                                                  },
                                                                  // onHover:
                                                                  //     (isHovered) {
                                                                  //   setState(
                                                                  //       () {
                                                                  //     this.isHovered[bookingIndex] =
                                                                  //         isHovered;
                                                                  //   });
                                                                  // },
                                                                  child:
                                                                      Tooltip(
                                                                    message: currentbooking.type ==
                                                                            'blocked'
                                                                        ? 'Blocked'
                                                                        : 'Booked',
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0), // Circular border radius
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        width: currentbooking.type ==
                                                                                'blocked'
                                                                            ? ResponsiveBuilder.isDesktop(context)
                                                                                ? size.width - 780
                                                                                : ResponsiveBuilder.isTablet(context)
                                                                                    ? size.width - 510
                                                                                    : size.width - 110
                                                                            : ResponsiveBuilder.isDesktop(context)
                                                                                ? size.width - 780
                                                                                : ResponsiveBuilder.isTablet(context)
                                                                                    ? size.width - 510
                                                                                    : size.width - 110,
                                                                        height:
                                                                            132,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: currentbooking.type == 'blocked'
                                                                              ? calendarRed
                                                                              : kSecondarybuttonblue,
                                                                          // border:
                                                                          //     Border.all(
                                                                          //   color: isHovered[bookingIndex] ? kColorPrimary : Colors.yellow,
                                                                          //   width: isHovered[bookingIndex] ? 3 : 1,
                                                                          // ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Text(
                                                                                '${selectedbookingdata!.timefrom} to ${selectedbookingdata!.timeto}',
                                                                                style: TextStyle(color: Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600),
                                                                              ),
                                                                            ),
                                                                            Visibility(
                                                                              visible: currentbooking.type != 'blocked',
                                                                              child: Flexible(
                                                                                child: Text(
                                                                                  currentbooking.studentinfo != null ? '${currentbooking.studentinfo!.studentFirstname} ${currentbooking.studentinfo!.studentLastname}' : '',
                                                                                  style: TextStyle(color: Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 18 : 16, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Visibility(
                                                                              visible: currentbooking.type != 'blocked',
                                                                              child: Flexible(
                                                                                child: Text(
                                                                                  currentbooking.subjectinfo != null ? '${currentbooking.subjectinfo!.subjectName} Class ${currentbooking.session}' : '',
                                                                                  style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, fontWeight: FontWeight.w400),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                              child: Text(
                                                                                currentbooking.type == 'blocked' ? 'Blocked' : 'Booked',
                                                                                style: TextStyle(color: currentbooking.type == 'blocked' ? Colors.white : Colors.white, overflow: TextOverflow.ellipsis, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, fontWeight: FontWeight.bold),
                                                                              ),
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
                                                            int bookingIndex =
                                                                0;
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
                                                              bookingIndex =
                                                                  filteredSchedules
                                                                      .indexOf(
                                                                          booking);
                                                              if (timeFrom.hour ==
                                                                      time
                                                                          .hour &&
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
                                                                    .any(
                                                                        (booking) {
                                                              String
                                                                  from24Hour =
                                                                  convertTo24HourFormat(
                                                                      booking
                                                                          .timefrom);
                                                              String to24Hour =
                                                                  convertTo24HourFormat(
                                                                      booking
                                                                          .timeto);
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
                                                              final timeTo =
                                                                  TimeOfDay(
                                                                hour: int.parse(
                                                                    to24Hour.split(
                                                                        ':')[0]),
                                                                minute: (int.parse(to24Hour
                                                                            .split(':')[1]
                                                                            .split(' ')[0]) +
                                                                        4) ~/
                                                                    5 *
                                                                    5,
                                                              );
                                                              DateTime now =
                                                                  DateTime
                                                                      .now();
                                                              DateTime
                                                                  startDateTime =
                                                                  DateTime(
                                                                      now.year,
                                                                      now.month,
                                                                      now.day,
                                                                      timeFrom
                                                                          .hour,
                                                                      timeFrom
                                                                          .minute);
                                                              DateTime
                                                                  endDateTime =
                                                                  DateTime(
                                                                      now.year,
                                                                      now.month,
                                                                      now.day,
                                                                      timeTo
                                                                          .hour,
                                                                      timeTo
                                                                          .minute);

                                                              // Subtract the DateTime objects
                                                              Duration
                                                                  difference =
                                                                  endDateTime
                                                                      .difference(
                                                                          startDateTime);
                                                              int totalMinutes =
                                                                  difference
                                                                      .inMinutes;
                                                              // Calculate how many 5-minute intervals are there
                                                              intervals =
                                                                  (totalMinutes /
                                                                          5)
                                                                      .round();
                                                              return (time.hour ==
                                                                      timeFrom
                                                                          .hour &&
                                                                  time.minute ==
                                                                      timeFrom
                                                                          .minute);
                                                            });
                                                            return Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      for (var booking
                                                                          in filteredSchedules) {
                                                                        String
                                                                            from24Hour =
                                                                            convertTo24HourFormat(booking.timefrom);
                                                                        final timeFrom =
                                                                            TimeOfDay(
                                                                          hour:
                                                                              int.parse(from24Hour.split(':')[0]),
                                                                          minute: (int.parse(from24Hour.split(':')[1].split(' ')[0]) + 4) ~/
                                                                              5 *
                                                                              5,
                                                                        );
                                                                        if (timeFrom.hour == time.hour &&
                                                                            timeFrom.minute ==
                                                                                time.minute) {
                                                                          selectedbooking =
                                                                              booking;
                                                                          final materialNotifier = Provider.of<MaterialNotifier>(
                                                                              context,
                                                                              listen: false);
                                                                          materialNotifier
                                                                              .getMaterials(selectedbooking!.classID);
                                                                          break;
                                                                        }
                                                                      }
                                                                    });
                                                                  },
                                                                  // onHover:
                                                                  //     (isHovered) {
                                                                  //   setState(
                                                                  //       () {
                                                                  //     this.isHovered[bookingIndex] =
                                                                  //         isHovered;
                                                                  //   });
                                                                  // },
                                                                  child:
                                                                      Tooltip(
                                                                    message: currentbooking.type ==
                                                                            'blocked'
                                                                        ? 'Blocked'
                                                                        : 'Booked',
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0), // Circular border radius
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        width: ResponsiveBuilder.isDesktop(
                                                                                context)
                                                                            ? size.width -
                                                                                780
                                                                            : ResponsiveBuilder.isTablet(context)
                                                                                ? size.width - 510
                                                                                : size.width - 110,
                                                                        height: currentbooking.type ==
                                                                                'blocked'
                                                                            ? intervals *
                                                                                12
                                                                            : 132,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: currentbooking.type == 'blocked'
                                                                              ? calendarRed
                                                                              : kColorSecondary,
                                                                          // border:
                                                                          //     Border.all(
                                                                          //   color: isHovered[bookingIndex] ? kColorPrimary : Colors.yellow,
                                                                          //   width: isHovered[bookingIndex] ? 3 : 1,
                                                                          // ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Text(
                                                                                '${selectedbookingdata!.timefrom} to ${selectedbookingdata!.timeto}',
                                                                                style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, fontWeight: FontWeight.w600),
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                              child: Text(
                                                                                currentbooking.type == 'blocked' ? 'Blocked' : 'Booked',
                                                                                style: TextStyle(overflow: TextOverflow.ellipsis, color: currentbooking.type == 'blocked' ? Colors.white : Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, fontWeight: FontWeight.bold),
                                                                              ),
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
                                                        return const SizedBox
                                                            .shrink();
                                                      }
                                                      return Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: isSelectable
                                                                ? () {}
                                                                : null,
                                                            child: Container(
                                                              width: ResponsiveBuilder
                                                                      .isDesktop(
                                                                          context)
                                                                  ? size.width -
                                                                      780
                                                                  : ResponsiveBuilder.isTablet(
                                                                          context)
                                                                      ? size.width -
                                                                          510
                                                                      : size.width -
                                                                          110,
                                                              height:
                                                                  indexSelect ==
                                                                          index
                                                                      ? 200
                                                                      : 12,
                                                              color: isSelectable
                                                                  ? indexSelect == index
                                                                      ? Colors.blue
                                                                      : Colors.green[50]
                                                                  : Colors.grey[100],
                                                              child: time.minute ==
                                                                      0
                                                                  ? const Center(
                                                                      child:
                                                                          Divider(
                                                                      thickness:
                                                                          .1,
                                                                    ))
                                                                  : null,
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
                                                children: [
                                                  const ClipRect(
                                                    child: Icon(
                                                      Icons.block,
                                                      color: Colors.red,
                                                      size: 150,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Day Off",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize:
                                                            ResponsiveBuilder
                                                                    .isDesktop(
                                                                        context)
                                                                ? 18
                                                                : 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            )),
                                ]),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectedbooking != null,
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedbooking = null;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.arrow_back_outlined,
                                            color: kColorGrey,
                                          )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        selectedbooking == null
                                            ? 'Select Information'
                                            : 'Information(${selectedbooking?.timefrom} to ${selectedbooking?.timeto})',
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveBuilder.isDesktop(
                                                        context)
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
                                                    Text(
                                                      "Select a schedule",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize:
                                                              ResponsiveBuilder
                                                                      .isDesktop(
                                                                          context)
                                                                  ? 18
                                                                  : 16,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                    style: TextStyle(
                                                      fontSize:
                                                          ResponsiveBuilder
                                                                  .isDesktop(
                                                                      context)
                                                              ? 18
                                                              : 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: kColorGrey,
                                                    ),
                                                  ),
                                                  Text(
                                                    selectedbooking!
                                                        .studentinfo!.studentID,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: kColorGrey,
                                                      fontSize:
                                                          ResponsiveBuilder
                                                                  .isDesktop(
                                                                      context)
                                                              ? 16
                                                              : 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    selectedbooking!
                                                        .subjectinfo!
                                                        .subjectName,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: kColorGrey,
                                                      fontSize:
                                                          ResponsiveBuilder
                                                                  .isDesktop(
                                                                      context)
                                                              ? 16
                                                              : 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Class ${selectedbooking!.session}',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: kColorGrey,
                                                      fontSize:
                                                          ResponsiveBuilder
                                                                  .isDesktop(
                                                                      context)
                                                              ? 18
                                                              : 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    'Class Materials',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: kColorGrey,
                                                      fontSize:
                                                          ResponsiveBuilder
                                                                  .isDesktop(
                                                                      context)
                                                              ? 18
                                                              : 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // Consumer<List<Schedule>>(
                                                  //     builder: (context,
                                                  //         scheduleListdata,
                                                  //         _) {
                                                  //   if (scheduleListdata
                                                  //       .isEmpty) {
                                                  //     return Center(
                                                  //       child: Text(
                                                  //         '(Link will be attached when student set class schedule!)',
                                                  //         style: TextStyle(
                                                  //             overflow:
                                                  //                 TextOverflow
                                                  //                     .ellipsis,
                                                  //             fontSize: 15,
                                                  //             color: Colors
                                                  //                 .blue
                                                  //                 .shade200,
                                                  //             fontStyle:
                                                  //                 FontStyle
                                                  //                     .italic),
                                                  //       ),
                                                  //     );
                                                  //   }
                                                  //   dynamic data =
                                                  //       scheduleListdata;
                                                  //   // ClassesData?
                                                  //   //     newclassdata =
                                                  //   //     widget.enrolledClass;
                                                  //   List<Schedule>
                                                  //       filtereddata = data
                                                  //           .where((element) =>
                                                  //               element
                                                  //                   .scheduleID ==
                                                  //               selectedbooking!
                                                  //                   .classID)
                                                  //           .toList();
                                                  //   filtereddata.sort(
                                                  //       (a, b) => a.schedule
                                                  //           .compareTo(
                                                  //               b.schedule));
                                                  //   Schedule
                                                  //       selectedSchedule =
                                                  //       filtereddata
                                                  //           .firstWhere(
                                                  //     (schedule) =>
                                                  //         schedule.schedule ==
                                                  //             selectedbooking!
                                                  //                 .scheduledate &&
                                                  //         schedule.timefrom ==
                                                  //             selectedbooking!
                                                  //                 .timefrom,
                                                  //     orElse: () =>
                                                  //         throw Exception(
                                                  //             'No matching schedule found.'),
                                                  //   );
                                                  //   int index =
                                                  //       filtereddata.indexOf(
                                                  //           selectedSchedule);
                                                  //   return
                                                  Consumer<MaterialNotifier>(
                                                      builder: (context,
                                                          materialNotifier, _) {
                                                    if (materialNotifier
                                                        .materials.isEmpty) {
                                                      return const SizedBox(
                                                        width: 600,
                                                        child: Center(
                                                          child: Text(
                                                            '(No materials added!)',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    kColorGrey,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                        ),
                                                      ); // Show loading indicator
                                                    }
                                                    List<Map<String, dynamic>>
                                                        materialsdata =
                                                        materialNotifier
                                                            .materials
                                                            .where((element) =>
                                                                element[
                                                                    'classno'] ==
                                                                (int.parse(selectedbooking!
                                                                            .session) -
                                                                        1)
                                                                    .toString())
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
                                                                      .blue
                                                                      .shade200,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                          )); // Show loading indicator
                                                    }
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              width: 600,
                                                              height: 120,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: Row(
                                                                children: [
                                                                  IconButton(
                                                                    iconSize:
                                                                        12,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    splashRadius:
                                                                        1,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_back_ios, // Left arrow icon
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      // Scroll to the left
                                                                      updatescrollController1
                                                                          .animateTo(
                                                                        updatescrollController1.offset -
                                                                            100.0, // Adjust the value as needed
                                                                        duration:
                                                                            const Duration(milliseconds: 500), // Adjust the duration as needed
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
                                                                        if (materialsdata[index]['extension'] ==
                                                                            'Image') {
                                                                          return FutureBuilder(
                                                                              future: FirebaseStorage.instance.ref(materialsdata[index]['reference']).getDownloadURL(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                  // return Container(
                                                                                  //     height: 60,
                                                                                  //     width: 60,
                                                                                  //     child: const Center(
                                                                                  //         child: CircularProgressIndicator(
                                                                                  //       strokeWidth: 2,
                                                                                  //       color: Color.fromRGBO(1, 118, 132, 1),
                                                                                  //     ))); // Display a loading indicator while waiting for the file to download
                                                                                } else if (snapshot.hasError) {
                                                                                  return Text('Error: ${snapshot.error}');
                                                                                }

                                                                                return Padding(
                                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                  child: Row(
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
                                                                                                    materialsdata[index]['reference'],
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
                                                                        } else if (materialsdata[index]['extension'] ==
                                                                            'pdf') {
                                                                          return FutureBuilder(
                                                                              future: FirebaseStorage.instance.ref(materialsdata[index]['reference']).getDownloadURL(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
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
                                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                  child: Row(
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
                                                                              future: FirebaseStorage.instance.ref(materialsdata[index]['reference']).getDownloadURL(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
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
                                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                  child: Row(
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
                                                                                                    style: const TextStyle(fontSize: 12.0, color: kColorGrey, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
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
                                                                        // return Text(materialsdata[index]['reference']);
                                                                      },
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    iconSize:
                                                                        12,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    splashRadius:
                                                                        1,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios, // Right arrow icon
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      // Scroll to the right
                                                                      updatescrollController1
                                                                          .animateTo(
                                                                        updatescrollController1.offset +
                                                                            100.0, // Adjust the value as needed
                                                                        duration:
                                                                            const Duration(milliseconds: 500), // Adjust the duration as needed
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
                                                  }),
                                                  // }),
                                                  const Spacer(),
                                                  Text(
                                                    'Class Link',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: kColorGrey,
                                                      fontSize:
                                                          ResponsiveBuilder
                                                                  .isDesktop(
                                                                      context)
                                                              ? 18
                                                              : 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 600,
                                                    height: 100,
                                                    child: Center(
                                                      child: Consumer<
                                                              List<Schedule>>(
                                                          builder: (context,
                                                              scheduleListdata,
                                                              _) {
                                                        if (scheduleListdata
                                                            .isEmpty) {
                                                          return Center(
                                                            child: Text(
                                                              '(Link will be attached when student set class schedule!)',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade200,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                          );
                                                        }
                                                        dynamic data =
                                                            scheduleListdata;
                                                        // ClassesData?
                                                        //     newclassdata =
                                                        //     widget.enrolledClass;
                                                        List<Schedule> filtereddata = data
                                                            .where((element) =>
                                                                element
                                                                    .scheduleID ==
                                                                selectedbooking!
                                                                    .classID)
                                                            .toList();
                                                        filtereddata.sort(
                                                            (a, b) => a.schedule
                                                                .compareTo(b
                                                                    .schedule));
                                                        Schedule
                                                            selectedSchedule =
                                                            filtereddata
                                                                .firstWhere(
                                                          (schedule) =>
                                                              schedule.schedule ==
                                                                  selectedbooking!
                                                                      .scheduledate &&
                                                              schedule.timefrom ==
                                                                  selectedbooking!
                                                                      .timefrom,
                                                          orElse: () =>
                                                              throw Exception(
                                                                  'No matching schedule found.'),
                                                        );
                                                        int index = filtereddata
                                                            .indexOf(
                                                                selectedSchedule);
                                                        if (selectedSchedule
                                                                .meetinglink !=
                                                            '') {
                                                          return SizedBox(
                                                            width: 600,
                                                            child: Center(
                                                              child:
                                                                  MouseRegion(
                                                                cursor:
                                                                    SystemMouseCursors
                                                                        .click,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    // const VideoCall videoCall = VideoCall(chatID: '123', uID: '456');

                                                                    // Replace 'your_flutter_app_port' with the actual port your Flutter web app is running on
                                                                    // String url =
                                                                    //     'http://localhost:58586/tutorsList';

                                                                    // Open the URL in a new tab
                                                                    // html.window.open('/videoCall', "");
                                                                    // html.window.open('/tutorslist', "");
                                                                    //  const VideoCall(chatID: '', uID: '',);
                                                                    GoRouter.of(
                                                                            context)
                                                                        .go('/videocall/${widget.uID.toString()}&${filtereddata[index].scheduleID}&${filtereddata[index].meetinglink}');
                                                                  },
                                                                  child: Text(
                                                                    'work4ututor/${filtereddata[index].meetinglink}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .blue
                                                                            .shade200,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic,
                                                                        decoration:
                                                                            TextDecoration.underline),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        return Center(
                                                          child: Flexible(
                                                            child: Text(
                                                              '(Link will be attached when student set class schedule!)',
                                                              style: TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade200,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
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
                                                          fontWeight:
                                                              FontWeight.w600,
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
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: ResponsiveBuilder.isDesktop(context)
                                      ? size.width - 720
                                      : ResponsiveBuilder.isTablet(context)
                                          ? size.width - 450
                                          : size.width - 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('MMMM, dd')
                                            .format(_selectedDay),
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveBuilder.isDesktop(
                                                        context)
                                                    ? 18
                                                    : 16,
                                            fontWeight: FontWeight.w800,
                                            color: kColorGrey),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text(
                                          ResponsiveBuilder.isDesktop(context)
                                              ? daystatus == false
                                                  ? "(${(filteredSchedules.where((schedule) => schedule.type == 'class').length)} Classes today)"
                                                  : '(Day Off)'
                                              : daystatus == false
                                                  ? "(${(filteredSchedules.where((schedule) => schedule.type == 'class').length)} Classes)"
                                                  : '(Day Off)',
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize:
                                                  ResponsiveBuilder.isDesktop(
                                                          context)
                                                      ? 18
                                                      : 16,
                                              fontWeight: FontWeight.normal,
                                              color: kColorGrey),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                    child: daystatus == false
                                        ? SizedBox(
                                            width: ResponsiveBuilder.isDesktop(
                                                    context)
                                                ? size.width - 870
                                                : ResponsiveBuilder.isTablet(
                                                        context)
                                                    ? size.width - 600
                                                    : size.width - 30,
                                            height: 600,
                                            child: Row(children: [
                                              SizedBox(
                                                width: 60,
                                                child: ScrollConfiguration(
                                                  behavior: ScrollConfiguration
                                                          .of(context)
                                                      .copyWith(
                                                          scrollbars: false),
                                                  child: ListView.builder(
                                                    itemExtent: 12,
                                                    controller: _controller2,
                                                    itemCount: 24 * 60 ~/ 5,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final time = TimeOfDay(
                                                          hour: index * 5 ~/ 60,
                                                          minute:
                                                              (index * 5) % 60);
                                                      final isSelectable =
                                                          isTimeWithinRange(
                                                              time);
                                                      final timeText =
                                                          time.format(context);

                                                      TextStyle textStyle =
                                                          TextStyle(
                                                        color: kColorGrey,
                                                        fontWeight: time
                                                                    .minute ==
                                                                0
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontSize: time.minute ==
                                                                0
                                                            ? 12
                                                            : 8, // Adjust the font size as needed
                                                      );

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5,
                                                                right: 0,
                                                                bottom: 0,
                                                                top: 0),
                                                        child: SizedBox(
                                                          width: 55,
                                                          height: 12,
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
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  controller: _controller1,
                                                  itemCount: 24 * 60 ~/ 5,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final time = TimeOfDay(
                                                        hour: index * 5 ~/ 60,
                                                        minute:
                                                            (index * 5) % 60);
                                                    final isSelectable =
                                                        isTimeWithinRange(time);
                                                    final timeText =
                                                        time.format(context);

                                                    TextStyle textStyle =
                                                        TextStyle(
                                                      color: kColorGrey,
                                                      fontWeight: time.minute ==
                                                              0
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

                                                      // Manually compare the hours and minutes
                                                      return (time.hour >
                                                                  timeFrom
                                                                      .hour ||
                                                              (time.hour ==
                                                                      timeFrom
                                                                          .hour &&
                                                                  time.minute >=
                                                                      timeFrom
                                                                          .minute)) &&
                                                          (time.hour <
                                                                  timeTo.hour ||
                                                              (time.hour ==
                                                                      timeTo
                                                                          .hour &&
                                                                  time.minute <=
                                                                      timeTo
                                                                          .minute));
                                                    });
                                                    if (isTimeInBookings) {
                                                      // Display only the timeFrom from the booking
                                                      final isTimefrom =
                                                          filteredSchedules
                                                              .any((booking) {
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
                                                        // Manually compare the hours and minutes
                                                        return (time.hour ==
                                                                timeFrom.hour &&
                                                            time.minute ==
                                                                timeFrom
                                                                    .minute);
                                                      });
                                                      if (isTimefrom) {
                                                        int bookingIndex = 0;
                                                        TutorInformation? temp1;
                                                        StudentInfoClass? temp2;
                                                        SubjectClass? temp3;
                                                        ScheduleData
                                                            currentbooking =
                                                            ScheduleData(
                                                                studentID: '',
                                                                tutorID: '',
                                                                classID: '',
                                                                scheduleID: '',
                                                                tutorinfo:
                                                                    temp1,
                                                                studentinfo:
                                                                    temp2,
                                                                subjectinfo:
                                                                    temp3,
                                                                session: '',
                                                                scheduledate:
                                                                    DateTime
                                                                        .now(),
                                                                timefrom: '',
                                                                timeto: '',
                                                                type: '');
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
                                                          bookingIndex =
                                                              filteredSchedules
                                                                  .indexOf(
                                                                      booking);

                                                          if (timeFrom.hour ==
                                                                  time.hour &&
                                                              timeFrom.minute ==
                                                                  time.minute) {
                                                            currentbooking =
                                                                booking;
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
                                                              selectedbookingdata =
                                                                  booking;
                                                              break;
                                                            }
                                                          }

                                                          return Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
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
                                                                        final materialNotifier = Provider.of<MaterialNotifier>(
                                                                            context,
                                                                            listen:
                                                                                false);
                                                                        materialNotifier
                                                                            .getMaterials(selectedbooking!.classID);
                                                                        break;
                                                                      }
                                                                    }
                                                                  });
                                                                },
                                                                // onHover:
                                                                //     (isHovered) {
                                                                //   setState(
                                                                //       () {
                                                                //     this.isHovered[
                                                                //             bookingIndex] =
                                                                //         isHovered;
                                                                //   });
                                                                // },
                                                                child: Tooltip(
                                                                  message: currentbooking
                                                                              .type ==
                                                                          'blocked'
                                                                      ? 'Blocked'
                                                                      : 'Booked',
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0), // Circular border radius
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      width: currentbooking.type ==
                                                                              'blocked'
                                                                          ? ResponsiveBuilder.isDesktop(context)
                                                                              ? size.width - 780
                                                                              : ResponsiveBuilder.isTablet(context)
                                                                                  ? size.width - 510
                                                                                  : size.width - 210
                                                                          : ResponsiveBuilder.isDesktop(context)
                                                                              ? size.width - 780
                                                                              : ResponsiveBuilder.isTablet(context)
                                                                                  ? size.width - 510
                                                                                  : size.width - 210,
                                                                      height:
                                                                          132,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: currentbooking.type ==
                                                                                'blocked'
                                                                            ? calendarRed
                                                                            : kSecondarybuttonblue,
                                                                        // border:
                                                                        //     Border.all(
                                                                        //   color: isHovered[bookingIndex]
                                                                        //       ? kColorPrimary
                                                                        //       : Colors.yellow,
                                                                        //   width: isHovered[bookingIndex]
                                                                        //       ? 3
                                                                        //       : 1,
                                                                        // ),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              '${selectedbookingdata!.timefrom} to ${selectedbookingdata!.timeto}',
                                                                              style: TextStyle(color: Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                currentbooking.type != 'blocked',
                                                                            child:
                                                                                Flexible(
                                                                              child: Text(
                                                                                currentbooking.studentinfo != null ? '${currentbooking.studentinfo!.studentFirstname} ${currentbooking.studentinfo!.studentLastname}' : '',
                                                                                style: TextStyle(color: Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 18 : 16, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                currentbooking.type != 'blocked',
                                                                            child:
                                                                                Flexible(
                                                                              child: Text(
                                                                                currentbooking.subjectinfo != null ? '${currentbooking.subjectinfo!.subjectName} Class ${currentbooking.session}' : '',
                                                                                style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, fontWeight: FontWeight.w400),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              currentbooking.type == 'blocked' ? 'Blocked' : 'Booked',
                                                                              style: TextStyle(color: currentbooking.type == 'blocked' ? Colors.white : Colors.white, overflow: TextOverflow.ellipsis, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, fontWeight: FontWeight.bold),
                                                                            ),
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
                                                            bookingIndex =
                                                                filteredSchedules
                                                                    .indexOf(
                                                                        booking);
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
                                                                  .any(
                                                                      (booking) {
                                                            String from24Hour =
                                                                convertTo24HourFormat(
                                                                    booking
                                                                        .timefrom);
                                                            String to24Hour =
                                                                convertTo24HourFormat(
                                                                    booking
                                                                        .timeto);
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
                                                            final timeTo =
                                                                TimeOfDay(
                                                              hour: int.parse(
                                                                  to24Hour.split(
                                                                      ':')[0]),
                                                              minute: (int.parse(to24Hour
                                                                          .split(':')[
                                                                              1]
                                                                          .split(
                                                                              ' ')[0]) +
                                                                      4) ~/
                                                                  5 *
                                                                  5,
                                                            );
                                                            DateTime now =
                                                                DateTime.now();
                                                            DateTime
                                                                startDateTime =
                                                                DateTime(
                                                                    now.year,
                                                                    now.month,
                                                                    now.day,
                                                                    timeFrom
                                                                        .hour,
                                                                    timeFrom
                                                                        .minute);
                                                            DateTime
                                                                endDateTime =
                                                                DateTime(
                                                                    now.year,
                                                                    now.month,
                                                                    now.day,
                                                                    timeTo.hour,
                                                                    timeTo
                                                                        .minute);

                                                            // Subtract the DateTime objects
                                                            Duration
                                                                difference =
                                                                endDateTime
                                                                    .difference(
                                                                        startDateTime);
                                                            int totalMinutes =
                                                                difference
                                                                    .inMinutes;
                                                            // Calculate how many 5-minute intervals are there
                                                            intervals =
                                                                (totalMinutes /
                                                                        5)
                                                                    .round();
                                                            return (time.hour ==
                                                                    timeFrom
                                                                        .hour &&
                                                                time.minute ==
                                                                    timeFrom
                                                                        .minute);
                                                          });
                                                          return Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
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
                                                                        final materialNotifier = Provider.of<MaterialNotifier>(
                                                                            context,
                                                                            listen:
                                                                                false);
                                                                        materialNotifier
                                                                            .getMaterials(selectedbooking!.classID);
                                                                        break;
                                                                      }
                                                                    }
                                                                  });
                                                                },
                                                                // onHover:
                                                                //     (isHovered) {
                                                                //   setState(
                                                                //       () {
                                                                //     this.isHovered[
                                                                //             bookingIndex] =
                                                                //         isHovered;
                                                                //   });
                                                                // },
                                                                child: Tooltip(
                                                                  message: currentbooking
                                                                              .type ==
                                                                          'blocked'
                                                                      ? 'Blocked'
                                                                      : 'Booked',
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0), // Circular border radius
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      width: ResponsiveBuilder.isDesktop(
                                                                              context)
                                                                          ? size.width -
                                                                              780
                                                                          : ResponsiveBuilder.isTablet(context)
                                                                              ? size.width - 510
                                                                              : size.width - 210,
                                                                      height: currentbooking.type ==
                                                                              'blocked'
                                                                          ? intervals *
                                                                              12
                                                                          : 132,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: currentbooking.type ==
                                                                                'blocked'
                                                                            ? calendarRed
                                                                            : kColorSecondary,
                                                                        // border:
                                                                        //     Border.all(
                                                                        //   color: isHovered[bookingIndex]
                                                                        //       ? kColorPrimary
                                                                        //       : Colors.yellow,
                                                                        //   width: isHovered[bookingIndex]
                                                                        //       ? 3
                                                                        //       : 1,
                                                                        // ),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              '${selectedbookingdata!.timefrom} to ${selectedbookingdata!.timeto}',
                                                                              style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              currentbooking.type == 'blocked' ? 'Blocked' : 'Booked',
                                                                              style: TextStyle(overflow: TextOverflow.ellipsis, color: currentbooking.type == 'blocked' ? Colors.white : Colors.white, fontSize: ResponsiveBuilder.isDesktop(context) ? 16 : 14, fontWeight: FontWeight.bold),
                                                                            ),
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
                                                      return const SizedBox
                                                          .shrink();
                                                    }
                                                    return Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: isSelectable
                                                              ? () {}
                                                              : null,
                                                          child: Container(
                                                            width: ResponsiveBuilder
                                                                    .isDesktop(
                                                                        context)
                                                                ? size.width -
                                                                    780
                                                                : ResponsiveBuilder
                                                                        .isTablet(
                                                                            context)
                                                                    ? size.width -
                                                                        510
                                                                    : size.width -
                                                                        210,
                                                            height: 12,
                                                            color: isSelectable
                                                                ? indexSelect ==
                                                                        index
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.green[
                                                                        50]
                                                                : Colors
                                                                    .grey[100],
                                                            child: time.minute ==
                                                                    0
                                                                ? const Center(
                                                                    child:
                                                                        Divider(
                                                                    thickness:
                                                                        .1,
                                                                  ))
                                                                : null,
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
                                              children: [
                                                const ClipRect(
                                                  child: Icon(
                                                    Icons.block,
                                                    color: Colors.red,
                                                    size: 150,
                                                  ),
                                                ),
                                                Text(
                                                  "Day Off",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize:
                                                          ResponsiveBuilder
                                                                  .isDesktop(
                                                                      context)
                                                              ? 18
                                                              : 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          )),
                              ]),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.fromLTRB(5, 10, 0, 0),
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
                                          fontSize: ResponsiveBuilder.isDesktop(
                                                  context)
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
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                    color: kColorGrey,
                                                  ),
                                                ),
                                                Text(
                                                  selectedbooking!
                                                      .studentinfo!.studentID,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: kColorGrey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  selectedbooking!
                                                      .subjectinfo!.subjectName,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: kColorGrey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'Class ${selectedbooking!.session}',
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: kColorGrey,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  'Class Materials',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: kColorGrey,
                                                    fontSize: ResponsiveBuilder
                                                            .isDesktop(context)
                                                        ? 18
                                                        : 16,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Consumer<List<Schedule>>(
                                                    builder: (context,
                                                        scheduleListdata, _) {
                                                  if (scheduleListdata
                                                      .isEmpty) {
                                                    return Center(
                                                      child: Text(
                                                        '(No materials added!)',
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontSize: 15,
                                                            color: Colors
                                                                .blue.shade200,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    );
                                                  }
                                                  dynamic data =
                                                      scheduleListdata;
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
                                                  int index =
                                                      filtereddata.indexOf(
                                                          selectedSchedule);
                                                  return Consumer<
                                                          MaterialNotifier>(
                                                      builder: (context,
                                                          materialNotifier, _) {
                                                    if (materialNotifier
                                                        .materials.isEmpty) {
                                                      return const SizedBox(
                                                        width: 600,
                                                        child: Center(
                                                          child: Text(
                                                            '(No materials added!)',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    kColorGrey,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                        ),
                                                      ); // Show loading indicator
                                                    }
                                                    List<Map<String, dynamic>>
                                                        materialsdata =
                                                        materialNotifier
                                                            .materials
                                                            .where((element) =>
                                                                element[
                                                                    'classno'] ==
                                                                index
                                                                    .toString())
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
                                                                      .blue
                                                                      .shade200,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                          )); // Show loading indicator
                                                    }
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              width: 600,
                                                              height: 120,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: Row(
                                                                children: [
                                                                  IconButton(
                                                                    iconSize:
                                                                        12,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    splashRadius:
                                                                        1,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_back_ios, // Left arrow icon
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      // Scroll to the left
                                                                      updatescrollController1
                                                                          .animateTo(
                                                                        updatescrollController1.offset -
                                                                            100.0, // Adjust the value as needed
                                                                        duration:
                                                                            const Duration(milliseconds: 500), // Adjust the duration as needed
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
                                                                        if (materialsdata[index]['extension'] ==
                                                                            'Image') {
                                                                          return FutureBuilder(
                                                                              future: FirebaseStorage.instance.ref(materialsdata[index]['reference']).getDownloadURL(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                  return Container(height: 60, width: 60, alignment: Alignment.center, child: const Text('Loading..'));
                                                                                } else if (snapshot.hasError) {
                                                                                  return Text('Error: ${snapshot.error}');
                                                                                }

                                                                                return Padding(
                                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                  child: Row(
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
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Tooltip(
                                                                                                  message: getFileNameFromUrl(snapshot.data.toString()),
                                                                                                  child: SizedBox(
                                                                                                    height: 60,
                                                                                                    width: 60,
                                                                                                    child: TextButton(
                                                                                                      onPressed: () {
                                                                                                        // setState(() {
                                                                                                        //   fetchFileData(snapshot.data.toString());
                                                                                                        // });
                                                                                                      },
                                                                                                      child: Text(
                                                                                                        getFileNameFromUrl(snapshot.data.toString()),
                                                                                                        style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                InkWell(
                                                                                                  onTap: () {
                                                                                                    fetchFileData(snapshot.data.toString());
                                                                                                  },
                                                                                                  child: const Tooltip(
                                                                                                    message: 'Download',
                                                                                                    child: Icon(
                                                                                                      Icons.file_download_outlined,
                                                                                                      color: kColorPrimary,
                                                                                                      size: 15,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              });
                                                                        } else if (materialsdata[index]['extension'] ==
                                                                            'pdf') {
                                                                          return FutureBuilder(
                                                                              future: FirebaseStorage.instance.ref(materialsdata[index]['reference']).getDownloadURL(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                  return Container(height: 60, width: 60, alignment: Alignment.center, child: const Text('Loading..'));
                                                                                } else if (snapshot.hasError) {
                                                                                  return Text('Error: ${snapshot.error}');
                                                                                }
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                  child: Row(
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
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Tooltip(
                                                                                                  message: getFileNameFromUrl(snapshot.data.toString()),
                                                                                                  child: SizedBox(
                                                                                                    height: 60,
                                                                                                    width: 60,
                                                                                                    child: TextButton(
                                                                                                      onPressed: () {
                                                                                                        // setState(() {
                                                                                                        //   fetchFileData(snapshot.data.toString());
                                                                                                        // });
                                                                                                      },
                                                                                                      child: Text(
                                                                                                        getFileNameFromUrl(snapshot.data.toString()),
                                                                                                        style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                InkWell(
                                                                                                  onTap: () {
                                                                                                    fetchFileData(snapshot.data.toString());
                                                                                                  },
                                                                                                  child: const Tooltip(
                                                                                                    message: 'Download',
                                                                                                    child: Icon(
                                                                                                      Icons.file_download_outlined,
                                                                                                      color: kColorPrimary,
                                                                                                      size: 15,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
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
                                                                              future: FirebaseStorage.instance.ref(materialsdata[index]['reference']).getDownloadURL(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                  return Container(height: 60, width: 60, alignment: Alignment.center, child: const Text('Loading..'));
                                                                                } else if (snapshot.hasError) {
                                                                                  return Text('Error: ${snapshot.error}');
                                                                                }
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                  child: Row(
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
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Tooltip(
                                                                                                  message: getFileNameFromUrl(snapshot.data.toString()),
                                                                                                  child: SizedBox(
                                                                                                    height: 60,
                                                                                                    width: 60,
                                                                                                    child: TextButton(
                                                                                                      onPressed: () {
                                                                                                        // setState(() {
                                                                                                        //   fetchFileData(snapshot.data.toString());
                                                                                                        // });
                                                                                                      },
                                                                                                      child: Text(
                                                                                                        getFileNameFromUrl(snapshot.data.toString()),
                                                                                                        style: const TextStyle(fontSize: 12.0, color: kColorGrey, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                InkWell(
                                                                                                  onTap: () {
                                                                                                    fetchFileData(snapshot.data.toString());
                                                                                                  },
                                                                                                  child: const Tooltip(
                                                                                                    message: 'Download',
                                                                                                    child: Icon(
                                                                                                      Icons.file_download_outlined,
                                                                                                      color: kColorPrimary,
                                                                                                      size: 15,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
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
                                                                    iconSize:
                                                                        12,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    splashRadius:
                                                                        1,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios, // Right arrow icon
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      // Scroll to the right
                                                                      updatescrollController1
                                                                          .animateTo(
                                                                        updatescrollController1.offset +
                                                                            100.0, // Adjust the value as needed
                                                                        duration:
                                                                            const Duration(milliseconds: 500), // Adjust the duration as needed
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
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: kColorGrey),
                                                ),
                                                SizedBox(
                                                  width: 600,
                                                  height: 100,
                                                  child: Center(
                                                    child: Consumer<
                                                            List<Schedule>>(
                                                        builder: (context,
                                                            scheduleListdata,
                                                            _) {
                                                      if (scheduleListdata
                                                          .isEmpty) {
                                                        return Center(
                                                          child: Text(
                                                            '(Link will be attached when student set class schedule!)',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .blue
                                                                    .shade200,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                        );
                                                      }
                                                      dynamic data =
                                                          scheduleListdata;
                                                      // ClassesData?
                                                      //     newclassdata =
                                                      //     widget.enrolledClass;
                                                      List<Schedule>
                                                          filtereddata = data
                                                              .where((element) =>
                                                                  element
                                                                      .scheduleID ==
                                                                  selectedbooking!
                                                                      .classID)
                                                              .toList();
                                                      filtereddata.sort(
                                                          (a, b) => a.schedule
                                                              .compareTo(
                                                                  b.schedule));
                                                      Schedule
                                                          selectedSchedule =
                                                          filtereddata
                                                              .firstWhere(
                                                        (schedule) =>
                                                            schedule.schedule ==
                                                                selectedbooking!
                                                                    .scheduledate &&
                                                            schedule.timefrom ==
                                                                selectedbooking!
                                                                    .timefrom,
                                                        orElse: () =>
                                                            throw Exception(
                                                                'No matching schedule found.'),
                                                      );
                                                      int index =
                                                          filtereddata.indexOf(
                                                              selectedSchedule);
                                                      if (selectedSchedule
                                                              .meetinglink !=
                                                          '') {
                                                        return SizedBox(
                                                          width: 600,
                                                          child: Center(
                                                            child: MouseRegion(
                                                              cursor:
                                                                  SystemMouseCursors
                                                                      .click,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  // const VideoCall videoCall = VideoCall(chatID: '123', uID: '456');

                                                                  // Replace 'your_flutter_app_port' with the actual port your Flutter web app is running on
                                                                  // String url =
                                                                  //     'http://localhost:58586/tutorsList';

                                                                  // Open the URL in a new tab
                                                                  // html.window.open('/videoCall', "");
                                                                  // html.window.open('/tutorslist', "");
                                                                  //  const VideoCall(chatID: '', uID: '',);
                                                                  GoRouter.of(
                                                                          context)
                                                                      .go('/videocall/${widget.uID.toString()}&${filtereddata[index].scheduleID}&${filtereddata[index].meetinglink}');
                                                                },
                                                                child: Text(
                                                                  'work4ututor/${filtereddata[index].meetinglink}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .blue
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
                                                          ),
                                                        );
                                                      }
                                                      return Center(
                                                        child: Text(
                                                          '(Link will be attached when student set class schedule!)',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.blue
                                                                  .shade200,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
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
                                                        fontWeight:
                                                            FontWeight.w600,
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
          const SizedBox(
            height: 5,
          ),
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

  Widget tableLedger(BuildContext context, List<TutorInformation> tutorinfodata,
      List<ScheduleData> scheduleList) {
    return ResponsiveBuilder.isMobile(context)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          var height = MediaQuery.of(context).size.height;
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
                                      height: 450,
                                      width: 800,
                                      child: CalendarSetup(
                                        userinfo: tutorinfodata.first,
                                        booking: scheduleList,
                                        timezone: widget.tutor.timezone,
                                      ),
                                    ),
                                    Positioned(
                                      top: 20.0,
                                      right: 20.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pop(false); // Close the dialog
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
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
                  child: Row(
                    children: const [
                      Text(
                        "Setup Calendar",
                        style: TextStyle(
                          color: kColorPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: kColorPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: kCalendarColorAB,
                          ),
                          child: null,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Available",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kColorGrey),
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
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: kCalendarColorFB,
                          ),
                          child: null,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Booked",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kColorGrey),
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
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: calendarRed,
                          ),
                          child: null,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Blocked",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kColorGrey),
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
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          var height = MediaQuery.of(context).size.height;
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
                                      height: 450,
                                      width: 800,
                                      child: CalendarSetup(
                                        userinfo: tutorinfodata.first,
                                        booking: scheduleList,
                                        timezone: widget.tutor.timezone,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pop(false); // Close the dialog
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
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
                  child: Row(
                    children: const [
                      Text(
                        "Setup Calendar",
                        style: TextStyle(
                          color: kColorPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: kColorPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: kCalendarColorAB,
                      ),
                      child: null,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Available Dates",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kColorGrey),
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
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: kCalendarColorFB,
                      ),
                      child: null,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Booked Dates",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kColorGrey),
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
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: calendarRed,
                      ),
                      child: null,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Blocked Dates",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kColorGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
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
