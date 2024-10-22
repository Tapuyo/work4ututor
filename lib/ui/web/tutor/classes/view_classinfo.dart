// ignore_for_file: unused_field, prefer_final_fields, unused_local_variable, sized_box_for_whitespace

import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/terms/termpage.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../provider/classinfo_provider.dart';
import '../../../../services/addfinishedclass.dart';
import '../../../../services/addmaterial.dart';
import '../../../../services/deletematerial.dart';
import '../../../../services/getmaterials.dart';
import '../../../../services/gettutorpayments.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';
import '../../student/book_classes/rescheduleclasses.dart';
import '../tutor_profile/view_file.dart';
import 'package:universal_html/html.dart' as html;

class ViewClassInfo extends StatefulWidget {
  final ClassesData enrolledClass;
  final String timezone;
  const ViewClassInfo({super.key, required this.enrolledClass, required this.timezone});

  @override
  State<ViewClassInfo> createState() => _ViewClassInfoState();
}

class _ViewClassInfoState extends State<ViewClassInfo> {
  @override
  void initState() {
    super.initState();
    // Call getMaterials method here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final materialNotifier =
          Provider.of<MaterialNotifier>(context, listen: false);
      materialNotifier.getMaterials(widget.enrolledClass.classid);
    });
  }

  final List<ClassesData> _tiles = [];

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

  void downloadFile(String fileUrl, String fileName, String mimeType) {
    html.AnchorElement(href: fileUrl)
      ..target = 'blank'
      ..download = fileName
      ..click();
  }

  Future<void> fetchFileData(String filepath) async {
    // Reference to the file in Firebase Storage
    Reference ref = FirebaseStorage.instance.ref(filepath);

    // Get the download URL
    String downloadURL = await ref.getDownloadURL();

    // Create an anchor element (a) with the download URL
    html.AnchorElement(href: downloadURL)
      ..target = 'blank'
      ..click();
  }

  Future<void> fetchFileData1(String fileUrl) async {
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

  GlobalKey progressKey = GlobalKey();
  Uint8List? selectedImage;
  String filename = '';
  int progressupload = 0;
  void selectImage(String classID, classNo) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result != null) {
      Uint8List selectedImage = result.files.first.bytes!;
      String filename = result.files.first.name;

      void updateProgress(int progress) {
        setState(() {
          progressupload = progress;
        });
      }

      bool? downloadURL = await uploadMaterialProfile(
          classID, selectedImage, filename, classNo, updateProgress);
    }
    if (downloadURL != null) {
      setState(() {
        progressupload = 0;
      });
    }
  }

  void handleUpload(String message, bool isSuccess) {
    Color backgroundColor =
        isSuccess ? Colors.lightGreen.shade500 : Colors.redAccent.shade400;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 5),
        dismissDirection: DismissDirection.endToStart,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ClaimableNotifier>(context, listen: false)
        .getClaims(widget.enrolledClass.tutorID, 'tutor');
    bool selection5 = false;
    const Color background = Color(0xFF377487);
    const Color fill = Colors.white;
    final List<Color> gradient = [
      ...secondaryHeadercolors,
      background,
      fill,
      fill,
    ];

    const double fillPercent = 30; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];
    Size size = MediaQuery.of(context).size;
    bool showcancelresched = false;
    profileurl = widget.enrolledClass.studentinfo.first.profilelink;
    // _updateResponse();
    List<ClassesMaterials> materials = widget.enrolledClass.materials;
    materials.sort((a, b) => a.session.compareTo(b.session));
    return Container(
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
      width:
          ResponsiveBuilder.isDesktop(context) ? size.width - 290 : size.width,
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Container(
              width: ResponsiveBuilder.isDesktop(context)
                  ? size.width - 300
                  : size.width,
              height: ResponsiveBuilder.isMobile(context) ? 200 : 300,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    ...secondaryHeadercolors,
                    ...[Colors.white, Colors.white],
                  ],
                  stops: stops,
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Tooltip(
                        message: 'Back',
                        child: IconButton(
                          // <-- TextButton
                          onPressed: () {
                            setState(
                              () {
                                final provider =
                                    context.read<ViewClassDisplayProvider>();
                                provider.setViewClassinfo(false);
                              },
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size:
                                ResponsiveBuilder.isMobile(context) ? 10 : 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: ResponsiveBuilder.isDesktop(context) ? 100 : 0,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
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
                                  ClipRect(
                                    child: Padding(
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
                                                  imageURL: downloadURL1,
                                                );
                                              },
                                            ).then((selectedDate) {
                                              if (selectedDate != null) {
                                                // Do something with the selected date
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: ResponsiveBuilder.isMobile(
                                                    context)
                                                ? 150
                                                : 250,
                                            width: ResponsiveBuilder.isMobile(
                                                    context)
                                                ? 150
                                                : 250,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                      widget
                                                          .enrolledClass
                                                          .studentinfo
                                                          .first
                                                          .profilelink
                                                          .toString(),
                                                    ),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: ResponsiveBuilder.isDesktop(context) ? 50 : 10,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Flexible(
                    flex: 20,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${(widget.enrolledClass.studentinfo.first.studentFirstname)}${(widget.enrolledClass.studentinfo.first.studentMiddlename == 'N/A' ? '' : ' ${(widget.enrolledClass.studentinfo.first.studentMiddlename)}')} ${(widget.enrolledClass.studentinfo.first.studentLastname)}, 18',
                                    style: TextStyle(
                                        fontSize:
                                            ResponsiveBuilder.isMobile(context)
                                                ? 20
                                                : 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 5,
                                        child: Text(
                                          (widget.enrolledClass.studentinfo
                                              .first.country),
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveBuilder.isMobile(
                                                          context)
                                                      ? 15
                                                      : 25,
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
                                          (widget.enrolledClass.subjectinfo
                                              .first.subjectName),
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveBuilder.isMobile(
                                                          context)
                                                      ? 15
                                                      : 25,
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
              height: size.width >= 822 ? 450 : 790,
              padding: ResponsiveBuilder.isMobile(context)
                  ? const EdgeInsets.fromLTRB(25, 0, 25, 0)
                  : const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: size.width >= 822
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 20,
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    child: TabBar(
                                      indicator: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 4),
                                              blurRadius: 5.0)
                                        ],
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          colors: buttonFocuscolors,
                                        ),
                                        color: Colors.deepPurple.shade300,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      indicatorColor: Colors.transparent,
                                      tabs: const [
                                        Tab(
                                          icon: Icon(
                                              Icons.insert_drive_file_outlined),
                                          text: 'Class Info',
                                          iconMargin:
                                              EdgeInsets.only(bottom: 3),
                                        ),
                                        Tab(
                                          icon: Icon(Icons.list_alt_outlined),
                                          text: 'Materials',
                                          iconMargin:
                                              EdgeInsets.only(bottom: 3),
                                        ),
                                      ],
                                      unselectedLabelColor: Colors.grey,
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      labelColor: Colors.white,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 20,
                                    child: TabBarView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: SingleChildScrollView(
                                            controller: ScrollController(),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text:
                                                            "You are enrolled in ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: kColorGrey,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "${widget.enrolledClass.totalClasses} classes ",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kColorGrey,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "of ${widget.enrolledClass.subjectinfo.first.subjectName}.",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kColorGrey,
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                        text:
                                                            "\nEach class lasts ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: kColorGrey,
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                        text: "50 minutes",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kColorGrey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  "Schedule:",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: kColorGrey,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Consumer<List<Schedule>>(
                                                    builder: (context,
                                                        scheduleListdata, _) {
                                                  dynamic data =
                                                      scheduleListdata;
                                                  ClassesData? newclassdata =
                                                      widget.enrolledClass;
                                                  return Container(
                                                    width: 600,
                                                    // height: 30 * 3,
                                                    child: ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: int.tryParse(
                                                            newclassdata
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
                                                                          .enrolledClass
                                                                          .classid)
                                                                  .toList();

                                                          filteredScheduleList
                                                              .sort((a, b) => a
                                                                  .schedule
                                                                  .compareTo(b
                                                                      .schedule));
                                                          final scheduledata =
                                                              filteredScheduleList
                                                                          .length >
                                                                      index
                                                                  ? filteredScheduleList[
                                                                      index]
                                                                  : null;
                                                          return Visibility(
                                                            visible: true,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Row(
                                                                children: [
                                                                  filteredScheduleList
                                                                          .isEmpty
                                                                      ? Text(
                                                                          (() {
                                                                            if (filteredScheduleList.isEmpty &&
                                                                                index == 0) {
                                                                              return "${(index + 1)}st class (Unschedule)";
                                                                            } else if (filteredScheduleList.isEmpty && index == 1) {
                                                                              return "${(index + 1)}nd class (Unschedule)";
                                                                            } else if (filteredScheduleList.isEmpty && index == 2) {
                                                                              return "${(index + 1)}rd class (Unschedule)";
                                                                            } else {
                                                                              return "${(index + 1)}th class (Unschedule)";
                                                                            }
                                                                          })(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontStyle:
                                                                                FontStyle.normal,
                                                                            color:
                                                                                kColorGrey,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        )
                                                                      : Text(
                                                                          (() {
                                                                            if (filteredScheduleList.length >
                                                                                index) {
                                                                              if (index == 0) {
                                                                                return "${(index + 1)}st class  ${DateFormat('MMMM, dd yyyy').format(scheduledata!.schedule)} ${scheduledata.schedule.isAfter(DateTime.now()) ? ' ' : ' '}";
                                                                              } else if (index == 1) {
                                                                                return "${(index + 1)}nd class  ${DateFormat('MMMM, dd yyyy').format(scheduledata!.schedule)} ${scheduledata.schedule.isAfter(DateTime.now()) ? ' ' : ' '}";
                                                                              } else if (index == 2) {
                                                                                return "${(index + 1)}rd class  ${DateFormat('MMMM, dd yyyy').format(scheduledata!.schedule)} ${scheduledata.schedule.isAfter(DateTime.now()) ? ' ' : ' '}";
                                                                              } else {
                                                                                return "${(index + 1)}th class  ${DateFormat('MMMM, dd yyyy').format(scheduledata!.schedule)} ${scheduledata.schedule.isAfter(DateTime.now()) ? ' ' : ' '}";
                                                                              }
                                                                            } else {
                                                                              if (index == 0) {
                                                                                return "${(index + 1)}st class ";
                                                                              } else if (index == 1) {
                                                                                return "${(index + 1)}nd class ";
                                                                              } else if (index == 2) {
                                                                                return "${(index + 1)}rd class ";
                                                                              } else {
                                                                                return "${(index + 1)}th class ";
                                                                              }
                                                                            }
                                                                          })(),
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                kColorGrey,
                                                                            fontSize:
                                                                                16,
                                                                            fontStyle:
                                                                                FontStyle.normal,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ),
                                                                  const Spacer(),
                                                                  newclassdata.status ==
                                                                          'Cancelled'
                                                                      ? const Center(
                                                                          child:
                                                                              Text(
                                                                            'Cancelled Class',
                                                                            style:
                                                                                TextStyle(
                                                                              color: kCalendarColorB,
                                                                              fontSize: 18,
                                                                              fontStyle: FontStyle.normal,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : filteredScheduleList.length >
                                                                              index
                                                                          ? filteredScheduleList[index].classstatus == 'finish'
                                                                              ? RatingBar(
                                                                                  ignoreGestures: true,
                                                                                  initialRating: filteredScheduleList[index].rating == '' ? 0 : double.parse(filteredScheduleList[index].rating),
                                                                                  direction: Axis.horizontal,
                                                                                  allowHalfRating: false,
                                                                                  itemCount: 5,
                                                                                  itemSize: 18,
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
                                                                                  })
                                                                              : TextButton(
                                                                                  child: const Text(
                                                                                    "Reschedule",
                                                                                    style: TextStyle(
                                                                                      color: kColorPrimary,
                                                                                      fontSize: 16,
                                                                                      fontStyle: FontStyle.normal,
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    String dateresult = dueCancelDate(scheduledata!.schedule);

                                                                                    rescheduleclass(context, filteredScheduleList[index], widget.timezone);
                                                                                  },
                                                                                )
                                                                          :
                                                                          // filteredScheduleList[index].tutorStatus == 'Completed'
                                                                          //     ? RatingBar(
                                                                          //         ignoreGestures: true,
                                                                          //         initialRating: filteredScheduleList[index].rating == '' ? 0 : double.parse(filteredScheduleList[index].rating),
                                                                          //         direction: Axis.horizontal,
                                                                          //         allowHalfRating: false,
                                                                          //         itemCount: 5,
                                                                          //         itemSize: 18,
                                                                          //         ratingWidget: RatingWidget(
                                                                          //             full: const Icon(Icons.star, color: Colors.orange),
                                                                          //             half: const Icon(
                                                                          //               Icons.star_half,
                                                                          //               color: Colors.orange,
                                                                          //             ),
                                                                          //             empty: const Icon(
                                                                          //               Icons.star_outline,
                                                                          //               color: Colors.orange,
                                                                          //             )),
                                                                          //         onRatingUpdate: (value) {
                                                                          //           // _ratingValue = value;
                                                                          //         })
                                                                          //     :
                                                                          Container(),
                                                                ],
                                                              ),
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
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: SingleChildScrollView(
                                            controller: ScrollController(),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 600,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: int.tryParse(
                                                        widget.enrolledClass
                                                            .totalClasses),
                                                    itemBuilder:
                                                        (context, index) {
                                                      final selectedmaterials =
                                                          materials.length >
                                                                  index
                                                              ? materials[index]
                                                              : null;

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10.0),
                                                        child: Card(
                                                                    color: Colors.white,

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
                                                                            selectedmaterials.session)! >
                                                                        3) {
                                                                      return "${(selectedmaterials.session)}th session materials";
                                                                    } else {
                                                                      return "${(index + 1)}th session materials";
                                                                    }
                                                                  } else {
                                                                    if (index ==
                                                                        0) {
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
                                                                  if (index ==
                                                                      0) {
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
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    kColorGrey,
                                                              ),
                                                            ),
                                                            children: <Widget>[
                                                              widget.enrolledClass
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
                                                                          padding:
                                                                              const EdgeInsets.all(16.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              const Text('Files:'),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              SizedBox(
                                                                                width: ResponsiveBuilder.isMobile(context) ? 140 : 160,
                                                                                height: 40,
                                                                                child: ElevatedButton.icon(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.white,
                                                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    selectImage(widget.enrolledClass.classid, index.toString());
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.attach_file_outlined,
                                                                                    color: kColorPrimary,
                                                                                  ),
                                                                                  label: const Text(
                                                                                    'Add Files',
                                                                                    style: TextStyle(color: kColorPrimary, overflow: TextOverflow.ellipsis),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Visibility(
                                                                                  visible: progressupload > 0 && progressupload < 100,
                                                                                  child: SizedBox(
                                                                                    width: 20,
                                                                                    height: 20,
                                                                                    child: LinearProgressIndicator(
                                                                                      value: progressupload / 100,
                                                                                      color: kColorPrimary,
                                                                                    ),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Consumer<MaterialNotifier>(builder: (context,
                                                                            materialNotifier,
                                                                            _) {
                                                                          if (materialNotifier
                                                                              .materials
                                                                              .isEmpty) {
                                                                            return Container(
                                                                                width: 600,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    '(No materials added!)',
                                                                                    style: TextStyle(fontSize: 15, color: Colors.blue.shade200, fontStyle: FontStyle.italic),
                                                                                  ),
                                                                                )); // Show loading indicator
                                                                          }
                                                                          List<Map<String, dynamic>>
                                                                              materialsdata =
                                                                              materialNotifier.materials.where((element) => element['classno'] == index.toString()).toList();
                                                                          if (materialsdata
                                                                              .isEmpty) {
                                                                            return Container(
                                                                                width: 600,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    '(No materials added!)',
                                                                                    style: TextStyle(fontSize: 15, color: Colors.blue.shade200, fontStyle: FontStyle.italic),
                                                                                  ),
                                                                                )); // Show loading indicator
                                                                          }
                                                                          return Container(
                                                                              width: 600,
                                                                              height: 120,
                                                                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  IconButton(
                                                                                    iconSize: 12,
                                                                                    padding: EdgeInsets.zero,
                                                                                    splashRadius: 1,
                                                                                    icon: const Icon(
                                                                                      Icons.arrow_back_ios, // Left arrow icon
                                                                                      color: Colors.blue,
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      // Scroll to the left
                                                                                      updatescrollController1.animateTo(
                                                                                        updatescrollController1.offset - 100.0, // Adjust the value as needed
                                                                                        duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                                                                                        curve: Curves.ease,
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: ListView.builder(
                                                                                      shrinkWrap: true,
                                                                                      controller: updatescrollController1, // Assign the ScrollController to the ListView
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      itemCount: materialsdata.length,
                                                                                      itemBuilder: (context, index) {
                                                                                        if (materialsdata[index]['extension'] == 'Image') {
                                                                                          return FutureBuilder(
                                                                                              future: FirebaseStorage.instance.ref(materialsdata[index]['reference']).getDownloadURL(),
                                                                                              builder: (context, snapshot) {
                                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                  return Container(height: 60, width: 60, alignment: Alignment.center, child: const Text('Loading..'));
                                                                                                } else if (snapshot.hasError) {
                                                                                                  return Text('Error: ${snapshot.error}');
                                                                                                }

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
                                                                                                                                child: ViewFile(imageURL: snapshot.data.toString()),
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
                                                                                                            child: Stack(
                                                                                                              children: <Widget>[
                                                                                                                Container(
                                                                                                                  height: 60,
                                                                                                                  width: 60,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                                    color: Colors.grey.shade200,
                                                                                                                  ),
                                                                                                                  child: ClipRRect(
                                                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                                                    child: Image.network(
                                                                                                                      snapshot.data.toString(),
                                                                                                                      fit: BoxFit.cover,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Positioned(
                                                                                                                  top: 0,
                                                                                                                  right: 0,
                                                                                                                  child: GestureDetector(
                                                                                                                    onTap: () async {
                                                                                                                      bool result = await deleteMaterial(materialsdata[index]['classno'], materialsdata[index]['reference']);
                                                                                                                      // if (result) {
                                                                                                                      //   handleUpload('Deleted Successfully!', true);
                                                                                                                      // } else {
                                                                                                                      //   handleUpload('Deleted Successfully!', false);
                                                                                                                      // }
                                                                                                                    },
                                                                                                                    child: Container(
                                                                                                                      padding: const EdgeInsets.all(2),
                                                                                                                      decoration: const BoxDecoration(
                                                                                                                        shape: BoxShape.circle,
                                                                                                                        color: Colors.red,
                                                                                                                      ),
                                                                                                                      child: const Icon(
                                                                                                                        Icons.remove,
                                                                                                                        color: Colors.white,
                                                                                                                        size: 15,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Center(
                                                                                                            child: Row(
                                                                                                              children: [
                                                                                                                Tooltip(
                                                                                                                  message: getFileNameFromUrl(snapshot.data.toString()),
                                                                                                                  child: SizedBox(
                                                                                                                    height: 60,
                                                                                                                    width: 60,
                                                                                                                    child: TextButton(
                                                                                                                      onPressed: () {},
                                                                                                                      child: Text(
                                                                                                                        getFileNameFromUrl(snapshot.data.toString()),
                                                                                                                        style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                InkWell(
                                                                                                                  onTap: () {
                                                                                                                    fetchFileData(snapshot.data.toString());
                                                                                                                  },
                                                                                                                  child: const Tooltip(
                                                                                                                    message: 'Download',
                                                                                                                    child: Icon(
                                                                                                                      Icons.file_download_outlined,
                                                                                                                      color: kColorPrimary,
                                                                                                                      size: 15,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                );
                                                                                              });
                                                                                        } else if (materialsdata[index]['extension'] == 'pdf') {
                                                                                          return FutureBuilder(
                                                                                              future: FirebaseStorage.instance.ref(materialsdata[index]['reference']).getDownloadURL(),
                                                                                              builder: (context, snapshot) {
                                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                  return Container(height: 60, width: 60, alignment: Alignment.center, child: const Text('Loading..'));
                                                                                                } else if (snapshot.hasError) {
                                                                                                  return Text('Error: ${snapshot.error}');
                                                                                                }
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
                                                                                                                                child: TermPage(pdfurl: snapshot.data.toString()),
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
                                                                                                            child: Stack(children: <Widget>[
                                                                                                              Container(
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
                                                                                                              Positioned(
                                                                                                                top: 0,
                                                                                                                right: 0,
                                                                                                                child: GestureDetector(
                                                                                                                  onTap: () async {
                                                                                                                    bool result = await deleteMaterial(materialsdata[index]['classno'], materialsdata[index]['reference']);
                                                                                                                    // if (result) {
                                                                                                                    //   handleUpload('Deleted Successfully!', true);
                                                                                                                    // } else {
                                                                                                                    //   handleUpload('Deleted Successfully!', false);
                                                                                                                    // }
                                                                                                                  },
                                                                                                                  child: Container(
                                                                                                                    padding: const EdgeInsets.all(2),
                                                                                                                    decoration: const BoxDecoration(
                                                                                                                      shape: BoxShape.circle,
                                                                                                                      color: Colors.red,
                                                                                                                    ),
                                                                                                                    child: const Icon(
                                                                                                                      Icons.remove,
                                                                                                                      color: Colors.white,
                                                                                                                      size: 15,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ]),
                                                                                                          ),
                                                                                                          Center(
                                                                                                            child: Row(
                                                                                                              children: [
                                                                                                                Tooltip(
                                                                                                                  message: getFileNameFromUrl(snapshot.data.toString()),
                                                                                                                  child: SizedBox(
                                                                                                                    height: 60,
                                                                                                                    width: 60,
                                                                                                                    child: TextButton(
                                                                                                                      onPressed: () {
                                                                                                                        fetchFileData(snapshot.data.toString());
                                                                                                                      },
                                                                                                                      child: Text(
                                                                                                                        getFileNameFromUrl(snapshot.data.toString()),
                                                                                                                        style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                InkWell(
                                                                                                                  onTap: () {
                                                                                                                    fetchFileData(snapshot.data.toString());
                                                                                                                  },
                                                                                                                  child: const Tooltip(
                                                                                                                    message: 'Download',
                                                                                                                    child: Icon(
                                                                                                                      Icons.file_download_outlined,
                                                                                                                      color: kColorPrimary,
                                                                                                                      size: 15,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                );
                                                                                              });
                                                                                        } else {
                                                                                          return FutureBuilder(
                                                                                              future: FirebaseStorage.instance.ref(materialsdata[index]['reference']).getDownloadURL(),
                                                                                              builder: (context, snapshot) {
                                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                  return Container(height: 60, width: 60, alignment: Alignment.center, child: const Text('Loading..'));
                                                                                                } else if (snapshot.hasError) {
                                                                                                  return Text('Error: ${snapshot.error}');
                                                                                                }
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
                                                                                                                                child: ViewFile(imageURL: snapshot.data.toString()),
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
                                                                                                            child: Stack(
                                                                                                              children: <Widget>[
                                                                                                                Container(
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
                                                                                                                Positioned(
                                                                                                                  top: 0,
                                                                                                                  right: 0,
                                                                                                                  child: GestureDetector(
                                                                                                                    onTap: () async {
                                                                                                                      bool result = await deleteMaterial(materialsdata[index]['classno'], materialsdata[index]['reference']);
                                                                                                                      // if (result) {
                                                                                                                      //   handleUpload('Deleted Successfully!', true);
                                                                                                                      // } else {
                                                                                                                      //   handleUpload('Deleted Successfully!', false);
                                                                                                                      // }
                                                                                                                    },
                                                                                                                    child: Container(
                                                                                                                      padding: const EdgeInsets.all(2),
                                                                                                                      decoration: const BoxDecoration(
                                                                                                                        shape: BoxShape.circle,
                                                                                                                        color: Colors.red,
                                                                                                                      ),
                                                                                                                      child: const Icon(
                                                                                                                        Icons.remove,
                                                                                                                        color: Colors.white,
                                                                                                                        size: 15,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Center(
                                                                                                            child: Row(
                                                                                                              children: [
                                                                                                                Tooltip(
                                                                                                                  message: getFileNameFromUrl(snapshot.data.toString()),
                                                                                                                  child: SizedBox(
                                                                                                                    height: 60,
                                                                                                                    width: 60,
                                                                                                                    child: TextButton(
                                                                                                                      onPressed: () {
                                                                                                                        // setState(() {
                                                                                                                        //   fetchFileData(snapshot.data.toString());
                                                                                                                        // });
                                                                                                                      },
                                                                                                                      child: Text(
                                                                                                                        getFileNameFromUrl(snapshot.data.toString()),
                                                                                                                        style: const TextStyle(fontSize: 12.0, color: Colors.black54, decoration: TextDecoration.underline, overflow: TextOverflow.ellipsis),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                InkWell(
                                                                                                                  onTap: () {
                                                                                                                    fetchFileData(snapshot.data.toString());
                                                                                                                  },
                                                                                                                  child: const Tooltip(
                                                                                                                    message: 'Download',
                                                                                                                    child: Icon(
                                                                                                                      Icons.file_download_outlined,
                                                                                                                      color: kColorPrimary,
                                                                                                                      size: 15,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                );
                                                                                              });
                                                                                        }
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  IconButton(
                                                                                    iconSize: 12,
                                                                                    padding: EdgeInsets.zero,
                                                                                    splashRadius: 1,
                                                                                    icon: const Icon(
                                                                                      Icons.arrow_forward_ios, // Right arrow icon
                                                                                      color: Colors.blue,
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      // Scroll to the right
                                                                                      updatescrollController1.animateTo(
                                                                                        updatescrollController1.offset + 100.0, // Adjust the value as needed
                                                                                        duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                                                                                        curve: Curves.ease,
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ));
                                                                        }),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(16.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              const Text('Class Video Meeting:'),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text(
                                                                                '(Click the link to join the class!)',
                                                                                style: TextStyle(fontSize: 12, color: Colors.blue.shade200, fontStyle: FontStyle.italic),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              50,
                                                                              10,
                                                                              50,
                                                                              10),
                                                                          child: Consumer<List<Schedule>>(builder: (context,
                                                                              scheduleListdata,
                                                                              _) {
                                                                            dynamic
                                                                                data =
                                                                                scheduleListdata;
                                                                            ClassesData?
                                                                                newclassdata =
                                                                                widget.enrolledClass;
                                                                            List<Schedule>
                                                                                filtereddata =
                                                                                data.where((element) => element.scheduleID == widget.enrolledClass.classid).toList();
                                                                            filtereddata.sort((a, b) =>
                                                                                a.schedule.compareTo(b.schedule));
                                                                            if (filtereddata.length >
                                                                                index) {
                                                                              return MouseRegion(
                                                                                cursor: SystemMouseCursors.click,
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    // const VideoCall videoCall = VideoCall(chatID: '123', uID: '456');

                                                                                    // Replace 'your_flutter_app_port' with the actual port your Flutter web app is running on
                                                                                    String url = 'http://localhost:58586/tutorsList';

                                                                                    // Open the URL in a new tab
                                                                                    // html.window.open('/videoCall', "");
                                                                                    // html.window.open('/tutorslist', "");
                                                                                    //  const VideoCall(chatID: '', uID: '',);
                                                                                    GoRouter.of(context).go('/videocall/${widget.enrolledClass.tutorID}&${filtereddata[index].scheduleID}&${filtereddata[index].meetinglink}');
                                                                                  },
                                                                                  child: Text(
                                                                                    'work4ututor/${filtereddata[index].meetinglink}',
                                                                                    style: TextStyle(fontSize: 15, color: Colors.blue.shade200, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }
                                                                            return Text(
                                                                              '(Link will be attached when student set class schedule!)',
                                                                              style: TextStyle(fontSize: 15, color: Colors.blue.shade200, fontStyle: FontStyle.italic),
                                                                            );
                                                                          }),
                                                                          //add link here
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
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
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                            // child: VerticalDivider(),
                          ),
                          Flexible(
                              flex: 13,
                              child: SingleChildScrollView(
                                controller: ScrollController(),
                                child: Column(
                                  children: [
                                    Card(
                                                color: Colors.white,

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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Class Session',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: kColorGrey),
                                                  )),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 10, 15, 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200),
                                              child:
                                                  Consumer<ClaimableNotifier>(
                                                      builder: (context,
                                                          claimDetailsNotifier,
                                                          child) {
                                                dynamic claims =
                                                    claimDetailsNotifier.claims;
                                                dynamic claimdata = claims
                                                    .where((element) =>
                                                        element['classId'] ==
                                                        widget.enrolledClass
                                                            .classid)
                                                    .toList();
                                                return Consumer<List<Schedule>>(
                                                    builder: (context,
                                                        scheduleListdata, _) {
                                                  dynamic data =
                                                      scheduleListdata;
                                                  List<Schedule>
                                                      filteredScheduleList =
                                                      data
                                                          .where((element) =>
                                                              element
                                                                  .scheduleID ==
                                                              widget
                                                                  .enrolledClass
                                                                  .classid)
                                                          .toList();
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        filteredScheduleList
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final sortedSchedule =
                                                          filteredScheduleList;
                                                      sortedSchedule.sort((a,
                                                              b) =>
                                                          int.parse(a.session)
                                                              .compareTo(
                                                                  int.parse(b
                                                                      .session)));

                                                      final classCount =
                                                          sortedSchedule[index];
                                                      return Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Row(
                                                          children: [
                                                            Tooltip(
                                                              message: (classCount
                                                                          .session ==
                                                                      '1')
                                                                  ? "${(classCount.session)}st Class Session"
                                                                  : (classCount
                                                                              .session ==
                                                                          '2')
                                                                      ? "${(classCount.session)}nd Class Session"
                                                                      : (classCount.session ==
                                                                              '3')
                                                                          ? "${(classCount.session)}rd Class Session"
                                                                          : "${(classCount.session)}th Class Session",
                                                              child: Text(
                                                                (() {
                                                                  if (classCount
                                                                          .session ==
                                                                      '1') {
                                                                    return "${(classCount.session)}st Class";
                                                                  } else if (classCount
                                                                          .session ==
                                                                      '2') {
                                                                    return "${(classCount.session)}nd Class";
                                                                  } else if (classCount
                                                                          .session ==
                                                                      '3') {
                                                                    return "${(classCount.session)}rd Class";
                                                                  } else {
                                                                    return "${(classCount.session)}th Class";
                                                                  }
                                                                })(),
                                                                style: const TextStyle(
                                                                    color:
                                                                        kColorGrey),
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            SizedBox(
                                                              height: 40,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor: classCount
                                                                              .tutorStatus ==
                                                                          'Completed'
                                                                      ? Colors
                                                                          .amber
                                                                      : Colors
                                                                          .white,
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15))),
                                                                ),
                                                                onPressed: classCount.tutorStatus ==
                                                                            'Completed' ||
                                                                        classCount
                                                                            .schedule
                                                                            .isAfter(DateTime.now())
                                                                    ? null
                                                                    : () {
                                                                        double
                                                                            disburseAmount =
                                                                            widget.enrolledClass.price /
                                                                                double.parse(widget.enrolledClass.totalClasses);
                                                                        // addClassFinished(
                                                                        //     widget
                                                                        //         .enrolledClass
                                                                        //         .price,
                                                                        //     widget
                                                                        //         .enrolledClass
                                                                        //         .classid,
                                                                        //     disburseAmount,
                                                                        //     '001235',
                                                                        //     widget
                                                                        //         .enrolledClass
                                                                        //         .studentID,
                                                                        //     widget
                                                                        //         .enrolledClass
                                                                        //         .tutorID);
                                                                        updateScheduleAndAddClassFinished(
                                                                            classCount.scheduleID,
                                                                            classCount.schedule,
                                                                            widget.enrolledClass.price,
                                                                            widget.enrolledClass.classid,
                                                                            double.parse(disburseAmount.toStringAsFixed(2)),
                                                                            '',
                                                                            widget.enrolledClass.studentID,
                                                                            widget.enrolledClass.tutorID);
                                                                      },
                                                                child: Text(
                                                                  classCount.tutorStatus ==
                                                                          'Completed'
                                                                      ? 'Completed'
                                                                      : 'Complete Session',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontWeight: classCount.tutorStatus ==
                                                                              'Completed'
                                                                          ? FontWeight
                                                                              .normal
                                                                          : FontWeight
                                                                              .bold,
                                                                      color: classCount.tutorStatus ==
                                                                              'Completed'
                                                                          ? kColorLight
                                                                          : kColorPrimary),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                });
                                              }),
                                            ),
                                            const Spacer(),
                                            Card(
                                                        color: Colors.white,

                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
                                                child: const Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        EvaIcons.clockOutline,
                                                        color: kColorGrey,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        '50 minutes per class session',
                                                        style: TextStyle(
                                                            color: kColorGrey),
                                                        textAlign:
                                                            TextAlign.justify,
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
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Card(
                                    //   shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(
                                    //         10.0), //<-- SEE HERE
                                    //   ),
                                    //   child: Container(
                                    //     width: 380,
                                    //     height: 100,
                                    //     alignment: Alignment.center,
                                    //     // padding:
                                    //     // const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                    //     decoration: BoxDecoration(
                                    //         color: Colors.white,
                                    //         border: Border.all(
                                    //           color: Colors.grey,
                                    //           width: .1,
                                    //         ),
                                    //         borderRadius: const BorderRadius.all(
                                    //             Radius.circular(10))),
                                    //     child: Column(
                                    //       children: [
                                    //         const Padding(
                                    //           padding:
                                    //               EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    //           child: Align(
                                    //               alignment: Alignment.topLeft,
                                    //               child: Text(
                                    //                 'A class by',
                                    //                 style: TextStyle(
                                    //                   fontSize: 16,
                                    //                 ),
                                    //               )),
                                    //         ),
                                    //         Padding(
                                    //           padding: const EdgeInsets.fromLTRB(
                                    //               50, 5, 50, 5),
                                    //           child: ListTile(
                                    //             leading: const CircleAvatar(
                                    //               backgroundColor: Colors.black12,
                                    //               child: Icon(
                                    //                 Icons.person,
                                    //                 color: Colors.grey,
                                    //               ),
                                    //             ),
                                    //             title: Text(
                                    //               '${(widget.enrolledClass.tutorinfo.first.firstName)}${(widget.enrolledClass.tutorinfo.first.middleName == 'N/A' ? '' : ' ${(widget.enrolledClass.tutorinfo.first.middleName)}')} ${(widget.enrolledClass.tutorinfo.first.lastname)}, 28',
                                    //               style: const TextStyle(
                                    //                   color: Colors.black,
                                    //                   fontWeight: FontWeight.bold),
                                    //             ),
                                    //             subtitle: Text(
                                    //                 (widget.enrolledClass.subjectinfo
                                    //                     .first.subjectName),
                                    //                 style: const TextStyle(
                                    //                     color: Colors.black)),
                                    //             onTap: () {
                                    //               // Navigate to user profile page
                                    //               // Navigator.pushNamed(context, '/profile',
                                    //               //     arguments: {'username': users[index]['name']});
                                    //               //  final provider =
                                    //               //           context.read<ChatDisplayProvider>();
                                    //               //       provider.setOpenMessage(true);
                                    //             },
                                    //           ),
                                    //         ),
                                    //         // Row(
                                    //         //   mainAxisAlignment: MainAxisAlignment.center,
                                    //         //   children: const [
                                    //         //     Icon(EvaIcons.clockOutline),
                                    //         //     Text('50 minutes per class session')
                                    //         //   ],
                                    //         // ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )),
                        ],
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
