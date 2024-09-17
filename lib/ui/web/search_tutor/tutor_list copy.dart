// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print, sized_box_for_whitespace

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/shared_components/responsive_builder.dart';
import 'dart:html' as html;

import '../../../data_class/studentinfoclass.dart';
import '../../../data_class/tutor_info_class.dart';
import '../../../provider/displaycount.dart';
import '../../../services/addpreftutor.dart';
import '../../../utils/themes.dart';
import '../tutor/tutor_profile/tutor_profile_float.dart';
// import '../../../routes/routes.dart';

class TutorList extends StatefulWidget {
  final List<String> preffered;
  final List<String> temppreffered;
  final List<String> country;
  final List<String> subject;
  final List<String> language;
  final List<String> provided;
  final String keyword;
  final int displayRange;
  final bool isLoading;
  final String studentdata;
  final List<TutorInformation> tutorsinfo;
  final String studenttzone;
  const TutorList({
    super.key,
    required this.keyword,
    required this.displayRange,
    required this.isLoading,
    required this.studentdata,
    required this.preffered,
    required this.country,
    required this.subject,
    required this.language,
    required this.provided,
    required this.tutorsinfo,
    required this.temppreffered,
    required this.studenttzone,
  });

  @override
  State<TutorList> createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  int displayCount = 0;
  List<TutorInformation> _foundUsers = [];
  List<TutorInformation> selected = [];
  List<String> prefTutor = [];
  Reference firebaseStorage = FirebaseStorage.instance.ref();
  Random random = Random();
  Map<String, dynamic> tutorInformationToJson(TutorInformation tutorData) {
    return {
      // Add other properties as needed
      'contact': tutorData.contact,
      'birthPlace': tutorData.birthPlace,
      'country': tutorData.country,
      'certificates': tutorData.certificates,
      'resume': tutorData.resume,
      'promotionalMessage': tutorData.promotionalMessage,
      'withdrawal': tutorData.withdrawal,
      'status': tutorData.status,
      'extensionName': tutorData.extensionName,
      'dateSign': tutorData.dateSign,
      'firstName': tutorData.firstName,
      'imageID': tutorData.imageID,
      'language': tutorData.language,
      'lastname': tutorData.lastname,
      'middleName': tutorData.middleName,
      'presentation': tutorData.presentation,
      'tutorID': tutorData.tutorID,
      'userId': tutorData.userId,
      'age': tutorData.age,
      'applicationID': tutorData.applicationID,
      'birthCity': tutorData.birthCity,
      'birthdate': tutorData.birthdate,
      'emailadd': tutorData.emailadd,
      'city': tutorData.city,
      'servicesprovided': tutorData.servicesprovided,
      'timezone': tutorData.timezone,
      'validIds': tutorData.validIds,
      'certificatestype': tutorData.certificatestype,
      'resumelinktype': tutorData.resumelinktype,
      'validIDstype': tutorData.validIDstype,
    };
  }

  List<dynamic> tutorteach = [];
  List<int> priceaverage = [];

  Stream<List<Map<String, dynamic>>> getDataStream() async* {
    while (true) {
      await Future.delayed(
          const Duration(seconds: 5)); // Adjust the delay as needed
      yield await getDataFromTutorSubjectTeach();
    }
  }

  Future<List<Map<String, dynamic>>> getDataFromTutorSubjectTeach() async {
    List<Map<String, dynamic>> result = [];

    try {
      Query tutorCollectionQuery =
          FirebaseFirestore.instance.collection('tutor');

      QuerySnapshot tutorCollectionQuerySnapshot =
          await tutorCollectionQuery.get();

      for (QueryDocumentSnapshot tutorDoc
          in tutorCollectionQuerySnapshot.docs) {
        CollectionReference timeAvailableCollection =
            tutorDoc.reference.collection('mycourses');

        QuerySnapshot timeAvailableQuerySnapshot =
            await timeAvailableCollection.get();

        for (QueryDocumentSnapshot timeDoc in timeAvailableQuerySnapshot.docs) {
          Map<String, dynamic> subcollectionData = {
            'collectionId': tutorDoc['userID'],
            'subjectname': timeDoc['subjectname'],
            'price2': timeDoc['price2'],
            'price3': timeDoc['price3'],
            'price5': timeDoc['price5'],
          };

          result.add(subcollectionData);
        }
      }

      return result;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  int findSmallestPrice(List<Map<String, dynamic>> tutorteachList, String uid) {
    List<int> allPrices = tutorteachList
        .where((tutorteach) => tutorteach['collectionId'] == uid)
        .map((tutorteach) => [
              int.tryParse(tutorteach["price2"]),
              int.tryParse(tutorteach["price3"]),
              int.tryParse(tutorteach["price5"]),
            ])
        .expand((prices) => prices)
        .where((price) => price != null)
        .cast<int>()
        .toList();

    if (allPrices.isEmpty) {
      return 0;
    }

    int smallestPrice =
        allPrices.reduce((value, element) => value < element ? value : element);

    return smallestPrice;
  }

  Future<List<Map<String, dynamic>>> anotherFunction() async {
    try {
      List<Map<String, dynamic>> dataList =
          await getDataFromTutorSubjectTeach();

      List<Map<String, dynamic>> filteredData = dataList
          .where((user) =>
              user['subjectname'] != null &&
              user['subjectname'].any((lang) => widget.subject.any((keyword) =>
                  lang.toLowerCase().contains(keyword.toLowerCase()))))
          .toList();

      return filteredData;
    } catch (e) {
      print("Error in anotherFunction: $e");
      return []; // or handle the error as appropriate
    }
  }

  ScrollController studentsDataController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // final tutorsinfo = Provider.of<List<TutorInformation>>(context);

    Size size = MediaQuery.of(context).size;
    if (widget.keyword.isEmpty) {
      _foundUsers = widget.tutorsinfo;
      if (widget.displayRange > _foundUsers.length) {
        displayCount = _foundUsers.length;
      } else {
        displayCount = widget.displayRange;
      }
      if (widget.language.isNotEmpty &&
          widget.subject.isEmpty &&
          widget.provided.isEmpty &&
          widget.preffered.isEmpty &&
          widget.country.isEmpty) {
        _foundUsers = widget.tutorsinfo
            .where((user) => user.language.any((lang) => widget.language.any(
                (keyword) =>
                    lang.toLowerCase().contains(keyword.toLowerCase()))))
            .toList();
      } else if (widget.subject.isNotEmpty &&
          widget.language.isEmpty &&
          widget.provided.isEmpty &&
          widget.preffered.isEmpty &&
          widget.country.isEmpty) {
        _foundUsers = widget.tutorsinfo
            .where((subj) => widget.subject.any((userId) =>
                subj.userId.toLowerCase().trim() ==
                userId.toLowerCase().trim()))
            .toList();
      } else if (widget.provided.isNotEmpty &&
          widget.language.isEmpty &&
          widget.subject.isEmpty &&
          widget.preffered.isEmpty &&
          widget.country.isEmpty) {
        _foundUsers = widget.tutorsinfo
            .where((provideddata) => provideddata.servicesprovided.any((lang) =>
                widget.provided.any((keyword) =>
                    lang.toLowerCase().contains(keyword.toLowerCase()))))
            .toList();
      } else if (widget.preffered.isNotEmpty &&
          widget.language.isEmpty &&
          widget.subject.isEmpty &&
          widget.provided.isEmpty &&
          widget.country.isEmpty) {
        _foundUsers = widget.tutorsinfo
            .where((pref) => widget.preffered.any((userId) =>
                pref.userId.toLowerCase().trim() ==
                userId.toLowerCase().trim()))
            .toList();
        // } else if (widget.provided.isNotEmpty) {
        //   _foundUsers = widget.tutorsinfo
        //       .where((provideddata) => provideddata.servicesprovided.any((lang) =>
        //           widget.provided.any((keyword) =>
        //               lang.toLowerCase().contains(keyword.toLowerCase()))))
        //       .toList();
      } else if (widget.country.isNotEmpty &&
          widget.language.isEmpty &&
          widget.subject.isEmpty &&
          widget.provided.isEmpty &&
          widget.preffered.isEmpty) {
        _foundUsers = widget.tutorsinfo
            .where((count) => widget.country.any((ctry) =>
                count.country.toLowerCase().trim() ==
                ctry.toLowerCase().trim()))
            .toList();
      } else if (widget.language.isNotEmpty &&
          widget.subject.isNotEmpty &&
          widget.provided.isNotEmpty &&
          widget.preffered.isNotEmpty &&
          widget.country.isNotEmpty) {
        _foundUsers = widget.tutorsinfo
            .where((user) =>
                // Apply the country filter
                (widget.country.isEmpty ||
                    widget.country.any((ctry) =>
                        user.country.toLowerCase().trim() ==
                        ctry.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.subject.isEmpty ||
                    widget.subject.any((userId) =>
                        user.userId.toLowerCase().trim() ==
                        userId.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.preffered.isEmpty ||
                    widget.preffered.any((userId) =>
                        user.userId.toLowerCase().trim() ==
                        userId.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.language.isEmpty ||
                    user.language.any((lang) => widget.language.any((keyword) =>
                        lang.toLowerCase().contains(keyword.toLowerCase())))) &&

                // Apply the subject filter
                (widget.provided.isEmpty ||
                    user.servicesprovided.any((lang) => widget.provided.any(
                        (keyword) => lang
                            .toLowerCase()
                            .contains(keyword.toLowerCase())))))
            .toList();
      } else if (widget.language.isEmpty &&
          widget.subject.isNotEmpty &&
          widget.provided.isEmpty &&
          widget.preffered.isEmpty &&
          widget.country.isNotEmpty) {
        _foundUsers = widget.tutorsinfo
            .where((user) =>
                // Apply the country filter
                (widget.country.isEmpty ||
                    widget.country.any((ctry) =>
                        user.country.toLowerCase().trim() ==
                        ctry.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.subject.isEmpty ||
                    widget.subject.any((userId) =>
                        user.userId.toLowerCase().trim() ==
                        userId.toLowerCase().trim())))
            .toList();
      } else {
        _foundUsers = widget.tutorsinfo
            .where((user) =>
                // Apply the country filter
                (widget.country.isEmpty ||
                    widget.country.any((ctry) =>
                        user.country.toLowerCase().trim() ==
                        ctry.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.subject.isEmpty ||
                    widget.subject.any((userId) =>
                        user.userId.toLowerCase().trim() ==
                        userId.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.preffered.isEmpty ||
                    widget.preffered.any((userId) =>
                        user.userId.toLowerCase().trim() ==
                        userId.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.language.isEmpty ||
                    user.language.any((lang) => widget.language.any((keyword) =>
                        lang.toLowerCase().contains(keyword.toLowerCase())))) &&

                // Apply the subject filter
                (widget.provided.isEmpty ||
                    user.servicesprovided.any((lang) => widget.provided.any(
                        (keyword) => lang
                            .toLowerCase()
                            .contains(keyword.toLowerCase())))))
            .toList();
      }
    } else {
     List<TutorInformation> tempfoundUsers = widget.tutorsinfo
            .where((user) =>
                // Apply the country filter
                (widget.country.isEmpty ||
                    widget.country.any((ctry) =>
                        user.country.toLowerCase().trim() ==
                        ctry.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.subject.isEmpty ||
                    widget.subject.any((userId) =>
                        user.userId.toLowerCase().trim() ==
                        userId.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.preffered.isEmpty ||
                    widget.preffered.any((userId) =>
                        user.userId.toLowerCase().trim() ==
                        userId.toLowerCase().trim())) &&

                // Apply the subject filter
                (widget.language.isEmpty ||
                    user.language.any((lang) => widget.language.any((keyword) =>
                        lang.toLowerCase().contains(keyword.toLowerCase())))) &&

                // Apply the subject filter
                (widget.provided.isEmpty ||
                    user.servicesprovided.any((lang) => widget.provided.any(
                        (keyword) => lang
                            .toLowerCase()
                            .contains(keyword.toLowerCase())))))
            .toList();
      _foundUsers = tempfoundUsers
          .where((user) =>
              user.firstName
                  .toLowerCase()
                  .contains(widget.keyword.toLowerCase()) ||
              user.lastname
                  .toLowerCase()
                  .contains(widget.keyword.toLowerCase()) ||
              user.middleName
                  .toLowerCase()
                  .contains(widget.keyword.toLowerCase()) ||
              user.country
                  .toLowerCase()
                  .contains(widget.keyword.toLowerCase()) ||
              user.language.any((lang) =>
                  lang.toLowerCase().contains(widget.keyword.toLowerCase())) ||
              user.promotionalMessage
                  .toLowerCase()
                  .contains(widget.keyword.toLowerCase()) ||
              user.servicesprovided.any((serv) =>
                  serv.toLowerCase().contains(widget.keyword.toLowerCase())))
          .toList();
      if (widget.displayRange > _foundUsers.length) {
        displayCount = _foundUsers.length;
      } else {
        displayCount = widget.displayRange;
      }
    }
    prefTutor = widget.temppreffered;
    return _foundUsers.isNotEmpty
        ? ResponsiveBuilder.isDesktop(context)
            ? SizedBox(
                width: size.width - 300,
                height: _foundUsers.length > 3 ? 760 : 540,
                // alignment: Alignment.center,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: studentsDataController,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    controller: studentsDataController,
                    child: SizedBox(
                      width: 1150,
                      height: _foundUsers.length > 3 ? 750 : 530,
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                          stream: getDataStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 0),
                                  width: 40,
                                  height: 40,
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kColorPrimary),
                                    strokeWidth: 5.0,
                                  ),
                                ),
                              );
                            }
                            List<Map<String, dynamic>> tutorteachdata =
                                snapshot.data!;
                            return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // Number of columns
                                  // crossAxisSpacing:
                                  //     20.0, // Adjust spacing as needed
                                  // mainAxisSpacing:
                                  //     20.0, // Adjust spacing as needed
                                ),
                                itemCount: Provider.of<
                                                    DisplayedItemCountProvider>(
                                                context)
                                            .displayedItemCount <
                                        _foundUsers.length
                                    ? Provider.of<DisplayedItemCountProvider>(
                                            context)
                                        .displayedItemCount
                                    : _foundUsers.length,
                                itemBuilder: (context, index) {
                                  int smallestPrice = findSmallestPrice(
                                      tutorteachdata,
                                      _foundUsers[index].userId);
                                  List<dynamic> subjectNames = snapshot.data!
                                      .where((data) =>
                                          data['collectionId'] ==
                                          _foundUsers[index].userId)
                                      .map((data) => data['subjectname'])
                                      .toList();
                                  return ClipRRect(
                                    child: Card(
                                      elevation: 2,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Map<String, dynamic> tutorDataMap =
                                                tutorInformationToJson(
                                                    _foundUsers[index]);
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  var height =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height;
                                                  var width =
                                                      MediaQuery.of(context)
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
                                                        EdgeInsets.zero,
                                                    content: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0), // Same radius as above
                                                      child: Container(
                                                        color: Colors
                                                            .white, // Set the background color of the circular content

                                                        child: Stack(
                                                          children: <Widget>[
                                                            TutorProfileFloat(
                                                              tutorsinfo:
                                                                  tutorDataMap,
                                                              studentdata: widget
                                                                  .studentdata,
                                                              studenttinfo: widget
                                                                  .studenttzone,
                                                            ),
                                                            Positioned(
                                                              top: 10.0,
                                                              right: 10.0,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
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
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 20, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    child: Container(
                                                      height: 150.0,
                                                      width: 150.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors
                                                              .transparent,
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  _foundUsers[
                                                                          index]
                                                                      .imageID),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 150.0,
                                                    child: ClipRect(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          RatingBar(
                                                              ignoreGestures:
                                                                  true,
                                                              initialRating: 0,
                                                              minRating: 0,
                                                              maxRating: 5,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemSize: 20,
                                                              ratingWidget:
                                                                  RatingWidget(
                                                                      full: const Icon(
                                                                          Icons
                                                                              .star,
                                                                          color: Colors
                                                                              .orange),
                                                                      half:
                                                                          const Icon(
                                                                        Icons
                                                                            .star_half,
                                                                        color: Colors
                                                                            .orange,
                                                                      ),
                                                                      empty:
                                                                          const Icon(
                                                                        Icons
                                                                            .star_outline,
                                                                        color: Colors
                                                                            .orange,
                                                                      )),
                                                              onRatingUpdate:
                                                                  (value) {
                                                                // _ratingValue = value;
                                                              }),
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: IconButton(
                                                                icon: widget
                                                                        .temppreffered
                                                                        .contains(_foundUsers[index]
                                                                            .userId)
                                                                    ? const Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red)
                                                                    : const Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color: Colors
                                                                            .red),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    // prefTutor = widget
                                                                    //     .temppreffered;
                                                                    if (prefTutor
                                                                        .contains(
                                                                            _foundUsers[index].userId)) {
                                                                      prefTutor.remove(
                                                                          _foundUsers[index]
                                                                              .userId);
                                                                    } else {
                                                                      prefTutor.add(
                                                                          _foundUsers[index]
                                                                              .userId);
                                                                    }

                                                                    updateprefferdInFirestore(
                                                                        prefTutor,
                                                                        widget
                                                                            .studentdata);
                                                                  });
                                                                },
                                                                iconSize: 30.0,
                                                              ),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "Starting from \$$smallestPrice",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts.lato(
                                                                  color:
                                                                      kColorPrimary,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0.0, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 3),
                                                          child: Text(
                                                            _foundUsers[index]
                                                                            .middleName ==
                                                                        'N/A' ||
                                                                    _foundUsers[index]
                                                                            .middleName ==
                                                                        ''
                                                                ? "${_foundUsers[index].firstName} ${_foundUsers[index].lastname}, (${calculateAge(_foundUsers[index].birthdate)})"
                                                                : "${_foundUsers[index].firstName} ${_foundUsers[index].middleName} ${_foundUsers[index].lastname}, (${calculateAge(_foundUsers[index].birthdate)})",
                                                            style: GoogleFonts.roboto(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    kColorGrey),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          FontAwesomeIcons
                                                              .mapLocation,
                                                          size: 15,
                                                          color: kColorGrey,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          _foundUsers[index]
                                                                  .country
                                                                  .isEmpty
                                                              ? 'No Country'
                                                              : _foundUsers[
                                                                      index]
                                                                  .country,
                                                          style: const TextStyle(
                                                              color: kColorGrey,
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        FontAwesomeIcons.book,
                                                        size: 15,
                                                        color: kColorGrey,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Tooltip(
                                                        message: subjectNames
                                                            .join(', '),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 3),
                                                          child: Text(
                                                            subjectNames
                                                                .join(', '),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: const TextStyle(
                                                                color:
                                                                    kColorGrey,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        FontAwesomeIcons
                                                            .language,
                                                        size: 15,
                                                        color: kColorGrey,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Tooltip(
                                                        message:
                                                            _foundUsers[index]
                                                                .language
                                                                .join(', '),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 3),
                                                          child: Text(
                                                            _foundUsers[index]
                                                                    .language
                                                                    .isEmpty
                                                                ? 'No Language'
                                                                : _foundUsers[
                                                                        index]
                                                                    .language
                                                                    .join(', '),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: const TextStyle(
                                                                color:
                                                                    kColorGrey,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                height: 45,
                                                child: Text(
                                                  _foundUsers[index]
                                                          .promotionalMessage
                                                          .isEmpty
                                                      ? 'No Message'
                                                      : _foundUsers[index]
                                                          .promotionalMessage,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: kColorGrey,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceBetween,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.end,
                                              //   children: [

                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ),
                  ),
                ),
              )
            : ResponsiveBuilder.isTablet(context)
                ? Container(
                    width: size.width - 50,
                    height: _foundUsers.length > 3 ? 760 : 540,
                    alignment: Alignment.center,
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: studentsDataController,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        controller: studentsDataController,
                        child: SizedBox(
                          width: 750,
                          height: _foundUsers.length > 3 ? 750 : 530,
                          child: StreamBuilder<List<Map<String, dynamic>>>(
                              stream: getDataStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 0),
                                      width: 40,
                                      height: 40,
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                kColorPrimary),
                                        strokeWidth: 5.0,
                                      ),
                                    ),
                                  );
                                }
                                List<Map<String, dynamic>> tutorteachdata =
                                    snapshot.data!;
                                return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing:
                                          10.0, // Adjust spacing as needed
                                      mainAxisSpacing:
                                          10.0, // Adjust spacing as needed
                                    ),
                                    itemCount:
                                        Provider.of<DisplayedItemCountProvider>(
                                                        context)
                                                    .displayedItemCount <
                                                _foundUsers.length
                                            ? Provider.of<
                                                        DisplayedItemCountProvider>(
                                                    context)
                                                .displayedItemCount
                                            : _foundUsers.length,
                                    itemBuilder: (context, index) {
                                      int smallestPrice = findSmallestPrice(
                                          tutorteachdata,
                                          _foundUsers[index].userId);
                                      List<dynamic> subjectNames = snapshot
                                          .data!
                                          .where((data) =>
                                              data['collectionId'] ==
                                              _foundUsers[index].userId)
                                          .map((data) => data['subjectname'])
                                          .toList();
                                      return ClipRRect(
                                        child: Card(
                                          elevation: 2,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                Map<String, dynamic>
                                                    tutorDataMap =
                                                    tutorInformationToJson(
                                                        _foundUsers[index]);
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      var height =
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height;
                                                      var width =
                                                          MediaQuery.of(context)
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
                                                            EdgeInsets.zero,
                                                        content: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15.0), // Same radius as above
                                                          child: Container(
                                                            color: Colors
                                                                .white, // Set the background color of the circular content

                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                SizedBox(
                                                                  height:
                                                                      height,
                                                                  width: width -
                                                                      400,
                                                                  child:
                                                                      TutorProfileFloat(
                                                                    tutorsinfo:
                                                                        tutorDataMap,
                                                                    studentdata:
                                                                        widget
                                                                            .studentdata,
                                                                    studenttinfo:
                                                                        widget
                                                                            .studenttzone,
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 10.0,
                                                                  right: 10.0,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(); // Close the dialog
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .white,
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 10, 20, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        child: Container(
                                                          height: 150.0,
                                                          width: 150.0,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors
                                                                  .transparent,
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      _foundUsers[
                                                                              index]
                                                                          .imageID),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 150.0,
                                                        child: ClipRect(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              RatingBar(
                                                                  ignoreGestures:
                                                                      true,
                                                                  initialRating:
                                                                      0,
                                                                  minRating: 0,
                                                                  maxRating: 5,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  allowHalfRating:
                                                                      true,
                                                                  itemCount: 5,
                                                                  itemSize: 20,
                                                                  ratingWidget:
                                                                      RatingWidget(
                                                                          full: const Icon(Icons.star,
                                                                              color: Colors
                                                                                  .orange),
                                                                          half:
                                                                              const Icon(
                                                                            Icons.star_half,
                                                                            color:
                                                                                Colors.orange,
                                                                          ),
                                                                          empty:
                                                                              const Icon(
                                                                            Icons.star_outline,
                                                                            color:
                                                                                Colors.orange,
                                                                          )),
                                                                  onRatingUpdate:
                                                                      (value) {
                                                                    // _ratingValue = value;
                                                                  }),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      IconButton(
                                                                    icon: widget
                                                                            .temppreffered
                                                                            .contains(_foundUsers[index]
                                                                                .userId)
                                                                        ? const Icon(
                                                                            Icons
                                                                                .favorite,
                                                                            color: Colors
                                                                                .red)
                                                                        : const Icon(
                                                                            Icons
                                                                                .favorite_border,
                                                                            color:
                                                                                Colors.red),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        // prefTutor = widget
                                                                        //     .temppreffered;
                                                                        if (prefTutor
                                                                            .contains(_foundUsers[index].userId)) {
                                                                          prefTutor
                                                                              .remove(_foundUsers[index].userId);
                                                                        } else {
                                                                          prefTutor
                                                                              .add(_foundUsers[index].userId);
                                                                        }

                                                                        updateprefferdInFirestore(
                                                                            prefTutor,
                                                                            widget.studentdata);
                                                                      });
                                                                    },
                                                                    iconSize:
                                                                        30.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  "Starting from \$$smallestPrice",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: GoogleFonts.lato(
                                                                      color:
                                                                          kColorPrimary,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0.0, 0, 0, 0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 3),
                                                              child: Text(
                                                                _foundUsers[index].middleName ==
                                                                            'N/A' ||
                                                                        _foundUsers[index].middleName ==
                                                                            ''
                                                                    ? "${_foundUsers[index].firstName} ${_foundUsers[index].lastname}, (${calculateAge(_foundUsers[index].birthdate)})"
                                                                    : "${_foundUsers[index].firstName} ${_foundUsers[index].middleName} ${_foundUsers[index].lastname}, (${calculateAge(_foundUsers[index].birthdate)})",
                                                                style: GoogleFonts.roboto(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color:
                                                                        kColorGrey),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 3),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              FontAwesomeIcons
                                                                  .mapLocation,
                                                              size: 15,
                                                              color: kColorGrey,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              _foundUsers[index]
                                                                      .country
                                                                      .isEmpty
                                                                  ? 'No Country'
                                                                  : _foundUsers[
                                                                          index]
                                                                      .country,
                                                              style: const TextStyle(
                                                                  color:
                                                                      kColorGrey,
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            FontAwesomeIcons
                                                                .book,
                                                            size: 15,
                                                            color: kColorGrey,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Tooltip(
                                                            message:
                                                                subjectNames
                                                                    .join(', '),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 3),
                                                              child: Text(
                                                                subjectNames
                                                                    .join(', '),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    color:
                                                                        kColorGrey,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            FontAwesomeIcons
                                                                .language,
                                                            size: 15,
                                                            color: kColorGrey,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Tooltip(
                                                            message:
                                                                _foundUsers[
                                                                        index]
                                                                    .language
                                                                    .join(', '),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 3),
                                                              child: Text(
                                                                _foundUsers[index]
                                                                        .language
                                                                        .isEmpty
                                                                    ? 'No Language'
                                                                    : _foundUsers[
                                                                            index]
                                                                        .language
                                                                        .join(
                                                                            ', '),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    color:
                                                                        kColorGrey,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    height: 45,
                                                    child: Text(
                                                      _foundUsers[index]
                                                              .promotionalMessage
                                                              .isEmpty
                                                          ? 'No Message'
                                                          : _foundUsers[index]
                                                              .promotionalMessage,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: kColorGrey,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                  // const SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment.spaceBetween,
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment.end,
                                                  //   children: [

                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: size.width - 20,
                    height: _foundUsers.length > 3 ? size.height : 300,
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: getDataStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 0),
                                width: 40,
                                height: 40,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kColorPrimary),
                                  strokeWidth: 5.0,
                                ),
                              ),
                            );
                          }
                          List<Map<String, dynamic>> tutorteachdata =
                              snapshot.data!;
                          return ScrollConfiguration(
                            behavior: MyCustomScrollBehavior(),
                            child: ListView.builder(
                                shrinkWrap: true,
                                // gridDelegate:
                                //     const SliverGridDelegateWithFixedCrossAxisCount(
                                //   crossAxisCount: 1, // Number of columns
                                //   // crossAxisSpacing:
                                //   //     10.0, // Adjust spacing as needed
                                //   mainAxisSpacing:
                                //       10.0, // Adjust spacing as needed
                                // ),
                                padding: const EdgeInsets.only(bottom: 10),
                                itemCount: Provider.of<
                                                    DisplayedItemCountProvider>(
                                                context)
                                            .displayedItemCount <
                                        _foundUsers.length
                                    ? Provider.of<DisplayedItemCountProvider>(
                                            context)
                                        .displayedItemCount
                                    : _foundUsers.length,
                                itemBuilder: (context, index) {
                                  int smallestPrice = findSmallestPrice(
                                      tutorteachdata,
                                      _foundUsers[index].userId);
                                  List<dynamic> subjectNames = snapshot.data!
                                      .where((data) =>
                                          data['collectionId'] ==
                                          _foundUsers[index].userId)
                                      .map((data) => data['subjectname'])
                                      .toList();
                                  return ClipRRect(
                                    child: Card(
                                      elevation: 2,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Map<String, dynamic> tutorDataMap =
                                                tutorInformationToJson(
                                                    _foundUsers[index]);
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  var height =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height;
                                                  var width =
                                                      MediaQuery.of(context)
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
                                                        EdgeInsets.zero,
                                                    content: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0), // Same radius as above
                                                      child: Container(
                                                        color: Colors
                                                            .white, // Set the background color of the circular content

                                                        child: Stack(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: height,
                                                              width:
                                                                  width - 400,
                                                              child:
                                                                  TutorProfileFloat(
                                                                tutorsinfo:
                                                                    tutorDataMap,
                                                                studentdata: widget
                                                                    .studentdata,
                                                                studenttinfo: widget
                                                                    .studenttzone,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 10.0,
                                                              right: 10.0,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
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
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    child: Container(
                                                      height: 150.0,
                                                      width: 150.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors
                                                              .transparent,
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  _foundUsers[
                                                                          index]
                                                                      .imageID),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 150.0,
                                                    child: ClipRect(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          RatingBar(
                                                              ignoreGestures:
                                                                  true,
                                                              initialRating: 0,
                                                              minRating: 0,
                                                              maxRating: 5,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemSize: 20,
                                                              ratingWidget:
                                                                  RatingWidget(
                                                                      full: const Icon(
                                                                          Icons
                                                                              .star,
                                                                          color: Colors
                                                                              .orange),
                                                                      half:
                                                                          const Icon(
                                                                        Icons
                                                                            .star_half,
                                                                        color: Colors
                                                                            .orange,
                                                                      ),
                                                                      empty:
                                                                          const Icon(
                                                                        Icons
                                                                            .star_outline,
                                                                        color: Colors
                                                                            .orange,
                                                                      )),
                                                              onRatingUpdate:
                                                                  (value) {
                                                                // _ratingValue = value;
                                                              }),
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: IconButton(
                                                                icon: widget
                                                                        .temppreffered
                                                                        .contains(_foundUsers[index]
                                                                            .userId)
                                                                    ? const Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red)
                                                                    : const Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color: Colors
                                                                            .red),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    // prefTutor = widget
                                                                    //     .temppreffered;
                                                                    if (prefTutor
                                                                        .contains(
                                                                            _foundUsers[index].userId)) {
                                                                      prefTutor.remove(
                                                                          _foundUsers[index]
                                                                              .userId);
                                                                    } else {
                                                                      prefTutor.add(
                                                                          _foundUsers[index]
                                                                              .userId);
                                                                    }

                                                                    updateprefferdInFirestore(
                                                                        prefTutor,
                                                                        widget
                                                                            .studentdata);
                                                                  });
                                                                },
                                                                iconSize: 30.0,
                                                              ),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "Starting from \$$smallestPrice",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts.lato(
                                                                  color:
                                                                      kColorPrimary,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0.0, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 3),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            width: size.width -
                                                                100,
                                                            height: 20,
                                                            child: Text(
                                                              _foundUsers[index]
                                                                              .middleName ==
                                                                          'N/A' ||
                                                                      _foundUsers[index]
                                                                              .middleName ==
                                                                          ''
                                                                  ? "${_foundUsers[index].firstName} ${_foundUsers[index].lastname}, (${calculateAge(_foundUsers[index].birthdate)})"
                                                                  : "${_foundUsers[index].firstName} ${_foundUsers[index].middleName} ${_foundUsers[index].lastname}, (${calculateAge(_foundUsers[index].birthdate)})",
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      kColorGrey),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          FontAwesomeIcons
                                                              .mapLocation,
                                                          size: 15,
                                                          color: kColorGrey,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          _foundUsers[index]
                                                                  .country
                                                                  .isEmpty
                                                              ? 'No Country'
                                                              : _foundUsers[
                                                                      index]
                                                                  .country,
                                                          style: const TextStyle(
                                                              color: kColorGrey,
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        FontAwesomeIcons.book,
                                                        size: 15,
                                                        color: kColorGrey,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Tooltip(
                                                        message: subjectNames
                                                            .join(', '),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 3),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            width: size.width -
                                                                100,
                                                            height: 20,
                                                            child: Text(
                                                              subjectNames
                                                                  .join(', '),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      kColorGrey,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        FontAwesomeIcons
                                                            .language,
                                                        size: 15,
                                                        color: kColorGrey,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Tooltip(
                                                        message:
                                                            _foundUsers[index]
                                                                .language
                                                                .join(', '),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 3),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            width: size.width -
                                                                100,
                                                            height: 20,
                                                            child: Text(
                                                              _foundUsers[index]
                                                                      .language
                                                                      .isEmpty
                                                                  ? 'No Language'
                                                                  : _foundUsers[
                                                                          index]
                                                                      .language
                                                                      .join(
                                                                          ', '),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      kColorGrey,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: size.width - 100,
                                                height: 45,
                                                child: Text(
                                                  _foundUsers[index]
                                                          .promotionalMessage
                                                          .isEmpty
                                                      ? 'No Message'
                                                      : _foundUsers[index]
                                                          .promotionalMessage,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: kColorGrey,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceBetween,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.end,
                                              //   children: [

                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }),
                  )
        : SizedBox(
            width: ResponsiveBuilder.isDesktop(context)
                ? size.width - 400
                : size.width - 60,
            height: size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/nodata.jpg',
                    width: 500.0,
                    height: 300.0,
                    fit: BoxFit.fill,
                  ),
                  const Text(
                    "NO DATA FOUND",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ));
  }

  String calculateAge(DateTime birthdate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;

    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month &&
            currentDate.day < birthdate.day)) {
      age--;
    }

    return age.toString();
  }
}

class MyCustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child; // Removes the default scrollbar
  }
}
