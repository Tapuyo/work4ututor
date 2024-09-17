// ignore_for_file: prefer_final_fields, unused_field, unrelated_type_equality_checks, sized_box_for_whitespace, avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison, use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../services/getcalendardata.dart';
import '../../../../services/timefromtimestamp.dart';
import '../../../../services/timestampconverter.dart';
import '../../../../utils/themes.dart';
import '../../../auth/database.dart';
import 'package:timezone/browser.dart' as tz;

class CalendarSetup extends StatefulWidget {
  final TutorInformation userinfo;
  final List<ScheduleData> booking;
  final String timezone;

  const CalendarSetup(
      {super.key,
      required this.userinfo,
      required this.booking,
      required this.timezone});

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
  String selectedBlockDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

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
          tempdateselected = picked;
          selectedDate = DateFormat('MMMM dd, yyyy').format(picked);
        }
      });
    }
  }

  String dateFormatted(String date) {
    // Your input date string with timezone
    String dateStr = date;

    // Parse the date string to DateTime with original timezone
    DateTime dateTime = DateTime.parse(dateStr).toLocal();
    print(dateTime);
    // Format the DateTime to the desired format, maintaining the original time and zone
    String formattedDate = DateFormat('MMMM d, yyyy h:mm a').format(dateTime);

    return formattedDate;
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
        selectedBlockDate = DateFormat('MMMM dd, yyyy').format(picked);
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
  String tempDayoffselected = '';
  String timefrom = '';
  String timeto = '';

  List<DateTime> dateselected = [];
  DateTime? tempdateselected;
  DateTime timeavailabledate = DateTime.now();
  DateTime availabletimedate = DateTime.now();
  DateTime? blocktimedate;
  TimeAvailability availabledateselected =
      TimeAvailability(timeAvailableFrom: '', timeAvailableTo: '');
  List<DateTimeAvailability> dateavailabledateselected = [];
  DateTimeAvailability? selectedDateTime;
  List<BlockDate> blockdateselected = [];
  ScrollController _scrollController = ScrollController();
  ScrollController daysoffcroll = ScrollController();
  ScrollController dateoffscroll = ScrollController();
  ScrollController dateavailablescroll = ScrollController();
  ScrollController blockdatetimescroll = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartNotifier =
          Provider.of<TutorScheduleProvider>(context, listen: false);
      cartNotifier.getDataFromTutorScheduleCollectionAvailableTime(
          widget.userinfo.userId);
    });
    _selectedDate = initialDate(widget.timezone);
    _selectedTime = initialTime(widget.timezone);
    super.initState();
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
    Duration timeDifference = duration2 - duration1;
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
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              elevation: 4,
              child: Container(
                  width: 800,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.1, 0),
                      end: Alignment.centerRight,
                      colors: secondaryHeadercolors,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                      child: Text(
                    'Schedule Setup',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ))),
            ),
            DefaultTabController(
              length: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 800,
                      height: 50,
                      child: TabBar(
                        indicator: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: buttonFocuscolors,
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        indicatorColor: kColorPrimary,
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.event_available),
                            text: 'Days Off',
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
                          color: Colors.white,
                        ),
                        labelColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 800,
                      height: 310,
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: 770,
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 10.0, 5.0),
                              decoration: BoxDecoration(
                                // gradient: const LinearGradient(
                                //   begin: Alignment(-0.1, 0),
                                //   end: Alignment.centerRight,
                                //   colors: tabBlue,
                                // ),
                                border: Border.all(
                                  width: 3,
                                  color: kCalendarColorFB,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Days Off',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: kColorWhite,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Current Timezone: ${widget.timezone}',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: kColorWhite,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
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
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        activeColor: Colors.grey,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return Colors.grey;
                                          }
                                          return kColorGrey;
                                        }),
                                        checkColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: kColorGrey),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      const Text(
                                        'Apply for specific days',
                                        style: TextStyle(
                                            color: kColorWhite, fontSize: 14),
                                      ),
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
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        activeColor: Colors.grey,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return Colors.grey;
                                          }
                                          return kColorGrey;
                                        }),
                                        checkColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: kColorGrey),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      const Text('Apply for specific dates',
                                          style: TextStyle(
                                              color: kColorWhite,
                                              fontSize: 14)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: _checkboxavailableday,
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
                                              color: kColorGrey,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
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
                                                color: kColorGrey,
                                              ),
                                              autofocus: false,
                                              controller: _typeAheadController3,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 8, left: 10),
                                                border: InputBorder.none,
                                                hintText: 'Select Days',
                                                hintStyle: TextStyle(
                                                  color: kColorGrey,
                                                ),
                                                suffixIcon:
                                                    Icon(Icons.arrow_drop_down),
                                              ),
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return days.where((item) => item
                                                  .toLowerCase()
                                                  .contains(
                                                      pattern.toLowerCase()));
                                            },
                                            itemBuilder: (context, suggestion) {
                                              return ListTile(
                                                title: Text(
                                                  suggestion.toString(),
                                                  style: const TextStyle(
                                                    color: kColorGrey,
                                                  ),
                                                ),
                                              );
                                            },
                                            onSuggestionSelected:
                                                (selectedItem) {
                                              setState(() {
                                                if (dayoffselected.contains(
                                                    selectedItem.toString())) {
                                                  print('Already added');
                                                } else {
                                                  tempDayoffselected =
                                                      selectedItem.toString();
                                                  _typeAheadController3.text =
                                                      tempDayoffselected; // Update text field with selected items
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Visibility(
                                        visible: _checkboxavailabledate,
                                        child: Container(
                                          height: 40,
                                          width: 200,
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 15),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: kColorGrey,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                selectedDate,
                                                style: const TextStyle(
                                                    color: kColorGrey),
                                              ),
                                              IconButton(
                                                onPressed:
                                                    _checkboxavailabledate
                                                        ? () =>
                                                            _selectDate(context)
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
                                      Visibility(
                                        visible: _checkboxavailableday ||
                                            _checkboxavailabledate,
                                        child: TextButton(
                                          onPressed: () async {
                                            // if (tempDayoffselected == '' &&
                                            //     tempdateselected == null) {
                                            //   CoolAlert.show(
                                            //     context: context,
                                            //     width: 200,
                                            //     type: CoolAlertType.warning,
                                            //     title: 'Nothing is selected!',
                                            //     titleTextStyle: const TextStyle(
                                            //         fontSize: 14,
                                            //         fontWeight:
                                            //             FontWeight.normal),
                                            //   );
                                            // } else {
                                            // setState(() {
                                            //   if (tempDayoffselected != '') {
                                            //     dayoffselected
                                            //         .add(tempDayoffselected);
                                            //   }
                                            //   if (tempdateselected != null) {
                                            //     dateselected
                                            //         .add(tempdateselected!);
                                            //   }
                                            //   tempDayoffselected = '';
                                            //   tempdateselected = null;
                                            // });
                                            if (_checkboxavailabledate) {
                                              final result =
                                                  await addDayOffDates(
                                                      widget.userinfo.userId,
                                                      // tempDayoffselected,
                                                      tempdateselected!,
                                                      widget.timezone);
                                              if (result == 'success') {
                                              } else {
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.error,
                                                  title: result.toString(),
                                                  titleTextStyle:
                                                      const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                );
                                              }
                                            } else if (_checkboxavailableday) {
                                              final result =
                                                  await addUpdateDayOffDates(
                                                      widget.userinfo.userId,
                                                      tempDayoffselected,
                                                      // tempdateselected!,
                                                      widget.timezone);
                                              if (result == 'success') {
                                              } else {
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.error,
                                                  title: result.toString(),
                                                  titleTextStyle:
                                                      const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                );
                                              }
                                              _typeAheadController3.text = '';
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'Add',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: kColorPrimary),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Consumer<TutorScheduleProvider>(
                                      builder: (context, scheduletime, _) {
                                    if (scheduletime.dayOffs != null ||
                                        scheduletime.dayOffsdate != null) {
                                      dayoffselected = scheduletime.dayOffs!;
                                      dateselected = scheduletime.dayOffsdate!;
                                    } else {
                                      dayoffselected = [];
                                      dateselected = [];
                                    }
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Days Off:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: kColorWhite,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            dayoffselected.isNotEmpty
                                                ? Container(
                                                    width: 300,
                                                    height: 150,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: RawScrollbar(
                                                      controller: daysoffcroll,
                                                      thumbColor:
                                                          Colors.redAccent,
                                                      radius:
                                                          const Radius.circular(
                                                              8),
                                                      crossAxisMargin: 2,
                                                      child: Scrollbar(
                                                        trackVisibility: true,
                                                        thumbVisibility: true,
                                                        controller:
                                                            daysoffcroll,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          controller:
                                                              daysoffcroll, // Assign the ScrollController to the ListView
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              dayoffselected
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
                                                                        5,
                                                                        0,
                                                                        5,
                                                                        0),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      dayoffselected[
                                                                          index],
                                                                      style: const TextStyle(
                                                                          color:
                                                                              kColorWhite),
                                                                    ),
                                                                    IconButton(
                                                                      iconSize:
                                                                          15,
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .delete_outline,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        final result =
                                                                            await deleteDayOff(
                                                                          widget
                                                                              .userinfo
                                                                              .userId,
                                                                          dayoffselected[
                                                                              index],
                                                                        );
                                                                        if (result ==
                                                                            'success') {
                                                                        } else {
                                                                          // ignore: use_build_context_synchronously
                                                                          CoolAlert
                                                                              .show(
                                                                            context:
                                                                                context,
                                                                            width:
                                                                                200,
                                                                            type:
                                                                                CoolAlertType.error,
                                                                            title:
                                                                                result.toString(),
                                                                            titleTextStyle:
                                                                                const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                                                          );
                                                                        }
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 300,
                                                    height: 100,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: const Center(
                                                      child: Text(
                                                        '"Weekly dayoffs."',
                                                        style: TextStyle(
                                                            color: kColorWhite),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Dates Off:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: kColorWhite,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            scheduletime.forlistdayoffsdate!
                                                    .isNotEmpty
                                                ? Container(
                                                    width: 300,
                                                    height: 150,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: Scrollbar(
                                                      trackVisibility: true,
                                                      thumbVisibility: true,
                                                      controller: dateoffscroll,
                                                      child: ListView.builder(
                                                        controller:
                                                            dateoffscroll, // Assign the ScrollController to the ListView
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: scheduletime
                                                            .forlistdayoffsdate!
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
                                                                      5,
                                                                      0,
                                                                      5,
                                                                      0),
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
                                                                      DateFormat('MMMM dd, yyyy').format(scheduletime
                                                                          .forlistdayoffsdate![
                                                                              index]
                                                                          .selectedDate),
                                                                      style: const TextStyle(
                                                                          color:
                                                                              kColorWhite)),
                                                                  IconButton(
                                                                    iconSize:
                                                                        15,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .delete_outline,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      print(scheduletime
                                                                          .forlistdayoffsdate![
                                                                              index]
                                                                          .selectedDate);
                                                                      print(scheduletime
                                                                          .forlistdayoffsdate![
                                                                              index]
                                                                          .timeAvailableFrom);
                                                                      print(scheduletime
                                                                          .forlistdayoffsdate![
                                                                              index]
                                                                          .timeAvailableTo);
                                                                      final result = await deleteDateOff(
                                                                          widget.userinfo.userId,
                                                                          // dateselected[
                                                                          //     index],
                                                                          scheduletime.forlistdayoffsdate![index],
                                                                          widget.timezone);
                                                                      if (result ==
                                                                          'success') {
                                                                      } else {
                                                                        CoolAlert
                                                                            .show(
                                                                          context:
                                                                              context,
                                                                          width:
                                                                              200,
                                                                          type:
                                                                              CoolAlertType.error,
                                                                          title:
                                                                              result.toString(),
                                                                          titleTextStyle: const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.normal),
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 300,
                                                    height: 100,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: const Center(
                                                      child: Text(
                                                          '"Select Specific Dates."',
                                                          style: TextStyle(
                                                              color:
                                                                  kColorWhite)),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                                  // const Spacer(),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     CoolAlert.show(
                                  //       context: context,
                                  //       barrierDismissible: false,
                                  //       width: 200,
                                  //       type: CoolAlertType.confirm,
                                  //       title: 'Proceed clearing day/date off?',
                                  //       titleTextStyle: const TextStyle(
                                  //           fontSize: 14,
                                  //           fontWeight: FontWeight.normal),
                                  //       confirmBtnText: 'Proceed',
                                  //       confirmBtnColor: Colors.greenAccent,
                                  //       cancelBtnText: 'Go back',
                                  //       showCancelBtn: true,
                                  //       cancelBtnTextStyle:
                                  //           const TextStyle(color: Colors.red),
                                  //       onCancelBtnTap: () {
                                  //         Navigator.of(context).pop;
                                  //       },
                                  //       onConfirmBtnTap: () async {
                                  //         final result =
                                  //             await deleteDayOffDates(
                                  //           widget.userinfo.userId,
                                  //         );
                                  //         if (result == 'success') {
                                  //         } else {
                                  //           CoolAlert.show(
                                  //             context: context,
                                  //             width: 200,
                                  //             type: CoolAlertType.error,
                                  //             title: result.toString(),
                                  //             titleTextStyle: const TextStyle(
                                  //                 fontSize: 14,
                                  //                 fontWeight:
                                  //                     FontWeight.normal),
                                  //           );
                                  //         }
                                  //       },
                                  //     );
                                  //   },
                                  //   style: ButtonStyle(
                                  //     backgroundColor:
                                  //         MaterialStateProperty.all(
                                  //             Colors.transparent),
                                  //     shape: MaterialStateProperty.all<
                                  //         RoundedRectangleBorder>(
                                  //       RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(15.0),
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   child: const Text(
                                  //     'Clear',
                                  //     style: TextStyle(
                                  //         fontSize: 16,
                                  //         fontWeight: FontWeight.bold,
                                  //         color: Colors.red),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: 770,
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 10.0, 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: kCalendarColorAB,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Time Availability',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: kColorGrey,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Current Timezone: ${widget.timezone}',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: kColorWhite,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
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
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        activeColor: Colors.grey,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return Colors.grey;
                                          }
                                          return kColorGrey;
                                        }),
                                        checkColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: kColorGrey),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      const Text(
                                        'Apply for every available day',
                                        style: TextStyle(
                                            color: kColorGrey, fontSize: 14),
                                      ),
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
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        activeColor: Colors.grey,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return Colors.grey;
                                          }
                                          return kColorGrey;
                                        }),
                                        checkColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: kColorGrey),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      const Text(
                                        'Apply for specific date',
                                        style: TextStyle(
                                            color: kColorGrey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: _checkboxavailabledateTime ||
                                        _checkboxavailabledayTime,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                right: 10, left: 15),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.white,
                                              border: Border.all(
                                                color: kColorGrey,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  DateFormat('MMMM dd, yyyy')
                                                      .format(
                                                          availabletimedate),
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                ),
                                                IconButton(
                                                  onPressed:
                                                      canbeuseTimeavailable == 2
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
                                          width: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 125,
                                          padding: const EdgeInsets.only(
                                              right: 2, left: 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: kColorGrey,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                selectedTime,
                                                style: const TextStyle(
                                                    color: kColorGrey),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    _selectTime(context),
                                                icon: const Icon(
                                                    Icons.access_time_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const SizedBox(
                                          child: Text(
                                            'to',
                                            style: TextStyle(color: kColorGrey),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 125,
                                          padding: const EdgeInsets.only(
                                              right: 2, left: 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: kColorGrey,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                selectedTimeto,
                                                style: const TextStyle(
                                                    color: kColorGrey),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    _selectTimeto(context),
                                                icon: const Icon(
                                                    Icons.access_time_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (_checkboxavailabledayTime) {
                                              if (selectedTime ==
                                                  selectedTimeto) {
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.error,
                                                  title: 'Time selected error!',
                                                  titleTextStyle:
                                                      const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                );
                                              } else if (selectedTime == '' ||
                                                  selectedTimeto == '') {
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.error,
                                                  title: 'No time selected!',
                                                  titleTextStyle:
                                                      const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                );
                                              } else {
                                                TimeAvailability timeselected =
                                                    TimeAvailability(
                                                        timeAvailableFrom:
                                                            selectedTime,
                                                        timeAvailableTo:
                                                            selectedTimeto);

                                                final result =
                                                    await addOrUpdateTimeAvailability(
                                                        widget.userinfo.userId,
                                                        timeselected,
                                                        widget.timezone);
                                                if (result == 'success') {
                                                } else {
                                                  CoolAlert.show(
                                                    context: context,
                                                    width: 200,
                                                    type: CoolAlertType.error,
                                                    title: result.toString(),
                                                    titleTextStyle:
                                                        const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                  );
                                                }

                                                setState(() {
                                                  availabledateselected =
                                                      timeselected;
                                                });
                                              }
                                            } else if (_checkboxavailabledateTime) {
                                              DateTimeAvailability
                                                  datetimeselected =
                                                  DateTimeAvailability(
                                                      selectedDate:
                                                          availabletimedate,
                                                      timeAvailableFrom:
                                                          selectedTime,
                                                      timeAvailableTo:
                                                          selectedTimeto);
                                              setState(() async {
                                                int time =
                                                    calculateTimeDifferenceInMinutes(
                                                        datetimeselected
                                                            .timeAvailableFrom,
                                                        datetimeselected
                                                            .timeAvailableTo);
                                                print(time);
                                                if (time >= 50) {
                                                  if (dateavailabledateselected.any(
                                                      (timeAvailable) =>
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
                                                      title:
                                                          'Time is already selected, check the timings.',
                                                      titleTextStyle:
                                                          const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
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
                                                    List<DateTimeAvailability>
                                                        tempdateavailabledateselected =
                                                        dateavailabledateselected;
                                                    tempdateavailabledateselected
                                                        .add(datetimeselected);
                                                    final result1 =
                                                        await addOrUpdateTimeAvailabilityWithDate(
                                                            widget.userinfo
                                                                .userId,
                                                            datetimeselected,
                                                            widget.timezone);
                                                    if (result1 == 'success') {
                                                    } else {
                                                      CoolAlert.show(
                                                        context: context,
                                                        width: 200,
                                                        type:
                                                            CoolAlertType.error,
                                                        title:
                                                            result1.toString(),
                                                        titleTextStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      );
                                                    }
                                                  } else {
                                                    List<DateTimeAvailability>
                                                        tempdateavailabledateselected =
                                                        dateavailabledateselected;
                                                    tempdateavailabledateselected
                                                        .add(datetimeselected);
                                                    final result1 =
                                                        await addOrUpdateTimeAvailabilityWithDate(
                                                            widget.userinfo
                                                                .userId,
                                                            datetimeselected,
                                                            widget.timezone);
                                                    if (result1 == 'success') {
                                                    } else {
                                                      CoolAlert.show(
                                                        context: context,
                                                        width: 200,
                                                        type:
                                                            CoolAlertType.error,
                                                        title:
                                                            result1.toString(),
                                                        titleTextStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      );
                                                    }
                                                  }
                                                } else {
                                                  CoolAlert.show(
                                                    context: context,
                                                    width: 200,
                                                    type: CoolAlertType.error,
                                                    title:
                                                        'Time Range Error, minimum of 50 minutes.',
                                                    titleTextStyle:
                                                        const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                  );
                                                }
                                              });
                                            }
                                          },
                                          child: const Text(
                                            'Add',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                // decoration:
                                                //     TextDecoration.underline,
                                                fontSize: 16,
                                                color: kColorPrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Consumer<TutorScheduleProvider>(
                                          builder: (context, scheduletime, _) {
                                        if (scheduletime
                                                .availableDateSelected !=
                                            null) {
                                          availabledateselected = scheduletime
                                              .availableDateSelected!;
                                        } else {
                                          availabledateselected =
                                              TimeAvailability(
                                                  timeAvailableFrom: '',
                                                  timeAvailableTo: '');
                                        }
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Every Available Day:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: kColorGrey,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            availabledateselected
                                                        .timeAvailableTo !=
                                                    ''
                                                ? ClipRect(
                                                    child: Container(
                                                        width: 300,
                                                        height: 60,
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15, 10, 5, 0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${updateTime(widget.userinfo.timezone, scheduletime.availableDateSelected!.timeAvailableFrom)} to ${updateTime(widget.userinfo.timezone, scheduletime.availableDateSelected!.timeAvailableTo)}',
                                                              style: const TextStyle(
                                                                  color:
                                                                      kColorGrey),
                                                            ),
                                                            IconButton(
                                                              iconSize: 15,
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                final result =
                                                                    await deleteTimeAvailability(
                                                                  widget
                                                                      .userinfo
                                                                      .userId,
                                                                  availabledateselected,
                                                                );
                                                                if (result ==
                                                                    'success') {
                                                                } else {
                                                                  CoolAlert
                                                                      .show(
                                                                    context:
                                                                        context,
                                                                    width: 200,
                                                                    type: CoolAlertType
                                                                        .error,
                                                                    title: result
                                                                        .toString(),
                                                                    titleTextStyle: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        )),
                                                  )
                                                : Container(
                                                    width: 200,
                                                    height: 55,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: const Center(
                                                      child: Text(
                                                        '"Time not set"',
                                                        style: TextStyle(
                                                            color: kColorGrey),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        );
                                      }),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Consumer<TutorScheduleProvider>(
                                          builder: (context, scheduletime, _) {
                                        if (scheduletime
                                                .dateavailabledateselected !=
                                            null) {
                                          dateavailabledateselected =
                                              scheduletime
                                                  .dateavailabledateselected!;
                                        } else {
                                          dateavailabledateselected = [];
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Specific Date:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: kColorGrey,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            dateavailabledateselected.isNotEmpty
                                                ? Container(
                                                    width: 450,
                                                    height: 150,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Scrollbar(
                                                            trackVisibility:
                                                                true,
                                                            thumbVisibility:
                                                                true,
                                                            controller:
                                                                dateavailablescroll,
                                                            child: ListView
                                                                .builder(
                                                              controller:
                                                                  dateavailablescroll,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  dateavailabledateselected
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 5.0,
                                                                      right: 5),
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15)),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          '${DateFormat('MMMM dd, yyyy').format(dateavailabledateselected[index].selectedDate)}(From: ${dateavailabledateselected[index].timeAvailableFrom} To: ${dateavailabledateselected[index].timeAvailableTo})',
                                                                          style:
                                                                              const TextStyle(color: kColorGrey),
                                                                        ),
                                                                        IconButton(
                                                                          iconSize:
                                                                              15,
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.delete_outline,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            final result = await deleteDateAvailability(
                                                                                widget.userinfo.userId,
                                                                                dateavailabledateselected[index],
                                                                                widget.timezone);
                                                                            print(result);
                                                                            if (result ==
                                                                                'success') {
                                                                            } else {
                                                                              CoolAlert.show(
                                                                                context: context,
                                                                                width: 200,
                                                                                type: CoolAlertType.error,
                                                                                title: result.toString(),
                                                                                titleTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                                                              );
                                                                            }
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                                : Container(
                                                    width: 300,
                                                    height: 55,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: const Center(
                                                      child: Text(
                                                        '"Select Specific Dates."',
                                                        style: TextStyle(
                                                            color: kColorGrey),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: 770,
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 10.0, 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: kCalendarColorB,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2, bottom: 5),
                                    child: Text(
                                      'Block Time and Date',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: kColorGrey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 200,
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 15),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: kColorGrey,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              selectedBlockDate,
                                              style: const TextStyle(
                                                  color: kColorGrey),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _selectBlockDate(context),
                                              icon: const Icon(
                                                  Icons.calendar_today),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 125,
                                        padding: const EdgeInsets.only(
                                            right: 2, left: 5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: kColorGrey,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              selectedTime,
                                              style: const TextStyle(
                                                color: kColorGrey,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _selectTime(context),
                                              icon: const Icon(
                                                  Icons.access_time_outlined),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const SizedBox(
                                        child: Text(
                                          'to',
                                          style: TextStyle(
                                            color: kColorGrey,
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
                                            right: 2, left: 5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: kColorGrey,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              selectedTimeto,
                                              style: const TextStyle(
                                                color: kColorGrey,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _selectTimeto(context),
                                              icon: const Icon(
                                                  Icons.access_time_outlined),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (blocktimedate != null) {
                                            BlockDate datetimeselected =
                                                BlockDate(
                                                    timeFrom: selectedTime,
                                                    timeTo: selectedTimeto,
                                                    blockDate: blocktimedate!);

                                            setState(() async {
                                              int time =
                                                  calculateTimeDifferenceInMinutes(
                                                      datetimeselected.timeFrom,
                                                      datetimeselected.timeTo);
                                              if (time >= 50) {
                                                if (blockdateselected.any(
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
                                                                .timeTo))) {
                                                  CoolAlert.show(
                                                    context: context,
                                                    width: 200,
                                                    type: CoolAlertType.error,
                                                    titleTextStyle:
                                                        const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                    title:
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
                                                  final result1 =
                                                      await blockTimeWithDate(
                                                          widget
                                                              .userinfo.userId,
                                                          datetimeselected,
                                                          widget.timezone);
                                                  if (result1 == 'success') {}
                                                } else if (dayoffselected
                                                        .contains(DateFormat('EEEE').format(datetimeselected.blockDate)) ||
                                                    dateselected.contains(datetimeselected.blockDate)) {
                                                  CoolAlert.show(
                                                    context: context,
                                                    width: 200,
                                                    type: CoolAlertType.error,
                                                    titleTextStyle:
                                                        const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                    title:
                                                        'Selected Date is a dayoff!',
                                                  );
                                                } else {
                                                  final result1 =
                                                      await blockTimeWithDate(
                                                          widget
                                                              .userinfo.userId,
                                                          datetimeselected,
                                                          widget.timezone);
                                                  if (result1 == 'success') {}
                                                }
                                              } else {
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.error,
                                                  titleTextStyle:
                                                      const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                  title:
                                                      'Time Range Error, minimum of 50 minutes.',
                                                );
                                              }
                                            });
                                          } else {
                                            CoolAlert.show(
                                              context: context,
                                              width: 200,
                                              type: CoolAlertType.warning,
                                              title: 'Nothing is selected!',
                                              titleTextStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          'Add',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              // decoration:
                                              //     TextDecoration.underline,
                                              fontSize: 16,
                                              color: kColorPrimary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Consumer<TutorScheduleProvider>(
                                      builder: (context, scheduletime, _) {
                                    if (scheduletime.blockdateselected !=
                                        null) {
                                      blockdateselected =
                                          scheduletime.blockdateselected!;
                                    } else {
                                      blockdateselected = [];
                                    }
                                    if (scheduletime.allblockdateselected !=
                                        null) {
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Specific Date:',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: kColorGrey,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        scheduletime.allblockdateselected !=
                                                null
                                            ? Container(
                                                width: 600,
                                                height: 120,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 5, 0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Scrollbar(
                                                        trackVisibility: true,
                                                        thumbVisibility: true,
                                                        controller:
                                                            blockdatetimescroll,
                                                        child: ListView.builder(
                                                          controller:
                                                              blockdatetimescroll,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount: scheduletime
                                                              .allblockdateselected!
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
                                                                        5,
                                                                        0,
                                                                        5,
                                                                        0),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'From: ${DateFormat('MMMM d, yyyy h:mm a').format(formatTimewDatewZone(DateFormat('MMMM d, yyyy h:mm a').format(DateTime.parse(scheduletime.allblockdateselected![index].timeFrom).toLocal()), widget.timezone))} To: ${DateFormat('MMMM d, yyyy h:mm a').format(formatTimewDatewZone(DateFormat('MMMM d, yyyy h:mm a').format(DateTime.parse(scheduletime.allblockdateselected![index].timeTo).toLocal()), widget.timezone))}',
                                                                      style:
                                                                          const TextStyle(
                                                                        color:
                                                                            kColorGrey,
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                      iconSize:
                                                                          15,
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .delete_outline,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        final result = await deleteBlockDate(
                                                                            widget.userinfo.userId,
                                                                            scheduletime.allblockdateselected![index],
                                                                            widget.timezone);
                                                                        if (result ==
                                                                            'success') {
                                                                        } else {
                                                                          CoolAlert
                                                                              .show(
                                                                            context:
                                                                                context,
                                                                            width:
                                                                                200,
                                                                            type:
                                                                                CoolAlertType.error,
                                                                            title:
                                                                                result.toString(),
                                                                            titleTextStyle:
                                                                                const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                                                          );
                                                                        }
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
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
                                                    '"Select Specific Dates."',
                                                    style: TextStyle(
                                                        color: kColorGrey),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    );
                                  }),
                                  const Spacer(),
                                  // Padding(
                                  //   padding: const EdgeInsets.fromLTRB(
                                  //       5.0, 0.0, 5.0, 0.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.start,
                                  //     children: [
                                  //       TextButton(
                                  //         onPressed: () {
                                  //           CoolAlert.show(
                                  //             context: context,
                                  //             barrierDismissible: false,
                                  //             width: 200,
                                  //             type: CoolAlertType.confirm,
                                  //             titleTextStyle: const TextStyle(
                                  //                 fontSize: 14,
                                  //                 fontWeight:
                                  //                     FontWeight.normal),
                                  //             title: 'Proceed clearing?',
                                  //             confirmBtnText: 'Proceed',
                                  //             confirmBtnColor:
                                  //                 Colors.greenAccent,
                                  //             cancelBtnText: 'Go back',
                                  //             showCancelBtn: true,
                                  //             cancelBtnTextStyle:
                                  //                 const TextStyle(
                                  //                     color: Colors.red),
                                  //             onCancelBtnTap: () {
                                  //               Navigator.of(context).pop;
                                  //             },
                                  //             onConfirmBtnTap: () async {
                                  //               final result =
                                  //                   await deleteAllBlockDates(
                                  //                 widget.userinfo.userId,
                                  //               );
                                  //               if (result == 'success') {
                                  //               } else {
                                  //                 CoolAlert.show(
                                  //                   context: context,
                                  //                   width: 200,
                                  //                   type: CoolAlertType.error,
                                  //                   titleTextStyle:
                                  //                       const TextStyle(
                                  //                           fontSize: 14,
                                  //                           fontWeight:
                                  //                               FontWeight
                                  //                                   .normal),
                                  //                   title: result.toString(),
                                  //                 );
                                  //               }
                                  //             },
                                  //           );
                                  //         },
                                  //         style: ButtonStyle(
                                  //           backgroundColor:
                                  //               MaterialStateProperty.all(
                                  //                   Colors.transparent),
                                  //           shape: MaterialStateProperty.all<
                                  //               RoundedRectangleBorder>(
                                  //             RoundedRectangleBorder(
                                  //               borderRadius:
                                  //                   BorderRadius.circular(15.0),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         child: const Text(
                                  //           'Clear',
                                  //           style: TextStyle(
                                  //               fontSize: 16,
                                  //               fontWeight: FontWeight.bold,
                                  //               color: Colors.red),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
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
          ],
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
