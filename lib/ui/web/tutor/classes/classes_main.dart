// ignore_for_file: unused_import, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/tutor_info_class.dart';
import '../../../../shared_components/responsive_builder.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/standalone.dart' as tz;
import 'dart:html' as html;

import '../../../../utils/themes.dart';
import '../subscription/subscription_type.dart';

class ClassesMain extends StatefulWidget {
  const ClassesMain({super.key});

  @override
  State<ClassesMain> createState() => _ClassesMainState();
}

class _ClassesMainState extends State<ClassesMain> {
  String status = '';
  String firstname = '';
  String middlename = '';
  String lastname = '';
  String fullName = '';
  bool tutorstatus = true;
  String currentDateTime = '';
  Timer? timer;
  String remainingTime = "";
  Timer? _timer;
  StreamController<String> timerStream = StreamController<String>.broadcast();
  final endDate =
      DateTime.now().add(const Duration(days: 5)); // the date, time u set
  final currentDate = DateTime.now();
  @override
  void initState() {
    prepareData();
    super.initState();
    updateDateTime();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateDateTime();
    });
  }

  @override
  void dispose() {
    try {
      if (_timer != null && _timer!.isActive) _timer!.cancel();
    } catch (e) {
      print(e);
    }
    timer?.cancel();
    super.dispose();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  prepareData() {
    final difference = daysBetween(currentDate, endDate);

    // get remaining time in second
    var result = const Duration(seconds: 0);
    result = endDate.difference(currentDate);
    remainingTime = result.inSeconds.toString(); // convert to second
//    remainingTime = '10'; // change this value to test for min function
  }

  void updateDateTime() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(now);
    setState(() {
      currentDateTime = formattedDate;
    });
  }

  // Future<void> printtime() async {
  //   List<String> getTimeZones() {
  //     tz.initializeTimeZones();
  //     final timeZones = tz.timeZoneDatabase.locations.keys.toList();
  //     return timeZones;
  //   }

  //   print(getTimeZones());

  //   DateTime originalDateTime = DateTime.now();
  //   tz.Location timeZone = tz.getLocation('Asia/Dubai');
  //   tz.TZDateTime convertedDateTime =
  //       tz.TZDateTime.from(originalDateTime, timeZone);
  //   print(convertedDateTime);

  //   final tz.TZDateTime dubaiDateTime =
  //       tz.TZDateTime.from(DateTime.now(), timeZone);
  //   print('Dubai Time: $dubaiDateTime');

  //   String localTimezone = await FlutterNativeTimezone.getLocalTimezone();
  //   tz.Location mylocaltimezone = tz.getLocation(localTimezone);
  //   print(mylocaltimezone);

  //   tz.TZDateTime convertedLocalDateTime =
  //       tz.TZDateTime.from(originalDateTime, mylocaltimezone);
  //   print('Local Time: $convertedLocalDateTime');
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final tutorinfodata = Provider.of<List<TutorInformation>>(context);
    if (tutorinfodata.isNotEmpty) {
      setState(() {
        final tutordata = tutorinfodata.first;
        status = tutordata.status.toString();
        firstname = tutordata.firstName;
        middlename = tutordata.middleName;
        lastname = tutordata.lastname;
        fullName = middlename == 'N/A'
            ? '$firstname $lastname'
            : '$firstname $middlename $lastname';
        tutorstatus = tutordata.status == 'unsubscribe' ? true : false;
      });
    }

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        // Visibility(
        //   visible: tutorstatus,
        //   child: Card(
        //     margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
        //     elevation: 4,
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(5),
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        //         child: Column(
        //           children: [
        //             Row(children: [
        //               Text(
        //                 'Hello $firstname, welcome to Work4uTutor!',
        //                 style: const TextStyle(
        //                   fontSize: 18,
        //                 ),
        //               ),
        //             ]),
        //             Row(children: [
        //               Container(
        //                 width: 200,
        //                 height: 10,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(10),
        //                   color: kColorPrimary,
        //                 ),
        //               ),
        //               const SizedBox(
        //                 width: 10,
        //               ),
        //               Container(
        //                 width: 200,
        //                 height: 10,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(10),
        //                   color: kColorPrimary,
        //                 ),
        //               ),
        //               const SizedBox(
        //                 width: 10,
        //               ),
        //               Container(
        //                 width: 200,
        //                 height: 10,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(10),
        //                   border: Border.all(
        //                     color: Colors.black,
        //                     width: .2,
        //                   ),
        //                   color: Colors.white,
        //                 ),
        //               ),
        //               const Spacer(),
        //               Container(
        //                 width: 70,
        //                 height: 70,
        //                 decoration: const BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   color: kColorLight,
        //                 ),
        //                 child: const Icon(
        //                   FontAwesomeIcons.trophy,
        //                   color: kColorPrimary,
        //                   size: 35,
        //                 ),
        //               ),
        //               const SizedBox(
        //                 width: 10,
        //               ),
        //               InkWell(
        //                 onTap: () {
        //                   showDialog(
        //                     context: context,
        //                     builder: (BuildContext context) {
        //                       return const SubscriptionType();
        //                     },
        //                   );
        //                 },
        //                 child: Container(
        //                     width: 180,
        //                     height: 50,
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(10),
        //                       color: kColorYellow,
        //                       boxShadow: [
        //                         BoxShadow(
        //                             color: kColorYellow.withOpacity(0.5),
        //                             offset: const Offset(5, 7),
        //                             blurRadius: 1.5,
        //                             spreadRadius: -2)
        //                       ],
        //                     ),
        //                     child: const Center(
        //                       child: Text(
        //                         'PAY NOW',
        //                         style: TextStyle(
        //                             color: kColorBlue,
        //                             fontSize: 22,
        //                             fontWeight: FontWeight.bold),
        //                       ),
        //                     )),
        //               ),
        //             ]),
        //             Row(children: const [
        //               Text(
        //                 'Account not subscribe, please subscribe to complete your profile.',
        //                 style: TextStyle(color: kColorDarkRed, fontSize: 13),
        //               ),
        //             ]),
        //             const SizedBox(
        //               height: 10,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Card(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
          elevation: 4,
          child: Container(
            height: 50,
            width: ResponsiveBuilder.isDesktop(context)
                ? size.width - 300
                : size.width - 30,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment(-0.1, 0), // 0% from the top center
                end: Alignment.centerRight, // 86% to the bottom center
                // transform: GradientRotation(1.57), // 90 degrees rotation
                colors: secondaryHeadercolors, // Add your desired colors here
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                // Text(
                //   'Local Date and Time: $currentDateTime',
                //   style: const TextStyle(
                //     color: Colors.white,
                //     fontSize: 18,
                //     fontWeight: FontWeight.normal,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ResponsiveBuilder.isMobile(context)
            ? SingleChildScrollView(
                child: SizedBox(
                  width: ResponsiveBuilder.isDesktop(context)
                      ? size.width - 300
                      : size.width - 30,
                  height: 1300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(          color: Colors.white,

                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width - 60,
                          height: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF8EF291),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.bookOpen,
                                    color: kColorPrimary,
                                    size: 35,
                                  ),
                                ),
                                const Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimary,
                                  ),
                                ),
                                const Text(
                                  "Enrolled Classes",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: kColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Card(          color: Colors.white,

                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width - 60,
                          height: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(255, 217, 111, 1),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.graduationCap,
                                    color: kColorPrimary,
                                    size: 35,
                                  ),
                                ),
                                const Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimary,
                                  ),
                                ),
                                const Text(
                                  "Active Classes",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: kColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Card(          color: Colors.white,

                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width - 60,
                          height: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kColorLight,
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.trophy,
                                    color: kColorPrimary,
                                    size: 35,
                                  ),
                                ),
                                const Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimary,
                                  ),
                                ),
                                const Text(
                                  "Completed Classes",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: kColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Card(          color: Colors.white,

                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width - 60,
                          height: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF8EF291),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.person,
                                    color: kColorPrimary,
                                    size: 35,
                                  ),
                                ),
                                const Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimary,
                                  ),
                                ),
                                const Text(
                                  "Total Students",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: kColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Card(          color: Colors.white,

                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width - 60,
                          height: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(255, 217, 111, 1),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.boxOpen,
                                    color: kColorPrimary,
                                    size: 35,
                                  ),
                                ),
                                const Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimary,
                                  ),
                                ),
                                const Text(
                                  "Total Classes",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: kColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Card(          color: Colors.white,

                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width - 60,
                          height: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kColorLight,
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.coins,
                                    color: kColorPrimary,
                                    size: 35,
                                  ),
                                ),
                                const Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimary,
                                  ),
                                ),
                                const Text(
                                  "Total Earnings",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: kColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    width: ResponsiveBuilder.isDesktop(context)
                        ? size.width - 300
                        : size.width - 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(          color: Colors.white,

                          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                          elevation: 4,
                          child: Container(
                            alignment: Alignment.center,
                            width: (ResponsiveBuilder.isDesktop(context)
                                    ? size.width - 350
                                    : size.width - 60) /
                                3,
                            height: ResponsiveBuilder.isDesktop(context)
                                ? 300
                                : ResponsiveBuilder.isTablet(context)
                                    ? (size.height - 140) / 2
                                    : (size.height - 140) / 2,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF8EF291),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.bookOpen,
                                      color: kColorPrimary,
                                      size: 35,
                                    ),
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                  const Text(
                                    "Enrolled Classes",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Card(          color: Colors.white,

                          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                          elevation: 4,
                          child: Container(
                            alignment: Alignment.center,
                            width: (ResponsiveBuilder.isDesktop(context)
                                    ? size.width - 350
                                    : size.width - 60) /
                                3,
                            height: ResponsiveBuilder.isDesktop(context)
                                ? 300
                                : ResponsiveBuilder.isTablet(context)
                                    ? (size.height - 140) / 2
                                    : (size.height - 140) / 2,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(255, 217, 111, 1),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.graduationCap,
                                      color: kColorPrimary,
                                      size: 35,
                                    ),
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                  const Text(
                                    "Active Classes",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Card(          color: Colors.white,

                          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                          elevation: 4,
                          child: Container(
                            alignment: Alignment.center,
                            width: (ResponsiveBuilder.isDesktop(context)
                                    ? size.width - 350
                                    : size.width - 60) /
                                3,
                            height: ResponsiveBuilder.isDesktop(context)
                                ? 300
                                : ResponsiveBuilder.isTablet(context)
                                    ? (size.height - 140) / 2
                                    : (size.height - 140) / 2,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kColorLight,
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.trophy,
                                      color: kColorPrimary,
                                      size: 35,
                                    ),
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                  const Text(
                                    "Completed Classes",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: ResponsiveBuilder.isDesktop(context)
                        ? size.width - 300
                        : size.width - 30,
                    child: Row(
                      children: [
                        Card(          color: Colors.white,

                          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                          elevation: 4,
                          child: Container(
                            alignment: Alignment.center,
                            width: (ResponsiveBuilder.isDesktop(context)
                                    ? size.width - 350
                                    : size.width - 60) /
                                3,
                            height: ResponsiveBuilder.isDesktop(context)
                                ? 300
                                : ResponsiveBuilder.isTablet(context)
                                    ? (size.height - 140) / 2
                                    : (size.height - 140) / 2,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF8EF291),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.person,
                                      color: kColorPrimary,
                                      size: 35,
                                    ),
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                  const Text(
                                    "Total Students",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Card(          color: Colors.white,

                          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                          elevation: 4,
                          child: Container(
                            alignment: Alignment.center,
                            width: (ResponsiveBuilder.isDesktop(context)
                                    ? size.width - 350
                                    : size.width - 60) /
                                3,
                            height: ResponsiveBuilder.isDesktop(context)
                                ? 300
                                : ResponsiveBuilder.isTablet(context)
                                    ? (size.height - 140) / 2
                                    : (size.height - 140) / 2,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(255, 217, 111, 1),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.boxOpen,
                                      color: kColorPrimary,
                                      size: 35,
                                    ),
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                  const Text(
                                    "Total Classes",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Card(          color: Colors.white,

                          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                          elevation: 4,
                          child: Container(
                            alignment: Alignment.center,
                            width: (ResponsiveBuilder.isDesktop(context)
                                    ? size.width - 350
                                    : size.width - 60) /
                                3,
                            height: ResponsiveBuilder.isDesktop(context)
                                ? 300
                                : ResponsiveBuilder.isTablet(context)
                                    ? (size.height - 140) / 2
                                    : (size.height - 140) / 2,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kColorLight,
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.coins,
                                      color: kColorPrimary,
                                      size: 35,
                                    ),
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                  const Text(
                                    "Total Earnings",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: kColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ]),
    );
  }
}
