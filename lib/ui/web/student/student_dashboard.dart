
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardMenu extends StatelessWidget {
   DashboardMenu({Key? key}) : super(key: key);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height - 75,
      width: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black45,
          width: .5,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(5.0),
          topLeft: Radius.circular(5.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(
            width: 300,
          ),
          Container(
            height: 50,
            width: size.width - 315,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              "SCHEDULE",
              style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: size.width - 315,
            height: 500,
            child: Card(
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 12,
              ),
              elevation: 5.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                side:
                    BorderSide(color: Color.fromRGBO(1, 118, 132, 1), width: 3),
              ),
              child: TableCalendar(
                shouldFillViewport: true,
                firstDay: DateTime(1950, 8),
                lastDay: DateTime(5000),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                daysOfWeekHeight: 40,
                rowHeight: 80,
                headerStyle: const HeaderStyle(
                  titleTextStyle:
                      TextStyle(color: Colors.white, fontSize: 30.0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(1, 118, 132, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  formatButtonVisible: false,
                  // formatButtonDecoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.all(
                  //     Radius.circular(5.0),
                  //   ),
                  // ),
                  leftChevronIcon: Icon(
                    Icons.arrow_left_outlined,
                    color: Colors.white,
                    size: 50,
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.white,
                    size: 50,
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
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  // decoration:  BoxDecoration(
                  //   color: Colors.transparent,
                  //   shape: BoxShape.rectangle,
                  //   borderRadius: BorderRadius.circular(5),
                  //   border: Border.all(
                  //     color: const Color(0xFF616161),
                  //   ),
                  // ),
                ),
                calendarStyle: CalendarStyle(
                  // Weekend dates color (Sat & Sun Column)
                  weekendTextStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  outsideDaysVisible: true,
                  cellMargin: const EdgeInsets.all(8),
                  rowDecoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  defaultDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF616161),
                    ),
                  ),
                  weekendDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF616161),
                    ),
                  ),
                  defaultTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  // highlighted color for today
                  // todayDecoration: BoxDecoration(
                  //   color: AppColors.eggPlant,
                  //   shape: BoxShape.circle,
                  // ),
                  // highlighted color for selected day
                  // selectedDecoration: BoxDecoration(
                  //   color: AppColors.blackCoffee,
                  //   shape: BoxShape.circle,
                  // ),
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
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                  }
                },
                // calendarBuilders: calendarBuilder(),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                      _calendarFormat = format;
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ),
          const SizedBox(
            width: 200,
          )
        ],
      ),
    );
  }
}