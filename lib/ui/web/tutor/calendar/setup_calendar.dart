// ignore_for_file: prefer_final_fields, unused_field, unrelated_type_equality_checks, sized_box_for_whitespace, avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../utils/themes.dart';
import '../../../auth/database.dart';
import '../../admin/admin_sharedcomponents/header_text.dart';

class CalendarSetup extends StatefulWidget {
  const CalendarSetup({super.key});

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
  List<DateTime> dateselected = [];
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  @override
  Widget build(BuildContext context) {
    List<TutorInformation> tutorinfodata =
        Provider.of<List<TutorInformation>>(context);

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
                                        print(tutorinfodata.first.userId);
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
                                                tutorinfodata.first.userId,
                                                dayoffselected);
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
                                          Text(selectedDate),
                                          IconButton(
                                            onPressed:
                                                canbeuseTimeavailable == 2
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
                                      //add formula
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
                              Row(
                                children: [
                                  const Text(
                                    'Every Available Day:',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  dayoffselected.isNotEmpty
                                      ? Container(
                                          width: 200,
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
                                          width: 200,
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: const Center(
                                            child: Text('"Time not set"'),
                                          ),
                                        ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    'Specific Date:',
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
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop;
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
                                          onPressed: () => _selectDate(context),
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
                                        cancelBtnTextStyle:
                                            const TextStyle(color: Colors.red),
                                        onCancelBtnTap: () {
                                          Navigator.of(context).pop;
                                        },
                                        onConfirmBtnTap: () async {
                                          final result = await addBlockDates(
                                              tutorinfodata.first.userId,
                                              dayoffselected);
                                          if (result == 'success') {
                                            setState(() {
                                              CoolAlert.show(
                                                context: context,
                                                width: 200,
                                                type: CoolAlertType.success,
                                                text: 'Day Off/s Added!',
                                                autoCloseDuration:
                                                    const Duration(seconds: 1),
                                              ).then(
                                                (value) {
                                                  Navigator.of(context).pop();
                                                },
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
                              Row(
                                children: [
                                  const Text(
                                    'Specific Date:',
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
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop;
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
