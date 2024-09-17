// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../services/bookingfunctions/setscheduletime.dart';
import '../../../../services/notificationfunctions/sendnotifications.dart';
import '../../../../services/timestampconverter.dart';
import '../../../../shared_components/header_text.dart';
import '../../../../utils/themes.dart';

import 'package:timezone/browser.dart' as tz;

import 'package:http/http.dart' as http;

class ReSchedNow extends StatefulWidget {
  final Schedule currentschedule;
  final String timezone;

  const ReSchedNow(
      {super.key, required this.currentschedule, required this.timezone});

  @override
  State<ReSchedNow> createState() => _ReSchedNowState();
}

class _ReSchedNowState extends State<ReSchedNow> {
  Schedule? selectedschedule;
  DateTime? selectedDatesched;
  TimeOfDay? selectedTimesched;
  TimeOfDay? selectedTimeschedto;
  TimeOfDay convertTimeStringToTimeOfDay(String timeString) {
    DateFormat dateFormat = DateFormat('h:mm a');
    DateTime dateTime = dateFormat.parse(timeString);

    // Extract hours and minutes from the DateTime object
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    // Create a TimeOfDay object
    return TimeOfDay(hour: hour, minute: minute);
  }

  TextEditingController _selectedTimeZone = TextEditingController();
  FocusNode _selectedTimeZonefocusNode = FocusNode();

  bool showselectedTimeZoneSuggestions = false;
  List<String> timezonesList = [];

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

  @override
  void initState() {
    super.initState();
    selectedschedule = widget.currentschedule;
    selectedDatesched = widget.currentschedule.schedule;
    selectedTimesched =
        convertTimeStringToTimeOfDay(widget.currentschedule.timefrom);
    selectedTimeschedto =
        convertTimeStringToTimeOfDay(widget.currentschedule.timeto);
    _selectedTimeZone.text = widget.timezone;
    getTimezones();
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDatesched!,
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
      initialTime: selectedTimesched!,
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

  @override
  Widget build(BuildContext context) {
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
                  const HeaderText('Update Date and Time'),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectDate();
                      });
                    },
                    child: Text(
                      DateFormat('MMM dd yyyy').format(selectedDatesched!),
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
                            DateTime(2022, 1, 1, selectedTimesched!.hour,
                                selectedTimesched!.minute),
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
                              selectedTimeschedto!.hour,
                              selectedTimeschedto!.minute)),
                          style: const TextStyle(color: Colors.black87),
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
                              title: Text(suggestion),
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
                              String convertedtimefrom =
                                  createTimeWithDateAndZone(
                                DateFormat('MMMM d, yyyy')
                                    .format(selectedDatesched!),
                                _selectedTimeZone.text,
                                DateFormat('h:mm a').format(DateTime(
                                    2022,
                                    1,
                                    1,
                                    selectedTimesched!.hour,
                                    selectedTimesched!.minute)),
                              ).toString();
                              String convertedtimeto =
                                  createTimeWithDateAndZone(
                                DateFormat('MMMM d, yyyy')
                                    .format(selectedDatesched!),
                                _selectedTimeZone.text,
                                DateFormat('h:mm a').format(DateTime(
                                    2022,
                                    1,
                                    1,
                                    selectedTimeschedto!.hour,
                                    selectedTimeschedto!.minute)),
                              ).toString();

                              String oldconvertedtimefrom =
                                  createTimeWithDateAndZone(
                                DateFormat('MMMM d, yyyy')
                                    .format(widget.currentschedule.schedule),
                                _selectedTimeZone.text,
                                widget.currentschedule.timefrom,
                              ).toString();
                              String oldconvertedtimeto =
                                  createTimeWithDateAndZone(
                                DateFormat('MMMM d, yyyy')
                                    .format(widget.currentschedule.schedule),
                                _selectedTimeZone.text,
                                widget.currentschedule.timeto,
                              ).toString();
                              String datefrom = formatTimewDatewZone(
                                      DateFormat('MMMM d, yyyy h:mm a').format(
                                          DateTime.parse(convertedtimefrom)
                                              .toLocal()),
                                      'Asia/Manila')
                                  .toString();
                              String dateto = formatTimewDatewZone(
                                      DateFormat('MMMM d, yyyy h:mm a').format(
                                          DateTime.parse(convertedtimeto)
                                              .toLocal()),
                                      'Asia/Manila')
                                  .toString();
                              String olddatefrom = formatTimewDatewZone(
                                      DateFormat('MMMM d, yyyy h:mm a').format(
                                          DateTime.parse(oldconvertedtimefrom)
                                              .toLocal()),
                                      'Asia/Manila')
                                  .toString();
                              String olddateto = formatTimewDatewZone(
                                      DateFormat('MMMM d, yyyy h:mm a').format(
                                          DateTime.parse(oldconvertedtimeto)
                                              .toLocal()),
                                      'Asia/Manila')
                                  .toString();
                              print('$olddatefrom $olddateto');
                              String? result = await updateSchedule(
                                  widget.currentschedule.scheduleID,
                                  olddatefrom,
                                  olddateto,
                                  datefrom,
                                  dateto,
                                  widget.currentschedule.schedule,
                                  selectedDatesched!);

                              if (result.toString() == "Success") {
                                List<String> idList = [
                                  widget.currentschedule.scheduleID,
                                ];
                                addNewNotification('ReSchedule', '', idList);
                                result = "Schedule succesfully updated!";
                                // CoolAlert.show(
                                //         context: context,
                                //         width: 200,
                                //         type: CoolAlertType.success,
                                //         title: 'Success...',
                                //         text: result,
                                //         autoCloseDuration:
                                //             const Duration(seconds: 3))
                                //     .then(
                                //   (value) {
                                    Navigator.of(context).pop(true);
                                //   },
                                // );
                              } else {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  width: 200,
                                  title: 'Oops...',
                                  text: result,
                                  backgroundColor: Colors.black,
                                );
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
