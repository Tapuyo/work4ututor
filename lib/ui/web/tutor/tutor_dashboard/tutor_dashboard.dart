import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/ui/web/tutor/classes/classes_main.dart';
import 'package:wokr4ututor/ui/web/tutor/classes/classes_inquiry.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/messages.dart';
import 'package:wokr4ututor/ui/web/tutor/performance/tutor_performance.dart';
import 'package:wokr4ututor/ui/web/tutor/calendar/tutor_schedule.dart';
import 'package:wokr4ututor/ui/web/tutor/settings/tutor_settings.dart';
import 'package:wokr4ututor/ui/web/tutor/classes/tutor_students.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../../../../components/nav_bar.dart';
import '../../../../constant/constant.dart';
import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/studentanalyticsclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/studentsEnrolledclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../data_class/user_class.dart';
import '../../../../services/getenrolledclasses.dart';
import '../../../../services/getstudentclassesanalytics.dart';
import '../../../../services/getstudentinfo.dart';
import '../../../../services/getuser.dart';
import '../../../../services/services.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../help/help.dart';

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
String tutroID = '';
String profileurl = '';

bool _showModal = false;
GlobalKey _buttonKey = GlobalKey();
int newmessagecount = 0;
int newnotificationcount = 0;

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        StreamProvider<List<TutorInformation>>.value(
          value: TutorInfoData(uid: widget.uID).gettutorinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<StudentsList>>.value(
          value: DatabaseService(uid: '').enrolleelist,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<StudentGuardianClass>>.value(
          value: StudentGuardianData(uid: 'XuQyf7S8gCOJBu6gTIb0').guardianinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<UserData>>.value(
          value: GetUsersData(uid: 'UhcbNwFHdQbclzdU2eC9NeIeziF2').getUserinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<ClassesData>>.value(
          value: EnrolledClass(uid: widget.uID, role: 'tutor').getenrolled,
          catchError: (context, error) {
            // Handle the error here
            print('Error occurred: $error');
            // Return a default value or an alternative stream
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<STUanalyticsClass>>.value(
          value: StudentAnalytics(uid: 'XuQyf7S8gCOJBu6gTIb0').studentanalytics,
          catchError: (context, error) {
            // Handle the error here
            print('Error occurred: $error');
            // Return a default value or an alternative stream
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
  Uint8List? imageBytes;
  String? downloadURL;
  String? downloadURL1;
  ImageProvider? imageProvider;
  bool _showModal = false;
  GlobalKey _buttonKey = GlobalKey();
  int newmessagecount = 0;
  int newnotificationcount = 0;
   bool tutorstatus = true;
  void _updateResponse() async {
    String result = await getData();
    setState(() {
      downloadURL1 = result;
      print('This is the result: $result');
    });
  }

  Future getData() async {
    try {
      await downloadURLExample(profileurl);
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample(String path) async {
    downloadURL = await FirebaseStorage.instance.ref(path).getDownloadURL();
    debugPrint(downloadURL.toString());
  }

  @override
  Widget build(BuildContext context) {
    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    final tutorinfodata = Provider.of<List<TutorInformation>>(context);
    if (downloadURL1 == null) {
      if (tutorinfodata.isNotEmpty) {
        setState(() {
          final tutordata = tutorinfodata.first;
          firstname = tutordata.firstName;
          middlename = tutordata.middleName;
          lastname = tutordata.lastname;
          fullName = middlename == 'N/A'
              ? '$firstname $lastname'
              : '$firstname $middlename $lastname';
          tutroID = tutordata.userId;
          profileurl = tutordata.imageID;
           tutorstatus = tutordata.status == 'unsubscribe' ? true : false;
          _updateResponse();
        });
      }
    }
    Size size = MediaQuery.of(context).size;
    return StreamProvider<List<StudentsList>>.value(
      value: DatabaseService(uid: '').enrolleelist,
      initialData: const [],
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color.fromRGBO(245, 247, 248, 1),
            drawer: ResponsiveBuilder.isDesktop(context)
                ? null
                : Drawer(
                    child: SafeArea(
                      child:
                          SingleChildScrollView(child: _buildSidebar(context)),
                    ),
                  ),
            appBar: AppBar(
              toolbarHeight: 65,
              backgroundColor: kColorPrimary,
              elevation: 4,
              shadowColor: Colors.black,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                  child: Badge(
                    isLabelVisible: newmessagecount == 0 ? false : true,
                    alignment: AlignmentDirectional.centerEnd,
                    label: Text(
                      newmessagecount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          EvaIcons.email,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {
                          final provider = context.read<InitProvider>();
                          provider.setMenuIndex(2);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                  child: Badge(
                    isLabelVisible: newnotificationcount == 0 ? false : true,
                    alignment: AlignmentDirectional.centerEnd,
                    label: Text(
                      newnotificationcount.toString(),
                      style: const TextStyle(color: Colors.white),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        tutroID,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      RatingBar(
                          initialRating: 4,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          ratingWidget: RatingWidget(
                              full:
                                  const Icon(Icons.star, color: Colors.orange),
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
                  padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                  child: downloadURL1 == null
                      ? const Center(child: CircularProgressIndicator())
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                            downloadURL1.toString(),
                          ),
                          radius: 25,
                        ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ResponsiveBuilder(
                mobileBuilder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _buildTaskContent(
                        //   onPressedMenu: () => controller.openDrawer(),
                        // ),
                        // _buildCalendarContent(),
                      ],
                    ),
                  );
                },
                tabletBuilder: (context, constraints) {
                  return Column(
                    children: [
                      if (menuIndex == 0) ...[
                        const ClassesMain()
                      ] else if (menuIndex == 1) ...[
                        TableBasicsExample1(
                          uID: widget.uID,
                        )
                      ] else if (menuIndex == 2) ...[
                        const MessagePage()
                      ] else if (menuIndex == 3) ...[
                        ClassInquiry(widget.uID)
                      ] else if (menuIndex == 4) ...[
                        const StudentsEnrolled()
                      ] else if (menuIndex == 5) ...[
                        PerformancePage(
                          uID: widget.uID,
                        )
                      ] else if (menuIndex == 6) ...[
                        const SettingsPage()
                      ] else if (menuIndex == 7) ...[
                        const HelpPage()
                      ] else ...[
                        const ClassesMain()
                      ],
                    ],
                  );
                },
                desktopBuilder: (context, constraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: constraints.maxWidth > 1350 ? 3 : 4,
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Card(
                              margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                              elevation: 4,
                              child: navbarmenu(context)),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                      ),
                      Flexible(
                        flex: 13,
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(
                            children: [
                              if (menuIndex == 0) ...[
                                const ClassesMain()
                              ] else if (menuIndex == 1) ...[
                                TableBasicsExample1(
                                  uID: widget.uID,
                                )
                              ] else if (menuIndex == 2) ...[
                                const MessagePage()
                              ] else if (menuIndex == 3) ...[
                                ClassInquiry(widget.uID)
                              ] else if (menuIndex == 4) ...[
                                const StudentsEnrolled()
                              ] else if (menuIndex == 5) ...[
                                PerformancePage(
                                  uID: widget.uID,
                                )
                              ] else if (menuIndex == 6) ...[
                                const SettingsPage()
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
                  );
                },
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: const Text('Clear Notifications'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        navbarmenu(context),
      ],
    );
  }

  void onPressed() {}
}
