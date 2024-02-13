// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../services/bookingfunctions/setscheduletime.dart';
import '../../../../services/notificationfunctions/sendnotifications.dart';
import '../../../../utils/themes.dart';
import '../../admin/admin_sharedcomponents/header_text.dart';

class ReSchedNow extends StatefulWidget {
  final Schedule currentschedule;
  const ReSchedNow({super.key, required this.currentschedule});

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

  @override
  void initState() {
    super.initState();
    selectedschedule = widget.currentschedule;
    selectedDatesched = widget.currentschedule.schedule;
    selectedTimesched =
        convertTimeStringToTimeOfDay(widget.currentschedule.timefrom);
    selectedTimeschedto =
        convertTimeStringToTimeOfDay(widget.currentschedule.timeto);
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
                              String? result = await updateSchedule(
                                  widget.currentschedule.scheduleID,
                                  widget.currentschedule.timefrom,
                                  widget.currentschedule.timeto,
                                  DateFormat('h:mm a').format(DateTime(
                                      2022,
                                      1,
                                      1,
                                      selectedTimesched!.hour,
                                      selectedTimesched!.minute)),
                                  DateFormat('h:mm a').format(DateTime(
                                      2022,
                                      1,
                                      1,
                                      selectedTimeschedto!.hour,
                                      selectedTimeschedto!.minute)),
                                  widget.currentschedule.schedule,
                                  selectedDatesched!);

                              if (result.toString() == "Success") {
                                List<String> idList = [
                                  widget.currentschedule.scheduleID,
                                ];
                                addNewNotification('ReSchedule', '', idList);
                                result = "Schedule succesfully updated!";
                                CoolAlert.show(
                                        context: context,
                                        width: 200,
                                        type: CoolAlertType.success,
                                        title: 'Success...',
                                        text: result,
                                        autoCloseDuration:
                                            const Duration(seconds: 3))
                                    .then(
                                  (value) {
                                    Navigator.of(context).pop(true);
                                  },
                                );
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
