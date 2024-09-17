// ignore_for_file: unused_import

library dashboard;

import 'dart:async';
import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/search_tutor/find_tutors.dart';
import 'package:work4ututor/ui/web/student/main_dashboard/students_classes.dart';

import '../../../../components/students_navbar.dart';
import '../../../../constant/constant.dart';
import '../../../../data_class/chatmessageclass.dart';
import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/studentanalyticsclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/user_class.dart';
import '../../../../provider/init_provider.dart';
import '../../../../services/getcurrentTimezone.dart';
import '../../../../services/getenrolledclasses.dart';
import '../../../../services/getmessages.dart';
import '../../../../services/getschedules.dart';
import '../../../../services/getstudentclassesanalytics.dart';
import '../../../../services/getstudentinfo.dart';
import '../../../../services/getuser.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';
import '../../cart/mycart.dart';
import '../../help/help.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'dart:html' as html;


import '../../tutor/calendar/tutor_calendar.dart';
import '../../tutor/classes/classes_main.dart';
import '../../tutor/mesages/messages.dart';
import '../../tutor/performance/tutor_performance.dart';
import '../book_classes/my_classes.dart';
import '../calendar/student_calendar.dart';
import '../settings/student_settings.dart';

//for timer local time
import 'package:timezone/browser.dart' as tz;

class StudentDashboardPage extends StatefulWidget {
  final String uID;
  final String email;
  const StudentDashboardPage(
      {super.key, required this.uID, required this.email});
  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

final _userinfo = Hive.box('userID');
List<Map<String, dynamic>> _items = [];
String firstname = '';
String middlename = '';
String lastname = '';
String fullName = '';
String studentID = '';
String profileurl = '';

bool _showModal = false;
GlobalKey _buttonKey = GlobalKey();
int newmessagecount = 0;
int newnotificationcount = 0;

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  final _userinfo = Hive.box('userID');
  List<Map<String, dynamic>> _items = [];
  _refreshItems() {
    final data = _userinfo.keys.map((key) {
      final item = _userinfo.get(key);
      return {
        "key": key,
        "userID": item["userID"],
        "role": item["role"],
        "userStatus": item["userStatus"]
      };
    }).toList();
    setState(() {
      _items = data.toList();
    });
  }

  @override
  void initState() {
    _refreshItems();
    final index = _items.length;
    if (index == 0) {
      GoRouter.of(context).go('/');
    } else {
      debugPrint(index.toString());
      if (_items[0]['role'].toString() == 'student' &&
          _items[0]['userStatus'].toString() == 'unfinished') {
        GoRouter.of(context)
            .go('/studentsignup/${_items[0]['userID'].toString()}');
      } else if (_items[0]['role'].toString() == 'student' &&
          _items[0]['userStatus'].toString() == 'completed' &&
          _items[0]['userID'].toString() != widget.uID.toString()) {
        GoRouter.of(context).go('/');
      } else if (_items[0]['role'].toString() == 'student' &&
          _items[0]['userStatus'].toString() == 'completed' &&
          _items[0]['userID'].toString() == widget.uID.toString()) {
        // GoRouter.of(context)
        //     .go('/studentdiary/${_items[0]['userID'].toString()}');
      } else if (_items[0]['role'].toString() == 'tutor' &&
          _items[0]['userStatus'].toString() == 'completed') {
        GoRouter.of(context).go('/tutordesk/${_items[0]['userID'].toString()}');
      } else if (_items[0]['role'].toString() == 'tutor' &&
          _items[0]['userStatus'].toString() == 'unfinished') {
        GoRouter.of(context)
            .go('/tutorsignup/${_items[0]['userID'].toString()}');
      } else {
        GoRouter.of(context).go('/');
      }
    }
     WidgetsBinding.instance.addPostFrameCallback((_) {
      final timedatenotifier =
          Provider.of<StudentNotifier>(context, listen: false);
      timedatenotifier.getlistenToTutor(widget.uID.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // StreamProvider<List<StudentsList>>.value(
        //   value: DatabaseService(uid: '').enrolleelist,
        //   catchError: (context, error) {
        //     print('Error occurred: $error');
        //     return [];
        //   },
        //   initialData: const [],
        // ),
        StreamProvider<List<ChatMessage>>.value(
          value:
              GetMessageList(uid: widget.uID, role: 'student').getmessageinfo,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<StudentInfoClass>>.value(
          value: StudentInfoData(uid: widget.uID).getstudentinfo,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<StudentGuardianClass>>.value(
          value: StudentGuardianData(uid: widget.uID).guardianinfo,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),
        // StreamProvider<List<UserData>>.value(
        //   value: GetUsersData(uid: widget.uID).getUserinfo,
        //   catchError: (context, error) {
        //     print('Error occurred: $error');
        //     return [];
        //   },
        //   initialData: const [],
        // ),

        StreamProvider<List<ScheduleData>>.value(
          value: ScheduleEnrolledClassData(
            uid: widget.uID,
            role: 'student',
            context: context,
          ).getenrolled,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),

        StreamProvider<List<STUanalyticsClass>>.value(
          value: StudentAnalytics(uid: widget.uID).studentanalytics,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        )
      ],
      child: MainPageBody(
        uID: widget.uID,
        email: widget.email,
      ),
    );
  }
}

class MainPageBody extends StatefulWidget {
  final String uID;
  final String email;
  const MainPageBody({super.key, required this.uID, required this.email});
  @override
  State<MainPageBody> createState() => _MainPageBodyPageState();
}

class _MainPageBodyPageState extends State<MainPageBody> {
  String utcZone(String timezone) {
    final location = tz.getLocation(timezone);
    final now = DateTime.now().toUtc();
    final localNow = tz.TZDateTime.from(now, location);
    final offset = localNow.timeZoneOffset;

    // Convert offset from Duration to hours and minutes
    final hours = offset.inHours.toString().padLeft(2, '0');
    final minutes = (offset.inMinutes % 60).toString().padLeft(2, '0');
    final sign = offset.isNegative ? '-' : '+';

    final utcOffset = 'UTC$sign$hours:$minutes';

    return utcOffset;
  }

  Uint8List? imageBytes;
  ImageProvider? imageProvider;
  gotoList(String studenttimezone) {
    return MyClasses(
      uID: widget.uID,
      timezone: studenttimezone,
    );
  }

  String? downloadURL;
  String? downloadURL1;
  String? timezone;
  void _updateResponse() async {
    String result = await getData();
    setState(() {
      downloadURL1 = result;
    });
  }

  Future getData() async {
    try {
      await downloadURLExample(profileurl);
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  Future<void> downloadURLExample(String path) async {
    downloadURL = await FirebaseStorage.instance.ref(path).getDownloadURL();
  }

  ScrollController scrollController = ScrollController();
  final studentdeskkey = GlobalKey<ScaffoldState>();
  String formattedDateTime =
      DateFormat('MMMM, dd yyyy HH:mm:ss').format(DateTime.now());
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _updateTime(String timezone) {
    final manilaTimeZone = tz.getLocation(timezone);
    final now = tz.TZDateTime.now(manilaTimeZone);
    final dateFormat = DateFormat('MMMM, dd yyyy HH:mm:ss');
    setState(() {
      formattedDateTime = dateFormat.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
    if (downloadURL1 == null) {
      if (studentinfodata.isNotEmpty) {
        setState(() {
          final studentdata = studentinfodata.first;
          firstname = studentdata.studentFirstname;
          middlename = studentdata.studentMiddlename;
          lastname = studentdata.studentLastname;
          fullName = middlename == 'N/A'
              ? '$firstname $lastname'
              : '$firstname $middlename $lastname';
          studentID = studentdata.studentID;
          downloadURL1 = studentdata.profilelink;
          timezone = studentdata.timezone;
          // _updateResponse();
          // _updateTime();
          // timer = Timer.periodic(
          //     const Duration(seconds: 1), (Timer t) => _updateTime(timezone!));
        });
      }
    }

    return timezone == null
        ? SizedBox(
            width: size.width,
            height: size.height,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                width: 40,
                height: 40,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kColorPrimary),
                  strokeWidth: 5.0,
                ),
              ),
            ),
          )
        : 
        MultiProvider(
            providers: [
              StreamProvider<List<Schedule>>.value(
                value: ScheduleEnrolledClass(
                  uid: widget.uID,
                  role: 'student',
                  targetTimezone: timezone!,
                ).getenrolled,
                catchError: (context, error) {
                  return [];
                },
                initialData: const [],
              ),
              StreamProvider<List<ClassesData>>.value(
                value: EnrolledClass(
                  uid: widget.uID,
                  role: 'student',
                  targetTimezone: timezone!,
                ).getenrolled,
                catchError: (context, error) {
                  return [];
                },
                initialData: const [],
              ),
            ],
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showModal = false;
                    });
                  },
                  child: Scaffold(
                    key: studentdeskkey,
                    backgroundColor: const Color.fromRGBO(245, 247, 248, 1),
                    appBar: AppBar(
                        toolbarHeight: 65,
                      backgroundColor: kColorPrimary,
                      elevation: 4,
                      shadowColor: Colors.black,
                      automaticallyImplyLeading: false,
                      title: InkWell(
                        onTap: () {
                          html.window.location.reload();
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                          width: 240,
                          child: Image.asset(
                            "assets/images/worklogo.png",
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      actions: [
                        ResponsiveBuilder.isDesktop(context)
                            ? Row(
                                children: [
                                  Text(
                                    timezone == null
                                        ? ''
                                        : '$timezone ${utcZone(timezone!)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 15, 10),
                                    child: Badge(
                                      isLabelVisible: newnotificationcount == 0
                                          ? false
                                          : true,
                                      alignment: AlignmentDirectional.centerEnd,
                                      label: Text(
                                        newnotificationcount.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      child: IconButton(
                                          key: _buttonKey,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            EvaIcons.bell,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _showModal = !_showModal;
                                            });
                                          }),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fullName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          studentID,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // RatingBar(
                                        //     initialRating: 0,
                                        //     direction: Axis.horizontal,
                                        //     allowHalfRating: true,
                                        //     itemCount: 5,
                                        //     itemSize: 16,
                                        //     ratingWidget: RatingWidget(
                                        //         full: const Icon(Icons.star,
                                        //             color: Colors.orange),
                                        //         half: const Icon(
                                        //           Icons.star_half,
                                        //           color: Colors.orange,
                                        //         ),
                                        //         empty: const Icon(
                                        //           Icons.star_outline,
                                        //           color: Colors.orange,
                                        //         )),
                                        //     onRatingUpdate: (value) {
                                        //       // _ratingValue = value;
                                        //     }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: downloadURL1 == null
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              downloadURL1.toString(),
                                            ),
                                            radius: 25,
                                          ),
                                  ),
                                ],
                              )
                            : ResponsiveBuilder.isDesktop(context)
                                ? Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 15, 10),
                                        child: Badge(
                                          isLabelVisible:
                                              newnotificationcount == 0
                                                  ? false
                                                  : true,
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          label: Text(
                                            newnotificationcount.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          child: IconButton(
                                              key: _buttonKey,
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(
                                                EvaIcons.bell,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _showModal = !_showModal;
                                                });
                                              }),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fullName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              studentID,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            RatingBar(
                                                initialRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 16,
                                                ratingWidget: RatingWidget(
                                                    full: const Icon(Icons.star,
                                                        color: Colors.orange),
                                                    half: const Icon(
                                                      Icons.star_half,
                                                      color: Colors.orange,
                                                    ),
                                                    empty: const Icon(
                                                      Icons.star_outline,
                                                      color: Colors.orange,
                                                    )),
                                                onRatingUpdate: (value) {
                                                  // _ratingValue = value;
                                                }),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        child: downloadURL1 == null
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  downloadURL1.toString(),
                                                ),
                                                radius: 25,
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: kSpacing / 2),
                                        child: IconButton(
                                          onPressed: () {
                                            if (studentdeskkey.currentState !=
                                                null) {
                                              studentdeskkey.currentState!
                                                  .openEndDrawer();
                                            }
                                          },
                                          icon: const Icon(Icons.menu),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 15, 10),
                                        child: Badge(
                                          isLabelVisible:
                                              newnotificationcount == 0
                                                  ? false
                                                  : true,
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          label: Text(
                                            newnotificationcount.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          child: IconButton(
                                              key: _buttonKey,
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(
                                                EvaIcons.bell,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _showModal = !_showModal;
                                                });
                                              }),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fullName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              studentID,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            RatingBar(
                                                initialRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 16,
                                                ratingWidget: RatingWidget(
                                                    full: const Icon(Icons.star,
                                                        color: Colors.orange),
                                                    half: const Icon(
                                                      Icons.star_half,
                                                      color: Colors.orange,
                                                    ),
                                                    empty: const Icon(
                                                      Icons.star_outline,
                                                      color: Colors.orange,
                                                    )),
                                                onRatingUpdate: (value) {
                                                  // _ratingValue = value;
                                                }),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: kSpacing / 2),
                                        child: IconButton(
                                          onPressed: () {
                                            if (studentdeskkey.currentState !=
                                                null) {
                                              studentdeskkey.currentState!
                                                  .openEndDrawer();
                                            }
                                          },
                                          icon: const Icon(Icons.menu),
                                        ),
                                      ),
                                    ],
                                  )
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: ResponsiveBuilder.isDesktop(context),
                            child: SingleChildScrollView(
                              controller: ScrollController(),
                              child: StudentsMenu(widget.uID),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                          ),
                          Scrollbar(
                            trackVisibility: true,
                            controller: scrollController,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (menuIndex == 0) ...[
                                    StudentMainDashboard(
                                      email: widget.email,
                                      uid: widget.uID,
                                    )
                                  ] else if (menuIndex == 1) ...[
                                    StudentCalendar(
                                      uID: widget.uID,
                                      timezone: timezone!,
                                    )
                                  ] else if (menuIndex == 3) ...[
                                    gotoList(timezone!)
                                  ] else if (menuIndex == 4) ...[
                                    MessagePage(
                                      uID: widget.uID,
                                    )
                                  ] else if (menuIndex == 5) ...[
                                    PerformancePage(
                                      uID: widget.uID,
                                    )
                                  ] else if (menuIndex == 6) ...[
                                    StudentSettingsPage(
                                      uID: widget.uID,
                                    )
                                  ] else if (menuIndex == 7) ...[
                                    const HelpPage()
                                  ] else if (menuIndex == 8) ...[
                                    const FindTutor(
                                      userid: '',
                                    )
                                  ] else if (menuIndex == 9) ...[
                                    MyCart(
                                      studentID: widget.uID,
                                    )
                                  ] else ...[
                                    const ClassesMain()
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    endDrawer: ResponsiveBuilder.isDesktop(context)
                        ? null
                        : Drawer(
                            child: Column(
                              children: [
                                _buildSidebar(context),
                              ],
                            ),
                          ),
                              bottomSheet: Consumer<StudentNotifier>(
                        builder: (context, studentNotifier, child) {
                      return Visibility(
                        visible:studentNotifier.timezone != timezone ,
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          color: Colors.transparent,
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: InkWell(
                            onTap: () {
                              html.window.location.reload();
                            },
                            child: Container(
                              width:
                                  350, // Adjust the width to display all the text
                              height: 50, // Adjust the height as needed
                              decoration: BoxDecoration(
                                color: kColorLight,
                                borderRadius: BorderRadius.circular(
                                    15.0), // Makes the button rounded
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius:
                                        2.0, // How much the shadow spreads
                                    blurRadius: 5.0, // Blur radius of the shadow
                                    offset: const Offset(
                                        0, 4), // Offset of the shadow
                                  ),
                                ],
                              ),
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      const TextSpan(
                                        text: 'Timezone updated, click ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      TextSpan(
                                        text: 'reload',
                                        style: const TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            html.window.location.reload();
                                          },
                                      ),
                                      const TextSpan(
                                        text: ' to reflect!',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                 
                  ),
                ),
                if (_showModal)
                  GestureDetector(
                    onTap: () {
                      null;
                    },
                    child: Overlay(
                      initialEntries: [
                        OverlayEntry(
                          builder: (context) {
                            final buttonRenderBox = _buttonKey.currentContext!
                                .findRenderObject() as RenderBox;
                            final buttonOffset =
                                buttonRenderBox.localToGlobal(Offset.zero);
                            final modalOffset = Offset(
                                buttonOffset.dx + buttonRenderBox.size.width,
                                buttonOffset.dy + buttonRenderBox.size.height);
                            return Positioned(
                              top: modalOffset.dy + 10,
                              left: modalOffset.dx - 220,
                              child: Container(
                                width: 200,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Notifications',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'No notifications to display as of the moment.',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child:
                                            const Text('Clear Notifications'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
  }

  Widget _buildSidebar(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: StudentsMenu(widget.uID),
        ),
      ),
    );
  }
}
