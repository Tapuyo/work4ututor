// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print, sized_box_for_whitespace

import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

import '../../../data_class/studentinfoclass.dart';
import '../../../data_class/tutor_info_class.dart';
import '../../../services/getlanguages.dart';
import '../../../utils/themes.dart';
import '../tutor/tutor_profile/tutor_profile.dart';
import '../tutor/tutor_profile/tutor_profile_float.dart';
// import '../../../routes/routes.dart';

class TutorList extends StatefulWidget {
  final String keyword;
  final int displayRange;
  final bool isLoading;
  final String studentdata;
  const TutorList({
    super.key,
    required this.keyword,
    required this.displayRange,
    required this.isLoading, required this.studentdata,
  });

  @override
  State<TutorList> createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  int displayCount = 0;
  List<TutorInformation> _foundUsers = [];
  List<TutorInformation> selected = [];
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

  @override
  Widget build(BuildContext context) {
    final tutorsinfo = Provider.of<List<TutorInformation>>(context);

    Size size = MediaQuery.of(context).size;
    if (widget.keyword.isEmpty) {
      _foundUsers = tutorsinfo;
      if (widget.displayRange > _foundUsers.length) {
        displayCount = _foundUsers.length;
      } else {
        displayCount = widget.displayRange;
      }
    } else {
      _foundUsers = tutorsinfo
          .where((user) => user.firstName
              .toLowerCase()
              .contains(widget.keyword.toLowerCase()))
          .toList();
      ;
      if (widget.displayRange > _foundUsers.length) {
        displayCount = _foundUsers.length;
      } else {
        displayCount = widget.displayRange;
      }
    }

    return widget.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _foundUsers.isNotEmpty
            ? Material(
                color: Colors.white60,
                child: SizedBox(
                  width: size.width - 400,
                  height: size.height,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 20.0, // Adjust spacing as needed
                        mainAxisSpacing: 20.0, // Adjust spacing as needed
                      ),
                      itemCount: _foundUsers.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                Map<String, dynamic> tutorDataMap =
                                    tutorInformationToJson(_foundUsers[index]);
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      var height =
                                          MediaQuery.of(context).size.height;
                                      var width =
                                          MediaQuery.of(context).size.width;
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15.0), // Adjust the radius as needed
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        content: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              15.0), // Same radius as above
                                          child: Container(
                                            color: Colors
                                                .white, // Set the background color of the circular content

                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: height,
                                                  width: width - 400,
                                                  child: TutorProfileFloat(
                                                    tutorsinfo: tutorDataMap, studentdata: widget.studentdata,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 10.0,
                                                  right: 10.0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
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
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 150.0,
                                        width: 150.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    _foundUsers[index].imageID),
                                                fit: BoxFit.cover)),
                                      ),
                                      ClipRect(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            RatingBar(
                                                initialRating: 0,
                                                minRating: 0,
                                                maxRating: 5,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 20,
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
                                                 Align(
                                        alignment: Alignment.topRight,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () {},
                                              child: Text(
                                                'PT',
                                                style:
                                                    GoogleFonts.ephesis(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800),
                                              )),
                                        ),
                                      ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 0, 0, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${_foundUsers[index].firstName}, (${_foundUsers[index].age})",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      Text(_foundUsers[index].country.isEmpty
                                          ? 'Add Country'
                                          : _foundUsers[index].country),
                                      Tooltip(
                                        message: _foundUsers[index]
                                            .language
                                            .join(', '),
                                        child: Text(
                                          _foundUsers[index].language.isEmpty
                                              ? 'Add Language'
                                              : _foundUsers[index]
                                                  .language
                                                  .join(', '),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 80,
                                    child: Text(
                                      _foundUsers[index]
                                              .promotionalMessage
                                              .isEmpty
                                          ? 'Add Message'
                                          : _foundUsers[index]
                                              .promotionalMessage,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Starting from \$${random.nextInt(100) + 1} per classes ",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.lato(
                                            color: kColorPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                     
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            : SizedBox(
                width: size.width - 400,
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ));
  }
}
