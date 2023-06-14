library dashboard;

import 'dart:math';
import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/components/students_navbar.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/ui/web/student/book_classes/my_classes.dart';
import 'package:wokr4ututor/ui/web/student/calendar/student_calendar.dart';
import 'package:wokr4ututor/ui/web/student/main_dashboard/students_classes.dart';
import 'package:wokr4ututor/ui/web/student/settings/student_settings.dart';
import 'package:wokr4ututor/ui/web/student/student_inquiry/student_inquiry.dart';
import 'package:wokr4ututor/ui/web/tutor/classes/classes_main.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/messages.dart';
import 'package:wokr4ututor/ui/web/tutor/performance/tutor_performance.dart';

import '../../../../data_class/studentanalyticsclass.dart';
import '../../../../data_class/studentinofclass.dart';
import '../../../../data_class/studentsEnrolledclass.dart';
import '../../../../services/getstudentclassesanalytics.dart';
import '../../../../services/getstudentinfo.dart';
import '../../../../services/services.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';
import '../../help/help.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});
  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

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
  @override
  Widget build(BuildContext context) {
    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    Size size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        StreamProvider<List<StudentsList>>.value(
          value: DatabaseService(uid: '').enrolleelist,
          catchError: (context, error) {
            // Handle the error here
            print('Error occurred: $error');
            // Return a default value or an alternative stream
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<StudentInfoClass>>.value(
          value: StudentInfoData(uid: 'XuQyf7S8gCOJBu6gTIb0').getstudentinfo,
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
      child: const MainPageBody(),
    );
  }

  void onPressed() {}
}

class MainPageBody extends StatefulWidget {
  const MainPageBody({super.key});
  @override
  State<MainPageBody> createState() => _MainPageBodyPageState();
}

class _MainPageBodyPageState extends State<MainPageBody> {
  Uint8List? imageBytes;
  gotoList() {
    return const MyClasses();
  }

  void loadImage(String path) async {
    Uint8List bytes = await fetchImage(path);
    setState(() {
      imageBytes = bytes;
    });
  }

  Future<Uint8List> fetchImage(String imagePath) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref = storage.ref().child(imagePath);

    // Fetch the download URL for the image
    String downloadURL = await ref.getDownloadURL();

    // Fetch the image data as a byte stream
    http.Response response = await http.get(Uri.parse(downloadURL));

    // Convert the byte stream to Uint8List
    Uint8List imageBytes = response.bodyBytes;

    return imageBytes;
  }

  void fetchFileUrl(String path, Function(String) onSuccess) {
    Reference storageReference = FirebaseStorage.instance.ref(path);
    storageReference.getDownloadURL().then((url) {
      onSuccess(url);
    }).catchError((error) {
      // Handle error
      print('Error fetching file URL: $error');
    });
  }

  void handleSuccess(String url) {
    profileurl = url;
    debugPrint(profileurl);
    // Perform any other necessary operations with the file URL
  }

  @override
  Widget build(BuildContext context) {
    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
    Size size = MediaQuery.of(context).size;

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
        String profileurl1 = studentdata.profilelink;
        // profileurl = await fetchFileUrl(profileurl1);
        fetchFileUrl(profileurl1, handleSuccess);
      });
    }
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromRGBO(245, 247, 248, 1),
          drawer: ResponsiveBuilder.isDesktop(context)
              ? null
              : Drawer(
                  child: SafeArea(
                    child: SingleChildScrollView(child: _buildSidebar(context)),
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
                        initialRating: 4,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 16,
                        ratingWidget: RatingWidget(
                            full: const Icon(Icons.star, color: Colors.orange),
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
                padding:const EdgeInsets.fromLTRB(0, 5, 10, 5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profileurl),
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
                      if (menuIndex == 0) ...[
                        const StudentMainDashboard()
                      ] else if (menuIndex == 1) ...[
                        const StudentCalendar()
                      ] else if (menuIndex == 2) ...[
                        const MessagePage()
                      ] else if (menuIndex == 3) ...[
                        gotoList()
                      ] else if (menuIndex == 4) ...[
                        StudentInquiry()
                      ] else if (menuIndex == 5) ...[
                        const PerformancePage()
                      ] else if (menuIndex == 6) ...[
                        const StudentSettingsPage()
                      ] else if (menuIndex == 7) ...[
                        const HelpPage()
                      ] else ...[
                        const ClassesMain()
                      ],
                    ],
                  ),
                );
              },
              tabletBuilder: (context, constraints) {
                return Column(
                  children: [
                    if (menuIndex == 0) ...[
                      const StudentMainDashboard()
                    ] else if (menuIndex == 1) ...[
                      const StudentCalendar()
                    ] else if (menuIndex == 2) ...[
                      const MessagePage()
                    ] else if (menuIndex == 3) ...[
                      gotoList()
                    ] else if (menuIndex == 4) ...[
                      StudentInquiry()
                    ] else if (menuIndex == 5) ...[
                      const PerformancePage()
                    ] else if (menuIndex == 6) ...[
                      const StudentSettingsPage()
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
                            child: StudentsMenu()),
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
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (menuIndex == 0) ...[
                              const StudentMainDashboard()
                            ] else if (menuIndex == 1) ...[
                              const StudentCalendar()
                            ] else if (menuIndex == 2) ...[
                              const MessagePage()
                            ] else if (menuIndex == 3) ...[
                              gotoList()
                            ] else if (menuIndex == 4) ...[
                              StudentInquiry()
                            ] else if (menuIndex == 5) ...[
                              const PerformancePage()
                            ] else if (menuIndex == 6) ...[
                              const StudentSettingsPage()
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
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudentsMenu(),
      ],
    );
  }
}
