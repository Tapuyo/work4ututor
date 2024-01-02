// ignore_for_file: unused_field, prefer_final_fields, unused_local_variable, sized_box_for_whitespace

import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/data_class/tutor_info_class.dart';
import 'package:work4ututor/ui/web/student/book_classes/setschedule.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../utils/themes.dart';
import '../../communication.dart/videocall.dart';
import '../../tutor/tutor_profile/view_file.dart';
import 'package:universal_html/html.dart' as html;

import 'cancelclasses.dart';
import 'rescheduleclasses.dart';

class StudentViewClassInfo extends StatefulWidget {
  final ClassesData? enrolledClass;
  const StudentViewClassInfo({super.key, required this.enrolledClass});

  @override
  State<StudentViewClassInfo> createState() => _StudentViewClassInfoState();
}

class _StudentViewClassInfoState extends State<StudentViewClassInfo> {
  void downloadFile(String fileUrl, String fileName, String mimeType) {
    html.AnchorElement(href: fileUrl)
      ..target = 'blank'
      ..download = fileName
      ..click();
  }

  Future<void> fetchFileData(String fileUrl) async {
    try {
      final html.HttpRequest request = await html.HttpRequest.request(
        fileUrl,
      );

      if (request.readyState == html.HttpRequest.DONE) {
        if (request.status == 200) {
          final ByteBuffer byteBuffer = request.response as ByteBuffer;
          final Uint8List uint8List = Uint8List.view(byteBuffer);
          final blob = html.Blob([uint8List]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          downloadFile(
              url, 'Emails_Student v1 (1).pdf', 'application/octet-stream');
          html.Url.revokeObjectUrl(url);
        } else {
          print('Error1: ${request.statusText}');
        }
      } else {
        print('Error2: Request not done');
      }
    } catch (e) {
      print('Error3: $e');
    }
  }

  bool _expanded = false;
  bool viewClassState = false;
  var formatter = DateFormat('MMMM, dd yyyy HH:mm:');
  DateTime datenow = DateTime.now();
  String profileurl = '';
  String? downloadURL;
  String? downloadURL1;
  String dueCancelDate(DateTime dateTime) {
    // DateTime due = DateFormat('d MMMM y').format(dateTime);
    Duration diff = dateTime.difference(DateTime.now());

    if (diff.inDays > 1) {
      return "${diff.inDays} Days";
    } else if (diff.inHours > 1) {
      return "${diff.inHours} Hours";
    } else {
      return "Is Overdue";
    }
  }

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

  ScrollController updatescrollController1 = ScrollController();

  String getFileNameFromUrl(String downloadUrl) {
    Uri uri = Uri.parse(downloadUrl);
    List<String> pathSegments = uri.pathSegments;

    // The last path segment contains the encoded filename
    String lastSegment = pathSegments.last;

    // Decode the filename
    String decodedFileName = Uri.decodeFull(lastSegment);

    // Extract only the filename without the path
    String filenameOnly = decodedFileName.split('/').last;

    return filenameOnly;
  }

  @override
  Widget build(BuildContext context) {
    bool selection5 = false;
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    const double fillPercent = 30; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];
    Size size = MediaQuery.of(context).size;
    bool showcancelresched = false;
    profileurl = widget.enrolledClass == null
        ? ''
        : widget.enrolledClass!.tutorinfo.first.imageID;
    // _updateResponse();
    List<ClassesMaterials>? materials =
        widget.enrolledClass == null ? null : widget.enrolledClass!.materials;
    materials!.sort((a, b) => a.session.compareTo(b.session));
    if (widget.enrolledClass == null) {
      return const Center(
        child: Text('Press back to select a class'),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.topCenter,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: gradient,
        //     stops: stops,
        //     end: Alignment.bottomCenter,
        //     begin: Alignment.topCenter,
        //   ),
        // ),
        width: size.width - 320,
        height: size.height + 900,
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Container(
                width: size.width - 320,
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    stops: stops,
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 10,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                        onTap: () {
                                          showDialog<DateTime>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ViewFile(
                                                imageURL: widget.enrolledClass!
                                                    .tutorinfo.first.imageID,
                                              );
                                            },
                                          ).then((selectedDate) {
                                            if (selectedDate != null) {
                                              // Do something with the selected date
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 250,
                                          width: 250,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    widget.enrolledClass!
                                                        .tutorinfo.first.imageID
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.cover)),
                                          //         child: const Icon(
                                          //   Icons.person,
                                          //   color: Colors.grey,
                                          //   size: 100,
                                          // ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: MediaQuery.of(context).size.height,
                      // child: const VerticalDivider(
                      //   thickness: 1,
                      // ),
                    ),
                    Flexible(
                      flex: 20,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${(widget.enrolledClass!.tutorinfo.first.firstName)}${(widget.enrolledClass!.tutorinfo.first.middleName == 'N/A' ? '' : ' ${(widget.enrolledClass!.tutorinfo.first.middleName)}')} ${(widget.enrolledClass!.tutorinfo.first.lastname)}, 28',
                                      style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            (widget.enrolledClass!.tutorinfo
                                                .first.country),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 20,
                                        // ),
                                        // Text(
                                        //   'Contact #: +123456789',
                                        //   style: TextStyle(
                                        //       fontSize: 25,
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.w500),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            (widget.enrolledClass!.subjectinfo
                                                .first.subjectName),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 20,
                                        // ),
                                        // Text(
                                        //   'Email: email@yahoo.com',
                                        //   style: TextStyle(
                                        //       fontSize: 25,
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.w500),
                                        // ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 680,
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 20,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              viewClassState == true
                                                  ? Colors.white
                                                  : kColorPrimary,
                                          disabledForegroundColor:
                                              Colors.blueGrey,
                                          disabledBackgroundColor:
                                              Colors.blueGrey,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            viewClassState = false;
                                          });
                                        },
                                        child: Text(
                                          'Class Info',
                                          style: TextStyle(
                                              color: viewClassState == true
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              viewClassState == false
                                                  ? Colors.white
                                                  : kColorPrimary,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            viewClassState = true;
                                          });
                                        },
                                        child: Text(
                                          'Materials',
                                          style: TextStyle(
                                              color: viewClassState == false
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                  child: Divider(color: Colors.grey),
                                ),
                                viewClassState == false
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            decoration: const BoxDecoration(
                                                color: kColorPrimary),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'About Class',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      "You are enrolled in a ",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${widget.enrolledClass!.totalClasses} sessions ",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "of ${widget.enrolledClass!.subjectinfo.first.subjectName}.",
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const TextSpan(
                                                  text:
                                                      " 50 minutes per class session.\nSchedule:",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Consumer<List<Schedule>>(builder:
                                              (context, scheduleListdata, _) {
                                            dynamic data = scheduleListdata;
                                            ClassesData? newclassdata =
                                                widget.enrolledClass;
                                            print('All data: ${data.length}');
                                            return Container(
                                              width: 600,
                                              // height: 30 * 3,
                                              child: ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: int.tryParse(
                                                      newclassdata!
                                                          .totalClasses),
                                                  itemBuilder:
                                                      (context, index) {
                                                    Schedule? temp;
                                                    List<Schedule>
                                                        filteredScheduleList =
                                                        data
                                                            .where((element) =>
                                                                element
                                                                    .scheduleID ==
                                                                widget
                                                                    .enrolledClass!
                                                                    .classid)
                                                            .toList();
                                                    print(
                                                        'Filtered data: ${filteredScheduleList.length}');
                                                    filteredScheduleList.sort(
                                                        (a, b) => a.schedule
                                                            .compareTo(
                                                                b.schedule));
                                                    final scheduledata =
                                                        filteredScheduleList
                                                                    .length >
                                                                index
                                                            ? filteredScheduleList[
                                                                index]
                                                            : null;
                                                    return Visibility(
                                                      visible: true,
                                                      child: Row(
                                                        children: [
                                                          filteredScheduleList
                                                                  .isEmpty
                                                              ? Text(
                                                                  (() {
                                                                    if (filteredScheduleList
                                                                            .isEmpty &&
                                                                        index ==
                                                                            0) {
                                                                      return "${(index + 1)}st session (Unschedule)";
                                                                    } else if (filteredScheduleList
                                                                            .isEmpty &&
                                                                        index ==
                                                                            1) {
                                                                      return "${(index + 1)}nd session (Unschedule)";
                                                                    } else if (filteredScheduleList
                                                                            .isEmpty &&
                                                                        index ==
                                                                            2) {
                                                                      return "${(index + 1)}rd session (Unschedule)";
                                                                    } else {
                                                                      return "${(index + 1)}th session (Unschedule)";
                                                                    }
                                                                  })(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                )
                                                              : Text(
                                                                  (() {
                                                                    if (filteredScheduleList
                                                                            .length >
                                                                        index) {
                                                                      if (index ==
                                                                          0) {
                                                                        return "${(index + 1)}st session  ${DateFormat('MMMM, dd yyyy').format(scheduledata!.schedule)} ${scheduledata.schedule.isAfter(DateTime.now()) ? '(Upcoming)' : '(Expired)'}";
                                                                      } else if (index ==
                                                                          1) {
                                                                        return "${(index + 1)}nd session  ${DateFormat('MMMM, dd yyyy').format(scheduledata!.schedule)} ${scheduledata.schedule.isAfter(DateTime.now()) ? '(Upcoming)' : '(Expired)'}";
                                                                      } else if (index ==
                                                                          2) {
                                                                        return "${(index + 1)}rd session  ${DateFormat('MMMM, dd yyyy').format(scheduledata!.schedule)} ${scheduledata.schedule.isAfter(DateTime.now()) ? '(Upcoming)' : '(Expired)'}";
                                                                      } else {
                                                                        return "${(index + 1)}th session  ${DateFormat('MMMM, dd yyyy').format(scheduledata!.schedule)} ${scheduledata.schedule.isAfter(DateTime.now()) ? '(Upcoming)' : '(Expired)'}";
                                                                      }
                                                                    } else {
                                                                      if (index ==
                                                                          0) {
                                                                        return "${(index + 1)}st session (Unschedule)";
                                                                      } else if (index ==
                                                                          1) {
                                                                        return "${(index + 1)}nd session (Unschedule)";
                                                                      } else if (index ==
                                                                          2) {
                                                                        return "${(index + 1)}rd session (Unschedule)";
                                                                      } else {
                                                                        return "${(index + 1)}th session (Unschedule)";
                                                                      }
                                                                    }
                                                                  })(),
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                ),
                                                          const Spacer(),
                                                          newclassdata.status ==
                                                                  'Cancelled'
                                                              ? const Center(
                                                                  child: Text(
                                                                    'Cancelled Class',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          kCalendarColorB,
                                                                      fontSize:
                                                                          18,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                )
                                                              : filteredScheduleList
                                                                          .length >
                                                                      index
                                                                  ? TextButton(
                                                                      child:
                                                                          const Text(
                                                                        "Reschedule",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.blue,
                                                                          fontSize:
                                                                              18,
                                                                          fontStyle:
                                                                              FontStyle.normal,
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        String
                                                                            dateresult =
                                                                            dueCancelDate(scheduledata!.schedule);
                                                                        print(
                                                                            dateresult);
                                                                        rescheduleclass(
                                                                            context, filteredScheduleList[index]);
                                                                      },
                                                                    )
                                                                  : TextButton(
                                                                      child:
                                                                          Text(
                                                                        "Set Schedule",
                                                                        style:
                                                                            TextStyle(
                                                                          color: Colors
                                                                              .green
                                                                              .shade400,
                                                                          fontSize:
                                                                              18,
                                                                          fontStyle:
                                                                              FontStyle.normal,
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        TutorInformation data = widget
                                                                            .enrolledClass!
                                                                            .tutorinfo
                                                                            .first;
                                                                        showDialog(
                                                                            barrierDismissible:
                                                                                false,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              var height = MediaQuery.of(context).size.height;
                                                                              var width = MediaQuery.of(context).size.width;
                                                                              return AlertDialog(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(15.0),
                                                                                ),
                                                                                contentPadding: EdgeInsets.zero,
                                                                                content: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(15.0),
                                                                                  child: Container(
                                                                                    color: Colors.white,
                                                                                    child: Stack(
                                                                                      children: <Widget>[
                                                                                        SizedBox(
                                                                                          height: height - 100,
                                                                                          width: width - 300,
                                                                                          child: SetScheduleData(
                                                                                            data: widget.enrolledClass,
                                                                                            session: index.toString(),
                                                                                          ),
                                                                                        ),
                                                                                        Positioned(
                                                                                          top: 10.0,
                                                                                          right: 10.0,
                                                                                          child: GestureDetector(
                                                                                            onTap: () {
                                                                                              Navigator.of(context).pop(false); // Close the dialog
                                                                                            },
                                                                                            child: const Icon(
                                                                                              Icons.close,
                                                                                              color: Colors.red,
                                                                                              size: 20,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }).then((selectedDate) {});
                                                                      },
                                                                    )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            );
                                          }),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          // Container(
                                          //   height: 40,
                                          //   padding: const EdgeInsets.fromLTRB(
                                          //       10, 0, 10, 0),
                                          //   decoration: const BoxDecoration(
                                          //       color: kColorPrimary),
                                          //   child: const Align(
                                          //     alignment: Alignment.centerLeft,
                                          //     child: Text(
                                          //       'Class Grade',
                                          //       style: TextStyle(
                                          //           fontSize: 18,
                                          //           fontWeight: FontWeight.bold,
                                          //           color: Colors.white),
                                          //     ),
                                          //   ),
                                          // ),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          // const Align(
                                          //   alignment: Alignment.centerLeft,
                                          //   child: SizedBox(
                                          //     height: 50,
                                          //     child: TextField(
                                          //       textAlignVertical:
                                          //           TextAlignVertical.top,
                                          //       maxLines: null,
                                          //       expands: true,
                                          //       decoration: InputDecoration(
                                          //         border: OutlineInputBorder(),
                                          //         hintText: 'eg. 100',
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          // Container(
                                          //   height: 40,
                                          //   padding: const EdgeInsets.fromLTRB(
                                          //       10, 0, 10, 0),
                                          //   decoration: const BoxDecoration(
                                          //       color: kColorPrimary),
                                          //   child: const Align(
                                          //     alignment: Alignment.centerLeft,
                                          //     child: Text(
                                          //       'Write down your comment',
                                          //       style: TextStyle(
                                          //           fontSize: 18,
                                          //           fontWeight: FontWeight.bold,
                                          //           color: Colors.white),
                                          //     ),
                                          //   ),
                                          // ),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          // const SizedBox(
                                          //   height: 200,
                                          //   child: TextField(
                                          //     textAlignVertical:
                                          //         TextAlignVertical.top,
                                          //     maxLines: null,
                                          //     expands: true,
                                          //     decoration: InputDecoration(
                                          //       border: OutlineInputBorder(),
                                          //       hintText:
                                          //           'Enter your comment....',
                                          //     ),
                                          //   ),
                                          // ),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          // Align(
                                          //   alignment: Alignment.centerRight,
                                          //   child: SizedBox(
                                          //     width: 130,
                                          //     height: 40,
                                          //     child: ElevatedButton(
                                          //       style: ElevatedButton.styleFrom(
                                          //         backgroundColor:
                                          //             kColorPrimary,
                                          //         shape:
                                          //             const RoundedRectangleBorder(
                                          //                 borderRadius:
                                          //                     BorderRadius.all(
                                          //                         Radius
                                          //                             .circular(
                                          //                                 20))),
                                          //       ),
                                          //       onPressed: () {},
                                          //       child: const Text('SAVE'),
                                          //     ),
                                          //   ),
                                          // ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Container(
                                            width: 600,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: int.tryParse(widget
                                                  .enrolledClass!.totalClasses),
                                              itemBuilder: (context, index) {
                                                final selectedmaterials =
                                                    materials.length > index
                                                        ? materials[index]
                                                        : null;
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  child: Card(
                                                    child: ExpansionTile(
                                                      title: Text(
                                                        (() {
                                                          if (materials
                                                              .isNotEmpty) {
                                                            if (materials
                                                                    .length >
                                                                index) {
                                                              if (selectedmaterials!
                                                                      .session ==
                                                                  '1') {
                                                                return "${(selectedmaterials.session)}st session materials.";
                                                              } else if (selectedmaterials
                                                                      .session ==
                                                                  '2') {
                                                                return "${(selectedmaterials.session)}nd session materials";
                                                              } else if (selectedmaterials
                                                                      .session ==
                                                                  '3') {
                                                                return "${(selectedmaterials.session)}rd session materials";
                                                              } else if (int.tryParse(
                                                                      selectedmaterials
                                                                          .session)! >
                                                                  3) {
                                                                return "${(selectedmaterials.session)}th session materials";
                                                              } else {
                                                                return "${(index + 1)}th session materials";
                                                              }
                                                            } else {
                                                              if (index == 0) {
                                                                return "${(index + 1)}st session materials";
                                                              } else if (index ==
                                                                  1) {
                                                                return "${(index + 1)}nd session materials";
                                                              } else if (index ==
                                                                  2) {
                                                                return "${(index + 1)}rd session materials";
                                                              } else {
                                                                return "${(index + 1)}th session materials";
                                                              }
                                                            }
                                                          } else {
                                                            if (index == 0) {
                                                              return "${(index + 1)}st session materials.";
                                                            } else if (index ==
                                                                1) {
                                                              return "${(index + 1)}nd session materials";
                                                            } else if (index ==
                                                                2) {
                                                              return "${(index + 1)}rd session materials";
                                                            } else {
                                                              return "${(index + 1)}th session materials";
                                                            }
                                                          }
                                                        })(),
                                                      ),
                                                      children: <Widget>[
                                                        widget.enrolledClass!
                                                                    .status ==
                                                                'Cancelled'
                                                            ? const Text(
                                                                'Cancelled Class',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color:
                                                                        kCalendarColorB),
                                                              )
                                                            : Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        16.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const Text(
                                                                            'Files:'),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          '(Please download the file for your reference!)',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.blue.shade200,
                                                                              fontStyle: FontStyle.italic),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // Padding(
                                                                  //   padding:
                                                                  //       const EdgeInsets
                                                                  //               .fromLTRB(
                                                                  //           50,
                                                                  //           10,
                                                                  //           50,
                                                                  //           10),
                                                                  //   child: TextFormField(
                                                                  //     decoration:
                                                                  //         const InputDecoration(
                                                                  //       labelText:
                                                                  //           'Add notes here',
                                                                  //       border:
                                                                  //           OutlineInputBorder(
                                                                  //         borderSide:
                                                                  //             BorderSide(),
                                                                  //         gapPadding: 0,
                                                                  //       ),
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                  // Align(
                                                                  //   alignment: Alignment
                                                                  //       .topRight,
                                                                  //   child: Padding(
                                                                  //     padding:
                                                                  //         const EdgeInsets
                                                                  //                 .fromLTRB(
                                                                  //             50,
                                                                  //             0,
                                                                  //             50,
                                                                  //             10),
                                                                  //     child: SizedBox(
                                                                  //       width: 100,
                                                                  //       height: 40,
                                                                  //       child:
                                                                  //           ElevatedButton(
                                                                  //         style: ElevatedButton
                                                                  //             .styleFrom(
                                                                  //           minimumSize:
                                                                  //               Size.zero,
                                                                  //           padding:
                                                                  //               EdgeInsets
                                                                  //                   .zero,
                                                                  //           backgroundColor:
                                                                  //               kColorPrimary,
                                                                  //           shape: const RoundedRectangleBorder(
                                                                  //               borderRadius:
                                                                  //                   BorderRadius.all(
                                                                  //                       Radius.circular(15))),
                                                                  //         ),
                                                                  //         onPressed:
                                                                  //             () {},
                                                                  //         // icon: const Icon(Icons.attach_file_outlined, color: kColorPrimary,),
                                                                  //         child:
                                                                  //             const Text(
                                                                  //           'Save',
                                                                  //           style: TextStyle(
                                                                  //               color: Colors
                                                                  //                   .white),
                                                                  //         ),
                                                                  //       ),
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                  Container(
                                                                      width:
                                                                          600,
                                                                      height:
                                                                          100,
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              10,
                                                                              0,
                                                                              10,
                                                                              0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          IconButton(
                                                                            iconSize:
                                                                                12,
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            splashRadius:
                                                                                1,
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.arrow_back_ios, // Left arrow icon
                                                                              color: Colors.blue,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              // Scroll to the left
                                                                              updatescrollController1.animateTo(
                                                                                updatescrollController1.offset - 100.0, // Adjust the value as needed
                                                                                duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                                                                                curve: Curves.ease,
                                                                              );
                                                                            },
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                ListView.builder(
                                                                              shrinkWrap: true,
                                                                              controller: updatescrollController1, // Assign the ScrollController to the ListView
                                                                              scrollDirection: Axis.horizontal,
                                                                              itemCount: widget.enrolledClass!.tutorinfo.first.certificates.length,
                                                                              itemBuilder: (context, index) {
                                                                                if (widget.enrolledClass!.tutorinfo.first.certificatestype[index] == 'Image') {
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Column(
                                                                                          children: [
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                showDialog(
                                                                                                    barrierDismissible: false,
                                                                                                    context: context,
                                                                                                    builder: (BuildContext context) {
                                                                                                      var height = MediaQuery.of(context).size.height;
                                                                                                      return AlertDialog(
                                                                                                        shape: RoundedRectangleBorder(
                                                                                                          borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                                                        ),
                                                                                                        contentPadding: EdgeInsets.zero,
                                                                                                        content: ClipRRect(
                                                                                                          borderRadius: BorderRadius.circular(15.0), // Same radius as above
                                                                                                          child: Container(
                                                                                                            color: Colors.white, // Set the background color of the circular content

                                                                                                            child: Stack(
                                                                                                              children: <Widget>[
                                                                                                                SizedBox(
                                                                                                                  height: height,
                                                                                                                  width: 900,
                                                                                                                  child: ViewFile(imageURL: widget.enrolledClass!.tutorinfo.first.certificates[index]),
                                                                                                                ),
                                                                                                                Positioned(
                                                                                                                  top: 10.0,
                                                                                                                  right: 10.0,
                                                                                                                  child: GestureDetector(
                                                                                                                    onTap: () {
                                                                                                                      Navigator.of(context).pop(false); // Close the dialog
                                                                                                                    },
                                                                                                                    child: const Icon(
                                                                                                                      Icons.close,
                                                                                                                      color: Colors.red,
                                                                                                                      size: 20,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                    });
                                                                                                // showDialog(
                                                                                                //     barrierDismissible:
                                                                                                //         false,
                                                                                                //     context:
                                                                                                //         context,
                                                                                                //     builder:
                                                                                                //         (BuildContext
                                                                                                //             context) {
                                                                                                //       return ViewFile(
                                                                                                //           imageURL:
                                                                                                //               widget.tutorsinfo['certificates'][index]);
                                                                                                //     });
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 60,
                                                                                                width: 60,
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                  color: Colors.grey.shade200, // You can adjust the fit as needed.
                                                                                                ),
                                                                                                child: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                  child: Image.network(
                                                                                                    widget.enrolledClass!.tutorinfo.first.certificates[index],
                                                                                                    fit: BoxFit.cover, // You can adjust the fit as needed.
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Tooltip(
                                                                                                message: getFileNameFromUrl(widget.enrolledClass!.tutorinfo.first.certificates[index]),
                                                                                                child: SizedBox(
                                                                                                  height: 60,
                                                                                                  width: 60,
                                                                                                  child: TextButton(
                                                                                                    onPressed: () {
                                                                                                      setState(() {
                                                                                                        fetchFileData(widget.enrolledClass!.tutorinfo.first.certificates[index]);
                                                                                                      });
                                                                                                    },
                                                                                                    child: Text(
                                                                                                      getFileNameFromUrl(widget.enrolledClass!.tutorinfo.first.certificates[index]),
                                                                                                      style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                } else if (widget.enrolledClass!.tutorinfo.first.certificatestype[index] == 'pdf') {
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Column(
                                                                                          children: [
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                showDialog(
                                                                                                    barrierDismissible: false,
                                                                                                    context: context,
                                                                                                    builder: (BuildContext context) {
                                                                                                      var height = MediaQuery.of(context).size.height;
                                                                                                      return AlertDialog(
                                                                                                        shape: RoundedRectangleBorder(
                                                                                                          borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                                                        ),
                                                                                                        contentPadding: EdgeInsets.zero,
                                                                                                        content: ClipRRect(
                                                                                                          borderRadius: BorderRadius.circular(15.0), // Same radius as above
                                                                                                          child: Container(
                                                                                                            color: Colors.white, // Set the background color of the circular content

                                                                                                            child: Stack(
                                                                                                              children: <Widget>[
                                                                                                                SizedBox(
                                                                                                                  height: height,
                                                                                                                  width: 900,
                                                                                                                  child: ViewFile(imageURL: widget.enrolledClass!.tutorinfo.first.certificates[index]),
                                                                                                                ),
                                                                                                                Positioned(
                                                                                                                  top: 10.0,
                                                                                                                  right: 10.0,
                                                                                                                  child: GestureDetector(
                                                                                                                    onTap: () {
                                                                                                                      Navigator.of(context).pop(false); // Close the dialog
                                                                                                                    },
                                                                                                                    child: const Icon(
                                                                                                                      Icons.close,
                                                                                                                      color: Colors.red,
                                                                                                                      size: 20,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                    });
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 60,
                                                                                                width: 60,
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                  color: Colors.grey.shade200, // You can adjust the fit as needed.
                                                                                                ),
                                                                                                child: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                  child: const Icon(
                                                                                                    Icons.picture_as_pdf,
                                                                                                    size: 48,
                                                                                                    color: Colors.red,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: TextButton(
                                                                                                onPressed: () {},
                                                                                                child: Text(
                                                                                                  getFileNameFromUrl(widget.enrolledClass!.tutorinfo.first.certificates[index]),
                                                                                                  style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Column(
                                                                                          children: [
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                showDialog(
                                                                                                    barrierDismissible: false,
                                                                                                    context: context,
                                                                                                    builder: (BuildContext context) {
                                                                                                      var height = MediaQuery.of(context).size.height;
                                                                                                      return AlertDialog(
                                                                                                        shape: RoundedRectangleBorder(
                                                                                                          borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                                                        ),
                                                                                                        contentPadding: EdgeInsets.zero,
                                                                                                        content: ClipRRect(
                                                                                                          borderRadius: BorderRadius.circular(15.0), // Same radius as above
                                                                                                          child: Container(
                                                                                                            color: Colors.white, // Set the background color of the circular content

                                                                                                            child: Stack(
                                                                                                              children: <Widget>[
                                                                                                                SizedBox(
                                                                                                                  height: height,
                                                                                                                  width: 900,
                                                                                                                  child: ViewFile(imageURL: widget.enrolledClass!.tutorinfo.first.certificates[index]),
                                                                                                                ),
                                                                                                                Positioned(
                                                                                                                  top: 10.0,
                                                                                                                  right: 10.0,
                                                                                                                  child: GestureDetector(
                                                                                                                    onTap: () {
                                                                                                                      Navigator.of(context).pop(false); // Close the dialog
                                                                                                                    },
                                                                                                                    child: const Icon(
                                                                                                                      Icons.close,
                                                                                                                      color: Colors.red,
                                                                                                                      size: 20,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                    });
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 60,
                                                                                                width: 60,
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                  color: Colors.grey.shade200, // You can adjust the fit as needed.
                                                                                                ),
                                                                                                child: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                  child: const Icon(
                                                                                                    FontAwesomeIcons.fileWord,
                                                                                                    size: 48,
                                                                                                    color: Colors.blue,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: TextButton(
                                                                                                onPressed: () {},
                                                                                                child: Text(
                                                                                                  getFileNameFromUrl(widget.enrolledClass!.tutorinfo.first.certificates[index]),
                                                                                                  style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                          ),
                                                                          IconButton(
                                                                            iconSize:
                                                                                12,
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            splashRadius:
                                                                                1,
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.arrow_forward_ios, // Right arrow icon
                                                                              color: Colors.blue,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              // Scroll to the right
                                                                              updatescrollController1.animateTo(
                                                                                updatescrollController1.offset + 100.0, // Adjust the value as needed
                                                                                duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                                                                                curve: Curves.ease,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      )),

                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        16.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const Text(
                                                                            'Class Video Meeting:'),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        // SizedBox(
                                                                        //   width: 180,
                                                                        //   height: 40,
                                                                        //   child:
                                                                        //       ElevatedButton
                                                                        //           .icon(
                                                                        //     style: ElevatedButton
                                                                        //         .styleFrom(
                                                                        //       backgroundColor:
                                                                        //           Colors
                                                                        //               .white,
                                                                        //       shape: const RoundedRectangleBorder(
                                                                        //           borderRadius:
                                                                        //               BorderRadius.all(Radius.circular(15))),
                                                                        //     ),
                                                                        //     onPressed:
                                                                        //         () {},
                                                                        //     icon:
                                                                        //         const Icon(
                                                                        //       Icons
                                                                        //           .video_camera_back_outlined,
                                                                        //       color:
                                                                        //           kColorPrimary,
                                                                        //     ),
                                                                        //     label:
                                                                        //         const Text(
                                                                        //       'Set up Class Link',
                                                                        //       style: TextStyle(
                                                                        //           color:
                                                                        //               kColorPrimary),
                                                                        //     ),
                                                                        //   ),
                                                                        // ),
                                                                        Text(
                                                                          '(Click the link to join the class!)',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.blue.shade200,
                                                                              fontStyle: FontStyle.italic),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            50,
                                                                            10,
                                                                            50,
                                                                            10),
                                                                    child: Text(
                                                                      '(No link attached message tutor to set up class link!)',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: Colors
                                                                              .blue
                                                                              .shade200,
                                                                          fontStyle:
                                                                              FontStyle.italic),
                                                                    ),
                                                                    //add link here
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  //   Padding(
                                                                  //     padding:
                                                                  //         const EdgeInsets
                                                                  //                 .fromLTRB(
                                                                  //             50,
                                                                  //             10,
                                                                  //             50,
                                                                  //             10),
                                                                  //     child: Align(
                                                                  //       alignment: Alignment
                                                                  //           .centerRight,
                                                                  //       child: SizedBox(
                                                                  //         width: 150,
                                                                  //         height: 40,
                                                                  //         child:
                                                                  //             ElevatedButton(
                                                                  //           style: ElevatedButton
                                                                  //               .styleFrom(
                                                                  //             backgroundColor:
                                                                  //                 kColorPrimary,
                                                                  //             shape: const RoundedRectangleBorder(
                                                                  //                 borderRadius:
                                                                  //                     BorderRadius.all(
                                                                  //                         Radius.circular(20))),
                                                                  //           ),
                                                                  //           onPressed: () {
                                                                  //             Navigator
                                                                  //                 .push(
                                                                  //               context,
                                                                  //               MaterialPageRoute(
                                                                  //                   builder: (context) =>
                                                                  //                       const VideoCall(
                                                                  //                         chatID: '',
                                                                  //                         uID: '',
                                                                  //                       )),
                                                                  //             );
                                                                  //           },
                                                                  //           child: const Text(
                                                                  //               'Join Class Link'),
                                                                  //         ),
                                                                  //       ),
                                                                  //     ),
                                                                  //   ),
                                                                ],
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                        // child: VerticalDivider(),
                      ),
                      Flexible(
                          flex: 13,
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), //<-- SEE HERE
                                ),
                                elevation: 1,
                                child: Container(
                                  width: 380,
                                  height: 300,
                                  padding: const EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Class Session',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )),
                                      ),
                                      Consumer<List<Schedule>>(builder:
                                          (context, scheduleListdata, _) {
                                        dynamic data = scheduleListdata;
                                        ClassesData? newclassdata =
                                            widget.enrolledClass;
                                        List<Schedule> filtereddata = data
                                            .where((element) =>
                                                element.scheduleID ==
                                                widget.enrolledClass!.classid)
                                            .toList();
                                        print(
                                            'Filtered data: ${filtereddata.length}');
                                        filtereddata.sort((a, b) =>
                                            a.schedule.compareTo(b.schedule));
                                        print('All data: ${data.length}');
                                        return Container(
                                          width: 380,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(
                                              30, 10, 30, 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: filtereddata.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      (() {
                                                        if (index == 0) {
                                                          return "${(index + 1)}st Class Session";
                                                        } else if (index == 1) {
                                                          return "${(index + 1)}nd Class Session";
                                                        } else if (index == 2) {
                                                          return "${(index + 1)}rd Class Session";
                                                        } else {
                                                          return "${(index + 1)}th Class Session";
                                                        }
                                                      })(),
                                                    ),
                                                    const Spacer(),
                                                    SizedBox(
                                                      width: 170,
                                                      height: 40,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15))),
                                                        ),
                                                        onPressed: () {},
                                                        child: const Text(
                                                          'Complete Session',
                                                          style: TextStyle(
                                                              color:
                                                                  kColorPrimary),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                      const Spacer(),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), //<-- SEE HERE
                                        ),
                                        elevation: 1,
                                        child: Container(
                                          width: 380,
                                          height: 65,
                                          alignment: Alignment.center,
                                          // padding:
                                          // const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const [
                                                Icon(EvaIcons.clockOutline),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '50 minutes per class session',
                                                  textAlign: TextAlign.justify,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), //<-- SEE HERE
                                ),
                                child: Container(
                                  width: 380,
                                  height: 100,
                                  alignment: Alignment.center,
                                  // padding:
                                  // const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: .1,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'A class by',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            50, 5, 50, 5),
                                        child: ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Colors.black12,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          title: Text(
                                            '${(widget.enrolledClass!.tutorinfo.first.firstName)}${(widget.enrolledClass!.tutorinfo.first.middleName == 'N/A' ? '' : ' ${(widget.enrolledClass!.tutorinfo.first.middleName)}')} ${(widget.enrolledClass!.tutorinfo.first.lastname)}, 28',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                              (widget.enrolledClass!.subjectinfo
                                                  .first.subjectName),
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                          onTap: () {
                                            // Navigate to user profile page
                                            // Navigator.pushNamed(context, '/profile',
                                            //     arguments: {'username': users[index]['name']});
                                            //  final provider =
                                            //           context.read<ChatDisplayProvider>();
                                            //       provider.setOpenMessage(true);
                                          },
                                        ),
                                      ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                      //   children: const [
                                      //     Icon(EvaIcons.clockOutline),
                                      //     Text('50 minutes per class session')
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
