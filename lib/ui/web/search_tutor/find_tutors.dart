// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/search_tutor/tutor_list.dart';
import 'package:work4ututor/ui/web/signup/tutor_signup.dart';

import '../../../data_class/studentinfoclass.dart';
import '../../../data_class/subject_class.dart';
import '../../../provider/search_provider.dart';
import '../../../services/addpreftutor.dart';
import '../../../services/getlanguages.dart';
import '../../../utils/themes.dart';
import 'package:google_fonts/google_fonts.dart';

import '../student/main_dashboard/student_dashboard.dart';

class FindTutor extends StatefulWidget {
  final String userid;
  const FindTutor({super.key, required this.userid});

  @override
  State<FindTutor> createState() => _FindTutorState();
}

class _FindTutorState extends State<FindTutor> {
  int displayRange = 12;
  List<String> languages = [];
  List<String> subjects = [];
  List<String> cchoosen = [];
  List<String> servchoosen = [];
  List<String> subjectchoosen = [];
  List<String> languagechoosen = [];
  List<String> tempmyprefTutor = [];
  List<String> myprefTutor = [];
  List<String> typeofclass = [
    'In person Class',
    'Online Class',
  ];
  List<String> provided = [
    'Recovery Lessons',
    'Kids with Learning Difficulties',
    'Pre Exam Classes',
    'Deaf Language',
    'Own Program',
  ];
  List<String> city = [
    'Philippines',
    'China',
  ];

  bool filtervisible = true;
  List<bool> termStatus = [false, false, false, false, false, false];
  List<bool> viewpreferred = [false, false, false, false, false, false];
  String firstname = '';
  String middlename = '';
  String lastname = '';
  String fullName = '';
  String studentID = '';
  String profileurl = '';

  GlobalKey _buttonKey = GlobalKey();
  int newmessagecount = 0;
  int newnotificationcount = 0;
  Uint8List? imageBytes;
  ImageProvider? imageProvider;
  List<String> subjectuids = [];
Future<List<String>> getDataFromTutorSubjectTeach(List<String> subjects) async {
  List<String> uids = [];
  try {
    QuerySnapshot tutorQuerySnapshot = await FirebaseFirestore.instance
        .collection('tutor')
        .get();

    for (QueryDocumentSnapshot doc in tutorQuerySnapshot.docs) {
      QuerySnapshot coursesSnapshot = await doc.reference.collection('mycourses')
          .where('subjectname', whereIn: subjects)
          .get();

      if (coursesSnapshot.docs.isNotEmpty) {
        // Check if any of the courses' subject names match any of the provided subjects
        for (QueryDocumentSnapshot courseDoc in coursesSnapshot.docs) {
          String courseSubject = courseDoc.get('subjectname');
          if (subjects.contains(courseSubject)) {
            uids.add(doc.get('userID'));
            break; // Once the UID is added, no need to check other courses for this tutor
          }
        }
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return uids;
}




  @override
  Widget build(BuildContext context) {
    List<String> countryNames = Provider.of<List<String>>(context);
    List<LanguageData> languagedata = Provider.of<List<LanguageData>>(context);
    final preferredTutorsNotifier =
        Provider.of<PreferredTutorsNotifier>(context);
    final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
    if (studentinfodata.isNotEmpty) {
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
    }
    if (studentinfodata.isEmpty) {}
    final subjectlist = Provider.of<List<Subjects>>(context);
    subjects = subjectlist.map((subject) => subject.subjectName).toList();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        toolbarHeight: 65,
        backgroundColor: kColorPrimary,
        elevation: 4,
        shadowColor: Colors.black,
        title: InkWell(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentDashboardPage(
                        uID: widget.userid.toString(),
                        email: '',
                      )),
            );
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
            width: 240,
            child: Image.asset(
              "assets/images/worklogo.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
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
          InkWell(
            onTap: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentDashboardPage(
                          uID: widget.userid.toString(),
                          email: '',
                        )),
              );
            },
            child: Padding(
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
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.clear,
                                      size: 25,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      viewpreferred[1] = false;
                                      viewpreferred[2] = false;
                                      viewpreferred[3] = false;
                                      viewpreferred[4] = false;
                                      viewpreferred[5] = false;
                                      servchoosen.clear();
                                      cchoosen.clear();
                                      subjectchoosen.clear();
                                      languagechoosen.clear();
                                      myprefTutor.clear();
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
                                onTap: () async {
                                  if (!preferredTutorsNotifier.isFetching) {
                                    await preferredTutorsNotifier
                                        .fetchPreferredTutors(widget.userid);
                                    tempmyprefTutor =
                                        preferredTutorsNotifier.preferredTutors;
                                  }

                                  setState(() {
                                    viewpreferred[1] = !viewpreferred[1];
                                    viewpreferred[2] = false;
                                    viewpreferred[3] = false;
                                    viewpreferred[4] = false;
                                    viewpreferred[5] = false;
                                    if (myprefTutor.isNotEmpty) {
                                      myprefTutor.clear();
                                    } else {
                                      myprefTutor = tempmyprefTutor;
                                    }

                                    servchoosen.clear();
                                    cchoosen.clear();
                                    subjectchoosen.clear();
                                    languagechoosen.clear();
                                  });
                                },
                                onHover: (hover) {
                                  termStatus[1] = hover;
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[1]
                                        ? kColorLight
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        viewpreferred[1]
                                            ? FontAwesomeIcons.handshake
                                            : FontAwesomeIcons.handshake,
                                        color: viewpreferred[1]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Preferred Tutor',
                                        style: GoogleFonts.roboto(
                                            color: viewpreferred[1]
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
                                    viewpreferred[1] = false;
                                    viewpreferred[3] = false;
                                    viewpreferred[4] = false;
                                    viewpreferred[5] = false;
                                    myprefTutor.clear();
                                    cchoosen.clear();
                                    servchoosen.clear();
                                    subjectchoosen.clear();
                                    languagechoosen.clear();
                                  });
                                },
                                onHover: (hover) {
                                  termStatus[2] = hover;
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[2]
                                        ? kColorLight
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        viewpreferred[2]
                                            ? FontAwesomeIcons.mapLocation
                                            : FontAwesomeIcons.mapLocation,
                                        color: viewpreferred[2]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Country',
                                        style: GoogleFonts.roboto(
                                            color: viewpreferred[2]
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
                                        value: cchoosen
                                            .contains(countryNames[index]),
                                        onChanged: (value) {
                                          setState(() {
                                            if (cchoosen.contains(
                                                countryNames[index])) {
                                              cchoosen
                                                  .remove(countryNames[index]);
                                            } else {
                                              cchoosen.add(countryNames[index]);
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
                                    viewpreferred[1] = false;
                                    viewpreferred[2] = false;
                                    viewpreferred[4] = false;
                                    viewpreferred[5] = false;
                                    cchoosen.clear();
                                    servchoosen.clear();
                                    subjectchoosen.clear();
                                    languagechoosen.clear();
                                    myprefTutor.clear();
                                  });
                                },
                                onHover: (hover) {
                                  termStatus[3] = hover;
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[3]
                                        ? kColorLight
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        viewpreferred[3]
                                            ? FontAwesomeIcons.handScissors
                                            : FontAwesomeIcons.handScissors,
                                        color: viewpreferred[3]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Subject',
                                        style: GoogleFonts.roboto(
                                            color: viewpreferred[3]
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
                                        onChanged: (value) async {
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
                                          if (subjectchoosen.isNotEmpty) {
                                            List<String> tempsubjectuids =
                                                await getDataFromTutorSubjectTeach(
                                                    subjectchoosen);
                                            setState(() {
                                              subjectuids = tempsubjectuids;
                                            });
                                          } else {
                                            setState(() {
                                              subjectuids = [];
                                            });
                                          }
                                          print(subjectchoosen);
                                          print(subjectuids);
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
                                    viewpreferred[2] = false;
                                    viewpreferred[3] = false;
                                    viewpreferred[1] = false;
                                    viewpreferred[5] = false;
                                    servchoosen.clear();
                                    cchoosen.clear();
                                    subjectchoosen.clear();
                                    myprefTutor.clear();
                                    languagechoosen.clear();
                                  });
                                },
                                onHover: (hover) {
                                  termStatus[4] = hover;
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[4]
                                        ? kColorLight
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        viewpreferred[4]
                                            ? FontAwesomeIcons.language
                                            : FontAwesomeIcons.language,
                                        color: viewpreferred[4]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Language',
                                        style: GoogleFonts.roboto(
                                            color: viewpreferred[4]
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
                                    itemCount: languagedata.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        title: Text(
                                          languagedata[index]
                                              .languageNamesStream,
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value: languagechoosen.contains(
                                            languagedata[index]
                                                .languageNamesStream),

                                        onChanged: (value) {
                                          setState(() {
                                            if (languagechoosen.contains(
                                                languagedata[index]
                                                    .languageNamesStream)) {
                                              languagechoosen.remove(
                                                  languagedata[index]
                                                      .languageNamesStream);
                                            } else {
                                              languagechoosen.add(
                                                  languagedata[index]
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
                                    viewpreferred[2] = false;
                                    viewpreferred[3] = false;
                                    viewpreferred[4] = false;
                                    viewpreferred[1] = false;
                                    servchoosen.clear();
                                    cchoosen.clear();
                                    subjectchoosen.clear();
                                    languagechoosen.clear();
                                    myprefTutor.clear();
                                  });
                                },
                                onHover: (hover) {
                                  termStatus[5] = hover;
                                },
                                child: Container(
                                  height: 35,
                                  width: 220,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  decoration: BoxDecoration(
                                    color: viewpreferred[5]
                                        ? kColorLight
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
                                        color: viewpreferred[5]
                                            ? Colors.white
                                            : Colors.black87,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Services Provided',
                                        style: GoogleFonts.roboto(
                                            color: viewpreferred[5]
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
                                    itemCount: provided.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        title: Text(
                                          provided[index],
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value: servchoosen
                                            .contains(provided[index]),
                                        onChanged: (value) {
                                          setState(() {
                                            if (servchoosen
                                                .contains(provided[index])) {
                                              servchoosen
                                                  .remove(provided[index]);
                                            } else {
                                              servchoosen.add(provided[index]);
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
                              Consumer<SearchTutorProvider>(
                                  builder: (context, searchTutorProvider, _) {
                                String data = searchTutorProvider.tName;
                                return TutorList(
                                  keyword: data,
                                  displayRange: displayRange,
                                  isLoading: false,
                                  studentdata: widget.userid,
                                  country: cchoosen,
                                  language: languagechoosen,
                                  preffered: myprefTutor,
                                  provided: servchoosen,
                                  subject: subjectuids,
                                );
                              }),
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
}
