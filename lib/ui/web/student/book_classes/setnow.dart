// ignore_for_file: use_build_context_synchronously, prefer_final_fields, unused_local_variable

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../services/bookingfunctions/setscheduletime.dart';
import '../../../../services/getcalendardata.dart';
import '../../../../services/getenrolledclasses.dart';
import '../../../../services/notificationfunctions/sendnotifications.dart';
import '../../../../services/timefromtimestamp.dart';
import '../../../../services/timestampconverter.dart';
import '../../../../shared_components/header_text.dart';
import '../../../../utils/themes.dart';
import '../../tutor/calendar/setup_calendar.dart';
import 'package:timezone/browser.dart' as tz;

import 'package:http/http.dart' as http;
import 'dart:convert';

class SetNow extends StatefulWidget {
  final String uID;
  final String session;
  final String classID;
  final List<ScheduleData> tutorscurrentschedule;
  final ClassesData? data;
  final String timezone;
  const SetNow(
      {super.key,
      required this.session,
      required this.classID,
      required this.tutorscurrentschedule,
      required this.uID,
      required this.timezone,
      required this.data});

  @override
  State<SetNow> createState() => _SetNowState();
}

class _SetNowState extends State<SetNow> {
  List<String> dayOffs = [];
  List<DateTime> dayOffsdate = [];

  String timeFrom = '12:00 AM';
  String timeTo = '11:59 PM';

  List<BlockDate> blocktime = [];

  List<DateTimeAvailability> dateavailabledateselected = [];
  TextEditingController _selectedTimeZone = TextEditingController();
  FocusNode _selectedTimeZonefocusNode = FocusNode();
  bool showselectedTimeZoneSuggestions = false;
  List<String> timezonesList = [];

  @override
  void initState() {
    super.initState();
    selectedTimesched = initialTime(widget.timezone);
    selectedTimeschedto = initialTime(widget.timezone);
    selectedDatesched = initialDate(widget.timezone);
    _selectedTimeZone.text = widget.timezone;
    getTimezones();
    // getfutureclass();
    // print('Future Data: ${widget.uID}');
    // getDataFromTutorScheduleCollection(widget.data!.tutorinfo.first.userId);
    // getDataFromTutorScheduleCollectionavilableTime(
    //     widget.data!.tutorinfo.first.userId);
    // getDataFromTutorScheduleCollectionBlockDateTime(
    //     widget.data!.tutorinfo.first.userId);
    // getDataFromTutorScheduleCollectionAvailableDateTime(
    //     widget.data!.tutorinfo.first.userId);
  }

  Future<void> getTimezones() async {
    final response =
        await http.get(Uri.parse('http://worldtimeapi.org/api/timezone'));

    if (response.statusCode == 200) {
      final List<dynamic> timezones = json.decode(response.body);
      if (timezones.isNotEmpty) {
        setState(() {
          timezonesList = List<String>.from(timezones);
        });
      } else {
        throw Exception('No timezones found');
      }
    } else {
      throw Exception('Failed to load timezones: ${response.statusCode}');
    }
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDatesched,
      firstDate: DateTime(2022),
      lastDate: DateTime(3000),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDatesched = pickedDate;
      });
    }
  }

  TimeOfDay initialTime(String timezone) {
    final location = tz.getLocation(timezone);

    // Get the current time in the specified timezone
    final nowInSpecificTimeZone = tz.TZDateTime.now(location);

    // Create a TimeOfDay from the timezone-adjusted DateTime
    return TimeOfDay(
      hour: nowInSpecificTimeZone.hour,
      minute: nowInSpecificTimeZone.minute,
    );
  }

  DateTime initialDate(String timezone) {
    final location = tz.getLocation(timezone);

    // Get the current time in the specified timezone
    final nowInSpecificTimeZone = tz.TZDateTime.now(location);

    // Create a TimeOfDay from the timezone-adjusted DateTime
    return nowInSpecificTimeZone;
  }

  void _selectTime(String timezone) async {
    // Specify the timezone you want to use, e.g., "America/New_York"
    final location = tz.getLocation(timezone);

    // Get the current time in the specified timezone
    final nowInSpecificTimeZone = tz.TZDateTime.now(location);

    // Create a TimeOfDay from the timezone-adjusted DateTime
    final initialTime = TimeOfDay(
      hour: nowInSpecificTimeZone.hour,
      minute: nowInSpecificTimeZone.minute,
    );
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
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
            uid: widget.data!.tutorinfo.first.userId,
            role: 'tutor',
            targetTimezone: 'Asia/Dubai')
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
    return Consumer<TutorScheduleProvider>(builder: (context, scheduletime, _) {
      if (scheduletime.availableDateSelected != null) {
        timeFrom = updateTime(widget.timezone,
            scheduletime.availableDateSelected!.timeAvailableFrom);
        timeTo = updateTime(widget.timezone,
            scheduletime.availableDateSelected!.timeAvailableTo);
      }
      if (scheduletime.dateavailabledateselected != null) {
        dateavailabledateselected = scheduletime.dateavailabledateselected!;
      }
      if (scheduletime.blockdateselected != null) {
        blocktime = scheduletime.blockdateselected!;
      }
      if (scheduletime.dayOffs != null || scheduletime.dayOffsdate != null) {
        dayOffs = scheduletime.dayOffs!;
        dayOffsdate = scheduletime.dayOffsdate!;
      }
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: EdgeInsets.zero,
          content: Stack(
            children: <Widget>[
              SizedBox(
                width: 250,
                height: 250,
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
                        style: const TextStyle(color: kColorGrey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectTime(_selectedTimeZone.text);
                            });
                          },
                          child: Text(
                            DateFormat('h:mm a').format(
                              DateTime(2022, 1, 1, selectedTimesched.hour,
                                  selectedTimesched.minute),
                            ),
                            style: const TextStyle(color: kColorGrey),
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
                              _selectTime(_selectedTimeZone.text);
                            });
                          },
                          child: Text(
                            DateFormat('h:mm a').format(DateTime(
                                2022,
                                1,
                                1,
                                selectedTimeschedto.hour,
                                selectedTimeschedto.minute)),
                            style: const TextStyle(color: kColorGrey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: SizedBox(
                        width: 300,
                        height: 45,
                        child: GestureDetector(
                          onTap: () {
                            // Close suggestions when tapped anywhere outside the input field.
                            if (_selectedTimeZonefocusNode.hasFocus) {
                              _selectedTimeZonefocusNode.unfocus();
                              setState(() {
                                showselectedTimeZoneSuggestions = false;
                              });
                            }
                          },
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _selectedTimeZone,
                              focusNode: _selectedTimeZonefocusNode,
                              onTap: () {
                                setState(() {
                                  showselectedTimeZoneSuggestions = false;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Ex. America/Chicago',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Rounded border
                                  borderSide:
                                      BorderSide.none, // No outline border
                                ),
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                              ),
                            ),
                            suggestionsCallback: (String pattern) {
                              return timezonesList.where((timezone) => timezone
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()));
                            },
                            itemBuilder: (context, String suggestion) {
                              return ListTile(
                                title: Text(suggestion, style:const  TextStyle(color: kColorGrey),),
                              );
                            },
                            onSuggestionSelected: (String suggestion) {
                              setState(() {
                                _selectedTimeZone.text = suggestion;
                                selectedTimesched =
                                    initialTime(_selectedTimeZone.text);
                                selectedTimeschedto =
                                    initialTime(_selectedTimeZone.text);
                                selectedDatesched =
                                    initialDate(_selectedTimeZone.text);
                              });
                            },
                            hideOnEmpty:
                                true, // Hide suggestions when the input is empty.
                            hideOnLoading:
                                true, // Hide suggestions during loading.
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 200,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            width: 100,
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
                                String convertedtimefrom =
                                    createTimeWithDateAndZone(
                                  DateFormat('MMMM d, yyyy')
                                      .format(selectedDatesched),
                                  _selectedTimeZone.text,
                                  DateFormat('h:mm a').format(DateTime(
                                      2022,
                                      1,
                                      1,
                                      selectedTimesched.hour,
                                      selectedTimesched.minute)),
                                ).toString();
                                String convertedtimeto =
                                    createTimeWithDateAndZone(
                                  DateFormat('MMMM d, yyyy')
                                      .format(selectedDatesched),
                                  _selectedTimeZone.text,
                                  DateFormat('h:mm a').format(DateTime(
                                      2022,
                                      1,
                                      1,
                                      selectedTimeschedto.hour,
                                      selectedTimeschedto.minute)),
                                ).toString();

                                String selectedfrom = convertTo24HourFormat(
                                    updateTime(
                                        widget.timezone, convertedtimefrom));
                                String selectedto = convertTo24HourFormat(
                                    updateTime(
                                        widget.timezone, convertedtimeto));

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
                                      minute: (int.parse(to24Hour
                                          .split(':')[1]
                                          .split(' ')[0])));

                                  // Manually compare the hours and minutes
                                  return (time.hour > timeFrom.hour ||
                                          (time.hour == timeFrom.hour &&
                                              time.minute >=
                                                  timeFrom.minute)) &&
                                      (time.hour < timeTo.hour ||
                                          (time.hour == timeTo.hour &&
                                              time.minute <= timeTo.minute));
                                });
                                if (isDayOffdate(selectedDatesched) ||
                                    isDayOff(selectedDatesched)) {
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.warning,
                                    width: 200,
                                    title: '',
                                    text: 'Selected DATE is a tutor dayoff.',
                                  );
                                } else if (filteredSchedules.isNotEmpty) {
                                  if (isSelectable) {
                                    if (isTimeInBookings) {
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.warning,
                                        width: 200,
                                        title: '',
                                        text: 'Selected Time is in bookings!',
                                      );
                                    } else if (isTimeInterval) {
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.warning,
                                        width: 200,
                                        title: '',
                                        text: 'Selected Time interval is fine!',
                                      );
                                    } else {
                                      if (isTimeStartOutRange(time)) {
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.warning,
                                          width: 200,
                                          title: 'Oops...',
                                          text:
                                              'Selected Time out of tutors schedule!',
                                        );
                                      } else if (isTimeToOutRange(timeto)) {
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.warning,
                                          width: 200,
                                          title: 'Oops...',
                                          text:
                                              'Selected Time out of tutors schedule!',
                                        );
                                      } else {
                                        String datefrom = formatTimewDatewZone(
                                                DateFormat(
                                                        'MMMM d, yyyy h:mm a')
                                                    .format(DateTime.parse(
                                                            convertedtimefrom)
                                                        .toLocal()),
                                                'Asia/Manila')
                                            .toString();
                                        String dateto = formatTimewDatewZone(
                                                DateFormat(
                                                        'MMMM d, yyyy h:mm a')
                                                    .format(DateTime.parse(
                                                            convertedtimeto)
                                                        .toLocal()),
                                                'Asia/Manila')
                                            .toString();
                                        String? result = await setClassSchedule(
                                            widget.classID,
                                            (int.parse(widget.session) + 1)
                                                .toString(),
                                            datefrom,
                                            dateto,
                                            selectedDatesched,
                                            widget.data!.subjectID);
                                        if (result == null) {
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            title: 'Oops...',
                                            text: 'Something went wrong!',
                                          );
                                        } else {
                                          setState(() {
                                            if (result.toString() ==
                                                "success") {
                                              List<String> idList = [
                                                widget.classID
                                              ];
                                              addNewNotification(
                                                  'New Schedule', '', idList);
                                              result =
                                                  "Schedule succesfully save!";

                                               Navigator.of(context).pop(
                                                          true); 
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
                                      }
                                    }
                                  } else {
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.warning,
                                      width: 200,
                                      title: '',
                                      text: 'Selected Time is out of range!',
                                    );
                                  }
                                } else {
                                  if (isTimeStartOutRange(time)) {
                                    print(time);
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
                                    print(timeto);
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
                                    String datefrom = formatTimewDatewZone(
                                            DateFormat('MMMM d, yyyy h:mm a')
                                                .format(DateTime.parse(
                                                        convertedtimefrom)
                                                    .toLocal()),
                                            'Asia/Manila')
                                        .toString();
                                    String dateto = formatTimewDatewZone(
                                            DateFormat('MMMM d, yyyy h:mm a')
                                                .format(DateTime.parse(
                                                        convertedtimeto)
                                                    .toLocal()),
                                            'Asia/Manila')
                                        .toString();
                                    String? result = await setClassSchedule(
                                        widget.classID,
                                        (int.parse(widget.session) + 1)
                                            .toString(),
                                        datefrom,
                                        dateto,
                                        selectedDatesched,
                                        widget.data!.subjectID);
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
                                          List<String> idList = [
                                            widget.classID
                                          ];
                                          addNewNotification(
                                              'New Schedule', '', idList);
                                          result = "Schedule succesfully save!";

                                            Navigator.of(context).pop(
                                                          true); 
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
                            width: 80,
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
                                  Navigator.of(context).pop(
                                                          false); 
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
    });
  }
}
