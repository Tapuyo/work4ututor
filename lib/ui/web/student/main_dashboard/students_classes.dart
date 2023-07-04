// ignore_for_file: unused_import, sized_box_for_whitespace

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/data_class/studentanalyticsclass.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/ui/web/student/main_dashboard/app_helpers.dart';
import 'package:wokr4ututor/ui/web/student/main_dashboard/task_progress.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/voucherclass.dart';
import '../../../../services/getvouchers.dart';
import 'coupon.dart';
import 'task_in_progress.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;
import 'dart:html' as html;

class StudentMainDashboard extends StatefulWidget {
  const StudentMainDashboard({super.key});

  @override
  State<StudentMainDashboard> createState() => _StudentMainDashboardState();
}

class _StudentMainDashboardState extends State<StudentMainDashboard> {
  final taskInProgress = [
    Voucherclass(
      voucherName: "Introductory Voucher",
      amount: '50.00',
      startDate: DateTime.now().add(const Duration(minutes: 50)),
      expiryDate: DateTime.now().add(const Duration(minutes: 50)),
      vstatus: 'Available',
    ),
    // CardTaskData(
    //   label: "Refund Voucher",
    //   jobDesk: "\$100.00",
    //   dueDate: DateTime.now().add(const Duration(hours: 4)),
    // ),
    // CardTaskData(
    //   label: "Introductory Voucher",
    //   jobDesk: "\$50.00",
    //   dueDate: DateTime.now().add(const Duration(days: 2)),
    // ),
    // CardTaskData(
    //   label: "Introductory Voucher",
    //   jobDesk: "\$50.00",
    //   dueDate: DateTime.now().add(const Duration(minutes: 50)),
    // ),
    // CardTaskData(
    //   label: "Introductory Voucher",
    //   jobDesk: "\$50.00",
    //   dueDate: DateTime.now().add(const Duration(minutes: 50)),
    // ),
  ];

  getUserBooks() {
    print('im here');
    FirebaseFirestore.instance.collection('vouchers').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('vouchers')
            .doc('XuQyf7S8gCOJBu6gTIb0')
            .collection("myvouchers")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            print(element.data());
          });
        });
      });
    });
  }

  final dataTask = const TaskProgressData(totalTask: 5, totalCompleted: 1);

  String remainingTime = "";
  Timer? _timer;
  StreamController<String> timerStream = StreamController<String>.broadcast();
  final endDate = DateTime.now().add(Duration(days: 5)); // the date, time u set
  final currentDate = DateTime.now();
  String currentDateTime = '';
  Timer? timer;
  @override
  void initState() {
    prepareData();
    super.initState();
    updateDateTime();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      updateDateTime();
    });
    printtime();
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

  prepareData() {
    final difference = daysBetween(currentDate, endDate);
    print(difference);
    print('difference in days');
    // get remaining time in second
    var result = Duration(seconds: 0);
    result = endDate.difference(currentDate);
    remainingTime = result.inSeconds.toString(); // convert to second
//    remainingTime = '10'; // change this value to test for min function
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  String dayHourMinuteSecondFunction(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String days = twoDigits(duration.inDays);
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return days +
        ' ' +
        ":" +
        ' ' +
        twoDigitHours +
        ' ' +
        ":" +
        ' ' +
        twoDigitMinutes +
        ' ' +
        ":" +
        ' ' +
        twoDigitSeconds;
  }

  Widget dateWidget() {
    return StreamBuilder<String>(
        stream: timerStream.stream,
        initialData: "0",
        builder: (cxt, snapshot) {
          const oneSec = Duration(seconds: 1);
          if (_timer != null && _timer!.isActive) _timer!.cancel();
          _timer = Timer.periodic(oneSec, (Timer timer) {
            try {
              int second = int.tryParse(remainingTime) ?? 0;
              second = second - 1;
              if (second < -1) return;
              remainingTime = second.toString();
              if (second == -1) {
                timer.cancel();
                print('timer cancelled');
              }
              if (second >= 0) {
                timerStream.add(remainingTime);
              }
            } catch (e) {
              print(e);
            }
          });
          String remainTimeDisplay = "-";
          try {
            int seconds = int.parse(remainingTime);
            var now = Duration(seconds: seconds);
            remainTimeDisplay = dayHourMinuteSecondFunction(now);
          } catch (e) {
            print(e);
          }
          print(remainTimeDisplay);
          return Text(
            remainTimeDisplay,
            textAlign: TextAlign.center,
          );
        });
  }

  void updateDateTime() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(now);
    setState(() {
      currentDateTime = formattedDate;
    });
  }

  String convertToLocalTime(DateTime dateTime) {
    try {
      // Get the user's current time zone
      final String currentTimeZone = DateTime.now().timeZoneOffset.toString();

      // Create a new DateTime object with the provided DateTime and the user's time zone offset
      final convertedDateTime =
          dateTime.add(Duration(hours: int.parse(currentTimeZone)));

      // Format the converted DateTime object to the desired format
      final formatter = DateFormat.yMMMMd('en_US').add_jm();
      return formatter.format(convertedDateTime);
    } catch (e) {
      print('Error converting to local time: $e');
      return ''; // Return an empty string or handle the error in a different way
    }
  }

//converting timezone
  Future<void> printtime() async {
    List<String> getTimeZones() {
      tz.initializeTimeZones();
      final timeZones = tz.timeZoneDatabase.locations.keys.toList();
      return timeZones;
    }

    print(getTimeZones());

    DateTime originalDateTime = DateTime.now();
    tz.Location timeZone = tz.getLocation('Asia/Dubai');
    tz.TZDateTime convertedDateTime =
        tz.TZDateTime.from(originalDateTime, timeZone);
    print(convertedDateTime);

    final tz.TZDateTime dubaiDateTime =
        tz.TZDateTime.from(DateTime.now(), timeZone);
    print('Dubai Time: $dubaiDateTime');

    String localTimezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.Location mylocaltimezone = tz.getLocation(localTimezone);
    print(mylocaltimezone);

    tz.TZDateTime convertedLocalDateTime =
        tz.TZDateTime.from(originalDateTime, mylocaltimezone);
    print('Local Time: $convertedLocalDateTime');
  }

//printsubcollection
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchSubcollection() async {
    QuerySnapshot subcollectionSnapshot = await firestore
        .collection('vouchers')
        .doc('XuQyf7S8gCOJBu6gTIb0')
        .collection('myvouchers')
        .get();

    subcollectionSnapshot.docs.forEach((DocumentSnapshot doc) {
      Object? data = doc.data();
      // Process the data as needed
      print(data);
    });
  }

  String enrolledclasses = '';
  List<STUanalyticsClass> completedclasses = [];
  String totalcompletedclasses = '';
  String firstname = '';
  String middlename = '';
  String lastname = '';
  String fullName = '';
  @override
  Widget build(BuildContext context) {
    final stuanalyticsdata = Provider.of<List<STUanalyticsClass>>(context);
    final studentinfodata = Provider.of<List<StudentInfoClass>>(context);

    if (stuanalyticsdata.isNotEmpty) {
      setState(() {
        enrolledclasses = stuanalyticsdata.length.toString();
      });
    }
    if (studentinfodata.isNotEmpty) {
      setState(() {
        final studentdata = studentinfodata.first;
        firstname = studentdata.studentFirstname;
        middlename = studentdata.studentMiddlename;
        lastname = studentdata.studentLastname;
        fullName = middlename == 'N/A'
            ? '$firstname $lastname'
            : '$firstname $middlename $lastname';
      });
    }

    List<STUanalyticsClass> filterClassesByStatus(
        List<STUanalyticsClass> classes, String status) {
      return classes
          .where((classObj) => classObj.classStatus == status)
          .toList();
    }

    if (stuanalyticsdata.isNotEmpty) {
      completedclasses = filterClassesByStatus(stuanalyticsdata, 'Completed');
      totalcompletedclasses = completedclasses.length.toString();
    } else {
      totalcompletedclasses = '0';
    }   
    Size size = MediaQuery.of(context).size;
    return StreamProvider<List<Voucherclass>>.value(
        value: GetVouchers(uid: 'UHvVwHVxYZARastsdiA0').voucherlist,
        initialData: [],
        child: Container(
          width: size.width - 300,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
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
                        "DASHBOARD",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Local Date and Time: $currentDateTime',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          elevation: 4,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            width: 905,
                            height: 310,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 35),
                                  height: 300,
                                  width: 500,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hi $fullName,',
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Welcome back, ready to learn new lesson \nclick the button bellow to book new tutor.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: 320,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.orangeAccent,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25))),
                                          ),
                                          onPressed: () {
                                            html.window.open('/tutorslist', "");
                                            // setState(() {
                                            //   fetchSubcollection();
                                            // });
                                          },
                                          child: const Text(
                                            'Book Now',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 320,
                                    width: 320,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/5836.png"),
                                          fit: BoxFit.cover),
                                    ),
                                    child: null // Foreground widget here
                                    ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Card(
                          margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          elevation: 4,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            width: 905,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Available Vouchers',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      child: Text(
                                        DateFormat.yMMMMd()
                                            .format(DateTime.now()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TaskInProgress(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      elevation: 4,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        width: 300,
                        height: 615,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: (700) / 2,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Colors.black45,
                                  width: .2,
                                ),
                                borderRadius: const BorderRadius.all(
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
                                    Text(
                                      enrolledclasses,
                                      style: const TextStyle(
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
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: (700) / 2,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Colors.black45,
                                  width: .2,
                                ),
                                borderRadius: const BorderRadius.all(
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
                                    Text(
                                      totalcompletedclasses,
                                      style: const TextStyle(
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
            ),
          ),
        ));
  }
}
