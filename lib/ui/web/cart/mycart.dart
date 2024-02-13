// ignore_for_file: unused_element, unused_local_variable, sized_box_for_whitespace

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/services/getcart.dart';
import 'package:work4ututor/ui/web/student/book_classes/cancelclasses.dart';
import 'package:work4ututor/ui/web/student/book_classes/student_view_classinfo.dart';
import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/classinfo_provider.dart';

import 'dart:html' as html;

import '../../../../utils/themes.dart';
import '../../../data_class/subject_class.dart';
import '../../../services/gettutor.dart';
import '../admin/admin_sharedcomponents/header_text.dart';
import '../tutor/tutor_profile/view_file.dart';

class MyCart extends StatefulWidget {
  final String studentID;
  const MyCart({super.key, required this.studentID});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  void initState() {
    super.initState();
    print(widget.studentID);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartNotifier = Provider.of<CartNotifier>(context, listen: false);
      cartNotifier.getCart(widget.studentID);
    });
  }

  String actionValue = 'View';
  String dropdownValue = 'English';
  String statusValue = 'Completed';
  Color buttonColor = kCalendarColorAB;
  DateTime? _fromselectedDate;
  DateTime? _toselectedDate;
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
        _fromselectedDate = pickedDate;
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
        _toselectedDate = pickedDate;
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
    setState(() {
      final provider = context.read<ViewClassDisplayProvider>();
      provider.setViewClassinfo(false);
    });

    super.dispose();
  }

  ScrollController alllistscroll = ScrollController();
  List<String> rowData = List.generate(20, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final subjectlist = Provider.of<List<Subjects>>(context);

    return Consumer<CartNotifier>(builder: (context, cartnotifierdata, _) {
      if (cartnotifierdata.cart.isEmpty) {
        return Container(
            width: size.width - 310,
            child: Center(
              child: Text(
                'Cart is empty.',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue.shade200,
                    fontStyle: FontStyle.italic),
              ),
            )); // Show loading indicator
      }
      List<Map<String, dynamic>> cart = cartnotifierdata.cart;
      return Padding(
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
                  children: const [
                    Text(
                      "MY CART",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Container(
                width: size.width - 310,
                height: size.height - 80,
                child: cart.isEmpty
                    ? Container(
                        width: size.width - 320,
                        height: size.height - 80,
                        child: Center(
                            child: Container(
                          width: 60,
                          height: 60,
                          child: const CircularProgressIndicator(
                            strokeWidth: 6,
                            color: Color.fromRGBO(1, 118, 132, 1),
                          ),
                        )))
                    : Container(
                        width: size.width - 320,
                        height: size.height - 90,
                        alignment: Alignment.topCenter,
                        child: Center(
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
                                  width: size.width - 320,
                                  height: size.height - 175,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: (cart.length / 2).ceil(),
                                    itemBuilder: (context, index) {
                                      final int firstColumnIndex = index * 2;
                                      final int? secondColumnIndex =
                                          firstColumnIndex + 1 < cart.length
                                              ? firstColumnIndex + 1
                                              : null;
                                      final enrolledClass =
                                          cart[firstColumnIndex];

                                      return Row(
                                        children: [
                                          // First column
                                          FutureBuilder<TutorInformation?>(
                                              future: getTutorInfo(
                                                  cart[firstColumnIndex]
                                                          ['tutorid']
                                                      .toString()),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          TutorInformation?>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container();
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                TutorInformation? tutorinfo =
                                                    snapshot.data;
                                                Subjects subjectid =
                                                    subjectlist.firstWhere(
                                                  (element) =>
                                                      element.subjectId ==
                                                      cart[firstColumnIndex]
                                                          ['subjectid'],
                                                );
                                                return Card(
                                                  elevation: 5,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    controller: alllistscroll,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: 600,
                                                          color: Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 5.0,
                                                              left: 10,
                                                              right: 10,
                                                              bottom: 5.0,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                HeaderText(
                                                                  subjectid
                                                                      .subjectName,
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: InkWell(
                                                                          onTap: () {
                                                                            showDialog<DateTime>(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return ViewFile(
                                                                                  imageURL: tutorinfo!.imageID.toString(),
                                                                                );
                                                                              },
                                                                            ).then((selectedDate) {
                                                                              if (selectedDate != null) {
                                                                                // Do something with the selected date
                                                                              }
                                                                            });
                                                                          },
                                                                          child: Card(
                                                                            elevation:
                                                                                4,
                                                                            child:
                                                                                Container(
                                                                              height: 200,
                                                                              width: 200,
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  color: Colors.white,
                                                                                  image: DecorationImage(
                                                                                      image: NetworkImage(
                                                                                        tutorinfo!.imageID.toString(),
                                                                                      ),
                                                                                      fit: BoxFit.cover)),
                                                                            ),
                                                                          )),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          200,
                                                                      width:
                                                                          200,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            '${(tutorinfo.firstName)}${(tutorinfo.middleName == 'N/A' || tutorinfo.middleName == '' ? '' : ' ${(tutorinfo.middleName)}')} ${(tutorinfo.lastname)}',
                                                                            // 'Name',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            tutorinfo.country,
                                                                            // 'Country',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '${cart[firstColumnIndex]['classno']} classes',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '\$${cart[firstColumnIndex]['classPrice']} classes',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Tooltip(
                                                                                message: 'Buy Class',
                                                                                child: Container(
                                                                                  width: 120,
                                                                                  height: 35,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                  ),
                                                                                  child: TextButton(
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
                                                                                      // setState(() {
                                                                                      //   selectedclass = enrolledClass;
                                                                                      // });
                                                                                      // final provider = context.read<ViewClassDisplayProvider>();
                                                                                      // provider.setViewClassinfo(true);
                                                                                    },
                                                                                    // icon: const Icon(
                                                                                    //   Icons.open_in_new,
                                                                                    //   size: 15,
                                                                                    // ),
                                                                                    child: const Text(
                                                                                      'Buy Now',
                                                                                      style: TextStyle(fontSize: 13),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Tooltip(
                                                                                message: 'Remove Item',
                                                                                child: IconButton(
                                                                                  icon: const FaIcon(FontAwesomeIcons.trashArrowUp),
                                                                                  color: Colors.red.shade200, // You can use a different delete icon
                                                                                  onPressed: () {
                                                                                    // Add your logic to remove the item from the cart
                                                                                    print('Remove item from cart pressed');
                                                                                  },
                                                                                  iconSize: 20,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),

                                          const Spacer(),
                                          // Second column
                                          if (secondColumnIndex != null)
                                            FutureBuilder<TutorInformation?>(
                                                future: getTutorInfo(
                                                    cart[secondColumnIndex]
                                                            ['tutorid']
                                                        .toString()),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            TutorInformation?>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Container();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  }
                                                  TutorInformation? tutorinfo =
                                                      snapshot.data;
                                                  Subjects subjectid =
                                                      subjectlist.firstWhere(
                                                    (element) =>
                                                        element.subjectId ==
                                                        cart[secondColumnIndex]
                                                            ['subjectid'],
                                                  );
                                                  return SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    controller: alllistscroll,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: 600,
                                                          color: Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 5.0,
                                                              left: 10,
                                                              right: 10,
                                                              bottom: 5.0,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                HeaderText(
                                                                  subjectid
                                                                      .subjectName,
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: InkWell(
                                                                          onTap: () {
                                                                            showDialog<DateTime>(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return ViewFile(
                                                                                  imageURL: tutorinfo!.imageID.toString(),
                                                                                );
                                                                              },
                                                                            ).then((selectedDate) {
                                                                              if (selectedDate != null) {
                                                                                // Do something with the selected date
                                                                              }
                                                                            });
                                                                          },
                                                                          child: Card(
                                                                            elevation:
                                                                                4,
                                                                            child:
                                                                                Container(
                                                                              height: 200,
                                                                              width: 200,
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  color: Colors.white,
                                                                                  image: DecorationImage(
                                                                                      image: NetworkImage(
                                                                                        tutorinfo!.imageID.toString(),
                                                                                      ),
                                                                                      fit: BoxFit.cover)),
                                                                            ),
                                                                          )),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          200,
                                                                      width:
                                                                          200,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            '${(tutorinfo.firstName)}${(tutorinfo.middleName == 'N/A' || tutorinfo.middleName == '' ? '' : ' ${(tutorinfo.middleName)}')} ${(tutorinfo.lastname)}',
                                                                            // 'Name',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            tutorinfo.country,
                                                                            // 'Country',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '${cart[secondColumnIndex]['classno']} classes',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '\$${cart[secondColumnIndex]['classPrice']} classes',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Tooltip(
                                                                                message: 'Buy Class',
                                                                                child: Container(
                                                                                  width: 120,
                                                                                  height: 35,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                  ),
                                                                                  child: TextButton(
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
                                                                                      // setState(() {
                                                                                      //   selectedclass = enrolledClass;
                                                                                      // });
                                                                                      // final provider = context.read<ViewClassDisplayProvider>();
                                                                                      // provider.setViewClassinfo(true);
                                                                                    },
                                                                                    // icon: const Icon(
                                                                                    //   Icons.open_in_new,
                                                                                    //   size: 15,
                                                                                    // ),
                                                                                    child: const Text(
                                                                                      'Buy Now',
                                                                                      style: TextStyle(fontSize: 13),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Tooltip(
                                                                                message: 'Remove Item',
                                                                                child: IconButton(
                                                                                  icon: const FaIcon(FontAwesomeIcons.trashArrowUp),
                                                                                  color: Colors.red.shade200, // You can use a different delete icon
                                                                                  onPressed: () {
                                                                                    // Add your logic to remove the item from the cart
                                                                                    print('Remove item from cart pressed');
                                                                                  },
                                                                                  iconSize: 20,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ]),
                        ),
                      ))
          ],
        ),
      );
    });
  }
}
