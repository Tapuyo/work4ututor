import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../../../../provider/init_provider.dart';

class TableBasicsExample1 extends StatefulWidget {
  const TableBasicsExample1({super.key});

  @override
  State<TableBasicsExample1> createState() => _TableBasicsExample1State();
}

class _TableBasicsExample1State extends State<TableBasicsExample1> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final int listIndex = context.select((InitProvider s) => s.listIndex);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Card(
            elevation: 5,
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
                      const Text(
                        "SCHEDULE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                            foregroundColor:
                                const Color.fromRGBO(1, 118, 132, 1),
                            disabledBackgroundColor: Colors.white,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: kColorPrimary, // your color here
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 12,
                      child: Container(
                        width: size.width - 320,
                        height: 500,
                        child: Card(
                          elevation: 0.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            side: BorderSide(color: kColorPrimary, width: 4),
                          ),
                          child: MouseRegion(
                            onHover: (event) {},
                            cursor: SystemMouseCursors.click,
                            child: TableCalendar(
                              shouldFillViewport: true,
                              firstDay: DateTime(1950, 8),
                              lastDay: DateTime(5000),
                              focusedDay: _focusedDay,
                              calendarFormat: _calendarFormat,
                              daysOfWeekHeight: 30,
                              rowHeight: 30,
                              headerStyle: const HeaderStyle(
                                titleTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                                decoration: BoxDecoration(
                                  color: kColorPrimary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                formatButtonVisible: false,
                                leftChevronIcon: Icon(
                                  Icons.arrow_left_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                rightChevronIcon: Icon(
                                  Icons.arrow_right_outlined,
                                  color: Colors.white,
                                  size: 25,
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
                              ),
                              calendarStyle: CalendarStyle(
                                // Weekend dates color (Sat & Sun Column)
                                weekendTextStyle: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                outsideDaysVisible: true,
                                cellMargin: const EdgeInsets.all(5),
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
                      ),
                    ),
                    const SizedBox(
                      // height: MediaQuery.of(context).size.height,
                      // child: const VerticalDivider(),
                      width: 5,
                    ),
                    Flexible(
                        flex: size.width > 1350 ? 2 : 3,
                        child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: tableLedger(context))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: size.width - 310,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 6,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        //todos Update the date strings here
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              "March, 28",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "(6 Classes today)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 600,
                          height: 500,
                          child: ListView.builder(
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0.0,
                                      left: 10,
                                      right: 10,
                                      bottom: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "08:45",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Card(
                                          color: index % 2 == 0
                                              ? kCalendarColorFB
                                              : kCalendarColorAB,
                                          margin: const EdgeInsets.fromLTRB(
                                              20.0, 6.0, 20.0, 0.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 25.0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Image.asset(
                                                    'assets/images/login.png',
                                                    width: 300.0,
                                                    height: 100.0,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      "Melvin Jhon Selma",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text('Chemistry'),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 12.0),
                                                  child: Text('First Class'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ]),
                    ),
                  ),
                ),
                Flexible(
                    flex: 6,
                    child: Column(
                      children: [
                        // if (listIndex == 0) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 1) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 2) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 3) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 4) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 5) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 6) ...[
                        //   classClick(context)
                        // ] else if (listIndex == 7) ...[
                        //   classClick(context)
                        // ] else ...[
                        //   classClick(context)
                        // ],
                      ],
                    ))
              ],
            ),
          ),
        ],
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
    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
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
    duration: const Duration(milliseconds: 300),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: backColor,
    ),
    width: 52,
    height: 13,
    child: Center(
      child: Text(
        text,
        style: const TextStyle().copyWith(
          color: Colors.white,
          fontSize: 10.0,
        ),
      ),
    ),
  );
}

Widget tableLedger(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              Text(
                "Legend",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacer(),
              Icon(
                Icons.list_alt_outlined,
                size: 20,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: kCalendarColorAB,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "Available",
                style: TextStyle(
                  color: ksecondarytextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: kCalendarColorFB,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "Fully Booked",
                style: TextStyle(
                  color: ksecondarytextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: kCalendarColorB,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "Blocked",
                style: TextStyle(
                  color: ksecondarytextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              Text(
                "Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacer(),
              Icon(
                Icons.summarize,
                size: 20,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(.1),
                ),
                child: const Icon(
                  Icons.event_available,
                  color: Colors.green,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Available Dates",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "3",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(.1),
                ),
                child: const Icon(
                  Icons.book,
                  color: Colors.blue,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Booked Dates",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "2",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(.1),
                ),
                child: const Icon(
                  Icons.block,
                  color: Colors.red,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Blocked Dates",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "4",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget listClasses(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width - 310,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                //todos Update the date strings here
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "March, 27",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "(3 Classes today)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 600,
                  height: 500,
                  child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: null,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "08:45",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Card(
                                  color: index % 2 == 0
                                      ? Colors.blue
                                      : Colors.green,
                                  margin: const EdgeInsets.fromLTRB(
                                      20.0, 6.0, 20.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25.0,
                                          backgroundColor: index % 2 == 0
                                              ? Colors.blue
                                              : Colors.green,
                                          child: Image.asset(
                                            'assets/images/login.png',
                                            width: 300.0,
                                            height: 100.0,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Melvin Jhon Selma",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text('Chemistry'),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.0),
                                          child: Text('First Class'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ]),
            ),
          ),
        ),
        const Flexible(flex: 6, child: Placeholder())
      ],
    ),
  );
}

Widget classClick(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Material(
    child: SizedBox(
      width: 600,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "08:45",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Card(
                      color: Colors.green,
                      margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.green,
                              child: Image.asset(
                                'assets/images/login.png',
                                width: 300.0,
                                height: 100.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  "Melvin Jhon Selma",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text('Chemistry'),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: Text('First Class'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    ),
  );
}
