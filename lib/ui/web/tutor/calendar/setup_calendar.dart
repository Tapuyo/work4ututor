// ignore_for_file: prefer_final_fields, unused_field, unrelated_type_equality_checks, sized_box_for_whitespace, avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../utils/themes.dart';
import '../../../auth/database.dart';
import '../../admin/admin_sharedcomponents/header_text.dart';

class CalendarSetup extends StatefulWidget {
  final TutorInformation userinfo;
  const CalendarSetup({super.key, required this.userinfo});

  @override
  State<CalendarSetup> createState() => _CalendarSetupState();
}

class _CalendarSetupState extends State<CalendarSetup> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _typeAheadController3 = TextEditingController();

  final TextEditingController _typeAheadController4 = TextEditingController();
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final int startHour = 0;
  final int endHour = 24;
  bool _checkboxavailableday = false;
  bool _checkboxavailabledate = false;
  bool _checkboxavailabledayTime = false;
  bool _checkboxavailabledateTime = false;
  bool _checkboxspeceficdate = false;
  bool _checkboxavailabledayblock = false;
  bool _checkboxavailabledateblock = false;
  bool _checkboxspeceficdateblock = false;

  String selectedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: kColorPrimary,
            colorScheme: const ColorScheme.light(primary: kColorPrimary),
            dialogBackgroundColor: Colors.white,
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              backgroundColor: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (dateselected.contains(picked)) {
          print('Already added');
        } else {
          dateselected.add(picked);
        }
      });
    }
  }

  Future<void> _selectTimeavailableDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: kColorPrimary,
            colorScheme: const ColorScheme.light(primary: kColorPrimary),
            dialogBackgroundColor: Colors.white,
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              backgroundColor: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        availabletimedate = picked;
      });
    }
  }

  Future<void> _selectBlockDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: kColorPrimary,
            colorScheme: const ColorScheme.light(primary: kColorPrimary),
            dialogBackgroundColor: Colors.white,
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              backgroundColor: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        blocktimedate = picked;
      });
    }
  }

  TimeOfDay _selectedTime = TimeOfDay.now();
  String selectedTime = DateFormat('hh:mm a')
      .format(DateTime(0, 0, 0, TimeOfDay.now().hour, TimeOfDay.now().minute));
  String selectedTimeto = DateFormat('hh:mm a')
      .format(DateTime(0, 0, 0, TimeOfDay.now().hour, TimeOfDay.now().minute));

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      useRootNavigator: false,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
        TimeOfDay time = _selectedTime;
        String formattedTime = DateFormat('hh:mm a')
            .format(DateTime(0, 0, 0, time.hour, time.minute));
        print(formattedTime);
        selectedTime = formattedTime.toString();
      });
    }
  }

  Future<void> _selectTimeto(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      useRootNavigator: false,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
        TimeOfDay time = _selectedTime;
        String formattedTime = DateFormat('hh:mm a')
            .format(DateTime(0, 0, 0, time.hour, time.minute));
        print(formattedTime);
        selectedTimeto = formattedTime.toString();
      });
    }
  }

  int canbeuseDayoff = 0;
  int canbeuseTimeavailable = 0;
  int canbeuseBlock = 0;

  List<String> dayoffselected = [];
  String timefrom = '';
  String timeto = '';

  List<DateTime> dateselected = [];
  DateTime timeavailabledate = DateTime.now();
  DateTime availabletimedate = DateTime.now();
  DateTime blocktimedate = DateTime.now();
  TimeAvailability availabledateselected =
      TimeAvailability(timeAvailableFrom: '', timeAvailableTo: '');
  List<DateTimeAvailability> dateavailabledateselected = [];
  List<BlockDate> blockdateselected = [];
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  @override
  void initState() {
    super.initState();
    getDataFromTutorScheduleCollection(widget.userinfo.userId);
    getDataFromTutorScheduleCollectionavilableTime(widget.userinfo.userId);
    getDataFromTutorScheduleCollectionAvailableDateTime(widget.userinfo.userId);
    getDataFromTutorScheduleCollectionBlockDateTime(widget.userinfo.userId);
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
          dayoffselected = List<String>.from(data['dayoffs'] ?? []);

          if (dateoffselected != null) {
            dateselected = dateoffselected
                .map((dateString) => DateTime.tryParse(dateString))
                .where((date) => date != null)
                .cast<DateTime>()
                .toList();
          }
        });

        // // Do something with the data
        // print('UID: $uid');
        print('Dayoffs: $dayoffselected');
        print('DateOffSelected: $dateoffselected');
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

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
            availabledateselected = timeAvailability;
          });
          print(availabledateselected.timeAvailableFrom);
        });
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

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
        blockdateselected = dateTimeAvailabilities;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  int calculateTimeDifferenceInMinutes(String time1, String time2) {
    String from24Hour = convertTo24HourFormat(time1);
    String to24Hour = convertTo24HourFormat(time2);
    TimeOfDay from = TimeOfDay(
      hour: int.parse(from24Hour.split(':')[0]),
      minute: int.parse(from24Hour.split(':')[1]),
    );

    TimeOfDay to = TimeOfDay(
      hour: int.parse(to24Hour.split(':')[0]),
      minute: int.parse(to24Hour.split(':')[1]),
    );
    Duration duration1 = Duration(hours: from.hour, minutes: from.minute);
    Duration duration2 = Duration(hours: to.hour, minutes: to.minute);
    Duration timeDifference = duration1 - duration2;
    return timeDifference.inMinutes;
  }

  String convertTo24HourFormat(String timeString) {
    final DateFormat inputFormat = DateFormat('h:mm a');
    final DateFormat outputFormat = DateFormat('HH:mm');
    final DateTime dateTime = inputFormat.parse(timeString);
    return outputFormat.format(dateTime);
  }

  bool isTimeWithinRange(String time, timefromrange, timetorange) {
    String from24Hour = '';
    String to24Hour = '';
    String timetoknow = '';
    bool isWithinRange = false;
    timetoknow = convertTo24HourFormat(time);
    from24Hour = convertTo24HourFormat(timefromrange);
    to24Hour = convertTo24HourFormat(timetorange);
    TimeOfDay from = TimeOfDay(
      hour: int.parse(from24Hour.split(':')[0]),
      minute: int.parse(from24Hour.split(':')[1]),
    );

    TimeOfDay timeknow = TimeOfDay(
      hour: int.parse(timetoknow.split(':')[0]),
      minute: int.parse(timetoknow.split(':')[1]),
    );

    TimeOfDay to = TimeOfDay(
      hour: int.parse(to24Hour.split(':')[0]),
      minute: int.parse(to24Hour.split(':')[1]),
    );

    int currentTimeInMinutes = timeknow.hour * 60 + timeknow.minute;
    int fromTimeInMinutes = from.hour * 60 + from.minute;
    int toTimeInMinutes = to.hour * 60 + to.minute;

    if (currentTimeInMinutes >= fromTimeInMinutes &&
        currentTimeInMinutes <= toTimeInMinutes) {
      isWithinRange = true; // Exit the loop when the first valid range is found
    }

    return isWithinRange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kColorPrimary,
        title: const HeaderText('Schedule Setup'),
      ),
      body: ClipRect(
        child: DefaultTabController(
          length: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: 770,
                  height: 50,
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the radius as needed
                      color:
                          kColorPrimary, // Background color for the selected tab
                    ),
                    indicatorColor: kColorPrimary,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.event_available),
                        text: 'Day Off',
                        iconMargin: EdgeInsets.only(bottom: 3),
                      ),
                      Tab(
                        icon: Icon(Icons.access_time_outlined),
                        text: 'Time Availabilty',
                        iconMargin: EdgeInsets.only(bottom: 3),
                      ),
                      Tab(
                        icon: Icon(Icons.block_outlined),
                        text: 'Block Time and Date',
                        iconMargin: EdgeInsets.only(bottom: 3),
                      ),
                    ],
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      // Style for selected tab
                      color: Colors.white, // Text color for selected tab
                    ),
                    labelColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: 800,
                  height: 300,
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 770,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kCalendarColorFB,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2, bottom: 0),
                                child: Text(
                                  'SELECT DAY OFF',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _checkboxavailableday,
                                    onChanged: (value) {
                                      setState(() {
                                        _checkboxavailableday = value!;
                                        _checkboxavailabledate = false;
                                        if (canbeuseDayoff == 0 ||
                                            canbeuseDayoff == 2) {
                                          canbeuseDayoff = 1;
                                        } else {
                                          canbeuseDayoff = 0;
                                        }
                                      });
                                    },
                                  ),
                                  const Text('Apply as weekly day off'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Checkbox(
                                    value: _checkboxavailabledate,
                                    onChanged: (value) {
                                      setState(() {
                                        _checkboxavailabledate = value!;
                                        _checkboxavailableday = false;
                                        if (canbeuseDayoff == 0 ||
                                            canbeuseDayoff == 1) {
                                          canbeuseDayoff = 2;
                                        } else {
                                          canbeuseDayoff = 0;
                                        }
                                      });
                                    },
                                  ),
                                  const Text('Apply for specific date'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: canbeuseDayoff == 0 ||
                                            canbeuseDayoff == 1
                                        ? true
                                        : false,
                                    child: Container(
                                      height: 40,
                                      width: 155,
                                      padding: const EdgeInsets.only(
                                          right: 5, left: 5),
                                      alignment: Alignment.topCenter,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: TypeAheadField(
                                        hideOnEmpty: false,
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          enabled: _checkboxavailableday,
                                          textAlign: TextAlign.left,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          autocorrect: true,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          autofocus: false,
                                          controller: _typeAheadController3,
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 8),
                                            border: InputBorder.none,
                                            hintText: 'Select Days',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                            suffixIcon:
                                                Icon(Icons.arrow_drop_down),
                                          ),
                                        ),
                                        suggestionsCallback: (pattern) {
                                          return days.where((item) => item
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()));
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion.toString(),
                                            ),
                                          );
                                        },
                                        onSuggestionSelected: (selectedItem) {
                                          setState(() {
                                            if (dayoffselected.contains(
                                                selectedItem.toString())) {
                                              print('Already added');
                                            } else {
                                              dayoffselected
                                                  .add(selectedItem.toString());
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: canbeuseDayoff == 0 ||
                                            canbeuseDayoff == 2
                                        ? true
                                        : false,
                                    child: Container(
                                      height: 40,
                                      width: 200,
                                      padding: const EdgeInsets.only(
                                          right: 5, left: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(selectedDate),
                                          IconButton(
                                            onPressed: _checkboxavailabledate
                                                ? () => _selectDate(context)
                                                : null,
                                            icon: const Icon(
                                                Icons.calendar_today),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Days Off:',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  dayoffselected.isNotEmpty
                                      ? Container(
                                          width: 300,
                                          height: 50,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                iconSize: 15,
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_back_ios, // Left arrow icon
                                                  color: kColorPrimaryDark,
                                                ),
                                                onPressed: () {
                                                  // Scroll to the left
                                                  _scrollController.animateTo(
                                                    _scrollController.offset -
                                                        100.0, // Adjust the value as needed
                                                    duration: const Duration(
                                                        milliseconds:
                                                            500), // Adjust the duration as needed
                                                    curve: Curves.ease,
                                                  );
                                                },
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  controller:
                                                      _scrollController, // Assign the ScrollController to the ListView
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      dayoffselected.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0,
                                                              right: 5),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(dayoffselected[
                                                                index]),
                                                            IconButton(
                                                              iconSize: 15,
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  dayoffselected
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                iconSize: 15,
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_forward_ios, // Right arrow icon
                                                  color: kColorPrimaryDark,
                                                ),
                                                onPressed: () {
                                                  // Scroll to the right
                                                  _scrollController.animateTo(
                                                    _scrollController.offset +
                                                        100.0, // Adjust the value as needed
                                                    duration: const Duration(
                                                        milliseconds:
                                                            500), // Adjust the duration as needed
                                                    curve: Curves.ease,
                                                  );
                                                },
                                              ),
                                            ],
                                          ))
                                      : Container(
                                          width: 300,
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: const Center(
                                            child: Text('"Weekly dayoffs."'),
                                          ),
                                        ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    'Dates Off:',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  dateselected.isNotEmpty
                                      ? Container(
                                          width: 300,
                                          height: 50,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                color: kColorSecondary,
                                                iconSize: 15,
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_back_ios, // Left arrow icon
                                                  color: kColorPrimaryDark,
                                                ),
                                                onPressed: () {
                                                  // Scroll to the left
                                                  _scrollController1.animateTo(
                                                    _scrollController1.offset -
                                                        100.0, // Adjust the value as needed
                                                    duration: const Duration(
                                                        milliseconds:
                                                            500), // Adjust the duration as needed
                                                    curve: Curves.ease,
                                                  );
                                                },
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  controller:
                                                      _scrollController1, // Assign the ScrollController to the ListView
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      dateselected.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0,
                                                              right: 5),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(DateFormat(
                                                                    'MMMM dd, yyyy')
                                                                .format(
                                                                    dateselected[
                                                                        index])),
                                                            IconButton(
                                                              iconSize: 15,
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  dateselected
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                iconSize: 15,
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_forward_ios, // Right arrow icon
                                                  color: kColorPrimaryDark,
                                                ),
                                                onPressed: () {
                                                  // Scroll to the right
                                                  _scrollController1.animateTo(
                                                    _scrollController1.offset +
                                                        100.0, // Adjust the value as needed
                                                    duration: const Duration(
                                                        milliseconds:
                                                            500), // Adjust the duration as needed
                                                    curve: Curves.ease,
                                                  );
                                                },
                                              ),
                                            ],
                                          ))
                                      : Container(
                                          width: 300,
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: const Center(
                                            child: Text(
                                                '"Select Specific Dates."'),
                                          ),
                                        ),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        CoolAlert.show(
                                          context: context,
                                          barrierDismissible: false,
                                          width: 200,
                                          type: CoolAlertType.confirm,
                                          text: 'You want to add dayoffs?',
                                          confirmBtnText: 'Proceed',
                                          confirmBtnColor: Colors.greenAccent,
                                          cancelBtnText: 'Go back',
                                          showCancelBtn: true,
                                          cancelBtnTextStyle: const TextStyle(
                                              color: Colors.red),
                                          onCancelBtnTap: () {
                                            Navigator.of(context).pop;
                                          },
                                          onConfirmBtnTap: () async {
                                            final result = await addDayOffDates(
                                                widget.userinfo.userId,
                                                dayoffselected,
                                                dateselected);
                                            if (result == 'success') {
                                              setState(() {
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.success,
                                                  text: 'Day Off/s Added!',
                                                  autoCloseDuration:
                                                      const Duration(
                                                          seconds: 1),
                                                );
                                              });
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              CoolAlert.show(
                                                context: context,
                                                width: 200,
                                                type: CoolAlertType.error,
                                                text: result.toString(),
                                              );
                                            }
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            kColorPrimary, // Text color
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Save Day Offs',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        CoolAlert.show(
                                          context: context,
                                          barrierDismissible: false,
                                          width: 200,
                                          type: CoolAlertType.confirm,
                                          text: 'You want to clear dayoff?',
                                          confirmBtnText: 'Proceed',
                                          confirmBtnColor: Colors.greenAccent,
                                          cancelBtnText: 'Go back',
                                          showCancelBtn: true,
                                          cancelBtnTextStyle: const TextStyle(
                                              color: Colors.red),
                                          onCancelBtnTap: () {
                                            Navigator.of(context).pop;
                                          },
                                          onConfirmBtnTap: () async {
                                            final result =
                                                await deleteDayOffDates(
                                              widget.userinfo.userId,
                                            );
                                            if (result == 'success') {
                                              setState(() {
                                                getDataFromTutorScheduleCollection(
                                                    widget.userinfo.userId);
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.success,
                                                  text: 'Day Off/s Deleted!',
                                                  autoCloseDuration:
                                                      const Duration(
                                                          seconds: 1),
                                                );
                                              });
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              CoolAlert.show(
                                                context: context,
                                                width: 200,
                                                type: CoolAlertType.error,
                                                text: result.toString(),
                                              );
                                            }
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: kColorPrimary,
                                        backgroundColor:
                                            Colors.white, // Text color
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Clear',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 770,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kCalendarColorAB,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2, bottom: 0),
                                child: Text(
                                  'TIME AVAILABLE',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _checkboxavailabledayTime,
                                    onChanged: (value) {
                                      setState(() {
                                        _checkboxavailabledayTime = value!;
                                        _checkboxavailabledateTime = false;
                                        _checkboxspeceficdate = false;
                                        if (canbeuseTimeavailable != 1) {
                                          canbeuseTimeavailable = 1;
                                        } else {
                                          canbeuseTimeavailable = 0;
                                        }
                                      });
                                    },
                                  ),
                                  const Text('Apply for every available day'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Checkbox(
                                    value: _checkboxavailabledateTime,
                                    onChanged: (value) {
                                      setState(() {
                                        _checkboxavailabledateTime = value!;
                                        _checkboxavailabledayTime = false;
                                        _checkboxspeceficdate = false;
                                        if (canbeuseTimeavailable != 2) {
                                          canbeuseTimeavailable = 2;
                                        } else {
                                          canbeuseTimeavailable = 0;
                                        }
                                      });
                                    },
                                  ),
                                  const Text('Apply for specific date'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: canbeuseTimeavailable == 0 ||
                                            canbeuseTimeavailable == 2
                                        ? true
                                        : false,
                                    child: Container(
                                      height: 40,
                                      width: 200,
                                      padding: const EdgeInsets.only(
                                          right: 5, left: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(DateFormat('MMMM dd, yyyy')
                                              .format(availabletimedate)),
                                          IconButton(
                                            onPressed: canbeuseTimeavailable ==
                                                    2
                                                ? () =>
                                                    _selectTimeavailableDate(
                                                        context)
                                                : null,
                                            icon: const Icon(
                                                Icons.calendar_today),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 125,
                                    padding: const EdgeInsets.only(
                                        right: 2, left: 2),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(selectedTime),
                                        IconButton(
                                          onPressed: () => _selectTime(context),
                                          icon: const Icon(
                                              Icons.timelapse_rounded),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    child: Text('to'),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 125,
                                    padding: const EdgeInsets.only(
                                        right: 2, left: 2),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(selectedTimeto),
                                        IconButton(
                                          onPressed: () =>
                                              _selectTimeto(context),
                                          icon: const Icon(
                                              Icons.timelapse_rounded),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_checkboxavailabledayTime) {
                                        TimeAvailability timeselected =
                                            TimeAvailability(
                                                timeAvailableFrom: selectedTime,
                                                timeAvailableTo:
                                                    selectedTimeto);
                                        setState(() {
                                          availabledateselected = timeselected;
                                        });
                                      } else if (_checkboxavailabledateTime) {
                                        DateTimeAvailability datetimeselected =
                                            DateTimeAvailability(
                                                selectedDate: availabletimedate,
                                                timeAvailableFrom: selectedTime,
                                                timeAvailableTo:
                                                    selectedTimeto);
                                        setState(() {
                                          int time =
                                              calculateTimeDifferenceInMinutes(
                                                  datetimeselected
                                                      .timeAvailableFrom,
                                                  datetimeselected
                                                      .timeAvailableTo);
                                          if (time >= 50) {
                                            if (dateavailabledateselected
                                                .any((timeAvailable) =>
                                                    timeAvailable
                                                            .selectedDate ==
                                                        datetimeselected
                                                            .selectedDate &&
                                                    isTimeWithinRange(
                                                        datetimeselected
                                                            .timeAvailableFrom,
                                                        timeAvailable
                                                            .timeAvailableFrom,
                                                        timeAvailable
                                                            .timeAvailableTo))) {
                                              CoolAlert.show(
                                                context: context,
                                                width: 200,
                                                type: CoolAlertType.error,
                                                text:
                                                    'Time is already selected, check the timings.',
                                              );
                                            } else if (dateavailabledateselected
                                                .any((timeAvailable) =>
                                                    timeAvailable
                                                            .selectedDate ==
                                                        datetimeselected
                                                            .selectedDate &&
                                                    isTimeWithinRange(
                                                            datetimeselected
                                                                .timeAvailableFrom,
                                                            timeAvailable
                                                                .timeAvailableFrom,
                                                            timeAvailable
                                                                .timeAvailableTo) ==
                                                        false)) {
                                              dateavailabledateselected
                                                  .add(datetimeselected);
                                            } else {
                                              dateavailabledateselected
                                                  .add(datetimeselected);
                                            }
                                          } else {
                                            CoolAlert.show(
                                              context: context,
                                              width: 200,
                                              type: CoolAlertType.error,
                                              text:
                                                  'Time Range Error, minimum of 50 minutes.',
                                            );
                                          }
                                        });
                                      }
                                    },
                                    child: const Text(
                                      'Add',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Every Available Day:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      availabledateselected.timeAvailableTo !=
                                              ''
                                          ? ClipRect(
                                              child: Container(
                                                  width: 300,
                                                  height: 60,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 10, 5, 0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'From: ${availabledateselected.timeAvailableFrom}'),
                                                          const Spacer(),
                                                          Text(
                                                              'To: ${availabledateselected.timeAvailableTo}'),
                                                        ],
                                                      )),
                                                    ],
                                                  )),
                                            )
                                          : Container(
                                              width: 200,
                                              height: 55,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: const Center(
                                                child: Text('"Time not set"'),
                                              ),
                                            ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Specific Date:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      dateavailabledateselected.isNotEmpty
                                          ? Container(
                                              width: 450,
                                              height: 100,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: Row(
                                                children: [
                                                  // IconButton(
                                                  //   color: kColorSecondary,
                                                  //   iconSize: 15,
                                                  //   icon: const Icon(
                                                  //     Icons
                                                  //         .arrow_back_ios, // Left arrow icon
                                                  //     color: kColorPrimaryDark,
                                                  //   ),
                                                  //   onPressed: () {
                                                  //     // Scroll to the left
                                                  //     _scrollController1
                                                  //         .animateTo(
                                                  //       _scrollController1
                                                  //               .offset -
                                                  //           100.0, // Adjust the value as needed
                                                  //       duration: const Duration(
                                                  //           milliseconds:
                                                  //               500), // Adjust the duration as needed
                                                  //       curve: Curves.ease,
                                                  //     );
                                                  //   },
                                                  // ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                      controller:
                                                          _scrollController1, // Assign the ScrollController to the ListView
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          dateavailabledateselected
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5.0,
                                                                  right: 5),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    5, 0, 5, 0),
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    '${DateFormat('MMMM dd, yyyy').format(dateavailabledateselected[index].selectedDate)}(From: ${dateavailabledateselected[index].timeAvailableFrom} To: ${dateavailabledateselected[index].timeAvailableTo})'),
                                                                IconButton(
                                                                  iconSize: 15,
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      dateavailabledateselected
                                                                          .removeAt(
                                                                              index);
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  // IconButton(
                                                  //   iconSize: 15,
                                                  //   icon: const Icon(
                                                  //     Icons
                                                  //         .arrow_forward_ios, // Right arrow icon
                                                  //     color: kColorPrimaryDark,
                                                  //   ),
                                                  //   onPressed: () {
                                                  //     // Scroll to the right
                                                  //     _scrollController1
                                                  //         .animateTo(
                                                  //       _scrollController1
                                                  //               .offset +
                                                  //           100.0, // Adjust the value as needed
                                                  //       duration: const Duration(
                                                  //           milliseconds:
                                                  //               500), // Adjust the duration as needed
                                                  //       curve: Curves.ease,
                                                  //     );
                                                  //   },
                                                  // ),
                                                ],
                                              ))
                                          : Container(
                                              width: 300,
                                              height: 55,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: const Center(
                                                child: Text(
                                                    '"Select Specific Dates."'),
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        CoolAlert.show(
                                          context: context,
                                          barrierDismissible: false,
                                          width: 200,
                                          type: CoolAlertType.confirm,
                                          text: 'You want to add/update time?',
                                          confirmBtnText: 'Proceed',
                                          confirmBtnColor: Colors.greenAccent,
                                          cancelBtnText: 'Go back',
                                          showCancelBtn: true,
                                          cancelBtnTextStyle: const TextStyle(
                                              color: Colors.red),
                                          onCancelBtnTap: () {
                                            Navigator.of(context).pop;
                                          },
                                          onConfirmBtnTap: () async {
                                            final result =
                                                await addOrUpdateTimeAvailability(
                                                    widget.userinfo.userId,
                                                    availabledateselected);
                                            final result1 =
                                                await addOrUpdateTimeAvailabilityWithDate(
                                                    widget.userinfo.userId,
                                                    dateavailabledateselected);
                                            if (result1 == 'success') {
                                              setState(() {
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.success,
                                                  text:
                                                      'Available Time/s Added!',
                                                  autoCloseDuration:
                                                      const Duration(
                                                          seconds: 1),
                                                );
                                              });
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              CoolAlert.show(
                                                context: context,
                                                width: 200,
                                                type: CoolAlertType.error,
                                                text: result.toString(),
                                              );
                                            }
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            kColorPrimary, // Text color
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Save Availability',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        CoolAlert.show(
                                          context: context,
                                          barrierDismissible: false,
                                          width: 200,
                                          type: CoolAlertType.confirm,
                                          text:
                                              'You want to clear time availabilty?',
                                          confirmBtnText: 'Proceed',
                                          confirmBtnColor: Colors.greenAccent,
                                          cancelBtnText: 'Go back',
                                          showCancelBtn: true,
                                          cancelBtnTextStyle: const TextStyle(
                                              color: Colors.red),
                                          onCancelBtnTap: () {
                                            Navigator.of(context).pop;
                                          },
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop;
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: kColorPrimary,
                                        backgroundColor:
                                            Colors.white, // Text color
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Clear',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 770,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kCalendarColorB,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2, bottom: 0),
                                child: Text(
                                  'BLOCK TIME AND DATE',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 200,
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(selectedDate),
                                        IconButton(
                                          onPressed: () =>
                                              _selectBlockDate(context),
                                          icon:
                                              const Icon(Icons.calendar_today),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 125,
                                    padding: const EdgeInsets.only(
                                        right: 2, left: 2),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(selectedTime),
                                        IconButton(
                                          onPressed: () => _selectTime(context),
                                          icon: const Icon(
                                              Icons.timelapse_rounded),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    child: Text('to'),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 125,
                                    padding: const EdgeInsets.only(
                                        right: 2, left: 2),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(selectedTimeto),
                                        IconButton(
                                          onPressed: () =>
                                              _selectTimeto(context),
                                          icon: const Icon(
                                              Icons.timelapse_rounded),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      BlockDate datetimeselected = BlockDate(
                                          timeFrom: selectedTime,
                                          timeTo: selectedTimeto,
                                          blockDate: blocktimedate);
                                      // setState(() {
                                      //   if (blockdateselected.any(
                                      //       (timeAvailable) =>
                                      //           timeAvailable.blockDate ==
                                      //           datetimeselected.blockDate)) {
                                      //   } else {
                                      //     blockdateselected
                                      //         .add(datetimeselected);
                                      //   }
                                      // });
                                      setState(() {
                                        int time =
                                            calculateTimeDifferenceInMinutes(
                                                datetimeselected.timeFrom,
                                                datetimeselected.timeTo);
                                        if (time >= 5) {
                                          if (blockdateselected.any(
                                              (timeAvailable) =>
                                                  timeAvailable.blockDate ==
                                                      datetimeselected
                                                          .blockDate &&
                                                  isTimeWithinRange(
                                                      datetimeselected.timeFrom,
                                                      timeAvailable.timeFrom,
                                                      timeAvailable.timeTo))) {
                                            CoolAlert.show(
                                              context: context,
                                              width: 200,
                                              type: CoolAlertType.error,
                                              text:
                                                  'Time is already selected, check the timings.',
                                            );
                                          } else if (blockdateselected.any(
                                              (timeAvailable) =>
                                                  timeAvailable.blockDate ==
                                                      datetimeselected
                                                          .blockDate &&
                                                  isTimeWithinRange(
                                                          datetimeselected
                                                              .timeFrom,
                                                          timeAvailable
                                                              .timeFrom,
                                                          timeAvailable
                                                              .timeTo) ==
                                                      false)) {
                                            blockdateselected
                                                .add(datetimeselected);
                                          } else {
                                            blockdateselected
                                                .add(datetimeselected);
                                          }
                                        } else {
                                          CoolAlert.show(
                                            context: context,
                                            width: 200,
                                            type: CoolAlertType.error,
                                            text:
                                                'Time Range Error, minimum of 50 minutes.',
                                          );
                                        }
                                      });
                                    },
                                    child: const Text(
                                      'Add',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Specific Date:',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  blockdateselected.isNotEmpty
                                      ? Container(
                                          width: 450,
                                          height: 120,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 5, 0),
                                          child: Row(
                                            children: [
                                              // IconButton(
                                              //   color: kColorSecondary,
                                              //   iconSize: 15,
                                              //   icon: const Icon(
                                              //     Icons
                                              //         .arrow_back_ios, // Left arrow icon
                                              //     color: kColorPrimaryDark,
                                              //   ),
                                              //   onPressed: () {
                                              //     // Scroll to the left
                                              //     _scrollController1.animateTo(
                                              //       _scrollController1.offset -
                                              //           100.0, // Adjust the value as needed
                                              //       duration: const Duration(
                                              //           milliseconds:
                                              //               500), // Adjust the duration as needed
                                              //       curve: Curves.ease,
                                              //     );
                                              //   },
                                              // ),
                                              Expanded(
                                                child: ListView.builder(
                                                  controller:
                                                      _scrollController1, // Assign the ScrollController to the ListView
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      blockdateselected.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0,
                                                              right: 5),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                '${DateFormat('MMMM dd, yyyy').format(blockdateselected[index].blockDate)}(From: ${blockdateselected[index].timeFrom} To: ${blockdateselected[index].timeTo})'),
                                                            IconButton(
                                                              iconSize: 15,
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  blockdateselected
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              // IconButton(
                                              //   iconSize: 15,
                                              //   icon: const Icon(
                                              //     Icons
                                              //         .arrow_forward_ios, // Right arrow icon
                                              //     color: kColorPrimaryDark,
                                              //   ),
                                              //   onPressed: () {
                                              //     // Scroll to the right
                                              //     _scrollController1.animateTo(
                                              //       _scrollController1.offset +
                                              //           100.0, // Adjust the value as needed
                                              //       duration: const Duration(
                                              //           milliseconds:
                                              //               500), // Adjust the duration as needed
                                              //       curve: Curves.ease,
                                              //     );
                                              //   },
                                              // ),
                                            ],
                                          ))
                                      : Container(
                                          width: 300,
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: const Center(
                                            child: Text(
                                                '"Select Specific Dates."'),
                                          ),
                                        ),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        CoolAlert.show(
                                          context: context,
                                          barrierDismissible: false,
                                          width: 200,
                                          type: CoolAlertType.confirm,
                                          text: 'You want to block date/time?',
                                          confirmBtnText: 'Proceed',
                                          confirmBtnColor: Colors.greenAccent,
                                          cancelBtnText: 'Go back',
                                          showCancelBtn: true,
                                          cancelBtnTextStyle: const TextStyle(
                                              color: Colors.red),
                                          onCancelBtnTap: () {
                                            Navigator.of(context).pop;
                                          },
                                          onConfirmBtnTap: () async {
                                            final result1 =
                                                await blockTimeWithDate(
                                                    widget.userinfo.userId,
                                                    blockdateselected);
                                            if (result1 == 'success') {
                                              setState(() {
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.success,
                                                  text: 'Block Time/s Added!',
                                                  autoCloseDuration:
                                                      const Duration(
                                                          seconds: 1),
                                                );
                                              });
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              CoolAlert.show(
                                                context: context,
                                                width: 200,
                                                type: CoolAlertType.error,
                                                text: result1.toString(),
                                              );
                                            }
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            kColorPrimary, // Text color
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Block Dates',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        CoolAlert.show(
                                          context: context,
                                          barrierDismissible: false,
                                          width: 200,
                                          type: CoolAlertType.confirm,
                                          text: 'You want to clear blockings?',
                                          confirmBtnText: 'Proceed',
                                          confirmBtnColor: Colors.greenAccent,
                                          cancelBtnText: 'Go back',
                                          showCancelBtn: true,
                                          cancelBtnTextStyle: const TextStyle(
                                              color: Colors.red),
                                          onCancelBtnTap: () {
                                            Navigator.of(context).pop;
                                          },
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop;
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: kColorPrimary,
                                        backgroundColor:
                                            Colors.white, // Text color
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        'Clear',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlockDate {
  String timeFrom;
  String timeTo;
  DateTime blockDate;

  BlockDate({
    required this.timeFrom,
    required this.timeTo,
    required this.blockDate,
  });

  // Factory constructor to create a BlockDate instance from a Map
  factory BlockDate.fromMap(Map<String, dynamic> map) {
    return BlockDate(
      timeFrom: map['timeFrom'],
      timeTo: map['timeTo'],
      blockDate: map['blockDate'].toDate() as DateTime,
    );
  }

  // Convert a BlockDate instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'timeFrom': timeFrom,
      'timeTo': timeTo,
      'blockDate': blockDate,
    };
  }
}

class TimeAvailability {
  String timeAvailableFrom;
  String timeAvailableTo;

  TimeAvailability({
    required this.timeAvailableFrom,
    required this.timeAvailableTo,
  });

  // Factory constructor to create a TimeAvailability instance from a Map
  factory TimeAvailability.fromMap(Map<String, dynamic> map) {
    return TimeAvailability(
      timeAvailableFrom: map['timeAvailableFrom'],
      timeAvailableTo: map['timeAvailableTo'],
    );
  }

  // Convert a TimeAvailability instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'timeAvailableFrom': timeAvailableFrom,
      'timeAvailableTo': timeAvailableTo,
    };
  }
}

class DateTimeAvailability {
  DateTime selectedDate;
  String timeAvailableFrom;
  String timeAvailableTo;

  DateTimeAvailability({
    required this.selectedDate,
    required this.timeAvailableFrom,
    required this.timeAvailableTo,
  });

  // Factory constructor to create a TimeAvailability instance from a Map
  factory DateTimeAvailability.fromMap(Map<String, dynamic> map) {
    return DateTimeAvailability(
      timeAvailableFrom: map['timeAvailableFrom'],
      timeAvailableTo: map['timeAvailableTo'],
      selectedDate: map['selectedDate']?.toDate() ?? '',
    );
  }

  // Convert a TimeAvailability instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'selectedDate': selectedDate,
      'timeAvailableFrom': timeAvailableFrom,
      'timeAvailableTo': timeAvailableTo,
    };
  }
}
