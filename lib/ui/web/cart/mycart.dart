// ignore_for_file: unused_element, unused_local_variable, sized_box_for_whitespace

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/services/getcart.dart';
import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/classinfo_provider.dart';


import '../../../../utils/themes.dart';
import '../../../data_class/subject_class.dart';
import '../../../services/gettutor.dart';
import '../../../shared_components/responsive_builder.dart';
import '../tutor/tutor_profile/book_lesson.dart';
import '../tutor/tutor_profile/view_file.dart';

class MyCart extends StatefulWidget {
  final String studentID;
  const MyCart({super.key, required this.studentID});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartNotifier = Provider.of<CartNotifier>(context, listen: false);
      cartNotifier.getCart(widget.studentID);
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showLoading = false;
      });
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
    subjectinfo: [],
    price: 0,
  );

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
    setState(() {
      final provider = context.read<ViewClassDisplayProvider>();
      provider.setViewClassinfo(false);
    });

    super.dispose();
  }

  ScrollController alllistscroll = ScrollController();
  List<String> rowData = List.generate(20, (index) => 'Item $index');
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
    Size size = MediaQuery.of(context).size;
    final subjectlist = Provider.of<List<Subjects>>(context);

    return Consumer<CartNotifier>(builder: (context, cartnotifierdata, _) {
      // if (cartnotifierdata.cart.isEmpty) {
      //   return Container(
      //       width: ResponsiveBuilder.isDesktop(context)
      //           ? size.width - 290
      //           : size.width - 30,
      //       height: size.height,
      //       child: Center(
      //         child: Text(
      //           'Cart is empty.',
      //           style: TextStyle(
      //               fontSize: 15,
      //               color: Colors.blue.shade200,
      //               fontStyle: FontStyle.italic),
      //         ),
      //       )); // Show loading indicator
      // }
      if (_showLoading || cartnotifierdata.cart.isEmpty) {
        return Center(
          child: _showLoading
              ? Container(
                  width: ResponsiveBuilder.isDesktop(context)
                      ? size.width - 290
                      : size.width - 30,
                  height: size.height,
                  child: const Center(child: CircularProgressIndicator()))
              : Card(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  elevation: 4,
                  child: Container(
                    width: ResponsiveBuilder.isDesktop(context)
                        ? size.width - 290
                        : size.width - 30,
                    height: size.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 50,
                            color: kColorPrimary,
                          ),
                          Text(
                            'Cart is empty.',
                            style: TextStyle(
                              fontSize: 24,
                              color: kCalendarColorB,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      }
      List<Map<String, dynamic>> cart = cartnotifierdata.cart;
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
              elevation: 4,
              child: Container(
                height: 50,
                width: ResponsiveBuilder.isDesktop(context)
                    ? size.width - 300
                    : size.width - 30,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(-0.1, 0), // 0% from the top center
                    end: Alignment.centerRight, // 86% to the bottom center
                    // transform: GradientRotation(1.57), // 90 degrees rotation
                    colors:
                        secondaryHeadercolors, // Add your desired colors here
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "My Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              elevation: 4,
              child: Container(
                  width: ResponsiveBuilder.isDesktop(context)
                      ? size.width - 300
                      : size.width - 30,
                  height: size.height - 140,
                  padding: ResponsiveBuilder.isDesktop(context)
                      ? size.width > 1330
                          ? const EdgeInsets.fromLTRB(100, 20, 100, 0)
                          : size.width > 1200 && size.width < 1330
                              ? const EdgeInsets.fromLTRB(40, 20, 40, 0)
                              : size.width > 1100 && size.width < 1130
                                  ? const EdgeInsets.fromLTRB(0, 20, 0, 0)
                                  : const EdgeInsets.fromLTRB(5, 20, 5, 0)
                      : ResponsiveBuilder.isTablet(context)
                          ? const EdgeInsets.fromLTRB(20, 20, 20, 0)
                          : const EdgeInsets.fromLTRB(5, 20, 5, 0),
                  alignment:
                      cart.length > 1 ? Alignment.topCenter : Alignment.topLeft,
                  child: ResponsiveBuilder.isDesktop(context)
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: (cart.length / 2).ceil(),
                          itemBuilder: (context, index) {
                            final int firstColumnIndex = index * 2;
                            final int? secondColumnIndex =
                                firstColumnIndex + 1 < cart.length
                                    ? firstColumnIndex + 1
                                    : null;
                            final enrolledClass = cart[firstColumnIndex];

                            return Row(
                              children: [
                                // First column
                                FutureBuilder<TutorInformation?>(
                                    future: getTutorInfo(cart[firstColumnIndex]
                                            ['tutorid']
                                        .toString()),
                                    builder: (context,
                                        AsyncSnapshot<TutorInformation?>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      TutorInformation? tutorinfo =
                                          snapshot.data;
                                      Subjects subjectid =
                                          subjectlist.firstWhere(
                                        (element) =>
                                            element.subjectId ==
                                            cart[firstColumnIndex]['subjectid'],
                                      );
                                      return Card(
                                        elevation: 4,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          controller: alllistscroll,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: size.width >= 1100 &&
                                                        size.width < 1130
                                                    ? 380
                                                    : 400,
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: size.width >= 1100 &&
                                                          size.width < 1130
                                                      ? const EdgeInsets.only(
                                                          top: 5.0,
                                                          left: 0,
                                                          right: 0,
                                                          bottom: 5.0,
                                                        )
                                                      : const EdgeInsets.only(
                                                          top: 5.0,
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 5.0,
                                                        ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${(tutorinfo!.firstName)}${(tutorinfo.middleName == 'N/A' || tutorinfo.middleName == '' ? '' : ' ${(tutorinfo.middleName)}')} ${(tutorinfo.lastname)}',
                                                        // 'Name',
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: kColorGrey),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
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
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  showDialog<
                                                                      DateTime>(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return ViewFile(
                                                                        imageURL: tutorinfo
                                                                            .imageID
                                                                            .toString(),
                                                                      );
                                                                    },
                                                                  ).then(
                                                                      (selectedDate) {
                                                                    if (selectedDate !=
                                                                        null) {
                                                                      // Do something with the selected date
                                                                    }
                                                                  });
                                                                },
                                                                child: Card(
                                                                  elevation: 4,
                                                                  child:
                                                                      Container(
                                                                    height: size.width >=
                                                                                1100 &&
                                                                            size.width <
                                                                                1130
                                                                        ? 150
                                                                        : 200,
                                                                    width: size.width >=
                                                                                1100 &&
                                                                            size.width <
                                                                                1130
                                                                        ? 150
                                                                        : 200,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        color: Colors.white,
                                                                        image: DecorationImage(
                                                                            image: NetworkImage(
                                                                              tutorinfo.imageID.toString(),
                                                                            ),
                                                                            fit: BoxFit.cover)),
                                                                  ),
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            height: size.width >=
                                                                        1100 &&
                                                                    size.width <
                                                                        1130
                                                                ? 150
                                                                : 200,
                                                            width: size.width >=
                                                                        1100 &&
                                                                    size.width <
                                                                        1130
                                                                ? 150
                                                                : 150,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  subjectid
                                                                      .subjectName,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color:
                                                                          kColorGrey),
                                                                ),
                                                                Text(
                                                                  tutorinfo
                                                                      .country,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color:
                                                                          kColorGrey),
                                                                ),
                                                                Text(
                                                                  '${cart[firstColumnIndex]['classno']} classes',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color:
                                                                          kColorGrey),
                                                                ),
                                                                Text(
                                                                  '${cart[firstColumnIndex]['classPrice']} \$',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color:
                                                                          kColorGrey),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  child:
                                                                      SizedBox(
                                                                    width: size.width >=
                                                                                1100 &&
                                                                            size.width <
                                                                                1130
                                                                        ? 150
                                                                        : 150,
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Tooltip(
                                                                          message:
                                                                              'Buy Class',
                                                                          child:
                                                                              TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Map<String, dynamic> tutorDataMap = tutorInformationToJson(tutorinfo);
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return BookLesson(
                                                                                    studentdata: cart[index]['studentid'],
                                                                                    tutordata: tutorDataMap,
                                                                                    tutorteach: const [],
                                                                                    noofclasses: cart[firstColumnIndex]['classno'],
                                                                                    subject: subjectid.subjectName,
                                                                                    currentprice: cart[firstColumnIndex]['classPrice'],
                                                                                  );
                                                                                },
                                                                              ).then((selectedDate) {
                                                                                deleteCartItem(cart[firstColumnIndex]['docid']);
                                                                              });
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              'Buy Now',
                                                                              style: TextStyle(color: kColorPrimary, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Tooltip(
                                                                          message:
                                                                              'Cancel',
                                                                          child:
                                                                              TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              deleteCartItem(cart[firstColumnIndex]['docid']);
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              'Cancel',
                                                                              style: TextStyle(color: kColorDarkRed, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
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
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),

                                const Spacer(),
                                if (secondColumnIndex != null)
                                  FutureBuilder<TutorInformation?>(
                                      future: getTutorInfo(
                                          cart[secondColumnIndex]['tutorid']
                                              .toString()),
                                      builder: (context,
                                          AsyncSnapshot<TutorInformation?>
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
                                              cart[secondColumnIndex]
                                                  ['subjectid'],
                                        );
                                        return Card(
                                          elevation: 4,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            controller: alllistscroll,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: size.width >= 1100 &&
                                                          size.width < 1130
                                                      ? 380
                                                      : 400,
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: size.width >=
                                                                1100 &&
                                                            size.width < 1130
                                                        ? const EdgeInsets.only(
                                                            top: 5.0,
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 5.0,
                                                          )
                                                        : const EdgeInsets.only(
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
                                                        Text(
                                                          '${(tutorinfo!.firstName)}${(tutorinfo.middleName == 'N/A' || tutorinfo.middleName == '' ? '' : ' ${(tutorinfo.middleName)}')} ${(tutorinfo.lastname)}',
                                                          // 'Name',
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  kColorGrey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
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
                                                                    showDialog<
                                                                        DateTime>(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ViewFile(
                                                                          imageURL: tutorinfo
                                                                              .imageID
                                                                              .toString(),
                                                                        );
                                                                      },
                                                                    ).then(
                                                                        (selectedDate) {
                                                                      if (selectedDate !=
                                                                          null) {
                                                                        // Do something with the selected date
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Card(
                                                                    elevation:
                                                                        4,
                                                                    child:
                                                                        Container(
                                                                      height: size.width >= 1100 &&
                                                                              size.width < 1130
                                                                          ? 150
                                                                          : 200,
                                                                      width: size.width >= 1100 &&
                                                                              size.width < 1130
                                                                          ? 150
                                                                          : 200,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          color: Colors.white,
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(
                                                                                tutorinfo.imageID.toString(),
                                                                              ),
                                                                              fit: BoxFit.cover)),
                                                                    ),
                                                                  )),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              height: size.width >=
                                                                          1100 &&
                                                                      size.width <
                                                                          1130
                                                                  ? 150
                                                                  : 200,
                                                              width: size.width >=
                                                                          1100 &&
                                                                      size.width <
                                                                          1130
                                                                  ? 150
                                                                  : 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    subjectid
                                                                        .subjectName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color:
                                                                            kColorGrey),
                                                                  ),
                                                                  Text(
                                                                    tutorinfo
                                                                        .country,
                                                                    // 'Country',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color:
                                                                            kColorGrey),
                                                                  ),
                                                                  Text(
                                                                    '${cart[secondColumnIndex]['classno']} classes',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color:
                                                                            kColorGrey),
                                                                  ),
                                                                  Text(
                                                                    '${cart[secondColumnIndex]['classPrice']} \$',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color:
                                                                            kColorGrey),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    child:
                                                                        SizedBox(
                                                                      width: size.width >= 1100 &&
                                                                              size.width < 1130
                                                                          ? 150
                                                                          : 150,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Tooltip(
                                                                            message:
                                                                                'Buy Class',
                                                                            child:
                                                                                TextButton(
                                                                              onPressed: () {
                                                                                Map<String, dynamic> tutorDataMap = tutorInformationToJson(tutorinfo);
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return BookLesson(
                                                                                      studentdata: cart[index]['studentid'],
                                                                                      tutordata: tutorDataMap,
                                                                                      tutorteach: const [],
                                                                                      noofclasses: cart[secondColumnIndex]['classno'],
                                                                                      subject: subjectid.subjectName,
                                                                                      currentprice: cart[secondColumnIndex]['classPrice'],
                                                                                    );
                                                                                  },
                                                                                ).then((selectedDate) {
                                                                                  deleteCartItem(cart[secondColumnIndex]['docid']);
                                                                                });
                                                                              },
                                                                              child: const Text(
                                                                                'Buy Now',
                                                                                style: TextStyle(color: kColorPrimary, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Tooltip(
                                                                            message:
                                                                                'Cancel',
                                                                            child:
                                                                                TextButton(
                                                                              onPressed: () {
                                                                                deleteCartItem(cart[secondColumnIndex]['docid']);
                                                                              },
                                                                              child: const Text(
                                                                                'Cancel',
                                                                                style: TextStyle(color: kColorDarkRed, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
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
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                              ],
                            );
                          },
                        )
                      :
                      // ResponsiveBuilder.isTablet(context)
                      //     ? ListView.builder(
                      //         shrinkWrap: true,
                      //         itemCount: cart.length,
                      //         itemBuilder: (context, index) {
                      //           return FutureBuilder<TutorInformation?>(
                      //               future: getTutorInfo(
                      //                   cart[index]['tutorid'].toString()),
                      //               builder: (context,
                      //                   AsyncSnapshot<TutorInformation?>
                      //                       snapshot) {
                      //                 if (snapshot.connectionState ==
                      //                     ConnectionState.waiting) {
                      //                   return Container();
                      //                 } else if (snapshot.hasError) {
                      //                   return Text('Error: ${snapshot.error}');
                      //                 }
                      //                 TutorInformation? tutorinfo =
                      //                     snapshot.data;
                      //                 Subjects subjectid =
                      //                     subjectlist.firstWhere(
                      //                   (element) =>
                      //                       element.subjectId ==
                      //                       cart[index]['subjectid'],
                      //                 );
                      //                 return Card(
                      //                   elevation: 4,
                      //                   child: SingleChildScrollView(
                      //                     scrollDirection: Axis.horizontal,
                      //                     controller: alllistscroll,
                      //                     child: Column(
                      //                       children: [
                      //                         Container(
                      //                           width: size.width >= 1100 &&
                      //                                   size.width < 1130
                      //                               ? 380
                      //                               : 400,
                      //                           color: Colors.white,
                      //                           child: Padding(
                      //                             padding: size.width >= 1100 &&
                      //                                     size.width < 1130
                      //                                 ? const EdgeInsets.only(
                      //                                     top: 5.0,
                      //                                     left: 0,
                      //                                     right: 0,
                      //                                     bottom: 5.0,
                      //                                   )
                      //                                 : const EdgeInsets.only(
                      //                                     top: 5.0,
                      //                                     left: 10,
                      //                                     right: 10,
                      //                                     bottom: 5.0,
                      //                                   ),
                      //                             child: Column(
                      //                               mainAxisAlignment:
                      //                                   MainAxisAlignment.start,
                      //                               crossAxisAlignment:
                      //                                   CrossAxisAlignment
                      //                                       .start,
                      //                               children: [
                      //                                 Text(
                      //                                   '${(tutorinfo!.firstName)}${(tutorinfo.middleName == 'N/A' || tutorinfo.middleName == '' ? '' : ' ${(tutorinfo.middleName)}')} ${(tutorinfo.lastname)}',
                      //                                   // 'Name',
                      //                                   style: const TextStyle(
                      //                                       fontSize: 18,
                      //                                       fontWeight:
                      //                                           FontWeight.w700,
                      //                                       color: kColorGrey),
                      //                                 ),
                      //                                 const SizedBox(
                      //                                   height: 5,
                      //                                 ),
                      //                                 Row(
                      //                                   mainAxisAlignment:
                      //                                       MainAxisAlignment
                      //                                           .start,
                      //                                   crossAxisAlignment:
                      //                                       CrossAxisAlignment
                      //                                           .start,
                      //                                   children: [
                      //                                     Align(
                      //                                       alignment: Alignment
                      //                                           .topRight,
                      //                                       child: InkWell(
                      //                                           onTap: () {
                      //                                             showDialog<
                      //                                                 DateTime>(
                      //                                               context:
                      //                                                   context,
                      //                                               builder:
                      //                                                   (BuildContext
                      //                                                       context) {
                      //                                                 return ViewFile(
                      //                                                   imageURL: tutorinfo
                      //                                                       .imageID
                      //                                                       .toString(),
                      //                                                 );
                      //                                               },
                      //                                             ).then(
                      //                                                 (selectedDate) {
                      //                                               if (selectedDate !=
                      //                                                   null) {
                      //                                                 // Do something with the selected date
                      //                                               }
                      //                                             });
                      //                                           },
                      //                                           child: Card(
                      //                                             elevation: 4,
                      //                                             child:
                      //                                                 Container(
                      //                                               height: size.width >=
                      //                                                           1100 &&
                      //                                                       size.width <
                      //                                                           1130
                      //                                                   ? 150
                      //                                                   : 200,
                      //                                               width: size.width >=
                      //                                                           1100 &&
                      //                                                       size.width <
                      //                                                           1130
                      //                                                   ? 150
                      //                                                   : 200,
                      //                                               decoration: BoxDecoration(
                      //                                                   borderRadius: BorderRadius.circular(5),
                      //                                                   color: Colors.white,
                      //                                                   image: DecorationImage(
                      //                                                       image: NetworkImage(
                      //                                                         tutorinfo.imageID.toString(),
                      //                                                       ),
                      //                                                       fit: BoxFit.cover)),
                      //                                             ),
                      //                                           )),
                      //                                     ),
                      //                                     const SizedBox(
                      //                                       width: 10,
                      //                                     ),
                      //                                     SizedBox(
                      //                                       height: size.width >=
                      //                                                   1100 &&
                      //                                               size.width <
                      //                                                   1130
                      //                                           ? 150
                      //                                           : 200,
                      //                                       width: size.width >=
                      //                                                   1100 &&
                      //                                               size.width <
                      //                                                   1130
                      //                                           ? 150
                      //                                           : 150,
                      //                                       child: Column(
                      //                                         mainAxisAlignment:
                      //                                             MainAxisAlignment
                      //                                                 .spaceEvenly,
                      //                                         crossAxisAlignment:
                      //                                             CrossAxisAlignment
                      //                                                 .start,
                      //                                         children: [
                      //                                           Text(
                      //                                             subjectid
                      //                                                 .subjectName,
                      //                                             style: const TextStyle(
                      //                                                 fontSize:
                      //                                                     18,
                      //                                                 fontWeight:
                      //                                                     FontWeight
                      //                                                         .w700,
                      //                                                 color:
                      //                                                     kColorGrey),
                      //                                           ),
                      //                                           Text(
                      //                                             tutorinfo
                      //                                                 .country,
                      //                                             style: const TextStyle(
                      //                                                 fontSize:
                      //                                                     15,
                      //                                                 fontWeight:
                      //                                                     FontWeight
                      //                                                         .normal,
                      //                                                 color:
                      //                                                     kColorGrey),
                      //                                           ),
                      //                                           Text(
                      //                                             '${cart[index]['classno']} classes',
                      //                                             style: const TextStyle(
                      //                                                 fontSize:
                      //                                                     15,
                      //                                                 fontWeight:
                      //                                                     FontWeight
                      //                                                         .normal,
                      //                                                 color:
                      //                                                     kColorGrey),
                      //                                           ),
                      //                                           Text(
                      //                                             '${cart[index]['classPrice']} \$',
                      //                                             style: const TextStyle(
                      //                                                 fontSize:
                      //                                                     15,
                      //                                                 fontWeight:
                      //                                                     FontWeight
                      //                                                         .normal,
                      //                                                 color:
                      //                                                     kColorGrey),
                      //                                           ),
                      //                                           Padding(
                      //                                             padding:
                      //                                                 EdgeInsets
                      //                                                     .zero,
                      //                                             child:
                      //                                                 SizedBox(
                      //                                               width: size.width >=
                      //                                                           1100 &&
                      //                                                       size.width <
                      //                                                           1130
                      //                                                   ? 150
                      //                                                   : 150,
                      //                                               child: Row(
                      //                                                 crossAxisAlignment:
                      //                                                     CrossAxisAlignment
                      //                                                         .start,
                      //                                                 mainAxisAlignment:
                      //                                                     MainAxisAlignment
                      //                                                         .start,
                      //                                                 children: [
                      //                                                   Tooltip(
                      //                                                     message:
                      //                                                         'Buy Class',
                      //                                                     child:
                      //                                                         TextButton(
                      //                                                       onPressed:
                      //                                                           () {
                      //                                                         // setState(() {
                      //                                                         //   selectedclass = enrolledClass;
                      //                                                         // });
                      //                                                         // final provider = context.read<ViewClassDisplayProvider>();
                      //                                                         // provider.setViewClassinfo(true);
                      //                                                       },
                      //                                                       child:
                      //                                                           const Text(
                      //                                                         'Buy Now',
                      //                                                         style: TextStyle(color: kColorPrimary, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                   Tooltip(
                      //                                                     message:
                      //                                                         'Cancel',
                      //                                                     child:
                      //                                                         TextButton(
                      //                                                       onPressed:
                      //                                                           () {
                      //                                                         // setState(() {
                      //                                                         //   selectedclass = enrolledClass;
                      //                                                         // });
                      //                                                         // final provider = context.read<ViewClassDisplayProvider>();
                      //                                                         // provider.setViewClassinfo(true);
                      //                                                       },
                      //                                                       child:
                      //                                                           const Text(
                      //                                                         'Cancel',
                      //                                                         style: TextStyle(color: kColorDarkRed, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ],
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                         ],
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         const SizedBox(
                      //                           height: 10,
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 );
                      //               });
                      //         },
                      //       )
                      //     :
                      size.width >= 886 && size.width < 1100
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: (cart.length / 2).ceil(),
                              itemBuilder: (context, index) {
                                final int firstColumnIndex = index * 2;
                                final int? secondColumnIndex =
                                    firstColumnIndex + 1 < cart.length
                                        ? firstColumnIndex + 1
                                        : null;
                                final enrolledClass = cart[firstColumnIndex];

                                return Row(
                                  children: [
                                    // First column
                                    FutureBuilder<TutorInformation?>(
                                        future: getTutorInfo(
                                            cart[firstColumnIndex]['tutorid']
                                                .toString()),
                                        builder: (context,
                                            AsyncSnapshot<TutorInformation?>
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
                                            elevation: 4,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              controller: alllistscroll,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: size.width >= 1100 &&
                                                            size.width < 1130
                                                        ? 380
                                                        : 400,
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: size.width >=
                                                                  1100 &&
                                                              size.width < 1130
                                                          ? const EdgeInsets
                                                              .only(
                                                              top: 5.0,
                                                              left: 0,
                                                              right: 0,
                                                              bottom: 5.0,
                                                            )
                                                          : const EdgeInsets
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
                                                          Text(
                                                            '${(tutorinfo!.firstName)}${(tutorinfo.middleName == 'N/A' || tutorinfo.middleName == '' ? '' : ' ${(tutorinfo.middleName)}')} ${(tutorinfo.lastname)}',
                                                            // 'Name',
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    kColorGrey),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
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
                                                                      showDialog<
                                                                          DateTime>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return ViewFile(
                                                                            imageURL:
                                                                                tutorinfo.imageID.toString(),
                                                                          );
                                                                        },
                                                                      ).then(
                                                                          (selectedDate) {
                                                                        if (selectedDate !=
                                                                            null) {
                                                                          // Do something with the selected date
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Card(
                                                                      elevation:
                                                                          4,
                                                                      child:
                                                                          Container(
                                                                        height: size.width >= 1100 &&
                                                                                size.width < 1130
                                                                            ? 150
                                                                            : 200,
                                                                        width: size.width >= 1100 &&
                                                                                size.width < 1130
                                                                            ? 150
                                                                            : 200,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            color: Colors.white,
                                                                            image: DecorationImage(
                                                                                image: NetworkImage(
                                                                                  tutorinfo.imageID.toString(),
                                                                                ),
                                                                                fit: BoxFit.cover)),
                                                                      ),
                                                                    )),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              SizedBox(
                                                                height: size.width >=
                                                                            1100 &&
                                                                        size.width <
                                                                            1130
                                                                    ? 150
                                                                    : 200,
                                                                width: size.width >=
                                                                            1100 &&
                                                                        size.width <
                                                                            1130
                                                                    ? 150
                                                                    : 150,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      subjectid
                                                                          .subjectName,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              kColorGrey),
                                                                    ),
                                                                    Text(
                                                                      tutorinfo
                                                                          .country,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color:
                                                                              kColorGrey),
                                                                    ),
                                                                    Text(
                                                                      '${cart[firstColumnIndex]['classno']} classes',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color:
                                                                              kColorGrey),
                                                                    ),
                                                                    Text(
                                                                      '${cart[firstColumnIndex]['classPrice']} \$',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color:
                                                                              kColorGrey),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      child:
                                                                          SizedBox(
                                                                        width: size.width >= 1100 &&
                                                                                size.width < 1130
                                                                            ? 150
                                                                            : 150,
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Tooltip(
                                                                              message: 'Buy Class',
                                                                              child: TextButton(
                                                                                onPressed: () {
                                                                                  Map<String, dynamic> tutorDataMap = tutorInformationToJson(tutorinfo);
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return BookLesson(
                                                                                        studentdata: cart[index]['studentid'],
                                                                                        tutordata: tutorDataMap,
                                                                                        tutorteach: const [],
                                                                                        noofclasses: cart[firstColumnIndex]['classno'],
                                                                                        subject: subjectid.subjectName,
                                                                                        currentprice: cart[firstColumnIndex]['classPrice'],
                                                                                      );
                                                                                    },
                                                                                  ).then((selectedDate) {
                                                                                    deleteCartItem(cart[firstColumnIndex]['docid']);
                                                                                  });
                                                                                },
                                                                                child: const Text(
                                                                                  'Buy Now',
                                                                                  style: TextStyle(color: kColorPrimary, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Tooltip(
                                                                              message: 'Cancel',
                                                                              child: TextButton(
                                                                                onPressed: () {
                                                                                  deleteCartItem(cart[firstColumnIndex]['docid']);
                                                                                },
                                                                                child: const Text(
                                                                                  'Cancel',
                                                                                  style: TextStyle(color: kColorDarkRed, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
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
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),

                                    const Spacer(),
                                    if (secondColumnIndex != null)
                                      FutureBuilder<TutorInformation?>(
                                          future: getTutorInfo(
                                              cart[secondColumnIndex]['tutorid']
                                                  .toString()),
                                          builder: (context,
                                              AsyncSnapshot<TutorInformation?>
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
                                                  cart[secondColumnIndex]
                                                      ['subjectid'],
                                            );
                                            return Card(
                                              elevation: 4,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                controller: alllistscroll,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: size.width >=
                                                                  1100 &&
                                                              size.width < 1130
                                                          ? 380
                                                          : 400,
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding: size.width >=
                                                                    1100 &&
                                                                size.width <
                                                                    1130
                                                            ? const EdgeInsets
                                                                .only(
                                                                top: 5.0,
                                                                left: 0,
                                                                right: 0,
                                                                bottom: 5.0,
                                                              )
                                                            : const EdgeInsets
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
                                                            Text(
                                                              '${(tutorinfo!.firstName)}${(tutorinfo.middleName == 'N/A' || tutorinfo.middleName == '' ? '' : ' ${(tutorinfo.middleName)}')} ${(tutorinfo.lastname)}',
                                                              // 'Name',
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color:
                                                                      kColorGrey),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
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
                                                                        showDialog<
                                                                            DateTime>(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return ViewFile(
                                                                              imageURL: tutorinfo.imageID.toString(),
                                                                            );
                                                                          },
                                                                        ).then(
                                                                            (selectedDate) {
                                                                          if (selectedDate !=
                                                                              null) {
                                                                            // Do something with the selected date
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Card(
                                                                        elevation:
                                                                            4,
                                                                        child:
                                                                            Container(
                                                                          height: size.width >= 1100 && size.width < 1130
                                                                              ? 150
                                                                              : 200,
                                                                          width: size.width >= 1100 && size.width < 1130
                                                                              ? 150
                                                                              : 200,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: Colors.white,
                                                                              image: DecorationImage(
                                                                                  image: NetworkImage(
                                                                                    tutorinfo.imageID.toString(),
                                                                                  ),
                                                                                  fit: BoxFit.cover)),
                                                                        ),
                                                                      )),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  height: size.width >=
                                                                              1100 &&
                                                                          size.width <
                                                                              1130
                                                                      ? 150
                                                                      : 200,
                                                                  width: size.width >=
                                                                              1100 &&
                                                                          size.width <
                                                                              1130
                                                                      ? 150
                                                                      : 150,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        subjectid
                                                                            .subjectName,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: kColorGrey),
                                                                      ),
                                                                      Text(
                                                                        tutorinfo
                                                                            .country,
                                                                        // 'Country',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            color: kColorGrey),
                                                                      ),
                                                                      Text(
                                                                        '${cart[secondColumnIndex]['classno']} classes',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            color: kColorGrey),
                                                                      ),
                                                                      Text(
                                                                        '${cart[secondColumnIndex]['classPrice']} \$',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            color: kColorGrey),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        child:
                                                                            SizedBox(
                                                                          width: size.width >= 1100 && size.width < 1130
                                                                              ? 150
                                                                              : 150,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Tooltip(
                                                                                message: 'Buy Class',
                                                                                child: TextButton(
                                                                                  onPressed: () {
                                                                                    Map<String, dynamic> tutorDataMap = tutorInformationToJson(tutorinfo);
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return BookLesson(
                                                                                          studentdata: cart[index]['studentid'],
                                                                                          tutordata: tutorDataMap,
                                                                                          tutorteach: const [],
                                                                                          noofclasses: cart[secondColumnIndex]['classno'],
                                                                                          subject: subjectid.subjectName,
                                                                                          currentprice: cart[secondColumnIndex]['classPrice'],
                                                                                        );
                                                                                      },
                                                                                    ).then((selectedDate) {
                                                                                      deleteCartItem(cart[secondColumnIndex]['docid']);
                                                                                    });
                                                                                  },
                                                                                  child: const Text(
                                                                                    'Buy Now',
                                                                                    style: TextStyle(color: kColorPrimary, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Tooltip(
                                                                                message: 'Cancel',
                                                                                child: TextButton(
                                                                                  onPressed: () {
                                                                                    deleteCartItem(cart[secondColumnIndex]['docid']);
                                                                                  },
                                                                                  child: const Text(
                                                                                    'Cancel',
                                                                                    style: TextStyle(color: kColorDarkRed, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
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
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                  ],
                                );
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: cart.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder<TutorInformation?>(
                                    future: getTutorInfo(
                                        cart[index]['tutorid'].toString()),
                                    builder: (context,
                                        AsyncSnapshot<TutorInformation?>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      TutorInformation? tutorinfo =
                                          snapshot.data;
                                      Subjects subjectid =
                                          subjectlist.firstWhere(
                                        (element) =>
                                            element.subjectId ==
                                            cart[index]['subjectid'],
                                      );
                                      return ClipRect(
                                        child: Card(
                                          elevation: 4,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            controller: alllistscroll,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 300,
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 5.0,
                                                      left: 0,
                                                      right: 0,
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
                                                        Text(
                                                          '${(tutorinfo!.firstName)}${(tutorinfo.middleName == 'N/A' || tutorinfo.middleName == '' ? '' : ' ${(tutorinfo.middleName)}')} ${(tutorinfo.lastname)}',
                                                          // 'Name',
                                                          style: const TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  kColorGrey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
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
                                                                    showDialog<
                                                                        DateTime>(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ViewFile(
                                                                          imageURL: tutorinfo
                                                                              .imageID
                                                                              .toString(),
                                                                        );
                                                                      },
                                                                    ).then(
                                                                        (selectedDate) {
                                                                      if (selectedDate !=
                                                                          null) {
                                                                        // Do something with the selected date
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Card(
                                                                    elevation:
                                                                        4,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          140,
                                                                      width:
                                                                          140,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          color: Colors.white,
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(
                                                                                tutorinfo.imageID.toString(),
                                                                              ),
                                                                              fit: BoxFit.cover)),
                                                                    ),
                                                                  )),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 140,
                                                              width: 140,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    subjectid
                                                                        .subjectName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color:
                                                                            kColorGrey),
                                                                  ),
                                                                  Text(
                                                                    tutorinfo
                                                                        .country,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color:
                                                                            kColorGrey),
                                                                  ),
                                                                  Text(
                                                                    '${cart[index]['classno']} classes',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color:
                                                                            kColorGrey),
                                                                  ),
                                                                  Text(
                                                                    '${cart[index]['classPrice']} \$',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color:
                                                                            kColorGrey),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          140,
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Tooltip(
                                                                            message:
                                                                                'Buy Class',
                                                                            child:
                                                                                TextButton(
                                                                              onPressed: () {
                                                                                Map<String, dynamic> tutorDataMap = tutorInformationToJson(tutorinfo);
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return BookLesson(
                                                                                      studentdata: cart[index]['studentid'],
                                                                                      tutordata: tutorDataMap,
                                                                                      tutorteach: const [],
                                                                                      noofclasses: cart[index]['classno'],
                                                                                      subject: subjectid.subjectName,
                                                                                      currentprice: cart[index]['classPrice'],
                                                                                    );
                                                                                  },
                                                                                ).then((selectedDate) {
                                                                                  deleteCartItem(cart[index]['docid']);
                                                                                });
                                                                              },
                                                                              child: const Text(
                                                                                'Buy Now',
                                                                                style: TextStyle(color: kColorPrimary, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Tooltip(
                                                                            message:
                                                                                'Cancel',
                                                                            child:
                                                                                TextButton(
                                                                              onPressed: () {
                                                                                deleteCartItem(cart[index]['docid']);
                                                                              },
                                                                              child: const Text(
                                                                                'Cancel',
                                                                                style: TextStyle(color: kColorDarkRed, fontSize: 14, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
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
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            )),
            )
          ],
        ),
      );
    });
  }
}
