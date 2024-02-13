// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../services/bookingfunctions/setscheduletime.dart';
import '../../../../services/getenrolledclasses.dart';
import '../../../../services/notificationfunctions/sendnotifications.dart';
import '../../../../utils/themes.dart';
import '../../admin/admin_sharedcomponents/header_text.dart';
import '../../tutor/calendar/setup_calendar.dart';

class SetNow extends StatefulWidget {
  final String uID;
  final String session;
  final String classID;
  final List<ScheduleData> tutorscurrentschedule;
  final ClassesData? data;
  const SetNow(
      {super.key,
      required this.session,
      required this.classID,
      required this.tutorscurrentschedule,
      required this.uID,
      required this.data});

  @override
  State<SetNow> createState() => _SetNowState();
}

class _SetNowState extends State<SetNow> {
  List<String> dayOffs = [];
  List<DateTime> dayOffsdate = [];
  Future<void> getTimeAvailableForSpecificUID(String uid) async {
    try {
      QuerySnapshot tutorScheduleQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('tutorSchedule')
          .where('uid', isEqualTo: uid)
          .get();

      tutorScheduleQuerySnapshot.docs.forEach((tutorScheduleDoc) async {
        QuerySnapshot timeAvailableQuerySnapshot =
            await tutorScheduleDoc.reference.collection('timeavailable').get();

        timeAvailableQuerySnapshot.docs.forEach((timeAvailableDoc) {
          Map<String, dynamic> data =
              timeAvailableDoc.data() as Map<String, dynamic>;
          setState(() {
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

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String uid = data['uid'] ?? [];
        List<dynamic> dateoffselected = data['dateoffselected'] != null
            ? List<dynamic>.from(data['dateoffselected'])
            : [];

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
      QuerySnapshot tutorScheduleQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('tutorSchedule')
          .where('uid', isEqualTo: uid)
          .get();

      tutorScheduleQuerySnapshot.docs.forEach((doc) async {
        CollectionReference timeAvailableCollection =
            doc.reference.collection('timeavailable');

        QuerySnapshot timeAvailableQuerySnapshot =
            await timeAvailableCollection.get();

        timeAvailableQuerySnapshot.docs.forEach((timeDoc) {
          Map<String, dynamic> timeData =
              timeDoc.data() as Map<String, dynamic>;

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
      QuerySnapshot tutorScheduleQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('tutorSchedule')
          .where('uid', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot doc in tutorScheduleQuerySnapshot.docs) {
        CollectionReference timeAvailableCollection =
            doc.reference.collection('blockdatetime');

        QuerySnapshot timeAvailableQuerySnapshot =
            await timeAvailableCollection.get();

        for (QueryDocumentSnapshot timeDoc in timeAvailableQuerySnapshot.docs) {
          Map<String, dynamic> timeData =
              timeDoc.data() as Map<String, dynamic>;

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
      QuerySnapshot tutorScheduleQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('tutorSchedule')
          .where('uid', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot doc in tutorScheduleQuerySnapshot.docs) {
        CollectionReference timeAvailableCollection =
            doc.reference.collection('timedateavailable');

        QuerySnapshot timeAvailableQuerySnapshot =
            await timeAvailableCollection.get();

        for (QueryDocumentSnapshot timeDoc in timeAvailableQuerySnapshot.docs) {
          Map<String, dynamic> timeData =
              timeDoc.data() as Map<String, dynamic>;

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

  @override
  void initState() {
    super.initState();
    // getfutureclass();
    print('Future Data: ${widget.uID}');
    getDataFromTutorScheduleCollection(widget.data!.tutorinfo.first.userId);
    getDataFromTutorScheduleCollectionavilableTime(
        widget.data!.tutorinfo.first.userId);
    getDataFromTutorScheduleCollectionBlockDateTime(
        widget.data!.tutorinfo.first.userId);
    getDataFromTutorScheduleCollectionAvailableDateTime(
        widget.data!.tutorinfo.first.userId);
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDatesched,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDatesched = pickedDate;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTimesched,
    );

    if (pickedTime != null) {
      // Add 50 minutes to pickedTime
      TimeOfDay newTime = TimeOfDay(
        hour: pickedTime.hour,
        minute: pickedTime.minute + 50,
      );

      // Make sure the minutes don't exceed 59
      newTime = newTime.replacing(
        minute: newTime.minute % 60,
        hour: newTime.hour + newTime.minute ~/ 60,
      );

      setState(() {
        selectedTimesched = pickedTime;
        selectedTimeschedto = newTime;
      });
    }
  }

  DateTime _selectedDay = DateTime.now();
  DateTime selectedDatesched = DateTime.now();
  TimeOfDay selectedTimesched = TimeOfDay.now();
  TimeOfDay selectedTimeschedto = TimeOfDay.now();
  List<ClassesData> futureclassdata = [];

  void getfutureclass() async {
    var futureclassdatatemp = await EnrolledClassFuture(
            uid: widget.data!.tutorinfo.first.userId, role: 'tutor')
        .getenrolled();

    if (mounted) {
      setState(() {
        futureclassdata = futureclassdatatemp;
      });
    }
  }

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

  bool isTimeStartOutRange(TimeOfDay time) {
    List<DateTimeAvailability> selectedTimeRanges = [];

    for (var dateList in dateavailabledateselected) {
      if (isSameDay(dateList.selectedDate, _selectedDay)) {
        selectedTimeRanges.add(dateList);
      }
    }
    String from24Hour = '';
    bool isWithinRange = false;
    if (selectedTimeRanges.isNotEmpty) {
      for (var selectedTimeRange in selectedTimeRanges) {
        String to24Hour =
            convertTo24HourFormat(selectedTimeRange.timeAvailableTo);

        TimeOfDay to = TimeOfDay(
          hour: int.parse(to24Hour.split(':')[0]),
          minute: int.parse(to24Hour.split(':')[1]),
        );

        int currentTimeInMinutes = time.hour * 60 + time.minute;
        int toTimeInMinutes = to.hour * 60 + to.minute;

        if (currentTimeInMinutes < toTimeInMinutes) {
          isWithinRange = true;
          break; // Exit the loop when the first valid range is found
        }
      }
    } else {
      from24Hour = convertTo24HourFormat(timeFrom);

      TimeOfDay from = TimeOfDay(
        hour: int.parse(from24Hour.split(':')[0]),
        minute: int.parse(from24Hour.split(':')[1]),
      );

      int currentTimeInMinutes = time.hour * 60 + time.minute;
      int fromTimeInMinutes = from.hour * 60 + from.minute;

      if (currentTimeInMinutes < fromTimeInMinutes) {
        isWithinRange =
            true; // Exit the loop when the first valid range is found
      }
    }

    return isWithinRange;
  }

  bool isTimeToOutRange(TimeOfDay time) {
    List<DateTimeAvailability> selectedTimeRanges = [];

    for (var dateList in dateavailabledateselected) {
      if (isSameDay(dateList.selectedDate, _selectedDay)) {
        selectedTimeRanges.add(dateList);
      }
    }
    String to24Hour = '';
    bool isWithinRange = false;
    if (selectedTimeRanges.isNotEmpty) {
      for (var selectedTimeRange in selectedTimeRanges) {
        String to24Hour =
            convertTo24HourFormat(selectedTimeRange.timeAvailableTo);

        TimeOfDay to = TimeOfDay(
          hour: int.parse(to24Hour.split(':')[0]),
          minute: int.parse(to24Hour.split(':')[1]),
        );

        int currentTimeInMinutes = time.hour * 60 + time.minute;
        int toTimeInMinutes = to.hour * 60 + to.minute;

        if (currentTimeInMinutes < toTimeInMinutes) {
          isWithinRange = true;
          break; // Exit the loop when the first valid range is found
        }
      }
    } else {
      to24Hour = convertTo24HourFormat(timeTo);

      TimeOfDay to = TimeOfDay(
        hour: int.parse(to24Hour.split(':')[0]),
        minute: int.parse(to24Hour.split(':')[1]),
      );

      int currentTimeInMinutes = time.hour * 60 + time.minute;
      int toTimeInMinutes = to.hour * 60 + to.minute;

      if (currentTimeInMinutes > toTimeInMinutes) {
        isWithinRange =
            true; // Exit the loop when the first valid range is found
      }
    }

    return isWithinRange;
  }

  bool isDayOff(DateTime date) {
    return dayOffs.contains(DateFormat('EEEE').format(date));
  }

  bool isDayOffdate(DateTime date) {
    date = DateTime(date.year, date.month, date.day);
    return dayOffsdate.any((dayOff) =>
        dayOff.year == date.year &&
        dayOff.month == date.month &&
        dayOff.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    getfutureclass();
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        titlePadding: EdgeInsets.zero,
        content: Stack(
          children: <Widget>[
            SizedBox(
              width: 250,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const HeaderText('Set Date and Time'),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectDate();
                      });
                    },
                    child: Text(
                      DateFormat('MMM dd yyyy').format(selectedDatesched),
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectTime();
                          });
                        },
                        child: Text(
                          DateFormat('h:mm a').format(
                            DateTime(2022, 1, 1, selectedTimesched.hour,
                                selectedTimesched.minute),
                          ),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      const Text(
                        '-',
                        style: TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectTime();
                          });
                        },
                        child: Text(
                          DateFormat('h:mm a').format(DateTime(
                              2022,
                              1,
                              1,
                              selectedTimeschedto.hour,
                              selectedTimeschedto.minute)),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 200,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          width: 130,
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(color: Colors.black),
                              backgroundColor:
                                  const Color.fromRGBO(1, 118, 132, 1),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color.fromRGBO(
                                      1, 118, 132, 1), // your color here
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            onPressed: () async {
                              // final timeText = time.format(context);
                              String selectedfrom = convertTo24HourFormat(
                                  DateFormat('h:mm a').format(DateTime(
                                      2022,
                                      1,
                                      1,
                                      selectedTimesched.hour,
                                      selectedTimesched.minute)));
                              String selectedto = convertTo24HourFormat(
                                  DateFormat('h:mm a').format(DateTime(
                                      2022,
                                      1,
                                      1,
                                      selectedTimeschedto.hour,
                                      selectedTimeschedto.minute)));
                              final time = TimeOfDay(
                                hour: int.parse(selectedfrom.split(':')[0]),
                                minute: int.parse(selectedfrom.split(':')[1]),
                              );
                              final timeto = TimeOfDay(
                                hour: int.parse(selectedto.split(':')[0]),
                                minute: int.parse(selectedto.split(':')[1]),
                              );
                              final isSelectable = isTimeWithinRange(time);

                              List<ScheduleData> filteredSchedules = widget
                                  .tutorscurrentschedule
                                  .where((schedule) {
                                DateTime scheduleDate = schedule.scheduledate;
                                String formattedScheduleDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(scheduleDate);
                                String formattedSelectedDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDatesched);

                                // Compare the date field of the schedule with the current date and time
                                return formattedScheduleDate ==
                                    formattedSelectedDate;
                              }).toList();

                              print(filteredSchedules.length);
                              final isTimeInterval =
                                  filteredSchedules.any((booking) {
                                String from24Hour =
                                    convertTo24HourFormat(booking.timefrom);
                                String to24Hour =
                                    convertTo24HourFormat(booking.timeto);
                                final timeFrom = TimeOfDay(
                                    hour: int.parse(from24Hour.split(':')[0]),
                                    minute: (int.parse(from24Hour
                                        .split(':')[1]
                                        .split(' ')[0])));
                                final timeTo = TimeOfDay(
                                    hour: int.parse(to24Hour.split(':')[0]),
                                    minute: (int.parse(to24Hour
                                            .split(':')[1]
                                            .split(' ')[0]) +
                                        5));

                                // Manually compare the hours and minutes
                                return (time.hour < timeTo.hour &&
                                        isTimeToOutRange(timeto) ||
                                    (time.hour == timeTo.hour &&
                                        time.minute >= timeTo.minute &&
                                        isTimeToOutRange(timeto)));
                              });
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
                                        .split(' ')[0])));
                                final timeTo = TimeOfDay(
                                    hour: int.parse(to24Hour.split(':')[0]),
                                    minute: (int.parse(
                                        to24Hour.split(':')[1].split(' ')[0])));

                                // Manually compare the hours and minutes
                                return (time.hour > timeFrom.hour ||
                                        (time.hour == timeFrom.hour &&
                                            time.minute >= timeFrom.minute)) &&
                                    (time.hour < timeTo.hour ||
                                        (time.hour == timeTo.hour &&
                                            time.minute <= timeTo.minute));
                              });
                              print(dayOffs.length);
                              print(dayOffsdate.length);
                              if (isDayOffdate(selectedDatesched) ||
                                  isDayOff(selectedDatesched)) {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.warning,
                                  width: 200,
                                  title: 'Oops...',
                                  text: 'Selected DATE is a tutor dayoff!',
                                );
                              } else if (filteredSchedules.isNotEmpty) {
                                if (isSelectable) {
                                  if (isTimeInBookings) {
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.warning,
                                      width: 200,
                                      title: 'Oops...',
                                      text: 'Selected Time is in bookings!',
                                    );
                                  } else if (isTimeInterval) {
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.warning,
                                      width: 200,
                                      title: 'Oops...',
                                      text: 'Selected Time interval is fine!',
                                    );
                                  } else {
                                    print('Selected Time interval not fine!');
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.warning,
                                      width: 200,
                                      title: 'Oops...',
                                      text: 'Selected Time interval not fine!',
                                    );
                                  }
                                } else {
                                  print('Selected Time is out of range!');
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.warning,
                                    width: 200,
                                    title: 'Oops...',
                                    text: 'Selected Time is out of range!',
                                  );
                                }
                              } else {
                                if (isTimeStartOutRange(time)) {
                                  print('Selected Time interval not fine!');
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.warning,
                                    width: 200,
                                    title: 'Oops...',
                                    text:
                                        'Selected Time out of tutors schedule!',
                                  );
                                } else if (isTimeToOutRange(timeto)) {
                                  print('Selected Time interval not fine!');
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.warning,
                                    width: 200,
                                    title: 'Oops...',
                                    text:
                                        'Selected Time out of tutors schedule!',
                                  );
                                } else {
                                  String? result = await setClassSchedule(
                                      widget.classID,
                                      (int.parse(widget.session) + 1)
                                          .toString(),
                                      DateFormat('h:mm a').format(DateTime(
                                          2022,
                                          1,
                                          1,
                                          selectedTimesched.hour,
                                          selectedTimesched.minute)),
                                      DateFormat('h:mm a').format(DateTime(
                                          2022,
                                          1,
                                          1,
                                          selectedTimeschedto.hour,
                                          selectedTimeschedto.minute)),
                                      selectedDatesched);
                                  if (result == null) {
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      title: 'Oops...',
                                      text: 'Something went wrong!',
                                    );
                                  } else {
                                    setState(() {
                                      if (result.toString() == "success") {
                                        List<String> idList = [widget.classID];
                                        addNewNotification(
                                            'New Schedule', '', idList);
                                        result = "Schedule succesfully save!";
                                        CoolAlert.show(
                                          context: context,
                                          width: 200,
                                          type: CoolAlertType.success,
                                          title: 'Success...',
                                          text: result,
                                          autoCloseDuration:
                                              const Duration(seconds: 5),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          width: 200,
                                          title: 'Oops...',
                                          text: result,
                                        );
                                      }
                                    });
                                  }
                                  // print('Selected Time interval not fine!');
                                  // CoolAlert.show(
                                  //   context: context,
                                  //   type: CoolAlertType.warning,
                                  //   width: 200,
                                  //   title: 'Oops...',
                                  //   text:
                                  //       'Selected Time is out of tutors schedule!',
                                  // );
                                }
                              }
                            },
                            child: const Text(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              'Save',
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 70,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: TextButton(
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: kColorPrimary,
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
            Positioned(
              top: -5,
              right: -5,
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
        ));
  }
}
