// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/search_tutor/tutor_list.dart';
import 'package:work4ututor/ui/web/signup/tutor_signup.dart';

import '../../../constant/constant.dart';
import '../../../data_class/studentinfoclass.dart';
import '../../../data_class/subject_class.dart';
import '../../../data_class/tutor_info_class.dart';
import '../../../provider/displaycount.dart';
import '../../../provider/init_provider.dart';
import '../../../provider/search_provider.dart';
import '../../../services/addpreftutor.dart';
import '../../../services/getlanguages.dart';
import '../../../services/getstudentinfo.dart';
import '../../../shared_components/responsive_builder.dart';
import '../../../utils/themes.dart';
import 'package:google_fonts/google_fonts.dart';

class FindTutor extends StatefulWidget {
  final String userid;
  const FindTutor({super.key, required this.userid});

  @override
  State<FindTutor> createState() => _FindTutorState();
}

class _FindTutorState extends State<FindTutor> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier =
          Provider.of<PreferredTutorsNotifier>(context, listen: false);
      notifier.fetchPreferredTutors(widget.userid);
    });
    // _fetchData();
    // _pageController = PageController(initialPage: _currentPageIndex);
    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   if (_currentPageIndex < gifUrls.length - 1) {
    //     _currentPageIndex++;
    //   } else {
    //     _currentPageIndex = 0;
    //   }
    //   _pageController.animateToPage(
    //     _currentPageIndex,
    //     duration: const Duration(milliseconds: 500),
    //     curve: Curves.easeInOut,
    //   );
    // });
  }

  @override
  void dispose() {
    // _pageController.dispose();
    // _timer.cancel();
    super.dispose();
  }

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
  String timezone = '';
  String? profileurl;

  GlobalKey buttonKey = GlobalKey();
  int newmessagecount = 0;
  int newnotificationcount = 0;
  Uint8List? imageBytes;
  ImageProvider? imageProvider;
  List<String> subjectuids = [];
  Future<List<String>> getDataFromTutorSubjectTeach(
      List<String> subjects) async {
    List<String> uids = [];
    try {
      // Step 1: Fetch all tutors once
      QuerySnapshot tutorQuerySnapshot =
          await FirebaseFirestore.instance.collection('tutor').get();

      // Step 2: Collect all Future queries for each tutor's subcollection
      List<Future<QuerySnapshot>> futures = [];

      for (QueryDocumentSnapshot tutorDoc in tutorQuerySnapshot.docs) {
        Future<QuerySnapshot> future = tutorDoc.reference
            .collection('mycourses')
            .where('subjectname', whereIn: subjects)
            .get();
        futures.add(future);
      }

      // Step 3: Await all futures to execute concurrently
      List<QuerySnapshot> results = await Future.wait(futures);

      // Step 4: Extract user IDs based on course matches
      for (int i = 0; i < results.length; i++) {
        if (results[i].docs.isNotEmpty) {
          String uid = tutorQuerySnapshot.docs[i].get('userID');
          uids.add(uid); // Ensure we get the 'userID' from the tutor document
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return uids;
  }

  final studentdeskkey = GlobalKey<ScaffoldState>();
  bool _showModal = false;
  ScrollController scrollController = ScrollController();
  bool _isDataLoaded = false; // Track whether data has been fetched

  Future<void> _fetchData(
      PreferredTutorsNotifier preferredTutorsNotifier) async {
    await preferredTutorsNotifier.fetchPreferredTutors(widget.userid);
    setState(() {
      tempmyprefTutor = preferredTutorsNotifier.preferredTutors;
      _isDataLoaded = true; // Mark data as loaded
    });
  }

  List<String> gifUrls = [
    'https://media.giphy.com/media/3o7qE0GkUwXGfHwlwo/giphy.gif', // Dancing Cat
    'https://media.giphy.com/media/5ftsmLIqktHQA/giphy.gif', // Happy Dance
    'https://media.giphy.com/media/3oz8xLd9DJq2l2VFtu/giphy.gif', // Excited Dog
    'https://media.giphy.com/media/l4FGI8l7Q6iXz8bIc/giphy.gif', // Baby Yoda
    'https://media.giphy.com/media/26BRv0ThflsHCj3k4/giphy.gif', // Excited Kid
    // Add more valid URLs as needed
  ];
  bool isSearchIconClicked = true;
  StudentInfoClass? tempinfo;
  @override
  Widget build(BuildContext context) {
    final List<TutorInformation> temptutorsinfo =
        Provider.of<List<TutorInformation>>(context);
    List<TutorInformation> tutorsinfo = temptutorsinfo;
    List<String> countryNames = Provider.of<List<String>>(context);
    List<LanguageData> languagedata = Provider.of<List<LanguageData>>(context);
    final preferredTutorsNotifier =
        Provider.of<PreferredTutorsNotifier>(context);

    final subjectlist = Provider.of<List<Subjects>>(context);
    subjects = subjectlist.map((subject) => subject.subjectName).toList();
    Size size = MediaQuery.of(context).size;

    return StreamProvider<List<StudentInfoClass>>.value(
        value: StudentInfoData(uid: widget.userid).getstudentinfo,
        catchError: (context, error) {
          return [];
        },
        initialData: const [],
        child: Consumer<List<StudentInfoClass>>(
            builder: (context, studentInfo, child) {
          if (studentInfo.isEmpty) {}
          if (studentInfo.isNotEmpty) {
            final studentdata = studentInfo
                .where((student) => student.userID == widget.userid)
                .toList();
            firstname = studentdata.first.studentFirstname;
            middlename = studentdata.first.studentMiddlename;
            lastname = studentdata.first.studentLastname;
            fullName = middlename == 'N/A'
                ? '$firstname $lastname'
                : '$firstname $middlename $lastname';
            studentID = studentdata.first.studentID;
            timezone = studentdata.first.timezone;
            profileurl = studentdata.first.profilelink;
            tempinfo = studentdata.first;
          }
          return Scaffold(
            key: studentdeskkey,
            backgroundColor: const Color.fromRGBO(245, 247, 248, 1),
            appBar: AppBar(
              toolbarHeight: 65,
              backgroundColor: kColorPrimary,
              elevation: 4,
              shadowColor: Colors.black,
              automaticallyImplyLeading: false,
              title: InkWell(
                onTap: () {
                  GoRouter.of(context)
                      .go('/studentdiary/${widget.userid.toString()}');
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
                ResponsiveBuilder.isDesktop(context)
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                            child: Badge(
                              isLabelVisible:
                                  newnotificationcount == 0 ? false : true,
                              alignment: AlignmentDirectional.centerEnd,
                              label: Text(
                                newnotificationcount.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              child: IconButton(
                                  key: buttonKey,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                // RatingBar(
                                //     initialRating: 0,
                                //     direction: Axis.horizontal,
                                //     allowHalfRating: true,
                                //     itemCount: 5,
                                //     itemSize: 16,
                                //     ratingWidget: RatingWidget(
                                //         full: const Icon(Icons.star,
                                //             color: Colors.orange),
                                //         half: const Icon(
                                //           Icons.star_half,
                                //           color: Colors.orange,
                                //         ),
                                //         empty: const Icon(
                                //           Icons.star_outline,
                                //           color: Colors.orange,
                                //         )),
                                //     onRatingUpdate: (value) {
                                //       // _ratingValue = value;
                                //     }),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: profileurl == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      profileurl.toString(),
                                    ),
                                    radius: 25,
                                  ),
                          ),
                        ],
                      )
                    : ResponsiveBuilder.isDesktop(context)
                        ? Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 15, 10),
                                child: Badge(
                                  isLabelVisible:
                                      newnotificationcount == 0 ? false : true,
                                  alignment: AlignmentDirectional.centerEnd,
                                  label: Text(
                                    newnotificationcount.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                      key: buttonKey,
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
                                        initialRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 16,
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
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: profileurl == null
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          profileurl.toString(),
                                        ),
                                        radius: 25,
                                      ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: kSpacing / 2),
                                child: IconButton(
                                  onPressed: () {
                                    if (studentdeskkey.currentState != null) {
                                      studentdeskkey.currentState!
                                          .openEndDrawer();
                                    }
                                  },
                                  icon: const Icon(Icons.menu),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 15, 10),
                                child: Badge(
                                  isLabelVisible:
                                      newnotificationcount == 0 ? false : true,
                                  alignment: AlignmentDirectional.centerEnd,
                                  label: Text(
                                    newnotificationcount.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                      key: buttonKey,
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
                                        initialRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 16,
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
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: kSpacing / 2),
                                child: IconButton(
                                  onPressed: () {
                                    if (studentdeskkey.currentState != null) {
                                      studentdeskkey.currentState!
                                          .openEndDrawer();
                                    }
                                  },
                                  icon: const Icon(Icons.menu),
                                ),
                              ),
                            ],
                          )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: ResponsiveBuilder.isDesktop(context),
                    child: SingleChildScrollView(
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        elevation: 4,
                        child: SizedBox(
                          width: 260,
                          height: size.height - 70,
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    final provider =
                                        context.read<InitProvider>();
                                    provider.setMenuIndex(0);
                                  },
                                  child: Card(
                                    margin:
                                        const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                    elevation: 0,
                                    child: Container(
                                      height: 50,
                                      width: 260,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        // color: kSecondarycolor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                      ),
                                      child: SizedBox(
                                        height: 170,
                                        width: 200,
                                        child: Image.asset(
                                          "assets/images/SEARCH TUTOR.png",
                                          alignment: Alignment.center,
                                          fit: BoxFit.fitWidth,
                                          color:
                                              kColorPrimary, // Replace with your desired color
                                          colorBlendMode: BlendMode.modulate,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: 224,
                                  decoration: !viewpreferred[1]
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )
                                      : BoxDecoration(
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(220, 50)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    onPressed: () async {
                                      if (!preferredTutorsNotifier.isFetching) {
                                        await preferredTutorsNotifier
                                            .fetchPreferredTutors(
                                                widget.userid);
                                        tempmyprefTutor =
                                            preferredTutorsNotifier
                                                .preferredTutors;
                                      }

                                      setState(() {
                                        // viewpreferred[1] = !viewpreferred[1];
                                        // viewpreferred[2] = false;
                                        // viewpreferred[3] = false;
                                        // viewpreferred[4] = false;
                                        // viewpreferred[5] = false;
                                        if (myprefTutor.isNotEmpty) {
                                          myprefTutor.clear();
                                          viewpreferred[1] = !viewpreferred[1];
                                        } else {
                                          myprefTutor = tempmyprefTutor;
                                          viewpreferred[1] = !viewpreferred[1];
                                        }

                                        // servchoosen.clear();
                                        // cchoosen.clear();
                                        // subjectchoosen.clear();
                                        // languagechoosen.clear();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 35,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.handshake,
                                            size: 25,
                                            color: viewpreferred[1]
                                                ? Colors.white
                                                : kColorGrey,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Preferred Tutor',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: viewpreferred[1]
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: viewpreferred[1]
                                                  ? Colors.white
                                                  : kColorGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: 224,
                                  decoration: !viewpreferred[2]
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )
                                      : BoxDecoration(
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(220, 50)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        viewpreferred[2] = !viewpreferred[2];
                                        // viewpreferred[1] = false;
                                        // viewpreferred[3] = false;
                                        // viewpreferred[4] = false;
                                        // viewpreferred[5] = false;
                                        // myprefTutor.clear();
                                        if (cchoosen.isNotEmpty) {
                                          cchoosen.clear();
                                        }
                                        // servchoosen.clear();
                                        // subjectchoosen.clear();
                                        // languagechoosen.clear();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 35,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.mapLocation,
                                            size: 25,
                                            color: viewpreferred[2]
                                                ? Colors.white
                                                : kColorGrey,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Country',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: viewpreferred[2]
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: viewpreferred[2]
                                                  ? Colors.white
                                                  : kColorGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: viewpreferred[2],
                                  child: Container(
                                    height: 250,
                                    width: 220,
                                    padding: const EdgeInsets.only(
                                        right: 20,
                                        top: 10,
                                        bottom: 10,
                                        left: 20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: countryNames.length,
                                      itemBuilder: (context, index) {
                                        // Create a combined list of selected and unselected country names
                                        List<String> combinedList = [
                                          ...cchoosen,
                                          ...countryNames.where((name) =>
                                              !cchoosen.contains(name)),
                                        ];

                                        return CheckboxListTile(
                                          activeColor: kColorPrimary,
                                          checkColor: Colors.white,
                                          title: Text(
                                            combinedList[index],
                                            style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          value: cchoosen
                                              .contains(combinedList[index]),
                                          onChanged: (value) {
                                            setState(() {
                                              if (cchoosen.contains(
                                                  combinedList[index])) {
                                                cchoosen.remove(
                                                    combinedList[index]);
                                              } else {
                                                cchoosen
                                                    .add(combinedList[index]);
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
                                  height: 20,
                                ),
                                Container(
                                  width: 224,
                                  decoration: !viewpreferred[3]
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )
                                      : BoxDecoration(
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(220, 50)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        viewpreferred[3] = !viewpreferred[3];
                                        // viewpreferred[1] = false;
                                        // viewpreferred[2] = false;
                                        // viewpreferred[4] = false;
                                        // viewpreferred[5] = false;
                                        // cchoosen.clear();
                                        // servchoosen.clear();
                                        if (subjectchoosen.isNotEmpty) {
                                          subjectchoosen.clear();
                                        }

                                        // languagechoosen.clear();
                                        // myprefTutor.clear();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 35,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.book,
                                            size: 25,
                                            color: viewpreferred[3]
                                                ? Colors.white
                                                : kColorGrey,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Subject',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: viewpreferred[3]
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: viewpreferred[3]
                                                  ? Colors.white
                                                  : kColorGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: viewpreferred[3],
                                  child: Container(
                                    height: 250,
                                    width: 220,
                                    padding: const EdgeInsets.only(
                                        right: 20,
                                        top: 10,
                                        bottom: 10,
                                        left: 20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: subjects.length,
                                      itemBuilder: (context, index) {
                                        // Combine selected and unselected subjects, with selected subjects appearing first
                                        List<String> combinedSubjects = [
                                          ...subjectchoosen,
                                          ...subjects.where((subject) =>
                                              !subjectchoosen
                                                  .contains(subject)),
                                        ];

                                        return CheckboxListTile(
                                          activeColor: kColorPrimary,
                                          checkColor: Colors.white,
                                          title: Text(
                                            combinedSubjects[index],
                                            style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          value: subjectchoosen.contains(
                                              combinedSubjects[index]),
                                          onChanged: (value) async {
                                            setState(() {
                                              // Update the subjectchoosen list based on checkbox value
                                              if (subjectchoosen.contains(
                                                  combinedSubjects[index])) {
                                                subjectchoosen.remove(
                                                    combinedSubjects[index]);
                                              } else {
                                                subjectchoosen.add(
                                                    combinedSubjects[index]);
                                              }
                                            });

                                            // Perform async operation to fetch subject UIDs when subjectchoosen is updated
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
                                          },
                                          controlAffinity: ListTileControlAffinity
                                              .leading, // Place checkbox before the title
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: 224,
                                  decoration: !viewpreferred[4]
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )
                                      : BoxDecoration(
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(220, 50)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        viewpreferred[4] = !viewpreferred[4];
                                        // viewpreferred[2] = false;
                                        // viewpreferred[3] = false;
                                        // viewpreferred[1] = false;
                                        // viewpreferred[5] = false;
                                        // servchoosen.clear();
                                        // cchoosen.clear();
                                        // subjectchoosen.clear();
                                        // myprefTutor.clear();
                                        if (languagechoosen.isNotEmpty) {
                                          languagechoosen.clear();
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 35,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.language,
                                            size: 25,
                                            color: viewpreferred[4]
                                                ? Colors.white
                                                : kColorGrey,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Language',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: viewpreferred[4]
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: viewpreferred[4]
                                                  ? Colors.white
                                                  : kColorGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: viewpreferred[4],
                                  child: Container(
                                    height: 250,
                                    width: 220,
                                    padding: const EdgeInsets.only(
                                        right: 20,
                                        top: 10,
                                        bottom: 10,
                                        left: 20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: languagedata.length,
                                      itemBuilder: (context, index) {
                                        // Create a combined list of selected and unselected languages
                                        List<dynamic> combinedLanguageData = [
                                          ...languagedata.where((data) =>
                                              languagechoosen.contains(
                                                  data.languageNamesStream)),
                                          ...languagedata.where((data) =>
                                              !languagechoosen.contains(
                                                  data.languageNamesStream)),
                                        ];

                                        return CheckboxListTile(
                                          activeColor: kColorPrimary,
                                          checkColor: Colors.white,
                                          title: Text(
                                            combinedLanguageData[index]
                                                .languageNamesStream,
                                            style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          value: languagechoosen.contains(
                                              combinedLanguageData[index]
                                                  .languageNamesStream),
                                          onChanged: (value) {
                                            setState(() {
                                              if (languagechoosen.contains(
                                                  combinedLanguageData[index]
                                                      .languageNamesStream)) {
                                                languagechoosen.remove(
                                                    combinedLanguageData[index]
                                                        .languageNamesStream);
                                              } else {
                                                languagechoosen.add(
                                                    combinedLanguageData[index]
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
                                  height: 20,
                                ),
                                Container(
                                  width: 224,
                                  decoration: !viewpreferred[5]
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )
                                      : BoxDecoration(
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(220, 50)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        viewpreferred[5] = !viewpreferred[5];
                                        // viewpreferred[2] = false;
                                        // viewpreferred[3] = false;
                                        // viewpreferred[4] = false;
                                        // viewpreferred[1] = false;
                                        if (servchoosen.isNotEmpty) {
                                          servchoosen.clear();
                                        }
                                        // cchoosen.clear();
                                        // subjectchoosen.clear();
                                        // languagechoosen.clear();
                                        // myprefTutor.clear();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 35,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            viewpreferred[5]
                                                ? FontAwesomeIcons
                                                    .handHoldingHeart
                                                : FontAwesomeIcons
                                                    .handHoldingHeart,
                                            size: 25,
                                            color: viewpreferred[5]
                                                ? Colors.white
                                                : kColorGrey,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Services Provided',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: viewpreferred[5]
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: viewpreferred[5]
                                                  ? Colors.white
                                                  : kColorGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: viewpreferred[5],
                                  child: Container(
                                    height: 250,
                                    width: 220,
                                    padding: const EdgeInsets.only(
                                        right: 20,
                                        top: 10,
                                        bottom: 10,
                                        left: 20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: provided.length,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          activeColor: kColorPrimary,
                                          checkColor: Colors.white,
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
                                                servchoosen
                                                    .add(provided[index]);
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
                                // Row(
                                //   children: [
                                //     InkWell(
                                //       onTap: () {
                                //         setState(() {
                                //           filtervisible = !filtervisible;
                                //         });
                                //       },
                                //       child: const Icon(
                                //         Icons.filter_list,
                                //         size: 25,
                                //       ),
                                //     ),
                                //     InkWell(
                                //       onTap: () {
                                //         setState(() {
                                //           filtervisible = !filtervisible;
                                //         });
                                //       },
                                //       child: const Text(
                                //         "Filters",
                                //         style: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w600),
                                //       ),
                                //     ),
                                //     const Spacer(),
                                //     InkWell(
                                //       onTap: () {},
                                //       child: const Icon(
                                //         Icons.clear,
                                //         size: 25,
                                //       ),
                                //     ),
                                //     InkWell(
                                //       onTap: () {
                                //         viewpreferred[1] = false;
                                //         viewpreferred[2] = false;
                                //         viewpreferred[3] = false;
                                //         viewpreferred[4] = false;
                                //         viewpreferred[5] = false;
                                //         servchoosen.clear();
                                //         cchoosen.clear();
                                //         subjectchoosen.clear();
                                //         languagechoosen.clear();
                                //         myprefTutor.clear();
                                //       },
                                //       child: const Text(
                                //         "Clear",
                                //         style: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w600),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // InkWell(
                                //   onTap: () async {
                                //     if (!preferredTutorsNotifier.isFetching) {
                                //       await preferredTutorsNotifier
                                //           .fetchPreferredTutors(widget.userid);
                                //       tempmyprefTutor =
                                //           preferredTutorsNotifier.preferredTutors;
                                //     }

                                //     setState(() {
                                //       viewpreferred[1] = !viewpreferred[1];
                                //       viewpreferred[2] = false;
                                //       viewpreferred[3] = false;
                                //       viewpreferred[4] = false;
                                //       viewpreferred[5] = false;
                                //       if (myprefTutor.isNotEmpty) {
                                //         myprefTutor.clear();
                                //       } else {
                                //         myprefTutor = tempmyprefTutor;
                                //       }

                                //       servchoosen.clear();
                                //       cchoosen.clear();
                                //       subjectchoosen.clear();
                                //       languagechoosen.clear();
                                //     });
                                //   },
                                //   onHover: (hover) {
                                //     termStatus[1] = hover;
                                //   },
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(10.0),
                                //     child: Container(
                                //       width: 220,
                                //       decoration: !viewpreferred[1]
                                //           ? BoxDecoration(
                                //               color: Colors.white,
                                //               borderRadius: BorderRadius.circular(20),
                                //             )
                                //           : BoxDecoration(
                                //               boxShadow: const [
                                //                 BoxShadow(
                                //                     color: Colors.black26,
                                //                     offset: Offset(0, 4),
                                //                     blurRadius: 5.0)
                                //               ],
                                //               gradient: const LinearGradient(
                                //                 begin: Alignment.topCenter,
                                //                 end: Alignment.bottomCenter,
                                //                 stops: [0.0, 1.0],
                                //                 colors: buttonFocuscolors,
                                //               ),
                                //               color: Colors.deepPurple.shade300,
                                //               borderRadius: BorderRadius.circular(20),
                                //             ),
                                //       child: Padding(
                                //         padding: const EdgeInsets.only(
                                //           left: 35,
                                //           top: 10,
                                //           bottom: 10,
                                //         ),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.start,
                                //           children: [
                                //             Icon(
                                //               viewpreferred[1]
                                //                   ? FontAwesomeIcons.handshake
                                //                   : FontAwesomeIcons.handshake,
                                //               color: viewpreferred[1]
                                //                   ? Colors.white
                                //                   : Colors.black87,
                                //               size: 30,
                                //             ),
                                //             const SizedBox(width: 5.0),
                                //             Text(
                                //               'Preferred Tutor',
                                //               style: TextStyle(
                                //                   color: viewpreferred[1]
                                //                       ? Colors.white
                                //                       : Colors.black87,
                                //                   fontWeight: viewpreferred[1]
                                //                       ? FontWeight.w500
                                //                       : FontWeight.normal,
                                //                   fontSize: 15),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     setState(() {
                                //       viewpreferred[2] = !viewpreferred[2];
                                //       viewpreferred[1] = false;
                                //       viewpreferred[3] = false;
                                //       viewpreferred[4] = false;
                                //       viewpreferred[5] = false;
                                //       myprefTutor.clear();
                                //       cchoosen.clear();
                                //       servchoosen.clear();
                                //       subjectchoosen.clear();
                                //       languagechoosen.clear();
                                //     });
                                //   },
                                //   onHover: (hover) {
                                //     termStatus[2] = hover;
                                //   },
                                //   child: Container(
                                //     height: 35,
                                //     width: 220,
                                //     padding:
                                //         const EdgeInsets.only(right: 20, left: 20),
                                //     decoration: BoxDecoration(
                                //       color: viewpreferred[2]
                                //           ? kColorLight
                                //           : Colors.transparent,
                                //       borderRadius: BorderRadius.circular(20.0),
                                //     ),
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         Icon(
                                //           viewpreferred[2]
                                //               ? FontAwesomeIcons.mapLocation
                                //               : FontAwesomeIcons.mapLocation,
                                //           color: viewpreferred[2]
                                //               ? Colors.white
                                //               : Colors.black87,
                                //           size: 18,
                                //         ),
                                //         const SizedBox(width: 8.0),
                                //         Text(
                                //           'Country',
                                //           style: GoogleFonts.roboto(
                                //               color: viewpreferred[2]
                                //                   ? Colors.white
                                //                   : Colors.black87,
                                //               fontWeight: viewpreferred[2]
                                //                   ? FontWeight.w500
                                //                   : FontWeight.normal,
                                //               fontSize: 14),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // Visibility(
                                //   visible: viewpreferred[2],
                                //   child: Container(
                                //     height: 250,
                                //     width: 220,
                                //     padding: const EdgeInsets.only(
                                //         right: 20, top: 10, bottom: 10, left: 20),
                                //     child: ListView.builder(
                                //       shrinkWrap: true,
                                //       physics: const BouncingScrollPhysics(),
                                //       itemCount: countryNames.length,
                                //       itemBuilder: (context, index) {
                                //         return CheckboxListTile(
                                //           title: Text(
                                //             countryNames[index],
                                //             style: GoogleFonts.roboto(
                                //                 fontSize: 12,
                                //                 fontWeight: FontWeight.normal),
                                //           ),
                                //           value:
                                //               cchoosen.contains(countryNames[index]),
                                //           onChanged: (value) {
                                //             setState(() {
                                //               if (cchoosen
                                //                   .contains(countryNames[index])) {
                                //                 cchoosen.remove(countryNames[index]);
                                //               } else {
                                //                 cchoosen.add(countryNames[index]);
                                //               }
                                //             });
                                //           },
                                //           controlAffinity: ListTileControlAffinity
                                //               .leading, // Place checkbox before the title
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     setState(() {
                                //       viewpreferred[3] = !viewpreferred[3];
                                //       viewpreferred[1] = false;
                                //       viewpreferred[2] = false;
                                //       viewpreferred[4] = false;
                                //       viewpreferred[5] = false;
                                //       cchoosen.clear();
                                //       servchoosen.clear();
                                //       subjectchoosen.clear();
                                //       languagechoosen.clear();
                                //       myprefTutor.clear();
                                //     });
                                //   },
                                //   onHover: (hover) {
                                //     termStatus[3] = hover;
                                //   },
                                //   child: Container(
                                //     height: 35,
                                //     width: 220,
                                //     padding:
                                //         const EdgeInsets.only(right: 20, left: 20),
                                //     decoration: BoxDecoration(
                                //       color: viewpreferred[3]
                                //           ? kColorLight
                                //           : Colors.transparent,
                                //       borderRadius: BorderRadius.circular(20.0),
                                //     ),
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         Icon(
                                //           viewpreferred[3]
                                //               ? FontAwesomeIcons.handScissors
                                //               : FontAwesomeIcons.handScissors,
                                //           color: viewpreferred[3]
                                //               ? Colors.white
                                //               : Colors.black87,
                                //           size: 18,
                                //         ),
                                //         const SizedBox(width: 8.0),
                                //         Text(
                                //           'Subject',
                                //           style: GoogleFonts.roboto(
                                //               color: viewpreferred[3]
                                //                   ? Colors.white
                                //                   : Colors.black87,
                                //               fontWeight: viewpreferred[3]
                                //                   ? FontWeight.w500
                                //                   : FontWeight.normal,
                                //               fontSize: 14),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // Visibility(
                                //   visible: viewpreferred[3],
                                //   child: Container(
                                //     height: 250,
                                //     width: 220,
                                //     padding: const EdgeInsets.only(
                                //         right: 20, top: 10, bottom: 10, left: 20),
                                //     child: ListView.builder(
                                //       shrinkWrap: true,
                                //       physics: const BouncingScrollPhysics(),
                                //       itemCount: subjects.length,
                                //       itemBuilder: (context, index) {
                                //         return CheckboxListTile(
                                //           title: Text(
                                //             subjects[index],
                                //             style: GoogleFonts.roboto(
                                //                 fontSize: 12,
                                //                 fontWeight: FontWeight.normal),
                                //           ),
                                //           value: subjectchoosen
                                //               .contains(subjects[index]),
                                //           onChanged: (value) async {
                                //             setState(() {
                                //               if (subjectchoosen
                                //                   .contains(subjects[index])) {
                                //                 subjectchoosen
                                //                     .remove(subjects[index]);
                                //               } else {
                                //                 subjectchoosen.add(subjects[index]);
                                //               }
                                //             });
                                //             if (subjectchoosen.isNotEmpty) {
                                //               List<String> tempsubjectuids =
                                //                   await getDataFromTutorSubjectTeach(
                                //                       subjectchoosen);
                                //               setState(() {
                                //                 subjectuids = tempsubjectuids;
                                //               });
                                //             } else {
                                //               setState(() {
                                //                 subjectuids = [];
                                //               });
                                //             }
                                //             print(subjectchoosen);
                                //             print(subjectuids);
                                //           },
                                //           controlAffinity: ListTileControlAffinity
                                //               .leading, // Place checkbox before the title
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     setState(() {
                                //       viewpreferred[4] = !viewpreferred[4];
                                //       viewpreferred[2] = false;
                                //       viewpreferred[3] = false;
                                //       viewpreferred[1] = false;
                                //       viewpreferred[5] = false;
                                //       servchoosen.clear();
                                //       cchoosen.clear();
                                //       subjectchoosen.clear();
                                //       myprefTutor.clear();
                                //       languagechoosen.clear();
                                //     });
                                //   },
                                //   onHover: (hover) {
                                //     termStatus[4] = hover;
                                //   },
                                //   child: Container(
                                //     height: 35,
                                //     width: 220,
                                //     padding:
                                //         const EdgeInsets.only(right: 20, left: 20),
                                //     decoration: BoxDecoration(
                                //       color: viewpreferred[4]
                                //           ? kColorLight
                                //           : Colors.transparent,
                                //       borderRadius: BorderRadius.circular(20.0),
                                //     ),
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         Icon(
                                //           viewpreferred[4]
                                //               ? FontAwesomeIcons.language
                                //               : FontAwesomeIcons.language,
                                //           color: viewpreferred[4]
                                //               ? Colors.white
                                //               : Colors.black87,
                                //           size: 18,
                                //         ),
                                //         const SizedBox(width: 8.0),
                                //         Text(
                                //           'Language',
                                //           style: GoogleFonts.roboto(
                                //               color: viewpreferred[4]
                                //                   ? Colors.white
                                //                   : Colors.black87,
                                //               fontWeight: viewpreferred[4]
                                //                   ? FontWeight.w500
                                //                   : FontWeight.normal,
                                //               fontSize: 14),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // Visibility(
                                //   visible: viewpreferred[4],
                                //   child: Container(
                                //     height: 250,
                                //     width: 220,
                                //     padding: const EdgeInsets.only(
                                //         right: 20, top: 10, bottom: 10, left: 20),
                                //     child: ListView.builder(
                                //       shrinkWrap: true,
                                //       physics: const BouncingScrollPhysics(),
                                //       itemCount: languagedata.length,
                                //       itemBuilder: (context, index) {
                                //         return CheckboxListTile(
                                //           title: Text(
                                //             languagedata[index].languageNamesStream,
                                //             style: GoogleFonts.roboto(
                                //                 fontSize: 12,
                                //                 fontWeight: FontWeight.normal),
                                //           ),
                                //           value: languagechoosen.contains(
                                //               languagedata[index]
                                //                   .languageNamesStream),

                                //           onChanged: (value) {
                                //             setState(() {
                                //               if (languagechoosen.contains(
                                //                   languagedata[index]
                                //                       .languageNamesStream)) {
                                //                 languagechoosen.remove(
                                //                     languagedata[index]
                                //                         .languageNamesStream);
                                //               } else {
                                //                 languagechoosen.add(
                                //                     languagedata[index]
                                //                         .languageNamesStream);
                                //               }
                                //             });
                                //           },
                                //           controlAffinity: ListTileControlAffinity
                                //               .leading, // Place checkbox before the title
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     setState(() {
                                //       viewpreferred[5] = !viewpreferred[5];
                                //       viewpreferred[2] = false;
                                //       viewpreferred[3] = false;
                                //       viewpreferred[4] = false;
                                //       viewpreferred[1] = false;
                                //       servchoosen.clear();
                                //       cchoosen.clear();
                                //       subjectchoosen.clear();
                                //       languagechoosen.clear();
                                //       myprefTutor.clear();
                                //     });
                                //   },
                                //   onHover: (hover) {
                                //     termStatus[5] = hover;
                                //   },
                                //   child: Container(
                                //     height: 35,
                                //     width: 220,
                                //     padding:
                                //         const EdgeInsets.only(right: 20, left: 20),
                                //     decoration: BoxDecoration(
                                //       color: viewpreferred[5]
                                //           ? kColorLight
                                //           : Colors.transparent,
                                //       borderRadius: BorderRadius.circular(20.0),
                                //     ),
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         Icon(
                                //           viewpreferred[5]
                                //               ? FontAwesomeIcons.solidHandPeace
                                //               : FontAwesomeIcons.handPeace,
                                //           color: viewpreferred[5]
                                //               ? Colors.white
                                //               : Colors.black87,
                                //           size: 18,
                                //         ),
                                //         const SizedBox(width: 8.0),
                                //         Text(
                                //           'Services Provided',
                                //           style: GoogleFonts.roboto(
                                //               color: viewpreferred[5]
                                //                   ? Colors.white
                                //                   : Colors.black87,
                                //               fontWeight: viewpreferred[5]
                                //                   ? FontWeight.w500
                                //                   : FontWeight.normal,
                                //               fontSize: 14),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // Visibility(
                                //   visible: viewpreferred[5],
                                //   child: Container(
                                //     height: 250,
                                //     width: 220,
                                //     padding: const EdgeInsets.only(
                                //         right: 20, top: 10, bottom: 10, left: 20),
                                //     child: ListView.builder(
                                //       shrinkWrap: true,
                                //       physics: const BouncingScrollPhysics(),
                                //       itemCount: provided.length,
                                //       itemBuilder: (context, index) {
                                //         return CheckboxListTile(
                                //           title: Text(
                                //             provided[index],
                                //             style: GoogleFonts.roboto(
                                //                 fontSize: 12,
                                //                 fontWeight: FontWeight.normal),
                                //           ),
                                //           value:
                                //               servchoosen.contains(provided[index]),
                                //           onChanged: (value) {
                                //             setState(() {
                                //               if (servchoosen
                                //                   .contains(provided[index])) {
                                //                 servchoosen.remove(provided[index]);
                                //               } else {
                                //                 servchoosen.add(provided[index]);
                                //               }
                                //             });
                                //           },
                                //           controlAffinity: ListTileControlAffinity
                                //               .leading, // Place checkbox before the title
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                  ),
                  Scrollbar(
                    trackVisibility: true,
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        elevation: 4,
                        child: Container(
                          padding: ResponsiveBuilder.isDesktop(context)
                              ? const EdgeInsets.only(left: 10, right: 10)
                              : const EdgeInsets.only(left: 5, right: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 2,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: ResponsiveBuilder.isDesktop(context)
                                    ? size.width - 300
                                    : size.width - 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: isSearchIconClicked,
                                      child: SizedBox(
                                        width:
                                            ResponsiveBuilder.isDesktop(context)
                                                ? size.width - 345
                                                : size.width - 65,
                                        height: 50,
                                        child: Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Adjust the radius as needed
                                            side: BorderSide
                                                .none, // This removes the border side
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                hintText: 'Search',
                                                hintStyle: TextStyle(
                                                  color: Colors
                                                      .grey, // Set hint text color to grey
                                                  fontSize: 16,
                                                ),
                                                border: InputBorder.none,
                                                // suffixIcon: Padding(
                                                //   padding: const EdgeInsets.fromLTRB(
                                                //       10, 0, 10, 0),
                                                //   child: InkWell(
                                                //     onTap: () {
                                                //       setState(() {
                                                //         final provider = context.read<
                                                //             SearchTutorProvider>();
                                                //         provider.setSearch(tName);
                                                //       });
                                                //     },
                                                //     child: const Icon(
                                                //       Icons.search_rounded,
                                                //       color: Colors.grey,
                                                //     ),
                                                //   ),
                                                // ),
                                              ),
                                              validator: (val) => val!.isEmpty
                                                  ? 'Enter your search filter'
                                                  : null,
                                              onChanged: (val) {
                                                tName = val;
                                                setState(() {
                                                  final provider = context.read<
                                                      SearchTutorProvider>();
                                                  provider.setSearch(tName);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isSearchIconClicked =
                                              !isSearchIconClicked;
                                        });
                                      },
                                      child: SizedBox(
                                        height: 50,
                                        child: Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Adjust the radius as needed
                                            side: BorderSide
                                                .none, // This removes the border side
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.search_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Consumer<PreferredTutorsNotifier>(
                                  builder: (context, prefferedTutor, _) {
                                // if (prefferedTutor.isFetching) {
                                //   return const CircularProgressIndicator();
                                // }
                                if (!preferredTutorsNotifier.isFetching &&
                                    !_isDataLoaded) {
                                  // _fetchData(prefferedTutor);
                                }
                                return Consumer<SearchTutorProvider>(
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
                                    tutorsinfo: tutorsinfo,
                                    temppreffered:
                                        prefferedTutor.preferredTutors,
                                    studenttzone: timezone,
                                  );
                                });
                              }),

                              // SizedBox(
                              //     width: size.width - 300,
                              //     height: 200,
                              //     child: CustomGifPageView(gifUrls: gifUrls)),
                              // SizedBox(
                              //   width: size.width - 300,
                              //   height: 200,
                              //   child: PageView.builder(
                              //     controller: _pageController,
                              //     itemCount: gifUrls.length,
                              //     onPageChanged: (index) {
                              //       setState(() {
                              //         _currentPageIndex = index;
                              //       });
                              //     },
                              //     itemBuilder: (context, index) {
                              //       return Container(
                              //         width: 100,
                              //         height: 100,
                              //         padding: const EdgeInsets.all(8),
                              //         child: Image.network(
                              //           gifUrls[index],
                              //           loadingBuilder:
                              //               (context, child, loadingProgress) {
                              //             if (loadingProgress == null) return child;
                              //             return Center(
                              //               child: CircularProgressIndicator(
                              //                 value: loadingProgress
                              //                             .expectedTotalBytes !=
                              //                         null
                              //                     ? loadingProgress
                              //                             .cumulativeBytesLoaded /
                              //                         loadingProgress
                              //                             .expectedTotalBytes!
                              //                     : null,
                              //               ),
                              //             );
                              //           },
                              //           errorBuilder: (context, error, stackTrace) {
                              //             return const Icon(Icons.error);
                              //           },
                              //           fit: BoxFit.fill,
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
