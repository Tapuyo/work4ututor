import 'dart:async';
import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/data_class/subject_teach_pricing.dart';

import '../../../../components/nav_bar.dart';
import '../../../../constant/constant.dart';
import '../../../../data_class/chatmessageclass.dart';
import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/studentanalyticsclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/studentsEnrolledclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../data_class/user_class.dart';
import '../../../../provider/init_provider.dart';
import '../../../../services/getenrolledclasses.dart';
import '../../../../services/getmessages.dart';
import '../../../../services/getschedules.dart';
import '../../../../services/getstudentclassesanalytics.dart';
import '../../../../services/getstudentinfo.dart';
import '../../../../services/getuser.dart';
import '../../../../services/services.dart';
import '../../../../services/timefromtimestamp.dart';
import '../../../../services/timestampconverter.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';
import '../../help/help.dart';
import '../calendar/tutor_calendar.dart';
import '../calendar/tutor_schedule.dart';
import '../classes/classes_inquiry.dart';
import '../classes/classes_main.dart';
import '../classes/tutor_students.dart';
import '../mesages/messages.dart';
import '../performance/tutor_performance.dart';
import '../settings/tutor_settings.dart';

//for timer local time
import 'package:timezone/browser.dart' as tz;

class DashboardPage extends StatefulWidget {
  final String uID;
  const DashboardPage({super.key, required this.uID});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

List<Map<String, dynamic>> _items = [];
String firstname = '';
String middlename = '';
String lastname = '';
String fullName = '';
String tutorID = '';
String profileurl = '';

bool _showModal = false;
GlobalKey _buttonKey = GlobalKey();
int newmessagecount = 0;
int newnotificationcount = 0;
ScrollController _scrollController = ScrollController();

class _DashboardPageState extends State<DashboardPage> {
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
          _items[0]['userStatus'].toString() == 'completed') {
        GoRouter.of(context)
            .go('/studentdiary/${_items[0]['userID'].toString()}');
      } else if (_items[0]['role'].toString() == 'tutor' &&
          _items[0]['userStatus'].toString() == 'completed' &&
          _items[0]['userID'].toString() != widget.uID.toString()) {
        GoRouter.of(context).go('/');
      } else if (_items[0]['role'].toString() == 'tutor' &&
          _items[0]['userStatus'].toString() == 'completed' &&
          _items[0]['userID'].toString() == widget.uID.toString()) {
        // GoRouter.of(context).go('/tutordesk/${_items[0]['userID'].toString()}');
      } else if (_items[0]['role'].toString() == 'tutor' &&
          _items[0]['userStatus'].toString() == 'unfinished') {
        GoRouter.of(context)
            .go('/tutorsignup/${_items[0]['userID'].toString()}');
      } else {
        GoRouter.of(context).go('/');
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<ChatMessage>>.value(
          value: GetMessageList(uid: widget.uID, role: 'tutor').getmessageinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<TutorInformation>>.value(
          value: TutorInfoData(uid: widget.uID).gettutorinfo,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<SubjectTeach>>.value(
          value: TutorInfoData(uid: widget.uID).gettutorsubjects,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<StudentsList>>.value(
          value: DatabaseService(uid: '').enrolleelist,
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
        //     return [];
        //   },
        //   initialData: const [],
        // ),

        StreamProvider<List<ScheduleData>>.value(
          value: ScheduleEnrolledClassData(
            uid: widget.uID,
            role: 'tutor',
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
      child: DashboardPageBody(
        uID: widget.uID,
      ),
    );
  }
}

class DashboardPageBody extends StatefulWidget {
  final String uID;
  const DashboardPageBody({super.key, required this.uID});
  @override
  State<DashboardPageBody> createState() => _DashboardPageBodyState();
}

class _DashboardPageBodyState extends State<DashboardPageBody> {
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
  String? downloadURL;
  String? downloadURL1;
  ImageProvider? imageProvider;
  bool _showModal = false;
  int newmessagecount = 0;
  int newnotificationcount = 0;
  bool tutorstatus = true;
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
    debugPrint(downloadURL.toString());
  }

  final tutordeskKey = GlobalKey<ScaffoldState>();
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

  String? timezone;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    final tutorinfodata = Provider.of<List<TutorInformation>>(context);
    if (downloadURL1 == null) {
      if (tutorinfodata.isNotEmpty) {
        setState(() {
          final tutordata = tutorinfodata.first;
          firstname = tutordata.firstName;
          middlename = tutordata.middleName;
          lastname = tutordata.lastname;
          fullName = middlename == ''
              ? '$firstname $lastname'
              : '$firstname $middlename $lastname';
          tutorID = tutordata.tutorID;
          profileurl = tutordata.imageID;
          tutorstatus = tutordata.status == 'unsubscribe' ? true : false;
          downloadURL1 = tutordata.imageID;
          timezone = tutordata.timezone;

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
        : MultiProvider(
            providers: [
              StreamProvider<List<Schedule>>.value(
                value: ScheduleEnrolledClass(
                  uid: widget.uID,
                  role: 'tutor',
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
                  role: 'tutor',
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
                    key: tutordeskKey,
                    backgroundColor: const Color.fromRGBO(245, 247, 248, 1),
                    appBar: AppBar(
                      toolbarHeight: 65,
                      backgroundColor: kColorPrimary,
                      elevation: 4,
                      shadowColor: Colors.black,
                      automaticallyImplyLeading: false,
                      title: Container(
                        padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                        width: 240,
                        child: Image.asset(
                          "assets/images/worklogo.png",
                          alignment: Alignment.topCenter,
                          fit: BoxFit.cover,
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
                                          tutorID,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        RatingBar(
                                            ignoreGestures: true,
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 10, 5),
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
                            : ResponsiveBuilder.isTablet(context)
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
                                              tutorID,
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
                                            0, 5, 10, 5),
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
                                            if (tutordeskKey.currentState !=
                                                null) {
                                              tutordeskKey.currentState!
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 10, 5),
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
                                            if (tutordeskKey.currentState !=
                                                null) {
                                              tutordeskKey.currentState!
                                                  .openEndDrawer();
                                            }
                                          },
                                          icon: const Icon(Icons.menu),
                                        ),
                                      ),
                                    ],
                                  ),
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
                              child: NavBarMenu(widget.uID),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                          ),
                          Scrollbar(
                            trackVisibility: true,
                            controller: _scrollController,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (menuIndex == 0) ...[
                                    const ClassesMain()
                                  ] else if (menuIndex == 1) ...[
                                    TableBasicsExample1(
                                      uID: widget.uID,
                                      tutor: tutorinfodata.first,
                                    )
                                  ] else if (menuIndex == 2) ...[
                                    MessagePage(
                                      uID: widget.uID,
                                    )
                                  ]
                                  // else if (menuIndex == 3) ...[
                                  //   ClassInquiry(widget.uID)
                                  // ]
                                  else if (menuIndex == 4) ...[
                                    const StudentsEnrolled()
                                  ] else if (menuIndex == 5) ...[
                                    PerformancePage(
                                      uID: widget.uID,
                                    )
                                  ] else if (menuIndex == 6) ...[
                                    SettingsPage(
                                      uID: widget.uID,
                                    )
                                  ] else if (menuIndex == 7) ...[
                                    const HelpPage()
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
                  ),
                ),
                if (_showModal)
                  Overlay(
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
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showModal = false;
                                });
                              },
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
                            ),
                          );
                        },
                      ),
                    ],
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
            child: NavBarMenu(
              widget.uID,
            )),
      ),
    );
  }
}
