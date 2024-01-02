// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/search_tutor/tutor_list.dart';
import 'package:work4ututor/ui/web/signup/tutor_signup.dart';

import '../../../components/students_navbar.dart';
import '../../../data_class/chatmessageclass.dart';
import '../../../data_class/studentinfoclass.dart';
import '../../../data_class/tutor_info_class.dart';
import '../../../provider/search_provider.dart';
import '../../../services/getlanguages.dart';
import '../../../utils/themes.dart';
import 'package:google_fonts/google_fonts.dart';

import '../student/book_classes/my_classes.dart';

class FindTutor extends StatefulWidget {
  final String userid;
  const FindTutor({super.key, required this.userid});

  @override
  State<FindTutor> createState() => _FindTutorState();
}

int displayRange = 12;
List<String> languages = [
  'Filipino',
  'English',
  'Russian',
  'Chinese',
  'Japanese',
];
List<String> subjects = [
  'Math',
  'English',
  'Geometry',
  'Music',
  'Language',
];
List<String> items = [];
List<String> subjectchoosen = [];
List<String> languagechoosen = [];
List<String> typeofclass = [
  'In person Class',
  'Online Class',
];
List<String> provided = [
  'Philippines',
  'China',
  'Russia',
  'United States',
  'India',
  'Japan',
];
List<String> city = [
  'Philippines',
  'China',
];

final TextEditingController _typeAheadController = TextEditingController();

final TextEditingController _typeAheadController1 = TextEditingController();

final TextEditingController _typeAheadController2 = TextEditingController();

final TextEditingController _typeAheadController3 = TextEditingController();

final TextEditingController _typeAheadController4 = TextEditingController();

final TextEditingController _typeAheadController5 = TextEditingController();

bool filtervisible = true;
double _pricevalue = 0;
int _rating = 0;
List<bool> termStatus = [false, false, false, false, false, false];
List<bool> viewpreferred = [false, false, false, false, false, false];
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
Uint8List? imageBytes;
ImageProvider? imageProvider;
gotoList() {
  return const MyClasses();
}

String? downloadURL;
String? downloadURL1;
void _updateResponse() async {
  String result = await getData();
  downloadURL1 = result;
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

class _FindTutorState extends State<FindTutor> {
  @override
  Widget build(BuildContext context) {
    List<String> countryNames = Provider.of<List<String>>(context);
    List<LanguageData> names = Provider.of<List<LanguageData>>(context);
    final String setSearch = context.select((SearchTutorProvider p) => p.tName);
    final tutorsinfo = Provider.of<List<TutorInformation>>(context);
    print(tutorsinfo.length);
    List<StudentInfoClass> studentinfodata =
        Provider.of<List<StudentInfoClass>>(context);
    if (downloadURL1 == null) {
      if (studentinfodata.isNotEmpty) {
        setState(() {
          final studentdata = studentinfodata
              .where((student) => student.userID == widget.userid)
              .toList();
          firstname = studentdata.first.studentFirstname;
          middlename = studentdata.first.studentMiddlename;
          lastname = studentdata.first.studentLastname;
          fullName = middlename == 'N/A'
              ? '$firstname $lastname'
              : '$firstname $middlename $lastname';
          studentID = studentdata.first.studentID;
          profileurl = studentdata.first.profilelink;
          _updateResponse();
        });
      }
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
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
                    initialRating: 0,
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
            padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
            child: profileurl.isEmpty
                ? const Center(child: Icon(Icons.person))
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                      profileurl.toString(),
                    ),
                    radius: 25,
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(100, 25, 100, 0),
            child: SizedBox(
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: size.width > 1350 ? 3 : 4,
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        filtervisible = !filtervisible;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.filter_list,
                                      size: 25,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        filtervisible = !filtervisible;
                                      });
                                    },
                                    child: const Text(
                                      "Filters",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      _typeAheadController.text = '';
                                      _typeAheadController1.text = '';
                                      _typeAheadController2.text = '';
                                      _typeAheadController3.text = '';
                                      _typeAheadController4.text = '';
                                      _typeAheadController5.text = '';
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      size: 25,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _typeAheadController.text = '';
                                      _typeAheadController1.text = '';
                                      _typeAheadController2.text = '';
                                      _typeAheadController3.text = '';
                                      _typeAheadController4.text = '';
                                      _typeAheadController5.text = '';
                                    },
                                    child: const Text(
                                      "Clear",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    viewpreferred[1] = !viewpreferred[1];
                                  });
                                },
                                onHover: (hover) {
                                  setState(() {
                                    termStatus[1] = hover;
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[1]
                                        ? kColorLight
                                        : termStatus[1]
                                            ? Colors.grey.shade300
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        termStatus[1] || viewpreferred[1]
                                            ? FontAwesomeIcons.handshake
                                            : FontAwesomeIcons.handshake,
                                        color: termStatus[1] || viewpreferred[1]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Preferred Tutor',
                                        style: GoogleFonts.roboto(
                                            color: termStatus[1] ||
                                                    viewpreferred[1]
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: viewpreferred[1]
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    viewpreferred[2] = !viewpreferred[2];
                                  });
                                },
                                onHover: (hover) {
                                  setState(() {
                                    termStatus[2] = hover;
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[2]
                                        ? kColorLight
                                        : termStatus[2]
                                            ? Colors.grey.shade300
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        termStatus[2] || viewpreferred[2]
                                            ? FontAwesomeIcons.mapLocation
                                            : FontAwesomeIcons.mapLocation,
                                        color: termStatus[2] || viewpreferred[2]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Country',
                                        style: GoogleFonts.roboto(
                                            color: termStatus[2] ||
                                                    viewpreferred[2]
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: viewpreferred[2]
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: viewpreferred[2],
                                child: Container(
                                  height: 250,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 10, bottom: 10, left: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: countryNames.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        title: Text(
                                          countryNames[index],
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value:
                                            items.contains(countryNames[index]),
                                        onChanged: (value) {
                                          setState(() {
                                            if (items.contains(
                                                countryNames[index])) {
                                              items.remove(countryNames[index]);
                                            } else {
                                              items.add(countryNames[index]);
                                            }
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .leading, // Place checkbox before the title
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    viewpreferred[3] = !viewpreferred[3];
                                  });
                                },
                                onHover: (hover) {
                                  setState(() {
                                    termStatus[3] = hover;
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[3]
                                        ? kColorLight
                                        : termStatus[3]
                                            ? Colors.grey.shade300
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        termStatus[3] || viewpreferred[3]
                                            ? FontAwesomeIcons.handScissors
                                            : FontAwesomeIcons.handScissors,
                                        color: termStatus[3] || viewpreferred[3]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Subject',
                                        style: GoogleFonts.roboto(
                                            color: termStatus[3] ||
                                                    viewpreferred[3]
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: viewpreferred[3]
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: viewpreferred[3],
                                child: Container(
                                  height: 250,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 10, bottom: 10, left: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: subjects.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        title: Text(
                                          subjects[index],
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value: subjectchoosen
                                            .contains(subjects[index]),
                                        onChanged: (value) {
                                          setState(() {
                                            if (subjectchoosen
                                                .contains(subjects[index])) {
                                              subjectchoosen
                                                  .remove(subjects[index]);
                                            } else {
                                              subjectchoosen
                                                  .add(subjects[index]);
                                            }
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .leading, // Place checkbox before the title
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    viewpreferred[4] = !viewpreferred[4];
                                  });
                                },
                                onHover: (hover) {
                                  setState(() {
                                    termStatus[4] = hover;
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[4]
                                        ? kColorLight
                                        : termStatus[4]
                                            ? Colors.grey.shade300
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        termStatus[4] || viewpreferred[4]
                                            ? FontAwesomeIcons.language
                                            : FontAwesomeIcons.language,
                                        color: termStatus[4] || viewpreferred[4]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Language',
                                        style: GoogleFonts.roboto(
                                            color: termStatus[4] ||
                                                    viewpreferred[4]
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: viewpreferred[4]
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: viewpreferred[4],
                                child: Container(
                                  height: 250,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 10, bottom: 10, left: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: names.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        title: Text(
                                          names[index].languageNamesStream,
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value: languagechoosen
                                            .contains(languages[index]),
                                        onChanged: (value) {
                                          setState(() {
                                            if (languagechoosen
                                                .contains(languages[index])) {
                                              languagechoosen.remove(
                                                  names[index]
                                                      .languageNamesStream);
                                            } else {
                                              languagechoosen.add(names[index]
                                                  .languageNamesStream);
                                            }
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .leading, // Place checkbox before the title
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    viewpreferred[5] = !viewpreferred[5];
                                  });
                                },
                                onHover: (hover) {
                                  setState(() {
                                    termStatus[5] = hover;
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[5]
                                        ? kColorLight
                                        : termStatus[5]
                                            ? Colors.grey.shade300
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        viewpreferred[5]
                                            ? FontAwesomeIcons.solidHandPeace
                                            : FontAwesomeIcons.handPeace,
                                        color: termStatus[5] || viewpreferred[5]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Services Provided',
                                        style: GoogleFonts.roboto(
                                            color: termStatus[5] ||
                                                    viewpreferred[5]
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: viewpreferred[5]
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: viewpreferred[5],
                                child: Container(
                                  height: 250,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 10, bottom: 10, left: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: subjects.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        title: Text(
                                          subjects[index],
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value: items.contains(subjects[index]),
                                        onChanged: (value) {
                                          setState(() {
                                            if (items
                                                .contains(subjects[index])) {
                                              items.remove(subjects[index]);
                                            } else {
                                              items.add(subjects[index]);
                                            }
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .leading, // Place checkbox before the title
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              // Visibility(
                              //   visible: filtervisible ? true : false,
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //         height: 50,
                              //         width: 220,
                              //         padding: const EdgeInsets.only(
                              //             right: 20, left: 20),
                              //         decoration: const BoxDecoration(
                              //           shape: BoxShape.rectangle,
                              //           color: kColorLight,
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20)),
                              //         ),
                              //         child: TypeAheadField(
                              //           hideOnEmpty: false,
                              //           textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //             style: const TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 15,
                              //             ),
                              //             autofocus: false,
                              //             controller: _typeAheadController,
                              //             decoration: const InputDecoration(
                              //               border: InputBorder.none,
                              //               hintText: 'Country',
                              //               hintStyle: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 15,
                              //               ),
                              //             ),
                              //           ),
                              //           suggestionsCallback: (pattern) {
                              //             return items.where((item) => item
                              //                 .toLowerCase()
                              //                 .contains(pattern.toLowerCase()));
                              //           },
                              //           itemBuilder: (context, suggestion) {
                              //             return ListTile(
                              //               title: Text(
                              //                 suggestion.toString(),
                              //               ),
                              //             );
                              //           },
                              //           onSuggestionSelected: (selectedItem) {
                              //             print('Selected item: $selectedItem');
                              //             setState(() {
                              //               _typeAheadController.text =
                              //                   selectedItem.toString();
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Container(
                              //         height: 50,
                              //         width: 220,
                              //         padding: const EdgeInsets.only(
                              //             right: 20, left: 20),
                              //         decoration: const BoxDecoration(
                              //           shape: BoxShape.rectangle,
                              //           color: kColorLight,
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20)),
                              //         ),
                              //         child: TypeAheadField(
                              //           hideOnEmpty: false,
                              //           textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //             style: const TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 15,
                              //             ),
                              //             autofocus: false,
                              //             controller: _typeAheadController1,
                              //             decoration: const InputDecoration(
                              //               border: InputBorder.none,
                              //               hintText: 'City',
                              //               hintStyle: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 15,
                              //               ),
                              //             ),
                              //           ),
                              //           suggestionsCallback: (pattern) {
                              //             return city.where((item) => item
                              //                 .toLowerCase()
                              //                 .contains(pattern.toLowerCase()));
                              //           },
                              //           itemBuilder: (context, suggestion) {
                              //             return ListTile(
                              //               title: Text(
                              //                 suggestion.toString(),
                              //               ),
                              //             );
                              //           },
                              //           onSuggestionSelected: (selectedItem) {
                              //             print('Selected item: $selectedItem');
                              //             setState(() {
                              //               _typeAheadController1.text =
                              //                   selectedItem.toString();
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Container(
                              //         height: 50,
                              //         width: 220,
                              //         padding: const EdgeInsets.only(
                              //             right: 20, left: 20),
                              //         decoration: const BoxDecoration(
                              //           shape: BoxShape.rectangle,
                              //           color: kColorLight,
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20)),
                              //         ),
                              //         child: TypeAheadField(
                              //           hideOnEmpty: false,
                              //           textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //             style: const TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 15,
                              //             ),
                              //             autofocus: false,
                              //             controller: _typeAheadController2,
                              //             decoration: const InputDecoration(
                              //               border: InputBorder.none,
                              //               hintText: 'Language',
                              //               hintStyle: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 15,
                              //               ),
                              //             ),
                              //           ),
                              //           suggestionsCallback: (pattern) {
                              //             return languages.where((item) => item
                              //                 .toLowerCase()
                              //                 .contains(pattern.toLowerCase()));
                              //           },
                              //           itemBuilder: (context, suggestion) {
                              //             return ListTile(
                              //               title: Text(
                              //                 suggestion.toString(),
                              //               ),
                              //             );
                              //           },
                              //           onSuggestionSelected: (selectedItem) {
                              //             print('Selected item: $selectedItem');
                              //             setState(() {
                              //               _typeAheadController2.text =
                              //                   selectedItem.toString();
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Container(
                              //           height: 50,
                              //           width: 220,
                              //           padding: const EdgeInsets.only(
                              //               right: 20, left: 20, top: 2),
                              //           decoration: const BoxDecoration(
                              //             shape: BoxShape.rectangle,
                              //             color: kColorLight,
                              //             borderRadius: BorderRadius.all(
                              //                 Radius.circular(20)),
                              //           ),
                              //           child: Column(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.start,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Text(
                              //                 'Pricing: $_pricevalue',
                              //                 style: const TextStyle(
                              //                   color: Colors.white,
                              //                   fontSize: 15,
                              //                 ),
                              //               ),
                              //               Row(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.center,
                              //                 children: [
                              //                   SliderTheme(
                              //                     data: SliderTheme.of(context)
                              //                         .copyWith(
                              //                       trackHeight: 5.0,
                              //                       trackShape:
                              //                           const RoundedRectSliderTrackShape(),
                              //                       activeTrackColor:
                              //                           kColorPrimary,
                              //                       inactiveTrackColor:
                              //                           Colors.white,
                              //                       thumbShape:
                              //                           const RoundSliderThumbShape(
                              //                         enabledThumbRadius: 10.0,
                              //                         pressedElevation: 0.0,
                              //                       ),
                              //                       thumbColor: kColorPrimary,
                              //                       overlayColor:
                              //                           Colors.transparent,
                              //                       overlayShape:
                              //                           const RoundSliderOverlayShape(
                              //                               overlayRadius: 0.0),
                              //                       tickMarkShape:
                              //                           const RoundSliderTickMarkShape(),
                              //                       activeTickMarkColor:
                              //                           kColorPrimaryDark,
                              //                       inactiveTickMarkColor:
                              //                           Colors.white,
                              //                       valueIndicatorShape:
                              //                           const PaddleSliderValueIndicatorShape(),
                              //                       valueIndicatorColor:
                              //                           Colors.black,
                              //                       valueIndicatorTextStyle:
                              //                           const TextStyle(
                              //                         color: Colors.white,
                              //                         fontSize: 12.0,
                              //                       ),
                              //                     ),
                              //                     child: Slider(
                              //                       min: 0.0,
                              //                       max: 500.0,
                              //                       value: _pricevalue,
                              //                       divisions: 500,
                              //                       label:
                              //                           '${_pricevalue.round()}',
                              //                       onChanged: (value) {
                              //                         setState(() {
                              //                           _pricevalue = value;
                              //                         });
                              //                       },
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ],
                              //           )),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Container(
                              //         height: 50,
                              //         width: 220,
                              //         padding: const EdgeInsets.only(
                              //             right: 20, left: 20, top: 2),
                              //         decoration: const BoxDecoration(
                              //           shape: BoxShape.rectangle,
                              //           color: kColorLight,
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20)),
                              //         ),
                              //         child: Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.start,
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           children: [
                              //             Text(
                              //               'Rating: $_rating',
                              //               style: const TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 15,
                              //               ),
                              //             ),
                              //             Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               children: [
                              //                 IconButton(
                              //                   padding: EdgeInsets.zero,
                              //                   constraints:
                              //                       const BoxConstraints(),
                              //                   icon: Icon(
                              //                     _rating >= 1
                              //                         ? Icons.star
                              //                         : Icons.star_border,
                              //                     color: _rating >= 1
                              //                         ? Colors.orange
                              //                         : Colors.white,
                              //                     size: 20,
                              //                   ),
                              //                   onPressed: () {
                              //                     setState(() {
                              //                       if (_rating > 1 ||
                              //                           _rating == 0) {
                              //                         _rating = 1;
                              //                       } else {
                              //                         _rating = 0;
                              //                       }
                              //                     });
                              //                   },
                              //                 ),
                              //                 IconButton(
                              //                   padding: EdgeInsets.zero,
                              //                   constraints:
                              //                       const BoxConstraints(),
                              //                   icon: Icon(
                              //                     _rating >= 2
                              //                         ? Icons.star
                              //                         : Icons.star_border,
                              //                     color: _rating >= 2
                              //                         ? Colors.orange
                              //                         : Colors.white,
                              //                     size: 20,
                              //                   ),
                              //                   onPressed: () {
                              //                     setState(() {
                              //                       _rating = 2;
                              //                     });
                              //                   },
                              //                 ),
                              //                 IconButton(
                              //                   padding: EdgeInsets.zero,
                              //                   constraints:
                              //                       const BoxConstraints(),
                              //                   icon: Icon(
                              //                     _rating >= 3
                              //                         ? Icons.star
                              //                         : Icons.star_border,
                              //                     color: _rating >= 3
                              //                         ? Colors.orange
                              //                         : Colors.white,
                              //                     size: 20,
                              //                   ),
                              //                   onPressed: () {
                              //                     setState(() {
                              //                       _rating = 3;
                              //                     });
                              //                   },
                              //                 ),
                              //                 IconButton(
                              //                   padding: EdgeInsets.zero,
                              //                   constraints:
                              //                       const BoxConstraints(),
                              //                   icon: Icon(
                              //                     _rating >= 4
                              //                         ? Icons.star
                              //                         : Icons.star_border,
                              //                     color: _rating >= 4
                              //                         ? Colors.orange
                              //                         : Colors.white,
                              //                     size: 20,
                              //                   ),
                              //                   onPressed: () {
                              //                     setState(() {
                              //                       _rating = 4;
                              //                     });
                              //                   },
                              //                 ),
                              //                 IconButton(
                              //                   padding: EdgeInsets.zero,
                              //                   constraints:
                              //                       const BoxConstraints(),
                              //                   icon: Icon(
                              //                     _rating >= 5
                              //                         ? Icons.star
                              //                         : Icons.star_border,
                              //                     color: _rating >= 5
                              //                         ? Colors.orange
                              //                         : Colors.white,
                              //                     size: 20,
                              //                   ),
                              //                   onPressed: () {
                              //                     setState(() {
                              //                       _rating = 5;
                              //                     });
                              //                   },
                              //                 ),
                              //               ],
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Container(
                              //         height: 50,
                              //         width: 220,
                              //         padding: const EdgeInsets.only(
                              //             right: 20, left: 20),
                              //         decoration: const BoxDecoration(
                              //           shape: BoxShape.rectangle,
                              //           color: kColorLight,
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20)),
                              //         ),
                              //         child: TypeAheadField(
                              //           hideOnEmpty: false,
                              //           textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //             style: const TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 15,
                              //             ),
                              //             autofocus: false,
                              //             controller: _typeAheadController3,
                              //             decoration: const InputDecoration(
                              //               border: InputBorder.none,
                              //               hintText: 'Subject',
                              //               hintStyle: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 15,
                              //               ),
                              //             ),
                              //           ),
                              //           suggestionsCallback: (pattern) {
                              //             return subjects.where((item) => item
                              //                 .toLowerCase()
                              //                 .contains(pattern.toLowerCase()));
                              //           },
                              //           itemBuilder: (context, suggestion) {
                              //             return ListTile(
                              //               title: Text(
                              //                 suggestion.toString(),
                              //               ),
                              //             );
                              //           },
                              //           onSuggestionSelected: (selectedItem) {
                              //             print('Selected item: $selectedItem');
                              //             setState(() {
                              //               _typeAheadController3.text =
                              //                   selectedItem.toString();
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Container(
                              //         height: 50,
                              //         width: 220,
                              //         padding: const EdgeInsets.only(
                              //             right: 20, left: 20),
                              //         decoration: const BoxDecoration(
                              //           shape: BoxShape.rectangle,
                              //           color: kColorLight,
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20)),
                              //         ),
                              //         child: TypeAheadField(
                              //           hideOnEmpty: false,
                              //           textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //             style: const TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 15,
                              //             ),
                              //             autofocus: false,
                              //             controller: _typeAheadController4,
                              //             decoration: const InputDecoration(
                              //               border: InputBorder.none,
                              //               hintText: 'Service Provided',
                              //               hintStyle: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 15,
                              //               ),
                              //             ),
                              //           ),
                              //           suggestionsCallback: (pattern) {
                              //             return provided.where((item) => item
                              //                 .toLowerCase()
                              //                 .contains(pattern.toLowerCase()));
                              //           },
                              //           itemBuilder: (context, suggestion) {
                              //             return ListTile(
                              //               title: Text(
                              //                 suggestion.toString(),
                              //               ),
                              //             );
                              //           },
                              //           onSuggestionSelected: (selectedItem) {
                              //             print('Selected item: $selectedItem');
                              //             setState(() {
                              //               _typeAheadController4.text =
                              //                   selectedItem.toString();
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Container(
                              //         height: 50,
                              //         width: 220,
                              //         padding: const EdgeInsets.only(
                              //             right: 20, left: 20),
                              //         decoration: const BoxDecoration(
                              //           shape: BoxShape.rectangle,
                              //           color: kColorLight,
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20)),
                              //         ),
                              //         child: TypeAheadField(
                              //           hideOnEmpty: false,
                              //           textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //             style: const TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 15,
                              //             ),
                              //             autofocus: false,
                              //             controller: _typeAheadController5,
                              //             decoration: const InputDecoration(
                              //               border: InputBorder.none,
                              //               hintText: 'Type of Class',
                              //               hintStyle: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 15,
                              //               ),
                              //             ),
                              //           ),
                              //           suggestionsCallback: (pattern) {
                              //             return typeofclass.where((item) =>
                              //                 item.toLowerCase().contains(
                              //                     pattern.toLowerCase()));
                              //           },
                              //           itemBuilder: (context, suggestion) {
                              //             return ListTile(
                              //               title: Text(
                              //                 suggestion.toString(),
                              //               ),
                              //             );
                              //           },
                              //           onSuggestionSelected: (selectedItem) {
                              //             print('Selected item: $selectedItem');
                              //             setState(() {
                              //               _typeAheadController5.text =
                              //                   selectedItem.toString();
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        height: MediaQuery.of(context).size.height,
                        child: const VerticalDivider(
                          thickness: 1,
                        ),
                      ),
                      Flexible(
                        flex: 15,
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(
                            children: [
                              SizedBox(
                                width: size.width - 400,
                                height: 50,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            final provider = context
                                                .read<SearchTutorProvider>();
                                            provider.setSearch(tName);

                                            TutorList(
                                              keyword: setSearch,
                                              displayRange: displayRange,
                                              isLoading: false,
                                              studentdata: widget.userid,
                                            );
                                          });
                                        },
                                        child: const Icon(
                                          Icons.search_rounded,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    hintStyle: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    hintText: 'Search',
                                  ),
                                  validator: (val) => val!.isEmpty
                                      ? 'Enter your search filter'
                                      : null,
                                  onChanged: (val) {
                                    tName = val;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              // CheckboxListTile(
                              //   contentPadding: EdgeInsets.zero,
                              //   title: const Text(
                              //     'My preferred tutor',
                              //     style: TextStyle(
                              //         fontSize: 16,
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w500),
                              //   ),
                              //   autofocus: false,
                              //   activeColor: Colors.green,
                              //   checkColor: Colors.white,
                              //   selected: termStatus,
                              //   value: termStatus,
                              //   controlAffinity:
                              //       ListTileControlAffinity.leading,
                              //   onChanged: (value) {
                              //     setState(() {
                              //       termStatus = value!;
                              //     });
                              //   },
                              //   visualDensity: VisualDensity
                              //       .compact, // Set visualDensity to compact
                              // ),
                              TutorList(
                                keyword: setSearch,
                                displayRange: displayRange,
                                isLoading: false,
                                studentdata: widget.userid,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 45,
                                width: 200,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: kColorLight,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontStyle: FontStyle.normal,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           const StudentSignup()),
                                    // );
                                  },
                                  child: const Text('Display More'),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _showModal = false;
              });
            },
            child: StudentsMenu()),
      ],
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "search"),
            )
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
