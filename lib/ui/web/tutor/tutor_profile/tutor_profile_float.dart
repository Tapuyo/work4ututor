// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work4ututor/ui/web/communication.dart/uploadrecording.dart';
import 'package:work4ututor/ui/web/tutor/tutor_profile/viewschedule.dart';

import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/subject_class.dart';
import '../../../../services/addtocart.dart';
import '../../../../services/getmyrating.dart';
import '../../../../utils/themes.dart';
import '../../terms/termpage.dart';
import 'book_lesson.dart';
import 'contact_teacher.dart';
import 'view_file.dart';

class TutorProfileFloat extends StatefulWidget {
  final dynamic tutorsinfo;
  final String studentdata;
  final String studenttinfo;
  const TutorProfileFloat(
      {super.key,
      required this.tutorsinfo,
      required this.studentdata,
      required this.studenttinfo});

  @override
  State<TutorProfileFloat> createState() => _TutorProfileFloatState();
}

class _TutorProfileFloatState extends State<TutorProfileFloat> {
  List<dynamic> tutorteach = [];
  dynamic selectedsuject = {};
  String currentprice = '0';
  String classcount = '';
  List<Subjects> subjectInfox = [];
  Random random = Random();
  Future<void> getDataFromTutorSubjectTeach(String uid) async {
    List<dynamic> tutorteachtemp = [];
    try {
      // Get the tutorSchedule document for the specified UID
      QuerySnapshot tutorScheduleQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('tutor')
          .where('userID', isEqualTo: uid)
          .get();

      // Loop through the documents in the tutorSchedule collection
      for (QueryDocumentSnapshot doc in tutorScheduleQuerySnapshot.docs) {
        // Get the reference to the "timeavailable" subcollection
        CollectionReference timeAvailableCollection =
            doc.reference.collection('mycourses');

        // Query documents within the "timeavailable" subcollection
        QuerySnapshot timeAvailableQuerySnapshot =
            await timeAvailableCollection.get();

        // Loop through the documents in the "timeavailable" subcollection
        for (QueryDocumentSnapshot timeDoc in timeAvailableQuerySnapshot.docs) {
          Map<String, dynamic> timeData =
              timeDoc.data() as Map<String, dynamic>;

          tutorteachtemp.add(timeData);
        }
      }

      setState(() {
        tutorteach = tutorteachtemp;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromTutorSubjectTeach(widget.tutorsinfo['userId']);
  }

  final RatingNotifier ratingNotifier = RatingNotifier();
  ScrollController studentsDataController = ScrollController();

  @override
  Widget build(BuildContext context) {
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    ScrollController updatescrollController1 = ScrollController();

    const double fillPercent = 70; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];
    Size size = MediaQuery.of(context).size;
    final subjectlist = Provider.of<List<Subjects>>(context);
    return Material(
      color: Colors.white,
      child: Container(
        width: 1135,
        height: 1000,
        alignment: Alignment.center,
        child: Scrollbar(
          thumbVisibility: true,
          controller: studentsDataController,
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            controller: studentsDataController,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: SizedBox(
                width: 1135,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        height: 780,
                        width: 1135,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ...secondaryHeadercolors,
                              ...[Colors.white, Colors.white],
                            ],
                            stops: stops,
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Flexible(
                                flex: 10,
                                child: SingleChildScrollView(
                                  controller: ScrollController(),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                                onTap: () {
                                                  // showDialog<DateTime>(
                                                  //   context: context,
                                                  //   builder: (BuildContext context) {
                                                  //     return ViewFile(
                                                  //       imageURL: widget
                                                  //           .tutorsinfo['imageID'],
                                                  //     );
                                                  //   },
                                                  // ).then((selectedDate) {
                                                  //   if (selectedDate != null) {
                                                  //     // Do something with the selected date
                                                  //   }
                                                  // });
                                                },
                                                child: Container(
                                                  height: 300,
                                                  width: 300,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.transparent,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              widget.tutorsinfo[
                                                                  'imageID']),
                                                          fit: BoxFit.cover)),
                                                )),
                                          ),
                                        ),
                                        Container(
                                            width: 340,
                                            height: 100,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  iconSize: 12,
                                                  padding: EdgeInsets.zero,
                                                  splashRadius: 1,
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_back_ios, // Left arrow icon
                                                    color: kColorPrimary,
                                                  ),
                                                  onPressed: () {
                                                    // Scroll to the left
                                                    updatescrollController1
                                                        .animateTo(
                                                      updatescrollController1
                                                              .offset -
                                                          100.0, // Adjust the value as needed
                                                      duration: const Duration(
                                                          milliseconds:
                                                              500), // Adjust the duration as needed
                                                      curve: Curves.ease,
                                                    );
                                                  },
                                                ),
                                                Visibility(
                                                  visible: widget.tutorsinfo[
                                                      'presentation'],
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            // showDialog(
                                                            //     barrierDismissible:
                                                            //         false,
                                                            //     context: context,
                                                            //     builder:
                                                            //         (BuildContext
                                                            //             context) {
                                                            //       var height =
                                                            //           MediaQuery.of(
                                                            //                   context)
                                                            //               .size
                                                            //               .height;
                                                            //       return AlertDialog(
                                                            //         shape:
                                                            //             RoundedRectangleBorder(
                                                            //           borderRadius:
                                                            //               BorderRadius.circular(
                                                            //                   15.0), // Adjust the radius as needed
                                                            //         ),
                                                            //         contentPadding:
                                                            //             EdgeInsets
                                                            //                 .zero,
                                                            //         content:
                                                            //             ClipRRect(
                                                            //           borderRadius:
                                                            //               BorderRadius.circular(
                                                            //                   15.0), // Same radius as above
                                                            //           child:
                                                            //               Container(
                                                            //             color: Colors
                                                            //                 .white, // Set the background color of the circular content

                                                            //             child:
                                                            //                 Stack(
                                                            //               children: <
                                                            //                   Widget>[
                                                            //                 SizedBox(
                                                            //                   height:
                                                            //                       height,
                                                            //                   width:
                                                            //                       900,
                                                            //                   child:
                                                            //                       VideoUploadWidget(
                                                            //                     videolink: widget.tutorsinfo['presentation'].first,
                                                            //                   ),
                                                            //                 ),
                                                            //                 Positioned(
                                                            //                   top:
                                                            //                       10.0,
                                                            //                   right:
                                                            //                       10.0,
                                                            //                   child:
                                                            //                       GestureDetector(
                                                            //                     onTap: () {
                                                            //                       Navigator.of(context).pop(false); // Close the dialog
                                                            //                     },
                                                            //                     child: const Icon(
                                                            //                       Icons.close,
                                                            //                       color: Colors.white,
                                                            //                       size: 20,
                                                            //                     ),
                                                            //                   ),
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           ),
                                                            //         ),
                                                            //       );
                                                            //     });
                                                            // // showDialog(
                                                            // //   barrierDismissible:
                                                            // //       false,
                                                            // //   context: context,
                                                            // //   builder:
                                                            // //       (BuildContext
                                                            // //           context) {
                                                            // //     return VideoUploadWidget(
                                                            // //       videolink: widget
                                                            // //           .tutorsinfo[
                                                            // //               'presentation']
                                                            // //           .first,
                                                            // //     );
                                                            // //   },
                                                            // // );
                                                            showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  var height =
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height;
                                                                  return FutureBuilder(
                                                                      future: FirebaseStorage
                                                                          .instance
                                                                          .ref(widget
                                                                              .tutorsinfo[
                                                                                  'presentation']
                                                                              .first)
                                                                          .getDownloadURL(),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (snapshot.connectionState ==
                                                                            ConnectionState
                                                                                .waiting) {
                                                                          return const SizedBox(
                                                                              height: 25,
                                                                              width: 25,
                                                                              child: Center(
                                                                                  child: CircularProgressIndicator(
                                                                                strokeWidth: 2,
                                                                                color: Color.fromRGBO(1, 118, 132, 1),
                                                                              )));

                                                                          /// Display a loading indicator while waiting for the file to download
                                                                        } else if (snapshot
                                                                            .hasError) {
                                                                          return Text(
                                                                              'Error: ${snapshot.error}');
                                                                        }
                                                                        return AlertDialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                          ),
                                                                          contentPadding:
                                                                              EdgeInsets.zero,
                                                                          content:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0), // Same radius as above
                                                                            child:
                                                                                Container(
                                                                              color: Colors.white, // Set the background color of the circular content

                                                                              child: Stack(
                                                                                children: <Widget>[
                                                                                  SizedBox(
                                                                                    height: height,
                                                                                    width: 900,
                                                                                    child: VideoUploadWidget(
                                                                                      videolink: snapshot.data.toString(),
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
                                                                                        color: Colors.white,
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
                                                                });
                                                          },
                                                          child: Container(
                                                            height: 60,
                                                            width: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors.grey
                                                                  .shade200,
                                                            ),
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  child: Image
                                                                      .network(
                                                                    widget.tutorsinfo[
                                                                        'imageID'],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                const Icon(
                                                                  Icons
                                                                      .play_circle, // You can use a different play icon if needed
                                                                  size: 40,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    controller:
                                                        updatescrollController1, // Assign the ScrollController to the ListView
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: widget
                                                        .tutorsinfo[
                                                            'certificates']
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (widget.tutorsinfo[
                                                                  'certificatestype']
                                                              [index] ==
                                                          'Image') {
                                                        return Tooltip(
                                                          message: getFileNameFromUrl(
                                                              widget.tutorsinfo[
                                                                      'certificates']
                                                                  [index]),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                        barrierDismissible:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          var height = MediaQuery.of(context)
                                                                              .size
                                                                              .height;
                                                                          return AlertDialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                            ),
                                                                            contentPadding:
                                                                                EdgeInsets.zero,
                                                                            content:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(15.0), // Same radius as above
                                                                              child: Container(
                                                                                color: Colors.white, // Set the background color of the circular content

                                                                                child: Stack(
                                                                                  children: <Widget>[
                                                                                    SizedBox(
                                                                                      height: height,
                                                                                      width: 900,
                                                                                      child: ViewFile(imageURL: widget.tutorsinfo['certificates'][index]),
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
                                                                                          color: Colors.white,
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
                                                                  child:
                                                                      Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .grey
                                                                          .shade200, // You can adjust the fit as needed.
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      child: Image
                                                                          .network(
                                                                        widget.tutorsinfo['certificates']
                                                                            [
                                                                            index],
                                                                        fit: BoxFit
                                                                            .cover, // You can adjust the fit as needed.
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      } else if (widget
                                                                      .tutorsinfo[
                                                                  'certificatestype']
                                                              [index] ==
                                                          'pdf') {
                                                        return Tooltip(
                                                          message: getFileNameFromUrl(
                                                              widget.tutorsinfo[
                                                                      'certificates']
                                                                  [index]),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                        barrierDismissible:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          var height = MediaQuery.of(context)
                                                                              .size
                                                                              .height;
                                                                          var width = MediaQuery.of(context)
                                                                              .size
                                                                              .width;
                                                                          return AlertDialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                            ),
                                                                            contentPadding:
                                                                                EdgeInsets.zero,
                                                                            content:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(15.0), // Same radius as above
                                                                              child: Container(
                                                                                color: Colors.white, // Set the background color of the circular content

                                                                                child: Stack(
                                                                                  children: <Widget>[
                                                                                    SizedBox(
                                                                                      height: height,
                                                                                      width: 900,
                                                                                      child: TermPage(
                                                                                        pdfurl: widget.tutorsinfo['certificates'][index],
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
                                                                                          color: Colors.white,
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
                                                                  child:
                                                                      Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .grey
                                                                          .shade200, // You can adjust the fit as needed.
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/filedoc.png",
                                                                        fit: BoxFit
                                                                            .cover, // Adjust the fit as needed.
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Tooltip(
                                                          message: getFileNameFromUrl(
                                                              widget.tutorsinfo[
                                                                      'certificates']
                                                                  [index]),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    // showDialog(
                                                                    //     barrierDismissible:
                                                                    //         false,
                                                                    //     context:
                                                                    //         context,
                                                                    //     builder:
                                                                    //         (BuildContext
                                                                    //             context) {
                                                                    //       var height =
                                                                    //           MediaQuery.of(context)
                                                                    //               .size
                                                                    //               .height;
                                                                    //       return AlertDialog(
                                                                    //         shape:
                                                                    //             RoundedRectangleBorder(
                                                                    //           borderRadius:
                                                                    //               BorderRadius.circular(15.0), // Adjust the radius as needed
                                                                    //         ),
                                                                    //         contentPadding:
                                                                    //             EdgeInsets
                                                                    //                 .zero,
                                                                    //         content:
                                                                    //             ClipRRect(
                                                                    //           borderRadius:
                                                                    //               BorderRadius.circular(15.0), // Same radius as above
                                                                    //           child:
                                                                    //               Container(
                                                                    //             color:
                                                                    //                 Colors.white, // Set the background color of the circular content

                                                                    //             child:
                                                                    //                 Stack(
                                                                    //               children: <Widget>[
                                                                    //                 SizedBox(
                                                                    //                   height: height,
                                                                    //                   width: 900,
                                                                    //                   child: TermPage(
                                                                    //                     pdfurl: widget.tutorsinfo['certificates'][index],
                                                                    //                   ),
                                                                    //                 ),
                                                                    //                 Positioned(
                                                                    //                   top: 10.0,
                                                                    //                   right: 10.0,
                                                                    //                   child: GestureDetector(
                                                                    //                     onTap: () {
                                                                    //                       Navigator.of(context).pop(false); // Close the dialog
                                                                    //                     },
                                                                    //                     child: const Icon(
                                                                    //                       Icons.close,
                                                                    //                       color: Colors.white,
                                                                    //                       size: 20,
                                                                    //                     ),
                                                                    //                   ),
                                                                    //                 ),
                                                                    //               ],
                                                                    //             ),
                                                                    //           ),
                                                                    //         ),
                                                                    //       );
                                                                    //     });
                                                                    _openDocument(
                                                                        widget.tutorsinfo['certificates']
                                                                            [
                                                                            index]);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .grey
                                                                          .shade200, // You can adjust the fit as needed.
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/filedoc.png",
                                                                        fit: BoxFit
                                                                            .cover, // Adjust the fit as needed.
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  iconSize: 12,
                                                  padding: EdgeInsets.zero,
                                                  splashRadius: 1,
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_forward_ios, // Right arrow icon
                                                    color: kColorPrimary,
                                                  ),
                                                  onPressed: () {
                                                    // Scroll to the right
                                                    updatescrollController1
                                                        .animateTo(
                                                      updatescrollController1
                                                              .offset +
                                                          100.0, // Adjust the value as needed
                                                      duration: const Duration(
                                                          milliseconds:
                                                              500), // Adjust the duration as needed
                                                      curve: Curves.ease,
                                                    );
                                                  },
                                                ),
                                              ],
                                            )),
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 0, 10, 5),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Subject',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: kColorLight),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 600,
                                          height: 50,
                                          color: Colors.transparent,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: tutorteach.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10,
                                                          top: 5,
                                                          bottom: 5),
                                                  child: Card(
                                                    margin: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    elevation: 5,
                                                    child: Container(
                                                      height: 40,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      decoration: selectedsuject[
                                                                  'subjectname'] ==
                                                              tutorteach[index][
                                                                  'subjectname']
                                                          ? const BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black12,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        5.0)
                                                              ],
                                                              gradient:
                                                                  LinearGradient(
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                                stops: [
                                                                  0.0,
                                                                  1.0
                                                                ],
                                                                colors:
                                                                    buttonFocuscolors,
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)),
                                                            )
                                                          : const BoxDecoration(
                                                              boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              4),
                                                                      blurRadius:
                                                                          5.0)
                                                                ],
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)),
                                                              color:
                                                                  Colors.white),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 5),
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              if (selectedsuject ==
                                                                  tutorteach[
                                                                      index]) {
                                                                selectedsuject =
                                                                    {};
                                                                classcount = '';
                                                                currentprice =
                                                                    '0';
                                                              } else {
                                                                selectedsuject =
                                                                    tutorteach[
                                                                        index];
                                                              }
                                                            });
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              tutorteach[index][
                                                                  'subjectname'],
                                                              style: TextStyle(
                                                                  color: selectedsuject[
                                                                              'subjectname'] ==
                                                                          tutorteach[index]
                                                                              [
                                                                              'subjectname']
                                                                      ? Colors
                                                                          .white
                                                                      : kColorGrey),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 5, 10, 5),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Number of Classes',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: kColorLight),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 0, 10, 5),
                                          child: Row(
                                            children: [
                                              // Container(
                                              //   height: 40,
                                              //   width: 100,
                                              //   decoration: const BoxDecoration(
                                              //     shape: BoxShape.rectangle,
                                              //     color:
                                              //         Color.fromRGBO(1, 118, 132, 1),
                                              //     borderRadius: BorderRadius.all(
                                              //         Radius.circular(5)),
                                              //   ),
                                              //   child: TextButton(
                                              //     style: TextButton.styleFrom(
                                              //       padding: const EdgeInsets.all(10),
                                              //       alignment: Alignment.centerLeft,
                                              //       foregroundColor: Colors.white,
                                              //       disabledBackgroundColor:
                                              //           Colors.white,
                                              //       backgroundColor: classcount == '1'
                                              //           ? kColorPrimary
                                              //           : Colors.white,
                                              //       shape: RoundedRectangleBorder(
                                              //         side: const BorderSide(
                                              //           color: Color.fromRGBO(
                                              //               1,
                                              //               118,
                                              //               132,
                                              //               1), // your color here
                                              //           width: 1,
                                              //         ),
                                              //         borderRadius:
                                              //             BorderRadius.circular(5.0),
                                              //       ),
                                              //       // ignore: prefer_const_constructors
                                              //       textStyle: TextStyle(
                                              //         color: classcount == '1'
                                              //             ? Colors.white
                                              //             : Colors.black,
                                              //         fontSize: 12,
                                              //         fontStyle: FontStyle.normal,
                                              //         decoration: TextDecoration.none,
                                              //       ),
                                              //     ),
                                              //     onPressed: () {
                                              //       setState(() {
                                              //         classcount = '1';
                                              //         currentprice =
                                              //             selectedsuject['price2'];
                                              //       });
                                              //     },
                                              //     child: Text(
                                              //       '2 Classes',
                                              //       style: TextStyle(
                                              //         fontSize: 15,
                                              //         color: classcount == '1'
                                              //             ? Colors.white
                                              //             : Colors.black,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  elevation: 5,
                                                  child: Container(
                                                    height: 40,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    decoration: classcount ==
                                                            '1'
                                                        ? const BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  offset:
                                                                      Offset(
                                                                          0, 4),
                                                                  blurRadius:
                                                                      5.0)
                                                            ],
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                              stops: [0.0, 1.0],
                                                              colors:
                                                                  buttonFocuscolors,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                          )
                                                        : const BoxDecoration(
                                                            boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black12,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        5.0)
                                                              ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            color:
                                                                Colors.white),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            classcount = '1';
                                                            currentprice =
                                                                selectedsuject[
                                                                    'price2'];
                                                          });
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            '2 Classes',
                                                            style: TextStyle(
                                                                color: classcount ==
                                                                        '1'
                                                                    ? Colors
                                                                        .white
                                                                    : kColorGrey),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 10,
                                              ),
                                              // Container(
                                              //   height: 40,
                                              //   width: 100,
                                              //   decoration: const BoxDecoration(
                                              //     shape: BoxShape.rectangle,
                                              //     color:
                                              //         Color.fromRGBO(1, 118, 132, 1),
                                              //     borderRadius: BorderRadius.all(
                                              //         Radius.circular(5)),
                                              //   ),
                                              //   child: TextButton(
                                              //     style: TextButton.styleFrom(
                                              //       padding: const EdgeInsets.all(10),
                                              //       alignment: Alignment.centerLeft,
                                              //       foregroundColor: Colors.white,
                                              //       disabledBackgroundColor:
                                              //           Colors.white,
                                              //       backgroundColor: classcount == '2'
                                              //           ? kColorPrimary
                                              //           : Colors.white,
                                              //       shape: RoundedRectangleBorder(
                                              //         side: const BorderSide(
                                              //           color: Color.fromRGBO(
                                              //               1,
                                              //               118,
                                              //               132,
                                              //               1), // your color here
                                              //           width: 1,
                                              //         ),
                                              //         borderRadius:
                                              //             BorderRadius.circular(5.0),
                                              //       ),
                                              //       // ignore: prefer_const_constructors
                                              //       textStyle: TextStyle(
                                              //         color: classcount == '2'
                                              //             ? Colors.white
                                              //             : Colors.black,
                                              //         fontSize: 12,
                                              //         fontStyle: FontStyle.normal,
                                              //         decoration: TextDecoration.none,
                                              //       ),
                                              //     ),
                                              //     onPressed: () {
                                              //       setState(() {
                                              //         classcount = '2';
                                              //         currentprice =
                                              //             selectedsuject['price3'];
                                              //       });
                                              //     },
                                              //     child: Text(
                                              //       '3 Classes',
                                              //       style: TextStyle(
                                              //         fontSize: 15,
                                              //         color: classcount == '2'
                                              //             ? Colors.white
                                              //             : Colors.black,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  elevation: 5,
                                                  child: Container(
                                                    height: 40,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    decoration: classcount ==
                                                            '2'
                                                        ? const BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  offset:
                                                                      Offset(
                                                                          0, 4),
                                                                  blurRadius:
                                                                      5.0)
                                                            ],
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                              stops: [0.0, 1.0],
                                                              colors:
                                                                  buttonFocuscolors,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                          )
                                                        : const BoxDecoration(
                                                            boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black12,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        5.0)
                                                              ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            color:
                                                                Colors.white),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            classcount = '2';
                                                            currentprice =
                                                                selectedsuject[
                                                                    'price3'];
                                                          });
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            '3 Classes',
                                                            style: TextStyle(
                                                                color: classcount ==
                                                                        '2'
                                                                    ? Colors
                                                                        .white
                                                                    : kColorGrey),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 10,
                                              ),
                                              // Container(
                                              //   height: 40,
                                              //   width: 100,
                                              //   decoration: const BoxDecoration(
                                              //     shape: BoxShape.rectangle,
                                              //     color:
                                              //         Color.fromRGBO(1, 118, 132, 1),
                                              //     borderRadius: BorderRadius.all(
                                              //         Radius.circular(5)),
                                              //   ),
                                              //   child: TextButton(
                                              //     style: TextButton.styleFrom(
                                              //       padding: const EdgeInsets.all(10),
                                              //       alignment: Alignment.centerLeft,
                                              //       foregroundColor: Colors.white,
                                              //       disabledBackgroundColor:
                                              //           Colors.white,
                                              //       backgroundColor: classcount == '3'
                                              //           ? kColorPrimary
                                              //           : Colors.white,
                                              //       shape: RoundedRectangleBorder(
                                              //         side: const BorderSide(
                                              //           color: Color.fromRGBO(
                                              //               1,
                                              //               118,
                                              //               132,
                                              //               1), // your color here
                                              //           width: 1,
                                              //         ),
                                              //         borderRadius:
                                              //             BorderRadius.circular(5.0),
                                              //       ),
                                              //       // ignore: prefer_const_constructors
                                              //       textStyle: TextStyle(
                                              //         color: classcount == '3'
                                              //             ? Colors.white
                                              //             : Colors.black,
                                              //         fontSize: 12,
                                              //         fontStyle: FontStyle.normal,
                                              //         decoration: TextDecoration.none,
                                              //       ),
                                              //     ),
                                              //     onPressed: () {
                                              //       setState(() {
                                              //         classcount = '3';
                                              //         currentprice =
                                              //             selectedsuject['price5'];
                                              //       });
                                              //     },
                                              //     child: Text(
                                              //       '5 classes',
                                              //       style: TextStyle(
                                              //         fontSize: 15,
                                              //         color: classcount == '3'
                                              //             ? Colors.white
                                              //             : Colors.black,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  elevation: 5,
                                                  child: Container(
                                                    height: 40,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    decoration: classcount ==
                                                            '3'
                                                        ? const BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  offset:
                                                                      Offset(
                                                                          0, 4),
                                                                  blurRadius:
                                                                      5.0)
                                                            ],
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                              stops: [0.0, 1.0],
                                                              colors:
                                                                  buttonFocuscolors,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                          )
                                                        : const BoxDecoration(
                                                            boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black12,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        5.0)
                                                              ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            color:
                                                                Colors.white),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            classcount = '3';
                                                            currentprice =
                                                                selectedsuject[
                                                                    'price5'];
                                                          });
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            '5 Classes',
                                                            style: TextStyle(
                                                                color: classcount ==
                                                                        '3'
                                                                    ? Colors
                                                                        .white
                                                                    : kColorGrey),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Container(
                                              //   height: 40,
                                              //   width: 100,
                                              //   decoration: const BoxDecoration(
                                              //     shape: BoxShape.rectangle,
                                              //     color: Colors.black45,
                                              //     borderRadius: BorderRadius.all(
                                              //         Radius.circular(5)),
                                              //   ),
                                              //   child: TextButton(
                                              //     style: TextButton.styleFrom(
                                              //       padding: const EdgeInsets.all(10),
                                              //       alignment: Alignment.centerLeft,
                                              //       foregroundColor: Colors.white,
                                              //       disabledBackgroundColor:
                                              //           Colors.white,
                                              //       backgroundColor: Colors.white,
                                              //       shape: RoundedRectangleBorder(
                                              //         side: const BorderSide(
                                              //           color: Colors
                                              //               .black45, // your color here
                                              //           width: 1,
                                              //         ),
                                              //         borderRadius:
                                              //             BorderRadius.circular(5.0),
                                              //       ),
                                              //     ),
                                              //     onPressed: () {
                                              //       // final provider = context.read<InitProvider>();
                                              //       // provider.setMenuIndex(5);
                                              //     },
                                              //     child: const Text(
                                              //       'Customize',
                                              //       style: TextStyle(
                                              //           fontSize: 15,
                                              //           color: Colors.black),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 0, 10, 5),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'For inquiries regarding varied class durations, kindly contact the tutor.',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      55, 116, 135, 1),
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Price: \$$currentprice',
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: kColorLight),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: 120,
                                                  // decoration: const BoxDecoration(
                                                  //   shape: BoxShape.rectangle,
                                                  //   color: kColorLight,
                                                  //   borderRadius: BorderRadius.all(
                                                  //       Radius.circular(20)),
                                                  // ),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: const BeveledRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return BookLesson(
                                                            studentdata: widget
                                                                .studentdata,
                                                            tutordata: widget
                                                                .tutorsinfo,
                                                            tutorteach:
                                                                tutorteach,
                                                            noofclasses:
                                                                classcount ==
                                                                        '1'
                                                                    ? '2'
                                                                    : classcount ==
                                                                            '2'
                                                                        ? '3'
                                                                        : '5',
                                                            subject:
                                                                selectedsuject[
                                                                    'subjectname'],
                                                            currentprice:
                                                                currentprice,
                                                          );
                                                        },
                                                      ).then((selectedDate) {
                                                        if (selectedDate !=
                                                            null) {
                                                          // Do something with the selected date
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Buy Classes',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: kColorPrimary,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  width: 120,
                                                  // decoration: const BoxDecoration(
                                                  //   shape: BoxShape.rectangle,
                                                  //   color: kColorLight,
                                                  //   borderRadius: BorderRadius.all(
                                                  //       Radius.circular(20)),
                                                  // ),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: const BeveledRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      if (classcount != '' &&
                                                          selectedsuject !=
                                                              {} &&
                                                          currentprice != '0') {
                                                        Subjects subjectid =
                                                            subjectlist
                                                                .firstWhere(
                                                          (element) =>
                                                              element
                                                                  .subjectName ==
                                                              selectedsuject[
                                                                  'subjectname'],
                                                        );
                                                        bool result =
                                                            await addtoCart(
                                                                widget
                                                                    .studentdata,
                                                                classcount ==
                                                                        '1'
                                                                    ? '2'
                                                                    : classcount ==
                                                                            '2'
                                                                        ? '3'
                                                                        : '5',
                                                                widget.tutorsinfo[
                                                                    'userId'],
                                                                subjectid
                                                                    .subjectId,
                                                                currentprice);
                                                        if (result == true) {
                                                          setState(() {
                                                            CoolAlert.show(
                                                              context: context,
                                                              width: 200,
                                                              type:
                                                                  CoolAlertType
                                                                      .success,
                                                              title: 'Success!',
                                                              text:
                                                                  'Class added to cart successfully.',
                                                              autoCloseDuration:
                                                                  const Duration(
                                                                      seconds:
                                                                          3),
                                                            );
                                                          });
                                                        } else {
                                                          CoolAlert.show(
                                                            context: context,
                                                            width: 200,
                                                            type: CoolAlertType
                                                                .warning,
                                                            title: 'Oops...',
                                                            text:
                                                                'Error declining, try again.',
                                                          );
                                                        }
                                                      } else {
                                                        CoolAlert.show(
                                                          context: context,
                                                          width: 200,
                                                          type: CoolAlertType
                                                              .warning,
                                                          title: 'Oops...',
                                                          text:
                                                              'Please select subject and classes.',
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Add Cart',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: kColorPrimary,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: 120,
                                                  // decoration: const BoxDecoration(
                                                  //   shape: BoxShape.rectangle,
                                                  //   color: kColorLight,
                                                  //   borderRadius: BorderRadius.all(
                                                  //       Radius.circular(20)),
                                                  // ),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: const BeveledRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ContactTeacher(
                                                            studentdata: widget
                                                                .studentdata,
                                                            tutordata: widget
                                                                .tutorsinfo,
                                                            tutorteach:
                                                                tutorteach,
                                                          );
                                                        },
                                                      ).then((selectedDate) {
                                                        if (selectedDate !=
                                                            null) {
                                                          // Do something with the selected date
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Send Inquiry',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: kColorPrimary,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  width: 120,
                                                  // decoration: const BoxDecoration(
                                                  //   shape: BoxShape.rectangle,
                                                  //   color: kColorLight,
                                                  //   borderRadius: BorderRadius.all(
                                                  //       Radius.circular(20)),
                                                  // ),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: const BeveledRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                var height =
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height;
                                                                var width =
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width;
                                                                return AlertDialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0), // Adjust the radius as needed
                                                                  ),
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  content:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0), // Same radius as above
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .white, // Set the background color of the circular content

                                                                      child:
                                                                          Stack(
                                                                        children: <
                                                                            Widget>[
                                                                          SizedBox(
                                                                            height:
                                                                                height - 100,
                                                                            width:
                                                                                width - 400,
                                                                            child:
                                                                                ViewScheduleData(
                                                                              data: widget.tutorsinfo,
                                                                              studentdata: widget.studenttinfo,
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            top:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.of(context).pop(false); // Close the dialog
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.close,
                                                                                color: kColorGrey,
                                                                                size: 20,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              })
                                                          .then((selectedDate) {
                                                        if (selectedDate !=
                                                            null) {
                                                          // Do something with the selected date
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      'View Calendar',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: kColorPrimary,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                height: MediaQuery.of(context).size.height,
                                child: const VerticalDivider(
                                  thickness: 1,
                                ),
                              ),
                              Flexible(
                                flex: 20,
                                child: SingleChildScrollView(
                                  controller: ScrollController(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RatingBar(
                                                ignoreGestures: true,
                                                initialRating: 0,
                                                minRating: 0,
                                                maxRating: 5,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 25,
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
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${widget.tutorsinfo['firstName']} ${widget.tutorsinfo['lastname']}',
                                              // '${widget.tutorsinfo['lastname']}, ${widget.tutorsinfo['firstName']} ${widget.tutorsinfo['middleName'] == 'N/A' ? '' : widget.tutorsinfo['middleName']}',
                                              style: const TextStyle(
                                                  fontSize: 35,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.mapLocation,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  widget.tutorsinfo['country'],
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.book,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  tutorteach.isEmpty
                                                      ? 'No Subject'
                                                      : tutorteach
                                                          .map((tutor) => tutor[
                                                                  'subjectname']
                                                              .toString())
                                                          .join(', '),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.language,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  widget.tutorsinfo['language']
                                                          .isEmpty
                                                      ? 'No Language'
                                                      : widget.tutorsinfo[
                                                              'language']
                                                          .join(', '),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'About Me',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: kColorLight,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              widget.tutorsinfo[
                                                  'promotionalMessage'],
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  color: kColorGrey),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Service Provided',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: kColorLight,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Container(
                                              width: 500,
                                              height: 70,
                                              color: Colors.transparent,
                                              child: GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    mainAxisSpacing: 2,
                                                    crossAxisSpacing: 2,
                                                    childAspectRatio: (1 / .2),
                                                    crossAxisCount: 3,
                                                  ),
                                                  itemCount: widget
                                                      .tutorsinfo[
                                                          'servicesprovided']
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          index) {
                                                    return Row(
                                                      children: [
                                                        const Icon(
                                                            FontAwesomeIcons
                                                                .handHoldingHeart,
                                                            size:
                                                                12.0, // Adjust the size as needed
                                                            color:
                                                                background // Set the color of the bullet
                                                            ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            widget.tutorsinfo[
                                                                    'servicesprovided']
                                                                [index],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                color:
                                                                    kColorGrey),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  }),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Column(
                                              children: [
                                                const Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Reviews',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: kColorLight,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Center(
                                                  child: FutureBuilder<
                                                          List<
                                                              Map<String,
                                                                  dynamic>>?>(
                                                      future: ratingNotifier
                                                          .getRating(
                                                              widget.tutorsinfo[
                                                                  'userId']),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  List<
                                                                      Map<String,
                                                                          dynamic>>?>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return SizedBox(
                                                              height:
                                                                  (size.height /
                                                                          2) -
                                                                      200,
                                                              width:
                                                                  size.width -
                                                                      320,
                                                              child:
                                                                  const Center(
                                                                child: SizedBox(
                                                                    width: 40,
                                                                    height: 40,
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                              ));
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        }
                                                        final List<
                                                                Map<String,
                                                                    dynamic>>?
                                                            reviewdata =
                                                            snapshot.data;
                                                        return reviewdata!
                                                                .isNotEmpty
                                                            ? ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    reviewdata
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  final reviews =
                                                                      reviewdata[
                                                                          index];
                                                                  // chartdata.add(ChartData(reviewdata[index]
                                                                  //                 ['datereview'].toString(), reviewdata[index]
                                                                  //                 ['totalRating']));
                                                                  return SizedBox(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              radius: 20.0,
                                                                              backgroundColor: Colors.transparent,
                                                                              child: Image.asset(
                                                                                'assets/images/login.png',
                                                                                width: 300.0,
                                                                                height: 100.0,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              reviewdata[index]['studentName'],
                                                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kColorGrey),
                                                                            ),
                                                                            const Spacer(),
                                                                            RatingBar(
                                                                                ignoreGestures: true,
                                                                                initialRating: reviewdata[index]['totalRating'],
                                                                                minRating: 0,
                                                                                maxRating: 5,
                                                                                direction: Axis.horizontal,
                                                                                allowHalfRating: true,
                                                                                itemCount: 5,
                                                                                itemSize: 20,
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
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            reviewdata[index]['review'],
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            // maxLines: 2,
                                                                            // overflow: TextOverflow.ellipsis,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.normal,
                                                                                color: kColorGrey),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                })
                                                            : Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Icon(
                                                                    Icons
                                                                        .announcement_outlined,
                                                                    color:
                                                                        background,
                                                                    size: 80,
                                                                  ),
                                                                  Text(
                                                                    "No Reviews",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color:
                                                                            background),
                                                                  ),
                                                                ],
                                                              );
                                                      }),
                                                ),
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
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
            ),
          ),
        ),
      ),
    );
  }

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

  Future<void> _openDocument(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
