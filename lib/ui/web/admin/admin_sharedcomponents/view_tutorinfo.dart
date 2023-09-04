import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/data_class/tutor_info_class.dart';
import 'package:wokr4ututor/ui/web/student/main_dashboard/student_dashboard.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_profile/book_lesson.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_profile/contact_teacher.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_profile/view_file.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_profile/viewschedule.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../../../../data_class/subject_class.dart';

class ViewTutorsData extends StatefulWidget {
  final String namex;
  const ViewTutorsData({super.key, required this.namex});

  @override
  State<ViewTutorsData> createState() => _ViewTutorsDataState();
}

class _ViewTutorsDataState extends State<ViewTutorsData> {
  List<Subjects> subjectInfox = [];

  @override
  Widget build(BuildContext context) {
    // final helpcategorylistx = Provider.of<List<HelpCategory>>(context);
    // debugPrint(helpcategorylistx.length.toString());
    // var tutorname = context.select((SearchTutorProvider p) => p.tName);
    // final subjectInfo = Provider.of<List<Subjects>>(context);
    // subjectInfox = subjectInfo;
    // debugPrint('${subjectInfo.length}11111111111111111111111111111111111');

    dynamic langx = List<String>;
    var tutorsinfo = Provider.of<List<TutorInformation>>(context);

    try {
      tutorsinfo.retainWhere((tutorId) {
        return tutorId.firstName
            .toLowerCase()
            .contains(widget.namex.toLowerCase());
      });
    } catch (a) {
      tutorsinfo = [];
    }
    print(tutorsinfo);
    final CollectionReference subjectCollection =
        FirebaseFirestore.instance.collection('subjects');

    langx = tutorsinfo[0].language;
    final ref = FirebaseStorage.instance.ref().child(tutorsinfo[0].imageID);

    const Color background = Color.fromRGBO(55, 116, 135, 1);
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    const double fillPercent = 70; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];
    Size size = MediaQuery.of(context).size;
    bool selection5 = false;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height + 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      stops: stops,
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 100, right: 100, top: 20),
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
                                                  imageURL: profileurl,
                                                );
                                              },
                                            ).then((selectedDate) {
                                              if (selectedDate != null) {
                                                // Do something with the selected date
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 300,
                                            width: 300,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.transparent,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/sample.jpg'),
                                                    fit: BoxFit.cover)),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 10, 0, 10),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog<DateTime>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return const ViewFile(
                                                        imageURL: '',
                                                      );
                                                    },
                                                  ).then((selectedDate) {
                                                    if (selectedDate != null) {
                                                      // Do something with the selected date
                                                    }
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.arrow_left,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {
                                                    showDialog<DateTime>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const ViewFile(
                                                          imageURL: '',
                                                        );
                                                      },
                                                    ).then((selectedDate) {
                                                      if (selectedDate !=
                                                          null) {
                                                        // Do something with the selected date
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.transparent,
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/5815489.jpg'),
                                                            fit: BoxFit.cover)),
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {
                                                    showDialog<DateTime>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const ViewFile(
                                                          imageURL: '',
                                                        );
                                                      },
                                                    ).then((selectedDate) {
                                                      if (selectedDate !=
                                                          null) {
                                                        // Do something with the selected date
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.transparent,
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/5815489.jpg'),
                                                            fit: BoxFit.cover)),
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.transparent,
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/5815489.jpg'),
                                                            fit: BoxFit.cover)),
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.black12,
                                                    ),
                                                    child: const Icon(
                                                      Icons.play_circle,
                                                      color: Colors.black87,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.arrow_right,
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Service Provided',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 500,
                                            height: 70,
                                            color: Colors.transparent,
                                            child: GridView.builder(
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  mainAxisSpacing: 0,
                                                  crossAxisSpacing: 0,
                                                  childAspectRatio: (1 / .2),
                                                  crossAxisCount: 3,
                                                ),
                                                itemCount: 4,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Row(
                                                    children: const [
                                                      Radio(
                                                        value: true,
                                                        groupValue: true,
                                                        onChanged: null,
                                                        activeColor:
                                                            kColorPrimary,
                                                      ),
                                                      Text('Add info here')
                                                    ],
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: const [
                                        Text(
                                          'Students Enrolled:',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Icon(Icons.person),
                                        Text(
                                          '20',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color:
                                                Color.fromRGBO(1, 118, 132, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(10),
                                              alignment: Alignment.centerLeft,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      1,
                                                      118,
                                                      132,
                                                      1), // your color here
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontStyle: FontStyle.normal,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            onPressed: () {
                                              // final provider = context.read<InitProvider>();
                                              // provider.setMenuIndex(5);
                                            },
                                            child: const Text(
                                              '2 Classes',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color:
                                                Color.fromRGBO(1, 118, 132, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(10),
                                              alignment: Alignment.centerLeft,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      1,
                                                      118,
                                                      132,
                                                      1), // your color here
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontStyle: FontStyle.normal,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            onPressed: () {
                                              // final provider = context.read<InitProvider>();
                                              // provider.setMenuIndex(5);
                                            },
                                            child: const Text(
                                              '3 Classes',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color:
                                                Color.fromRGBO(1, 118, 132, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(10),
                                              alignment: Alignment.centerLeft,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      1,
                                                      118,
                                                      132,
                                                      1), // your color here
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontStyle: FontStyle.normal,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            onPressed: () {
                                              // final provider = context.read<InitProvider>();
                                              // provider.setMenuIndex(5);
                                            },
                                            child: const Text(
                                              '5 classes',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.black45,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(10),
                                              alignment: Alignment.centerLeft,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Colors
                                                      .black45, // your color here
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              // final provider = context.read<InitProvider>();
                                              // provider.setMenuIndex(5);
                                            },
                                            child: const Text(
                                              'Customize',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 500,
                                    height: 60,
                                    color: Colors.transparent,
                                    child: GridView.builder(
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 0,
                                          crossAxisSpacing: 0,
                                          childAspectRatio: (1 / .2),
                                          crossAxisCount: 3,
                                        ),
                                        itemCount: 3,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CheckboxListTile(
                                            title: const Text(
                                              'Math',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: selection5,
                                            value: selection5,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                selection5 = value!;
                                              });
                                            },
                                          );
                                        }),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      '111111Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Price: \$ 10.00',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                          Container(
                                            height: 30,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: kColorLight,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                shape:
                                                    const BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.normal,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog<DateTime>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const BookLesson();
                                                  },
                                                ).then((selectedDate) {
                                                  if (selectedDate != null) {
                                                    // Do something with the selected date
                                                  }
                                                });
                                              },
                                              child: const Text(
                                                'Buy Lesson',
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 30,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: kColorLight,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                shape:
                                                    const BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.normal,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog<DateTime>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const BookLesson();
                                                  },
                                                ).then((selectedDate) {
                                                  if (selectedDate != null) {
                                                    // Do something with the selected date
                                                  }
                                                });
                                              },
                                              child: const Text(
                                                'Book Trial',
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: kColorLight,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                shape:
                                                    const BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.normal,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog<DateTime>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const ContactTeacher();
                                                  },
                                                ).then((selectedDate) {
                                                  if (selectedDate != null) {
                                                    // Do something with the selected date
                                                  }
                                                });
                                              },
                                              child: const Text(
                                                'Contact Teacher',
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 30,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: kColorLight,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                shape:
                                                    const BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.normal,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog<DateTime>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const CalendarDialog();
                                                  },
                                                ).then((selectedDate) {
                                                  if (selectedDate != null) {
                                                    // Do something with the selected date
                                                  }
                                                });
                                              },
                                              child: const Text(
                                                'View Schedule',
                                                textAlign: TextAlign.left,
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
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RatingBar(
                                          initialRating: 4.5,
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
                                        '${tutorsinfo[0].lastname}, ${tutorsinfo[0].firstName} ${tutorsinfo[0].middleName == 'N/A' ? '' : tutorsinfo[0].middleName}',
                                        // 'Marian, 28',
                                        style: const TextStyle(
                                            fontSize: 35,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        tutorsinfo[0].birthPlace,
                                        // 'USA, Manchester',
                                        style: const TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                            itemCount: langx.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (contex, index) {
                                              final item = langx[index];
                                              return Row(
                                                children: [
                                                  Text(
                                                    item == ''
                                                        ? ''
                                                        : item + ',',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),

                                      // Text(
                                      //   'English, Filipino, Russian, European',
                                      //   style: TextStyle(
                                      //       fontSize: 20,
                                      //       color: Colors.white,
                                      //       fontWeight: FontWeight.w400),
                                      // ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: StreamBuilder(
                                            stream:
                                                subjectCollection.snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    streamSnapshot) {
                                              if (streamSnapshot.hasData) {
                                                return ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: streamSnapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final DocumentSnapshot
                                                          documentSnapshot =
                                                          streamSnapshot.data!
                                                              .docs[index];
                                                      return Row(
                                                        children: [
                                                          // Text(
                                                          //   documentSnapshot[
                                                          //       'tutorId'],
                                                          //   style: TextStyle(
                                                          //       fontSize: 12,
                                                          //       color:
                                                          //           Colors.red),
                                                          // ),
                                                          Text(
                                                            documentSnapshot[
                                                                'subjectName'],
                                                            style: const TextStyle(
                                                                fontSize: 25,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }),
                                      ),
                                      // const Text(
                                      //   'Chemistry, Science, Math, Language(Filipino, English)',
                                      //   style: TextStyle(
                                      //       fontSize: 25,
                                      //       color: Colors.white,
                                      //       fontWeight: FontWeight.w500,
                                      //       fontStyle: FontStyle.italic),
                                      // ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        tutorsinfo[0].promotionalMessage,
                                        // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat vLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat ',
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        children: [
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Reviews',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: kColorPrimary,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundColor:
                                                      Colors.transparent,
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
                                                const Text(
                                                  "Melvin Jhon",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Spacer(),
                                                RatingBar(
                                                    initialRating: 4.5,
                                                    minRating: 0,
                                                    maxRating: 5,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 20,
                                                    ratingWidget: RatingWidget(
                                                        full: const Icon(
                                                            Icons.star,
                                                            color:
                                                                Colors.orange),
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
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
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
    );
  }
}
