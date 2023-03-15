import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wokr4ututor/utils/themes.dart';

class TableBasicsExample1 extends StatefulWidget {
  @override
  _TableBasicsExample1State createState() => _TableBasicsExample1State();
}

class _TableBasicsExample1State extends State<TableBasicsExample1> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black45,
            width: .1,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(5.0),
            topLeft: Radius.circular(5.0),
          ),
        ),
        width: size.width - 310,
        height: size.height - 75,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: size.width - 310,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorPrimary,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "SCHEDULE",
                    style: GoogleFonts.arimo(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 35,
                    width: 150,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color.fromRGBO(1, 118, 132, 1),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        foregroundColor: const Color.fromRGBO(
                                1, 118, 132, 1), 
                        disabledBackgroundColor: Colors.white,
                        backgroundColor:  Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color:kColorPrimary, // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        // ignore: prefer_const_constructors
                        textStyle: TextStyle(
                          color: kColorPrimary,
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.calendar_month,
                        size: 15,
                        color: kColorPrimary, 
                      ),
                      label: const Text(
                        'Set Up Calendar',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
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
                  side: BorderSide(
                      color: kColorPrimary, width: 3),
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
                        TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                        color:kColorPrimary,
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
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  // calendarBuilders: calendarBuilder(),
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
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.black45,
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Text(
                  "AVAILABLE",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(
                      color: Colors.black45,
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Text(
                  "FULLY BOOKED",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(
                      color: Colors.black45,
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Text(
                  "BLOCKED",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

CalendarBuilders calendarBuilder() {
  return CalendarBuilders(
      // selectedDayBuilder: (context, date, _) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.day.toString(), backColor: DaisyColors.main4Color);
      // },
      todayBuilder: (
    context,
    day,
    focusedDay,
  ) {
    return buildCalendarDay(
        day: DateTime.now().day.toString(), text: '3', backColor: Colors.green);
  }
      // final children = <Widget>[];
      // children.add(
      //   Positioned(
      //     bottom: 1,
      //     child: Text("3 Classes"),
      //   ),
      // );

      // dayBuilder: (context, date, _) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.day.toString(), backColor: Colors.white);
      // },
      // weekendDayBuilder: (context, date, _) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.day.toString(),
      //       backColor: Colors.white,
      //       color: Colors.red);
      // },
      // outsideDayBuilder: (context, date, _) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.day.toString(),
      //       backColor: Colors.blue,
      //       color: Colors.red);
      // },
      // outsideHolidayDayBuilder: (context, date, _) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.day.toString(),
      //       backColor: Colors.deepOrange,
      //       color: Colors.red);
      // },
      // holidayDayBuilder: (context, date, _) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.day.toString(),
      //       backColor: Colors.purple,
      //       color: Colors.red);
      // },
      // outsideWeekendDayBuilder: (context, date, _) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.day.toString(),
      //       backColor: Colors.pinkAccent,
      //       color: Colors.black);
      // },
      // dowWeekdayBuilder: (context, date) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.toString(), backColor: Colors.yellow, color: Colors.red);
      // },
      // dowWeekendBuilder: (context, date) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.toString(), backColor: Colors.green, color: Colors.red);
      // },
      // unavailableDayBuilder: (context, date, _) {
      //   return DaisyWidget().buildCalendarDay(
      //       day: date.day.toString(),
      //       backColor: Colors.red,
      //       color: DaisyColors.serveColor);
      // },
      // markerBuilder: (context, date, events, holidays) {
      //   final children = <Widget>[];
      //   if (events.isNotEmpty) {
      //     children.add(
      //       Positioned(
      //         bottom: 1,
      //         child: _buildEventsMarkerNum(date),
      //       ),
      //     );
      //   }
      //   return children;
      // },
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
    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
    duration: Duration(milliseconds: 300),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: backColor,
    ),
    width: 52,
    height: 13,
    child: Center(
      child: Text(
        text,
        style: TextStyle().copyWith(
          color: Colors.white,
          fontSize: 10.0,
        ),
      ),
    ),
  );
}
