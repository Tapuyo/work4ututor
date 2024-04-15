// ignore_for_file: unused_element, unused_local_variable, sized_box_for_whitespace, avoid_web_libraries_in_flutter

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

import '../../../../utils/themes.dart';

class MyClasses extends StatefulWidget {
  final String uID;
  const MyClasses({super.key, required this.uID});

  @override
  State<MyClasses> createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
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
  ClassesData selectedclass = ClassesData(
      classid: '',
      subjectID: '',
      tutorID: '',
      studentID: '',
      materials: [],
      schedule: [],
      score: [],
      status: '',
      totalClasses: '',
      completedClasses: '',
      pendingClasses: '',
      dateEnrolled: DateTime.now(),
      studentinfo: [],
      tutorinfo: [],
      subjectinfo: []);

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
                    // bool isDateInRange =
                    //     item.dateEnrolled.isAfter(_fromselectedDate!) &&
                    //         item.dateEnrolled.isBefore(_toselectedDate!);

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
                            // Format the selected dates to compare only the date part
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
                .toSet() // Use a Set to eliminate duplicates
                .toList();
      });
    }

    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            elevation: 5,
            child: Container(
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
                    "CLASSES",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 35,
                    width: 170,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color.fromRGBO(1, 118, 132, 1),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        foregroundColor: const Color.fromRGBO(1, 118, 132, 1),
                        disabledBackgroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.deepPurple, // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        // ignore: prefer_const_constructors
                        textStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      onPressed: () {
                        html.window.open(
                            '/#/studentdiary/${widget.uID.toString()}/tutors',
                            '_blank');
                        // html.window.open('/tutorslist', "");
                        // js.context.callMethod('open', ['/tutorList', '_blank']);
                      },
                      icon: const Icon(
                        Icons.book_outlined,
                        size: 15,
                        color: kColorPrimary,
                      ),
                      label: const Text(
                        'SEARCH TUTOR',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: open == false ? true : false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width - 310,
                  height: 50,
                  child: Card(
                    elevation: 5.0,
                    child: Row(
                      children: [
                        // Visibility(
                        //   visible: open == true ? true : false,
                        //   child: TextButton.icon(
                        //     // <-- TextButton
                        //     onPressed: () {
                        //       setState(
                        //         () {
                        //           final provider = context
                        //               .read<ViewClassDisplayProvider>();
                        //           provider.setViewClassinfo(false);
                        //         },
                        //       );
                        //     },
                        //     icon: const Icon(
                        //       Icons.arrow_back,
                        //       size: 24.0,
                        //       color: Colors.black,
                        //     ),
                        //     label: const Text(
                        //       'Back',
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: open == false ? true : false,
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Date Enrolled:",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: open == false ? true : false,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    _tempfromselectedDate == null
                                        ? 'From'
                                        : DateFormat.yMMMMd()
                                            .format(_tempfromselectedDate!),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _pickDateDialog();
                                  },
                                  child: const Icon(
                                    Icons.calendar_month,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Visibility(
                          visible: open == false ? true : false,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    _temptoselectedDate == null
                                        ? 'To'
                                        : DateFormat.yMMMMd()
                                            .format(_temptoselectedDate!),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _topickDateDialog();
                                  },
                                  child: const Icon(
                                    Icons.calendar_month,
                                    size: 20,
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
                          visible: open == false ? true : false,
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Status:",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: open == false ? true : false,
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 5, right: 5),
                            width: 150,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              elevation: 10,
                              value: tempstatusValue,
                              onChanged: (statValue) {
                                setState(() {
                                  tempstatusValue = statValue!;
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
                                return DropdownMenuItem<String>(
                                  value: value1,
                                  child: Container(
                                    width: 110,
                                    child: Text(
                                      value1,
                                      style: const TextStyle(
                                        fontSize: 16,
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
                          visible: open == false ? true : false,
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Subject:",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: open == false ? true : false,
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 5, right: 5),
                            width: 150,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              elevation: 10,
                              value: tempdropdownValue,
                              onChanged: (newValue) {
                                setState(() {
                                  tempdropdownValue = newValue!;
                                });
                              },
                              underline: Container(),
                              items: subjectnames
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    width: 110,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: open == false ? true : false,
                          child: SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kColorPrimary,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))),
                              ),
                              onPressed: () {
                                setState(() {
                                  _toselectedDate = _temptoselectedDate;
                                  _fromselectedDate = _tempfromselectedDate;
                                  statusValue = tempstatusValue;
                                  List<SubjectClass> filteredSubjects =
                                      enrolledlist
                                          .expand((classesData) => classesData
                                              .subjectinfo
                                              .where((subject) => subject
                                                  .subjectName
                                                  .contains(
                                                      tempdropdownValue)))
                                          .toList();

                                  subjectID = filteredSubjects.isNotEmpty
                                      ? filteredSubjects.first.subjectID
                                          .toString()
                                      : tempdropdownValue;
                                });
                              },
                              child: const Text('Search'),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: size.width - 310,
            height: size.height - 80,
            child: newenrolledlist.isEmpty
                ? Container(
                    width: size.width - 320,
                    height: size.height - 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.list,
                          size: 50,
                          color: kColorPrimary,
                        ),
                        Text(
                          'No data found!',
                          style:
                              TextStyle(color: kCalendarColorB, fontSize: 18),
                        ),
                      ],
                    ))
                : enrolledlist.isEmpty
                    ? Container(
                        width: size.width - 320,
                        height: size.height - 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.list,
                              size: 50,
                              color: kColorPrimary,
                            ),
                            Text(
                              'No data found!',
                              style: TextStyle(
                                  color: kCalendarColorB, fontSize: 18),
                            ),
                          ],
                        ))
                    : Card(
                        child: open == false
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 10,
                                      right: 10,
                                      bottom: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        // Checkbox(
                                        //   checkColor: Colors.black,
                                        //   activeColor: Colors.green,
                                        //   value: select,
                                        //   onChanged: (value) {
                                        //     setState(() {
                                        //       select = value!;
                                        //     });
                                        //   },
                                        // ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "Tutor Name",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Spacer(
                                          flex: 2,
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Text(
                                          "Date Enrolled",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Spacer(
                                            // flex: 2,
                                            ),
                                        Text(
                                          "Subject",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Spacer(
                                            // flex: 1,
                                            ),
                                        Text(
                                          "Status",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Text(
                                          "Classes",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Spacer(
                                          flex: 2,
                                        ),
                                        Text(
                                          "Action",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Spacer(
                                            // flex: 1,
                                            ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    child: Divider(
                                      height: 1,
                                      thickness: 2,
                                    ),
                                  ),
                                  enrolledlist.isNotEmpty
                                      ? Consumer<List<Schedule>>(builder:
                                          (context, scheduleListdata, _) {
                                          dynamic data = scheduleListdata;
                                          return Container(
                                            width: size.width - 320,
                                            height: size.height - 175,
                                            child: ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: [
                                                  Container(
                                                    width: size.width - 320,
                                                    height: size.height - 175,
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
                                                            enrolledClass
                                                                .tutorinfo;
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

                                                        return SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          controller:
                                                              alllistscroll,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                color: (index %
                                                                            2 ==
                                                                        0)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors.grey[
                                                                        200],
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
                                                                    setState(
                                                                        () {
                                                                      selectedclass =
                                                                          enrolledClass;
                                                                    });
                                                                    final provider =
                                                                        context.read<
                                                                            ViewClassDisplayProvider>();
                                                                    provider
                                                                        .setViewClassinfo(
                                                                            true);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 5.0,
                                                                      left: 10,
                                                                      right: 10,
                                                                      bottom:
                                                                          5.0,
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        // Checkbox(
                                                                        //   checkColor: Colors.black,
                                                                        //   activeColor: Colors.red,
                                                                        //   value: select,
                                                                        //   onChanged: (value) {
                                                                        //     setState(() {
                                                                        //       select = value!;
                                                                        //     });
                                                                        //   },
                                                                        // ),
                                                                        SizedBox(
                                                                          width:
                                                                              300,
                                                                          child:
                                                                              ListTile(
                                                                            leading:
                                                                                CircleAvatar(
                                                                              backgroundImage: NetworkImage(
                                                                                tutorinfo.first.imageID.toString(),
                                                                              ),
                                                                              radius: 25,
                                                                            ),
                                                                            title:
                                                                                Text(
                                                                              '${(tutorinfo.first.firstName)}${(tutorinfo.first.middleName == 'N/A' || tutorinfo.first.middleName == '' ? '' : ' ${(tutorinfo.first.middleName)}')} ${(tutorinfo.first.lastname)}',
                                                                              // 'Name',
                                                                              style: const TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            ),
                                                                            subtitle:
                                                                                Text(
                                                                              tutorinfo.first.country,
                                                                              // 'Country',
                                                                              style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              Text(
                                                                            DateFormat('MMMM dd, yyyy').format(enrolledlist[index].dateEnrolled).toString(),
                                                                            style:
                                                                                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              120,
                                                                          child:
                                                                              Text(
                                                                            subjectinfo.first.subjectName,
                                                                            // 'Subject Name',
                                                                            style:
                                                                                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                100,
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                  color: enrolledlist[index].status == 'Pending'
                                                                                      ? kCalendarColorFB
                                                                                      : enrolledlist[index].status == 'Ongoing'
                                                                                          ? kColorSecondary
                                                                                          : enrolledlist[index].status == 'Completed'
                                                                                              ? Colors.green.shade200
                                                                                              : kCalendarColorB,
                                                                                ),
                                                                                child: Align(alignment: Alignment.center, child: Text(enrolledlist[index].status)))),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                230,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                ListTile(
                                                                                  title: Text('${(enrolledClass.totalClasses)} Classes'),
                                                                                  subtitle: enrolledlist[index].status == 'Cancelled' ? const Text('Cancelled Classes') : Text('Completed: ${(enrolledClass.completedClasses)} Class \nUpcoming: ${(filteredScheduleList.length)} Classes'),
                                                                                )
                                                                              ],
                                                                            )),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Tooltip(
                                                                                message: 'View Class',
                                                                                child: Container(
                                                                                  width: 90,
                                                                                  height: 30,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                    color: Colors.green.shade400,
                                                                                  ),
                                                                                  child: TextButton.icon(
                                                                                    style: TextButton.styleFrom(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      alignment: Alignment.center,
                                                                                      foregroundColor: const Color.fromRGBO(1, 118, 132, 1),
                                                                                      backgroundColor: Colors.green.shade200,
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
                                                                                        selectedclass = enrolledClass;
                                                                                      });
                                                                                      final provider = context.read<ViewClassDisplayProvider>();
                                                                                      provider.setViewClassinfo(true);
                                                                                    },
                                                                                    icon: const Icon(
                                                                                      Icons.open_in_new,
                                                                                      size: 15,
                                                                                    ),
                                                                                    label: const Text(
                                                                                      'View',
                                                                                      style: TextStyle(fontSize: 13),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Tooltip(
                                                                                message: 'Cancel Class',
                                                                                child: Container(
                                                                                  width: 90,
                                                                                  height: 30,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                    color: Colors.red.shade400,
                                                                                  ),
                                                                                  child: TextButton.icon(
                                                                                    style: TextButton.styleFrom(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      alignment: Alignment.center,
                                                                                      foregroundColor: const Color.fromRGBO(1, 118, 132, 1),
                                                                                      backgroundColor: Colors.red.shade200,
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
                                                                                    icon: const Icon(
                                                                                      Icons.cancel_presentation,
                                                                                      size: 15,
                                                                                    ),
                                                                                    label: const Text(
                                                                                      'Cancel',
                                                                                      style: TextStyle(fontSize: 13),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
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
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                          );
                                        })
                                      : Container(
                                          width: size.width - 320,
                                          height: size.height - 175,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                ],
                              )
                            : selectedclass.classid == ''
                                ? const Center(
                                    child: Text('Press back to select a class'),
                                  )
                                : StudentViewClassInfo(
                                    enrolledClass: selectedclass,
                                    uID: widget.uID,
                                  ),
                      ),
          ),
        ],
      ),
    );
  }

  getclose() {
    setState(() {
      final provider = context.read<ViewClassDisplayProvider>();
      provider.setViewClassinfo(true);
    });
  }
}
