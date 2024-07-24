// ignore_for_file: unused_element, unused_local_variable, sized_box_for_whitespace, avoid_web_libraries_in_flutter, unused_import

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/student/book_classes/cancelclasses.dart';
import 'package:work4ututor/ui/web/student/book_classes/student_view_classinfo.dart';
import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/classinfo_provider.dart';

import 'dart:html' as html;
import 'dart:js' as js;

import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';

class MyClasses extends StatefulWidget {
  final String uID;
  const MyClasses({super.key, required this.uID});

  @override
  State<MyClasses> createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 10), () {
    //   setState(() {
    //     _showLoading = false;
    //   });
    // });
  }

  String actionValue = 'View';
  String subjectID = 'All';
  String statusValue = 'All';
  Color buttonColor = kCalendarColorAB;
  DateTime? _fromselectedDate;
  DateTime? _toselectedDate;
  String tempactionValue = 'View';
  String tempdropdownValue = 'All';
  String tempstatusValue = 'All';
  DateTime? _tempfromselectedDate;
  DateTime? _temptoselectedDate;
  // ClassesData selectedclass = ClassesData(
  //     classid: '',
  //     subjectID: '',
  //     tutorID: '',
  //     studentID: '',
  //     materials: [],
  //     schedule: [],
  //     score: [],
  //     status: '',
  //     totalClasses: '',
  //     completedClasses: '',
  //     pendingClasses: '',
  //     dateEnrolled: DateTime.now(),
  //     studentinfo: [],
  //     tutorinfo: [],
  //     subjectinfo: [],
  //     price: 0);

  String? downloadURL;
  List<String> imagelinks = [];
  List<String> subjectnames = [];
  ImageProvider? imageProvider;
  String profileurl = '';

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _tempfromselectedDate = pickedDate;
      });
    });
  }

  void _topickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _temptoselectedDate = pickedDate;
      });
    });
  }

  bool select = false;

  Future getData(String path) async {
    try {
      return await FirebaseStorage.instance.ref(path).getDownloadURL();
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  @override
  void dispose() {
    // Dispose of resources when the widget is removed from the widget tree
    // setState(() {
    // final provider = context.read<ViewClassDisplayProvider>();
    // provider.setViewClassinfo(false);
    // });

    super.dispose();
  }

  ScrollController alllistscroll = ScrollController();
  ScrollController studentsDataController = ScrollController();

//style Header Fontsize
  TextStyle tableHeaderStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: kColorGrey,
  );
  @override
  Widget build(BuildContext context) {
    final bool open =
        context.select((ViewClassDisplayProvider p) => p.openClassInfo);
    List<ClassesData> newenrolledlist = Provider.of<List<ClassesData>>(context);
    List<ClassesData> enrolledlist = statusValue == 'All' &&
            _fromselectedDate == null &&
            _toselectedDate == null &&
            subjectID == 'All'
        ? newenrolledlist
        : statusValue == 'All' &&
                _fromselectedDate == null &&
                _toselectedDate == null &&
                subjectID != 'All'
            ? newenrolledlist.where((item) {
                bool isSubjectMatch = item.subjectID == subjectID;
                return isSubjectMatch;
              }).toList()
            : statusValue != 'All' &&
                    _fromselectedDate == null &&
                    _toselectedDate == null &&
                    subjectID != ''
                ? newenrolledlist.where((item) {
                    bool isStatusMatch = item.status == statusValue;

                    return isStatusMatch;
                  }).toList()
                : statusValue != 'All' &&
                        _fromselectedDate != null &&
                        _toselectedDate != null &&
                        subjectID == 'All'
                    ? newenrolledlist.where((item) {
                        bool isStatusMatch = item.status == statusValue;
                        DateTime formattedFromDate = DateTime(
                            _fromselectedDate!.year,
                            _fromselectedDate!.month,
                            _fromselectedDate!.day);
                        DateTime formattedToDate = DateTime(
                            _toselectedDate!.year,
                            _toselectedDate!.month,
                            _toselectedDate!.day);
                        DateTime formatteDateEnrolled = DateTime(
                            item.dateEnrolled.year,
                            item.dateEnrolled.month,
                            item.dateEnrolled.day);

                        bool isDateInRange = formatteDateEnrolled
                                .isAtSameMomentAs(formattedFromDate) ||
                            formatteDateEnrolled
                                .isAtSameMomentAs(formattedToDate) ||
                            (formatteDateEnrolled.isAfter(_fromselectedDate!) &&
                                formatteDateEnrolled
                                    .isBefore(_toselectedDate!));

                        return isStatusMatch && isDateInRange;
                      }).toList()
                    : statusValue == 'All' &&
                            _fromselectedDate != null &&
                            _toselectedDate != null
                        ? newenrolledlist.where((item) {
                            DateTime formattedFromDate = DateTime(
                                _fromselectedDate!.year,
                                _fromselectedDate!.month,
                                _fromselectedDate!.day);
                            DateTime formattedToDate = DateTime(
                                _toselectedDate!.year,
                                _toselectedDate!.month,
                                _toselectedDate!.day);

                            bool isStatusMatch = item.status == statusValue;
                            DateTime formatteDateEnrolled = DateTime(
                                item.dateEnrolled.year,
                                item.dateEnrolled.month,
                                item.dateEnrolled.day);

                            bool isDateInRange = formatteDateEnrolled
                                    .isAtSameMomentAs(formattedFromDate) ||
                                formatteDateEnrolled
                                    .isAtSameMomentAs(formattedToDate) ||
                                (formatteDateEnrolled
                                        .isAfter(_fromselectedDate!) &&
                                    formatteDateEnrolled
                                        .isBefore(_toselectedDate!));

                            return isDateInRange;
                          }).toList()
                        : statusValue == 'All' &&
                                _fromselectedDate == null &&
                                _toselectedDate == null &&
                                subjectID != 'All'
                            ? newenrolledlist.where((item) {
                                bool isSubjectMatch =
                                    item.subjectID == subjectID;
                                bool isStatusMatch = item.status == statusValue;
                                DateTime formattedFromDate = DateTime(
                                    _fromselectedDate!.year,
                                    _fromselectedDate!.month,
                                    _fromselectedDate!.day);
                                DateTime formattedToDate = DateTime(
                                    _toselectedDate!.year,
                                    _toselectedDate!.month,
                                    _toselectedDate!.day);
                                DateTime formatteDateEnrolled = DateTime(
                                    item.dateEnrolled.year,
                                    item.dateEnrolled.month,
                                    item.dateEnrolled.day);

                                bool isDateInRange = formatteDateEnrolled
                                        .isAtSameMomentAs(formattedFromDate) ||
                                    formatteDateEnrolled
                                        .isAtSameMomentAs(formattedToDate) ||
                                    (formatteDateEnrolled
                                            .isAfter(_fromselectedDate!) &&
                                        formatteDateEnrolled
                                            .isBefore(_toselectedDate!));

                                return isDateInRange && isSubjectMatch;
                              }).toList()
                            : statusValue == 'All' &&
                                    _fromselectedDate != null &&
                                    _toselectedDate != null &&
                                    subjectID != 'All'
                                ? newenrolledlist.where((item) {
                                    bool isSubjectMatch =
                                        item.subjectID == subjectID;
                                    bool isStatusMatch =
                                        item.status == statusValue;

                                    return isSubjectMatch;
                                  }).toList()
                                : newenrolledlist.where((item) {
                                    bool isStatusMatch =
                                        item.status == statusValue;

                                    return isStatusMatch;
                                  }).toList();
    if (enrolledlist.isNotEmpty) {
      setState(() {
        enrolledlist.sort((b, a) => a.dateEnrolled.compareTo(b.dateEnrolled));
        List<List<SubjectClass>> allSubjects = enrolledlist.map((classesData) {
          return classesData.subjectinfo;
        }).toList();
        subjectnames = ['All'] +
            allSubjects
                .map((subjectList) =>
                    subjectList.map((subject) => subject.subjectName).toList())
                .expand((names) => names)
                .toSet()
                .toList();
      });
    }

    Size size = MediaQuery.of(context).size;
    //

    return Consumer<SelectedClassInfoProvider>(
        builder: (context, selectedclass, child) {
        return Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              Card(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Classes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: ResponsiveBuilder.isDesktop(context)
                    ? size.width - 290
                    : size.width - 30,
                alignment: Alignment.center,
                child: open == false
                    ? Scrollbar(
                        thumbVisibility: true,
                        controller: studentsDataController,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          controller: studentsDataController,
                          child: Column(
                            children: [
                              Card(
                                margin: EdgeInsets.zero,
                                elevation: 4,
                                child: SizedBox(
                                  width: 1235,
                                  child: Visibility(
                                    visible: open == false ? true : false,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 1235,
                                          height: 50,
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Visibility(
                                                visible:
                                                    open == false ? true : false,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Date Enrolled",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: kColorGrey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    open == false ? true : false,
                                                child: Container(
                                                  padding: const EdgeInsets.all(5),
                                                  width: 185,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: kColorGrey,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          _tempfromselectedDate ==
                                                                  null
                                                              ? 'From'
                                                              : DateFormat.yMMMMd()
                                                                  .format(
                                                                      _tempfromselectedDate!),
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kColorGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _pickDateDialog();
                                                        },
                                                        child: const Icon(
                                                          Icons.calendar_month,
                                                          size: 20,
                                                          color: kColorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Visibility(
                                                visible:
                                                    open == false ? true : false,
                                                child: Container(
                                                  padding: const EdgeInsets.all(5),
                                                  width: 185,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: kColorGrey,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          _temptoselectedDate ==
                                                                  null
                                                              ? 'To'
                                                              : DateFormat.yMMMMd()
                                                                  .format(
                                                                      _temptoselectedDate!),
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kColorGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _topickDateDialog();
                                                        },
                                                        child: const Icon(
                                                          Icons.calendar_month,
                                                          size: 20,
                                                          color: kColorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Visibility(
                                                visible:
                                                    open == false ? true : false,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Status",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: kColorGrey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    open == false ? true : false,
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  width: 150,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: kColorGrey,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: DropdownButton<String>(
                                                    elevation: 10,
                                                    value: tempstatusValue,
                                                    onChanged: (statValue) {
                                                      setState(() {
                                                        tempstatusValue =
                                                            statValue!;
                                                      });
                                                    },
                                                    underline: Container(),
                                                    items: <String>[
                                                      'All',
                                                      'Completed',
                                                      'Ongoing',
                                                      'Pending',
                                                      'Cancelled',
                                                    ].map<DropdownMenuItem<String>>(
                                                        (String value1) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value1,
                                                        child: Container(
                                                          width: 110,
                                                          child: Text(
                                                            value1,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: kColorGrey,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Visibility(
                                                visible:
                                                    open == false ? true : false,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Subject",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: kColorGrey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    open == false ? true : false,
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  width: 150,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: kColorGrey,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: DropdownButton<String>(
                                                    elevation: 10,
                                                    value: tempdropdownValue,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        tempdropdownValue =
                                                            newValue!;
                                                      });
                                                    },
                                                    underline: Container(),
                                                    items: subjectnames.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Container(
                                                          width: 110,
                                                          child: Text(
                                                            value,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: kColorGrey,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(flex: 2),
                                              Visibility(
                                                visible:
                                                    open == false ? true : false,
                                                child: SizedBox(
                                                  width: 100,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.white,
                                                      disabledForegroundColor:
                                                          kColorLight
                                                              .withOpacity(0.38),
                                                      disabledBackgroundColor:
                                                          kColorLight
                                                              .withOpacity(0.12),
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius
                                                                          .circular(
                                                                              5))),
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _toselectedDate =
                                                            _temptoselectedDate;
                                                        _fromselectedDate =
                                                            _tempfromselectedDate;
                                                        statusValue =
                                                            tempstatusValue;
                                                        List<SubjectClass>
                                                            filteredSubjects =
                                                            enrolledlist
                                                                .expand((classesData) => classesData
                                                                    .subjectinfo
                                                                    .where((subject) => subject
                                                                        .subjectName
                                                                        .contains(
                                                                            tempdropdownValue)))
                                                                .toList();

                                                        subjectID = filteredSubjects
                                                                .isNotEmpty
                                                            ? filteredSubjects
                                                                .first.subjectID
                                                                .toString()
                                                            : tempdropdownValue;
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Search',
                                                      style: TextStyle(
                                                          color: kColorPrimary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Card(
                                  elevation: 4.0,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 1235,
                                        padding: const EdgeInsets.only(
                                          top: 5.0,
                                          left: 10,
                                          right: 5,
                                          bottom: 5.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 300,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 60.0),
                                                child: Text(
                                                  "Name",
                                                  style: tableHeaderStyle,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                "Date Enrolled",
                                                style: tableHeaderStyle,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 140,
                                              child: Text(
                                                "Subject",
                                                style: tableHeaderStyle,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                "Status",
                                                style: tableHeaderStyle,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 40,
                                            ),
                                            SizedBox(
                                              width: 230,
                                              child: Text(
                                                "Classes",
                                                style: tableHeaderStyle,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 140,
                                              child: Text(
                                                "Action",
                                                style: tableHeaderStyle,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 1235,
                                        child: const Divider(
                                          height: 1,
                                          thickness: 1,
                                        ),
                                      ),
                                      newenrolledlist == null
                                          ? Container(
                                              width: 1235,
                                              height: size.height - 230,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                        Icons.collections_bookmark_outlined,
                                                    size: 50,
                                                    color: kColorPrimary,
                                                  ),
                                                  Text(
                                                    'No classes found!',
                                                    style: TextStyle(
                                                       fontStyle: FontStyle.italic,
                                                        color: kCalendarColorB,
                                                        fontSize: 24),
                                                  ),
                                                ],
                                              ))
                                          : enrolledlist.isNotEmpty
                                              ? Consumer<List<Schedule>>(builder:
                                                  (context, scheduleListdata, _) {
                                                  dynamic data = scheduleListdata;
                                                  return Container(
                                                    width: 1235,
                                                    height: size.height - 230,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          enrolledlist.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final enrolledClass =
                                                            enrolledlist[index];
                                                        List<SubjectClass>
                                                            subjectinfo =
                                                            enrolledClass
                                                                .subjectinfo;
                                                        List<TutorInformation>
                                                            tutorinfo =
                                                            enrolledClass.tutorinfo;
                                                        List<StudentInfoClass>
                                                            studentinfo =
                                                            enrolledClass
                                                                .studentinfo;
                                                        bool dataLoaded = false;
                                                        List<Schedule>
                                                            filteredScheduleList =
                                                            scheduleListdata
                                                                .where((element) =>
                                                                    element
                                                                        .scheduleID ==
                                                                    enrolledClass
                                                                        .classid)
                                                                .toList();
                                                        String tempimage = '';
                                                        // if (!dataLoaded) {
                                                        //   getData(tutorinfo.first.imageID)
                                                        //       .then((downloadURL) {
                                                        //     if (downloadURL != null) {
                                                        //       setState(() {
                                                        //         tempimage = downloadURL;
                                                        //         dataLoaded =
                                                        //             true; // Mark the data as loaded
                                                        //       });
                                                        //     } else {
                                                        //       print(
                                                        //           'Failed to retrieve download URL.');
                                                        //     }
                                                        //   });
                                                        // }

                                                        return Column(
                                                          children: [
                                                            Container(
                                                              color: (index % 2 ==
                                                                      0)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .grey[200],
                                                              child: InkWell(
                                                                highlightColor:
                                                                    kCalendarColorFB,
                                                                splashColor:
                                                                    kColorPrimary,
                                                                focusColor: Colors
                                                                    .green
                                                                    .withOpacity(
                                                                        0.0),
                                                                hoverColor:
                                                                    kColorLight,
                                                                onTap: () {
                                                                  setState(() {
                                                                     final provider1 =
                                                                      context.read<
                                                                          SelectedClassInfoProvider>();
                                                                  provider1
                                                                      .setSelectedClass(
                                                                          enrolledClass);
                                                                  });
                                                                  final provider =
                                                                      context.read<
                                                                          ViewClassDisplayProvider>();
                                                                  provider
                                                                      .setViewClassinfo(
                                                                          true);
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 5.0,
                                                                    left: 10,
                                                                    right: 10,
                                                                    bottom: 5.0,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child:
                                                                            ListTile(
                                                                          leading:
                                                                              CircleAvatar(
                                                                            backgroundImage:
                                                                                NetworkImage(
                                                                              tutorinfo
                                                                                  .first
                                                                                  .imageID
                                                                                  .toString(),
                                                                            ),
                                                                            radius:
                                                                                25,
                                                                          ),
                                                                          title:
                                                                              Text(
                                                                            '${(tutorinfo.first.firstName)}${(tutorinfo.first.middleName == 'N/A' || tutorinfo.first.middleName == '' ? '' : ' ${(tutorinfo.first.middleName)}')} ${(tutorinfo.first.lastname)}',
                                                                            // 'Name',
                                                                            style: const TextStyle(
                                                                                fontSize:
                                                                                    18,
                                                                                fontWeight:
                                                                                    FontWeight.w700,
                                                                                color: kColorGrey),
                                                                          ),
                                                                          subtitle:
                                                                              Text(
                                                                            tutorinfo
                                                                                .first
                                                                                .country,
                                                                            // 'Country',
                                                                            style: const TextStyle(
                                                                                fontSize:
                                                                                    15,
                                                                                fontWeight:
                                                                                    FontWeight.normal,
                                                                                color: kColorGrey),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Container(
                                                                        width: 200,
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: Text(
                                                                          DateFormat(
                                                                                  'MMMM dd, yyyy')
                                                                              .format(
                                                                                  enrolledlist[index].dateEnrolled)
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight: FontWeight
                                                                                  .normal,
                                                                              color:
                                                                                  kColorGrey),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      Container(
                                                                        width: 140,
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: Text(
                                                                          subjectinfo
                                                                              .first
                                                                              .subjectName,
                                                                          // 'Subject Name',
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight: FontWeight
                                                                                  .normal,
                                                                              color:
                                                                                  kColorGrey),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              30,
                                                                          child: Container(
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                  color: Colors.white,
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.grey.withOpacity(0.5),
                                                                                      spreadRadius: 2,
                                                                                      blurRadius: 3,
                                                                                      offset: const Offset(3, 4),
                                                                                    ),
                                                                                    const BoxShadow(
                                                                                      color: Colors.transparent,
                                                                                      spreadRadius: 2,
                                                                                      blurRadius: 3,
                                                                                      offset: Offset(-3, 0),
                                                                                    ),
                                                                                  ],
                                                                                  border: Border.all(
                                                                                    width: 1.5,
                                                                                    color: enrolledlist[index].status == 'Pending'
                                                                                        ? classStatuscolor[0]
                                                                                        : enrolledlist[index].status == 'Ongoing'
                                                                                            ? classStatuscolor[1]
                                                                                            : enrolledlist[index].status == 'Completed'
                                                                                                ? Colors.green.shade200
                                                                                                : classStatuscolor[2],
                                                                                  )),
                                                                              child: Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: Text(
                                                                                    enrolledlist[index].status,
                                                                                    style: const TextStyle(color: kColorGrey),
                                                                                  )))),
                                                                      const SizedBox(
                                                                        width: 40,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              180,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              ListTile(
                                                                                contentPadding:
                                                                                    EdgeInsets.zero,
                                                                                title:
                                                                                    Text(
                                                                                  '${(enrolledClass.totalClasses)} Classes',
                                                                                  style: const TextStyle(color: kColorGrey),
                                                                                ),
                                                                                subtitle: enrolledlist[index].status == 'Cancelled'
                                                                                    ? const Text('Cancelled Classes')
                                                                                    : Text('Completed: ${(enrolledClass.completedClasses)} Class \nUpcoming: ${(filteredScheduleList.length)} Classes'),
                                                                              )
                                                                            ],
                                                                          )),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 200,
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .spaceEvenly,
                                                                          children: [
                                                                            Tooltip(
                                                                              message:
                                                                                  'View Class',
                                                                              child:
                                                                                  Container(
                                                                                width:
                                                                                    90,
                                                                                height:
                                                                                    30,
                                                                                decoration:
                                                                                    BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                  // color: Colors
                                                                                  //     .green
                                                                                  //     .shade400,
                                                                                ),
                                                                                child:
                                                                                    TextButton.icon(
                                                                                  style: TextButton.styleFrom(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    alignment: Alignment.center,
                                                                                    foregroundColor: const Color.fromRGBO(1, 118, 132, 1),
                                                                                    // backgroundColor:
                                                                                    //     Colors
                                                                                    //         .green
                                                                                    //         .shade200,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(24.0),
                                                                                    ),
                                                                                    // ignore: prefer_const_constructors
                                                                                    textStyle: const TextStyle(
                                                                                      color: Colors.deepPurple,
                                                                                      fontSize: 12,
                                                                                      fontStyle: FontStyle.normal,
                                                                                      decoration: TextDecoration.none,
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      final provider1 =
                                                                      context.read<
                                                                          SelectedClassInfoProvider>();
                                                                  provider1
                                                                      .setSelectedClass(
                                                                          enrolledClass);
                                                                                    });
                                                                                    final provider = context.read<ViewClassDisplayProvider>();
                                                                                    provider.setViewClassinfo(true);
                                                                                  },
                                                                                  icon: const Icon(Icons.open_in_new, size: 16, color: kColorPrimary),
                                                                                  label: const Text(
                                                                                    'View',
                                                                                    style: TextStyle(fontSize: 14, color: kColorPrimary),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Tooltip(
                                                                              message:
                                                                                  'Cancel Class',
                                                                              child:
                                                                                  Container(
                                                                                width:
                                                                                    90,
                                                                                height:
                                                                                    30,
                                                                                decoration:
                                                                                    BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                  // color: Colors
                                                                                  //     .green
                                                                                  //     .shade400,
                                                                                ),
                                                                                child:
                                                                                    TextButton.icon(
                                                                                  style: TextButton.styleFrom(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    alignment: Alignment.center,
                                                                                    foregroundColor: const Color.fromRGBO(1, 118, 132, 1),
                                                                                    // backgroundColor:
                                                                                    //     Colors
                                                                                    //         .green
                                                                                    //         .shade200,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(24.0),
                                                                                    ),
                                                                                    // ignore: prefer_const_constructors
                                                                                    textStyle: const TextStyle(
                                                                                      color: Colors.deepPurple,
                                                                                      fontSize: 12,
                                                                                      fontStyle: FontStyle.normal,
                                                                                      decoration: TextDecoration.none,
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    cancellclass(context, enrolledClass.classid);
                                                                                  },
                                                                                  icon: const Icon(Icons.close, size: 16, color: kColorDarkRed),
                                                                                  label: const Text(
                                                                                    'Cancel',
                                                                                    style: TextStyle(fontSize: 14, color: kColorDarkRed),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            // Tooltip(
                                                                            //   message: 'Cancel Class',
                                                                            //   child: Container(
                                                                            //     width: 90,
                                                                            //     height: 30,
                                                                            //     decoration: BoxDecoration(
                                                                            //       borderRadius: BorderRadius.circular(20),
                                                                            //       color: Colors.red.shade400,
                                                                            //     ),
                                                                            //     child: TextButton.icon(
                                                                            //       style: TextButton.styleFrom(
                                                                            //         padding: const EdgeInsets.all(10),
                                                                            //         alignment: Alignment.center,
                                                                            //         foregroundColor: const Color.fromRGBO(1, 118, 132, 1),
                                                                            //         backgroundColor: Colors.red.shade200,
                                                                            //         shape: RoundedRectangleBorder(
                                                                            //           borderRadius: BorderRadius.circular(24.0),
                                                                            //         ),
                                                                            //         // ignore: prefer_const_constructors
                                                                            //         textStyle: const TextStyle(
                                                                            //           color: Colors.deepPurple,
                                                                            //           fontSize: 12,
                                                                            //           fontStyle: FontStyle.normal,
                                                                            //           decoration: TextDecoration.none,
                                                                            //         ),
                                                                            //       ),
                                                                            //       onPressed: () {
                                                                            //         cancellclass(context, enrolledClass.classid);
                                                                            //       },
                                                                            //       icon: const Icon(
                                                                            //         Icons.cancel_presentation,
                                                                            //         size: 15,
                                                                            //       ),
                                                                            //       label: const Text(
                                                                            //         'Cancel',
                                                                            //         style: TextStyle(fontSize: 13),
                                                                            //       ),
                                                                            //     ),
                                                                            //   ),
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              height: 1,
                                                              thickness: 1,
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  );
                                                })
                                              : Container(
                                                  width: 1235,
                                                  height: size.height - 230,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: const [
                                                      Icon(
                                                        Icons.collections_bookmark_outlined,
                                                        size: 50,
                                                        color: kColorPrimary,
                                                      ),
                                                      Text(
                                                        'No students found.',
                                                        style: TextStyle(
                                                            color: kCalendarColorB,
                                                             fontStyle: FontStyle.italic,
                                                            fontSize: 24),
                                                      ),
                                                    ],
                                                  ))
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        color: Colors.white,
                        child: StudentViewClassInfo(
                          enrolledClass: selectedclass.selectedclass,
                          uID: widget.uID,
                        ),
                      ),
              )

              // Card(
              //   margin: EdgeInsets.zero,
              //   elevation: 4,
              //   child: SizedBox(
              //     width: 1235,
              //     child: Visibility(
              //       visible: open == false ? true : false,
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Container(
              //             width: size.width - 310,
              //             height: 50,
              //             child: Card(
              //               elevation: 5.0,
              //               child: Row(
              //                 children: [
              //                   const SizedBox(
              //                     width: 10,
              //                   ),
              //                   Visibility(
              //                     visible: open == false ? true : false,
              //                     child: const Padding(
              //                       padding: EdgeInsets.all(5.0),
              //                       child: Text(
              //                         "Date Enrolled:",
              //                         style: TextStyle(
              //                           fontWeight: FontWeight.w600,
              //                           color: kColorGrey,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   Visibility(
              //                     visible: open == false ? true : false,
              //                     child: Container(
              //                       padding: const EdgeInsets.all(5),
              //                       width: 185,
              //                       decoration: BoxDecoration(
              //                         color: Colors.white,
              //                         border: Border.all(
              //                           color: Colors.black45,
              //                           width: 1,
              //                         ),
              //                         borderRadius: BorderRadius.circular(5),
              //                       ),
              //                       child: Row(
              //                         children: [
              //                           SizedBox(
              //                             width: 150,
              //                             child: Text(
              //                               _tempfromselectedDate == null
              //                                   ? 'From'
              //                                   : DateFormat.yMMMMd()
              //                                       .format(_tempfromselectedDate!),
              //                               style: const TextStyle(
              //                                   fontWeight: FontWeight.w500),
              //                             ),
              //                           ),
              //                           InkWell(
              //                             onTap: () {
              //                               _pickDateDialog();
              //                             },
              //                             child: const Icon(
              //                               Icons.calendar_month,
              //                               size: 20,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(width: 10),
              //                   Visibility(
              //                     visible: open == false ? true : false,
              //                     child: Container(
              //                       padding: const EdgeInsets.all(5),
              //                       width: 185,
              //                       decoration: BoxDecoration(
              //                         color: Colors.white,
              //                         border: Border.all(
              //                           color: Colors.black45,
              //                           width: 1,
              //                         ),
              //                         borderRadius: BorderRadius.circular(5),
              //                       ),
              //                       child: Row(
              //                         children: [
              //                           SizedBox(
              //                             width: 150,
              //                             child: Text(
              //                               _temptoselectedDate == null
              //                                   ? 'To'
              //                                   : DateFormat.yMMMMd()
              //                                       .format(_temptoselectedDate!),
              //                               style: const TextStyle(
              //                                   fontWeight: FontWeight.w500),
              //                             ),
              //                           ),
              //                           InkWell(
              //                             onTap: () {
              //                               _topickDateDialog();
              //                             },
              //                             child: const Icon(
              //                               Icons.calendar_month,
              //                               size: 20,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(
              //                     width: 30,
              //                   ),
              //                   Visibility(
              //                     visible: open == false ? true : false,
              //                     child: const Padding(
              //                       padding: EdgeInsets.all(5.0),
              //                       child: Text(
              //                         "Status:",
              //                         style: TextStyle(
              //                           fontWeight: FontWeight.w600,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   Visibility(
              //                     visible: open == false ? true : false,
              //                     child: Container(
              //                       padding:
              //                           const EdgeInsets.only(left: 5, right: 5),
              //                       width: 150,
              //                       height: 32,
              //                       decoration: BoxDecoration(
              //                         border: Border.all(
              //                           color: Colors.black45,
              //                           width: 1,
              //                         ),
              //                         borderRadius: BorderRadius.circular(5),
              //                         color: Colors.white,
              //                       ),
              //                       child: DropdownButton<String>(
              //                         elevation: 10,
              //                         value: tempstatusValue,
              //                         onChanged: (statValue) {
              //                           setState(() {
              //                             tempstatusValue = statValue!;
              //                           });
              //                         },
              //                         underline: Container(),
              //                         items: <String>[
              //                           'All',
              //                           'Completed',
              //                           'Ongoing',
              //                           'Pending',
              //                           'Cancelled',
              //                         ].map<DropdownMenuItem<String>>(
              //                             (String value1) {
              //                           return DropdownMenuItem<String>(
              //                             value: value1,
              //                             child: Container(
              //                               width: 110,
              //                               child: Text(
              //                                 value1,
              //                                 style: const TextStyle(
              //                                   fontSize: 16,
              //                                 ),
              //                               ),
              //                             ),
              //                           );
              //                         }).toList(),
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(
              //                     width: 30,
              //                   ),
              //                   Visibility(
              //                     visible: open == false ? true : false,
              //                     child: const Padding(
              //                       padding: EdgeInsets.all(5.0),
              //                       child: Text(
              //                         "Subject:",
              //                         style: TextStyle(
              //                           fontWeight: FontWeight.w600,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   Visibility(
              //                     visible: open == false ? true : false,
              //                     child: Container(
              //                       padding:
              //                           const EdgeInsets.only(left: 5, right: 5),
              //                       width: 150,
              //                       height: 32,
              //                       decoration: BoxDecoration(
              //                         border: Border.all(
              //                           color: Colors.black45,
              //                           width: 1,
              //                         ),
              //                         borderRadius: BorderRadius.circular(5),
              //                         color: Colors.white,
              //                       ),
              //                       child: DropdownButton<String>(
              //                         elevation: 10,
              //                         value: tempdropdownValue,
              //                         onChanged: (newValue) {
              //                           setState(() {
              //                             tempdropdownValue = newValue!;
              //                           });
              //                         },
              //                         underline: Container(),
              //                         items: subjectnames
              //                             .map<DropdownMenuItem<String>>(
              //                                 (String value) {
              //                           return DropdownMenuItem<String>(
              //                             value: value,
              //                             child: Container(
              //                               width: 110,
              //                               child: Text(
              //                                 value,
              //                                 style: const TextStyle(
              //                                   fontSize: 16,
              //                                 ),
              //                               ),
              //                             ),
              //                           );
              //                         }).toList(),
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(
              //                     width: 10,
              //                   ),
              //                   Visibility(
              //                     visible: open == false ? true : false,
              //                     child: SizedBox(
              //                       width: 100,
              //                       child: ElevatedButton(
              //                         style: ElevatedButton.styleFrom(
              //                           backgroundColor: kColorPrimary,
              //                           shape: const RoundedRectangleBorder(
              //                               borderRadius: BorderRadius.all(
              //                                   Radius.circular(5))),
              //                         ),
              //                         onPressed: () {
              //                           setState(() {
              //                             _toselectedDate = _temptoselectedDate;
              //                             _fromselectedDate = _tempfromselectedDate;
              //                             statusValue = tempstatusValue;
              //                             List<SubjectClass> filteredSubjects =
              //                                 enrolledlist
              //                                     .expand((classesData) => classesData
              //                                         .subjectinfo
              //                                         .where((subject) => subject
              //                                             .subjectName
              //                                             .contains(
              //                                                 tempdropdownValue)))
              //                                     .toList();

              //                             subjectID = filteredSubjects.isNotEmpty
              //                                 ? filteredSubjects.first.subjectID
              //                                     .toString()
              //                                 : tempdropdownValue;
              //                           });
              //                         },
              //                         child: const Text('Search'),
              //                       ),
              //                     ),
              //                   ),
              //                   const Spacer(),
              //                 ],
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      }
    );
  }

  getclose() {
    setState(() {
      final provider = context.read<ViewClassDisplayProvider>();
      provider.setViewClassinfo(true);
    });
  }
}
