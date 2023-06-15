import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatefulWidget {
  const CalendarDialog({super.key});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  DateTime _selectedDate = DateTime.now();
  final int startHour = 0;
  final int endHour = 24;
  String dateselected = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text('Select a date'),
      content:  Container(
        height: 400,
        width: 650,
        child: Row(
          children: [
            SizedBox(
              height: 400,
              width: 450,
              child: TableCalendar(
                focusedDay: _selectedDate,
                firstDay: DateTime.utc(2021, 01, 01),
                lastDay: DateTime.utc(2030, 12, 31),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    dateselected =
                        DateFormat('MMMM dd,').format(_selectedDate).toString();
                  });
                },
              ),
            ),
            const SizedBox(
              child: VerticalDivider(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    dateselected.isEmpty
                        ? DateFormat('MMMM dd,')
                            .format(DateTime.now())
                            .toString()
                        : dateselected,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 375,
                  width: 180,
                  child: ListView.builder(
                      itemCount: endHour - startHour + 1,
                      itemBuilder: (context, index) {
                        final hour = startHour + index;
                        final timeString =
                            '${hour.toString().padLeft(2, '0')}:00';
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.9),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black45,
                                width: .5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      timeString,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      'Available',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedDate);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
