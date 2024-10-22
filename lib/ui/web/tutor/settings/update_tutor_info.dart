// ignore_for_file: unused_element, prefer_final_fields, unused_field, unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/update_tutor_provider.dart';
import '../../../../services/getlanguages.dart';
import 'package:http/http.dart' as http;

import '../../../../services/getstudentinfo.dart';
import '../../../../services/update_tutorinformations_services.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';

class UpdateTutor extends StatefulWidget {
  final TutorInformation tutordata;
  final List<LanguageData> names;
  final List<String> countryNames;

  const UpdateTutor({
    super.key,
    required this.tutordata,
    required this.names,
    required this.countryNames,
  });

  @override
  UpdateTutorState createState() => UpdateTutorState();
}

class UpdateTutorState extends State<UpdateTutor> {
  int? selectedindex;

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
      'gender': tutorData.gender,
      'citizenship': tutorData.citizenship,
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

  TextEditingController tutorfirstname = TextEditingController();
  TextEditingController tutorlastname = TextEditingController();
  TextEditingController tutormiddleName = TextEditingController();
  DateTime birthdate = DateTime.now();
  int newage = 0;
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController birthcountry = TextEditingController();
  TextEditingController birthcity = TextEditingController();
  TextEditingController timezone = TextEditingController();
  TextEditingController contactnumber = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<dynamic> newlanguages = [];
  List<dynamic> newselectedlanguages = [];
  List<String> timezonesList = [];
  @override
  void initState() {
    super.initState();
    initializeWidget();
    getTimezones();
  }

  void initializeWidget() {
    // Initialize your controllers and variables here with widget data

    Map<String, dynamic> tutorDataMap =
        tutorInformationToJson(widget.tutordata);

    tutorfirstname.text = tutorDataMap['firstName'];
    tutorlastname.text = tutorDataMap['lastname'];
    tutormiddleName.text = tutorDataMap['middleName'];
    birthdate = tutorDataMap['birthdate'];
    newage = int.parse(tutorDataMap['age']);
    country.text = tutorDataMap['country'];
    city.text = tutorDataMap['city'];
    birthcountry.text = tutorDataMap['country'];
    birthcity.text = tutorDataMap['birthCity'];
    timezone.text = tutorDataMap['timezone'];
    contactnumber.text = tutorDataMap['contact'];
    selectedDate = tutorDataMap['birthdate'];
    for (var language in tutorDataMap['language']) {
      // You can process each language here if needed
      // For example, you can check if it's already in newlanguages before adding
      if (!newlanguages.contains(language)) {
        newlanguages.add(language);
      }
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(5000));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      birthdate = picked;
      calculateAge(picked);
    }
  }

  void calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int currentage = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (currentage < 0) {
    } else {
      if (month2 > month1) {
        currentage--;
        setState(() {
          newage = currentage;
        });
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          currentage--;
          setState(() {
            newage = currentage;
          });
        } else if (day2 <= day1) {
          setState(() {
            newage = currentage;
          });
        }
      } else if (month1 > month2) {
        setState(() {
          newage = currentage;
        });
      }
    }
  }

  Future<void> getTimezones() async {
    final response =
        await http.get(Uri.parse('http://worldtimeapi.org/api/timezone'));

    if (response.statusCode == 200) {
      final List<dynamic> timezones = json.decode(response.body);
      if (timezones.isNotEmpty) {
        setState(() {
          timezonesList = List<String>.from(timezones);
        });
      } else {
        throw Exception('No timezones found');
      }
    } else {
      throw Exception('Failed to load timezones: ${response.statusCode}');
    }
  }

  List<Color> vibrantColors = [
    const Color.fromRGBO(185, 237, 221, 1),
    const Color.fromRGBO(135, 203, 185, 1),
    const Color.fromRGBO(86, 157, 170, 1),
    const Color.fromRGBO(87, 125, 134, 1),
  ];
  FocusNode _focusNode = FocusNode();

  bool allowUpdate = false;
  String profilelink = '';
  Uint8List selectedImage = Uint8List(0);
  String filename = '';

// Function to select an image
  void selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        selectedImage = result.files.first.bytes!;
        filename = result.files.first.name;
      });
    }
  }

  String? data;
  ScrollController updatescrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    profilelink = widget.tutordata.imageID;
    final bool model = context.select((MyModel p) => p.updateDisplay);
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    const double fillPercent = 30; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];
    Map<String, dynamic> tutorDataMap =
        tutorInformationToJson(widget.tutordata);
    Size size = MediaQuery.of(context).size;
    return Card(
                color: Colors.white,

      margin: EdgeInsets.zero,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), // Adjust the radius as needed
          topRight: Radius.circular(10.0), // Adjust the radius as needed
        ),
      ),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            width: size.width - 290,
            height: size.height - 140,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Container(
                      width: ResponsiveBuilder.isDesktop(context)
                          ? size.width - 290
                          : size.width,
                      height: ResponsiveBuilder.isMobile(context) ? 200 : 250,
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
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: model == false
                              ? ResponsiveBuilder.isDesktop(context)
                                  ? const EdgeInsets.only(
                                      left: 250, top: 20, right: 20)
                                  : ResponsiveBuilder.isTablet(context)
                                      ? const EdgeInsets.only(
                                          left: 100, top: 20, right: 20)
                                      : const EdgeInsets.only(
                                          left: 10, top: 20, right: 10)
                              : ResponsiveBuilder.isDesktop(context)
                                  ? const EdgeInsets.only(
                                      left: 20, top: 20, right: 20)
                                  : ResponsiveBuilder.isTablet(context)
                                      ? const EdgeInsets.only(
                                          left: 20, top: 20, right: 20)
                                      : const EdgeInsets.only(
                                          left: 10, top: 20, right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: model
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 700,
                                child: Stack(children: [
                                  Container(
                                    height: 250,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors
                                          .transparent, // You can adjust the fit as needed.
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: filename.isEmpty
                                          ? Image.network(
                                              profilelink,
                                              fit: BoxFit
                                                  .cover, // You can adjust the fit as needed.
                                            )
                                          : Image.memory(
                                              selectedImage,
                                              fit: BoxFit
                                                  .cover, // You can adjust the fit as needed.
                                            ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: model,
                                    child: Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SizedBox(
                                          width: 250,
                                          height: 40,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white60,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                            ),
                                            onPressed: () {
                                              selectImage();
                                              bool areListsEqual = listEquals(
                                                newlanguages,
                                                (tutorDataMap['language']
                                                        as List<dynamic>)
                                                    .cast<dynamic>(),
                                              );
                                              if (filename != '' ||
                                                  tutorfirstname.text !=
                                                      tutorDataMap[
                                                          'firstName'] ||
                                                  tutorlastname.text !=
                                                      tutorDataMap[
                                                          'lastname'] ||
                                                  tutormiddleName.text !=
                                                      tutorDataMap[
                                                          'middleName'] ||
                                                  newage !=
                                                      int.parse(tutorDataMap[
                                                          'age']) ||
                                                  country.text !=
                                                      tutorDataMap['country'] ||
                                                  city.text !=
                                                      tutorDataMap['city'] ||
                                                  birthcountry.text !=
                                                      tutorDataMap[
                                                          'birthPlace'] ||
                                                  birthcity.text !=
                                                      tutorDataMap[
                                                          'birthCity'] ||
                                                  timezone.text !=
                                                      tutorDataMap[
                                                          'timezone'] ||
                                                  contactnumber.text !=
                                                      tutorDataMap['contact'] ||
                                                  areListsEqual == false) {
                                                setState(() {
                                                  allowUpdate = true;
                                                });
                                              } else {
                                                setState(() {
                                                  allowUpdate = false;
                                                });
                                              }
                                            },
                                            label: const Text(
                                              '',
                                              style: TextStyle(
                                                  color: kColorPrimary),
                                            ),
                                            icon: const Icon(
                                              Icons.camera_alt_outlined,
                                              size: 30,
                                              color: kColorPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                              Visibility(
                                  visible: model == false,
                                  child: const Spacer()),
                              Visibility(
                                visible: model == false,
                                child: TextButton.icon(
                                  onPressed: () {
                                    final provider = context.read<MyModel>();
                                    provider.updateBoolValue(true);
                                  },
                                  icon: const Icon(
                                    Icons.edit_document,
                                    color:
                                        kColorPrimaryDark, // Set the icon color to white
                                  ),
                                  label: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      color:
                                          kColorPrimaryDark, // Set the text color to white
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: ResponsiveBuilder.isDesktop(context)
                          ? const EdgeInsets.only(left: 250, top: 20, right: 20)
                          : ResponsiveBuilder.isTablet(context)
                              ? const EdgeInsets.only(
                                  left: 100, top: 20, right: 20)
                              : const EdgeInsets.only(
                                  left: 10, top: 20, right: 10),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(),
                      ),
                    ),
                    model
                        ? Container(
                            alignment: Alignment.center,
                            width: size.width - 320,
                            padding: ResponsiveBuilder.isDesktop(context)
                                ? const EdgeInsets.only(
                                    left: 20, top: 20, right: 20)
                                : ResponsiveBuilder.isTablet(context)
                                    ? const EdgeInsets.only(
                                        left: 20, top: 20, right: 20)
                                    : const EdgeInsets.only(
                                        left: 10, top: 20, right: 10),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: 700,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 220,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'First Name',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(          color: Colors.white,

                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 220,
                                              height: 45,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: TextFormField(
                                                  enabled: false,
                                                  controller: tutorfirstname,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade200,
                                                    hintText: 'Firstname',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                  onChanged: (value) {
                                                    // Your onChanged logic here
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 220,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Middle Name',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(          color: Colors.white,

                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 220,
                                              height: 45,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: TextFormField(
                                                  enabled: false,

                                                  controller: tutormiddleName,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade200,
                                                    hintText: '(Optional)',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                  // validator: (val) => val!.isEmpty
                                                  //     ? 'Enter a middlename'
                                                  //     : null,
                                                  onChanged: (value) {
                                                    bool areListsEqual =
                                                        listEquals(
                                                      newlanguages,
                                                      (tutorDataMap['language']
                                                              as List<dynamic>)
                                                          .cast<dynamic>(),
                                                    );
                                                    if (filename != '' ||
                                                        tutorfirstname.text !=
                                                            tutorDataMap[
                                                                'firstName'] ||
                                                        tutorlastname.text !=
                                                            tutorDataMap[
                                                                'lastname'] ||
                                                        tutormiddleName.text !=
                                                            tutorDataMap[
                                                                'middleName'] ||
                                                        newage !=
                                                            int.parse(
                                                                tutorDataMap[
                                                                    'age']) ||
                                                        country.text !=
                                                            tutorDataMap[
                                                                'country'] ||
                                                        city.text !=
                                                            tutorDataMap[
                                                                'city'] ||
                                                        birthcountry.text !=
                                                            tutorDataMap[
                                                                'birthPlace'] ||
                                                        birthcity.text !=
                                                            tutorDataMap[
                                                                'birthCity'] ||
                                                        timezone.text !=
                                                            tutorDataMap[
                                                                'timezone'] ||
                                                        contactnumber.text !=
                                                            tutorDataMap[
                                                                'contact'] ||
                                                        areListsEqual ==
                                                            false) {
                                                      setState(() {
                                                        allowUpdate = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        allowUpdate = false;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 220,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Last Name',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(          color: Colors.white,

                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 220,
                                              height: 45,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: TextFormField(
                                                  enabled: false,
                                                  controller: tutorlastname,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade200,
                                                    hintText: 'Lastname',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                  onChanged: (value) {
                                                    bool areListsEqual =
                                                        listEquals(
                                                      newlanguages,
                                                      (tutorDataMap['language']
                                                              as List<dynamic>)
                                                          .cast<dynamic>(),
                                                    );
                                                    if (filename != '' ||
                                                        tutorfirstname.text !=
                                                            tutorDataMap[
                                                                'firstName'] ||
                                                        tutorlastname.text !=
                                                            tutorDataMap[
                                                                'lastname'] ||
                                                        tutormiddleName.text !=
                                                            tutorDataMap[
                                                                'middleName'] ||
                                                        newage !=
                                                            int.parse(
                                                                tutorDataMap[
                                                                    'age']) ||
                                                        country.text !=
                                                            tutorDataMap[
                                                                'country'] ||
                                                        city.text !=
                                                            tutorDataMap[
                                                                'city'] ||
                                                        birthcountry.text !=
                                                            tutorDataMap[
                                                                'birthPlace'] ||
                                                        birthcity.text !=
                                                            tutorDataMap[
                                                                'birthCity'] ||
                                                        timezone.text !=
                                                            tutorDataMap[
                                                                'timezone'] ||
                                                        contactnumber.text !=
                                                            tutorDataMap[
                                                                'contact'] ||
                                                        areListsEqual ==
                                                            false) {
                                                      setState(() {
                                                        allowUpdate = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        allowUpdate = false;
                                                      });
                                                    }
                                                  },
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
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 400,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Date of Birth',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(          color: Colors.white,

                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: Container(
                                              color: Colors.grey.shade200,
                                              width: 400,
                                              height: 45,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    DateFormat("MMMM dd, yyyy")
                                                        .format(birthdate),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: kColorGrey),
                                                  ),
                                                  const Spacer(),
                                                  const IconButton(
                                                    hoverColor:
                                                        Colors.transparent,
                                                    icon: Icon(
                                                      EvaIcons.calendarOutline,
                                                      color: kColorPrimary,
                                                      size: 25,
                                                    ),
                                                    onPressed: null,
                                                    // onPressed: () {
                                                    //   _selectDate();
                                                    //   bool areListsEqual = listEquals(
                                                    //     newlanguages,
                                                    //     (tutorDataMap['language']
                                                    //             as List<dynamic>)
                                                    //         .cast<dynamic>(),
                                                    //   );
                                                    //   if (filename != '' ||
                                                    //       tutorfirstname.text !=
                                                    //           tutorDataMap[
                                                    //               'firstName'] ||
                                                    //       tutorlastname.text !=
                                                    //           tutorDataMap[
                                                    //               'lastname'] ||
                                                    //       tutormiddleName.text !=
                                                    //           tutorDataMap[
                                                    //               'middleName'] ||
                                                    //       birthdate !=
                                                    //           DateTime.parse(
                                                    //               tutorDataMap[
                                                    //                   'birthdate']) ||
                                                    //       newage !=
                                                    //           int.parse(tutorDataMap[
                                                    //               'age']) ||
                                                    //       country.text !=
                                                    //           tutorDataMap[
                                                    //               'country'] ||
                                                    //       city.text !=
                                                    //           tutorDataMap['city'] ||
                                                    //       birthcountry.text !=
                                                    //           tutorDataMap[
                                                    //               'birthPlace'] ||
                                                    //       birthcity.text !=
                                                    //           tutorDataMap[
                                                    //               'birthCity'] ||
                                                    //       timezone.text !=
                                                    //           tutorDataMap[
                                                    //               'timezone'] ||
                                                    //       contactnumber.text !=
                                                    //           tutorDataMap[
                                                    //               'contact'] ||
                                                    //       selectedDate !=
                                                    //           DateTime.parse(
                                                    //               tutorDataMap[
                                                    //                   'birthdate']) ||
                                                    //       areListsEqual == false) {
                                                    //     setState(() {
                                                    //       allowUpdate = true;
                                                    //     });
                                                    //   } else {
                                                    //     setState(() {
                                                    //       allowUpdate = false;
                                                    //     });
                                                    //   }
                                                    // },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 270,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Age',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(          color: Colors.white,

                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: Container(
                                              width: 100,
                                              height: 45,
                                              color: Colors.grey.shade200,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    newage.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: kColorGrey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 370,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Citizenship',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(          color: Colors.white,

                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 370,
                                              height: 45,

                                              child: TypeAheadFormField<String>(
                                                enabled: false,
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  enabled: false,
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                  controller: birthcountry,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade200,
                                                    hintText:
                                                        'Select a Country',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    labelStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                    suffixIcon: const Icon(
                                                        Icons.arrow_drop_down),
                                                  ),
                                                ),
                                                suggestionsCallback:
                                                    (String pattern) {
                                                  return widget.countryNames
                                                      .where((country) => country
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()));
                                                },
                                                itemBuilder: (context,
                                                    String suggestion) {
                                                  return ListTile(
                                                    title: Text(suggestion),
                                                  );
                                                },
                                                onSuggestionSelected:
                                                    (String suggestion) {
                                                  birthcountry.text =
                                                      suggestion;
                                                  bool areListsEqual =
                                                      listEquals(
                                                    newlanguages,
                                                    (tutorDataMap['language']
                                                            as List<dynamic>)
                                                        .cast<dynamic>(),
                                                  );
                                                  if (filename != '' ||
                                                      tutorfirstname.text !=
                                                          tutorDataMap[
                                                              'firstName'] ||
                                                      tutorlastname.text !=
                                                          tutorDataMap[
                                                              'lastname'] ||
                                                      tutormiddleName.text !=
                                                          tutorDataMap[
                                                              'middleName'] ||
                                                      newage !=
                                                          int.parse(
                                                              tutorDataMap[
                                                                  'age']) ||
                                                      country.text !=
                                                          tutorDataMap[
                                                              'country'] ||
                                                      city.text !=
                                                          tutorDataMap[
                                                              'city'] ||
                                                      birthcountry.text !=
                                                          tutorDataMap[
                                                              'birthPlace'] ||
                                                      birthcity.text !=
                                                          tutorDataMap[
                                                              'birthCity'] ||
                                                      timezone.text !=
                                                          tutorDataMap[
                                                              'timezone'] ||
                                                      contactnumber.text !=
                                                          tutorDataMap[
                                                              'contact'] ||
                                                      areListsEqual == false) {
                                                    setState(() {
                                                      allowUpdate = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      allowUpdate = false;
                                                    });
                                                  }
                                                },
                                              ),
                                              // country.name
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(
                                      //   width: 10,
                                      // ),
                                      // Column(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     Container(
                                      //       width: 300,
                                      //       padding: const EdgeInsets.fromLTRB(
                                      //           10, 5, 10, 5),
                                      //       decoration: BoxDecoration(
                                      //         // color: const Color.fromRGBO(
                                      //         //     55, 116, 135, 1),
                                      //         borderRadius: BorderRadius.circular(5),
                                      //       ),
                                      //       child: const Align(
                                      //         alignment: Alignment.centerLeft,
                                      //         child: Text(
                                      //           'City of Birth',
                                      //           style: TextStyle(
                                      //               fontWeight: FontWeight.w600,
                                      //               color: kColorLight),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Card(
                                      //       margin: EdgeInsets.zero,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(10),
                                      //       ),
                                      //       elevation: 5,
                                      //       child: Container(
                                      //         width: 300,
                                      //         height: 45,
                                      //         child: TextFormField(
                                      //           controller: birthcity,
                                      //           decoration: InputDecoration(
                                      //             fillColor: Colors.grey,
                                      //             hintText: 'City',
                                      //             hintStyle: const TextStyle(
                                      //                 color: Colors.grey,
                                      //                 fontSize: 15),
                                      //             contentPadding:
                                      //                 const EdgeInsets.symmetric(
                                      //                     vertical: 12,
                                      //                     horizontal: 10),
                                      //             border: OutlineInputBorder(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       10.0), // Rounded border
                                      //               borderSide: BorderSide
                                      //                   .none, // No outline border
                                      //             ),
                                      //           ),
                                      //           style: const TextStyle(
                                      //               color: kColorGrey),
                                      //           onChanged: (value) {
                                      //             bool areListsEqual = listEquals(
                                      //               newlanguages,
                                      //               (tutorDataMap['language']
                                      //                       as List<dynamic>)
                                      //                   .cast<dynamic>(),
                                      //             );
                                      //             if (filename != '' ||
                                      //                 tutorfirstname.text !=
                                      //                     tutorDataMap['firstName'] ||
                                      //                 tutorlastname.text !=
                                      //                     tutorDataMap['lastname'] ||
                                      //                 tutormiddleName.text !=
                                      //                     tutorDataMap[
                                      //                         'middleName'] ||
                                      //                 birthdate !=
                                      //                     DateTime.parse(tutorDataMap[
                                      //                         'birthdate']) ||
                                      //                 newage !=
                                      //                     int.parse(
                                      //                         tutorDataMap['age']) ||
                                      //                 country.text !=
                                      //                     tutorDataMap['country'] ||
                                      //                 city.text !=
                                      //                     tutorDataMap['city'] ||
                                      //                 birthcountry.text !=
                                      //                     tutorDataMap[
                                      //                         'birthPlace'] ||
                                      //                 birthcity.text !=
                                      //                     tutorDataMap['birthCity'] ||
                                      //                 timezone.text !=
                                      //                     tutorDataMap['timezone'] ||
                                      //                 contactnumber.text !=
                                      //                     tutorDataMap['contact'] ||
                                      //                 selectedDate !=
                                      //                     DateTime.parse(tutorDataMap[
                                      //                         'birthdate']) ||
                                      //                 areListsEqual == false) {
                                      //               setState(() {
                                      //                 allowUpdate = true;
                                      //               });
                                      //             } else {
                                      //               setState(() {
                                      //                 allowUpdate = false;
                                      //               });
                                      //             }
                                      //           },
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 370,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Country of Residence',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(          color: Colors.white,

                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 370,
                                              height: 45,
                                              child: TypeAheadFormField<String>(
                                                enabled: false,
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                  controller: country,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Select a Country',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    labelStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                    suffixIcon: const Icon(
                                                        Icons.arrow_drop_down),
                                                  ),
                                                ),
                                                suggestionsCallback:
                                                    (String pattern) {
                                                  return widget.countryNames
                                                      .where((country) => country
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()));
                                                },
                                                itemBuilder: (context,
                                                    String suggestion) {
                                                  return ListTile(
                                                    title: Text(suggestion),
                                                  );
                                                },
                                                onSuggestionSelected:
                                                    (String suggestion) {
                                                  country.text = suggestion;
                                                  bool areListsEqual =
                                                      listEquals(
                                                    newlanguages,
                                                    (tutorDataMap['language']
                                                            as List<dynamic>)
                                                        .cast<dynamic>(),
                                                  );
                                                  if (filename != '' ||
                                                      tutorfirstname.text !=
                                                          tutorDataMap[
                                                              'firstName'] ||
                                                      tutorlastname.text !=
                                                          tutorDataMap[
                                                              'lastname'] ||
                                                      tutormiddleName.text !=
                                                          tutorDataMap[
                                                              'middleName'] ||
                                                      newage !=
                                                          int.parse(
                                                              tutorDataMap[
                                                                  'age']) ||
                                                      country.text !=
                                                          tutorDataMap[
                                                              'country'] ||
                                                      city.text !=
                                                          tutorDataMap[
                                                              'city'] ||
                                                      birthcountry.text !=
                                                          tutorDataMap[
                                                              'birthPlace'] ||
                                                      birthcity.text !=
                                                          tutorDataMap[
                                                              'birthCity'] ||
                                                      timezone.text !=
                                                          tutorDataMap[
                                                              'timezone'] ||
                                                      contactnumber.text !=
                                                          tutorDataMap[
                                                              'contact'] ||
                                                      areListsEqual == false) {
                                                    setState(() {
                                                      allowUpdate = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      allowUpdate = false;
                                                    });
                                                  }
                                                },
                                              ),
                                              // country.name
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 300,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'City of Residence',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(          color: Colors.white,

                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 300,
                                              height: 45,
                                              child: TextFormField(
                                                controller: city,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.grey,
                                                  hintText: 'City',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12,
                                                          horizontal: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Rounded border
                                                    borderSide: BorderSide
                                                        .none, // No outline border
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                    color: kColorGrey),
                                                onChanged: (value) {
                                                  bool areListsEqual =
                                                      listEquals(
                                                    newlanguages,
                                                    (tutorDataMap['language']
                                                            as List<dynamic>)
                                                        .cast<dynamic>(),
                                                  );
                                                  if (filename != '' ||
                                                      tutorfirstname.text !=
                                                          tutorDataMap[
                                                              'firstName'] ||
                                                      tutorlastname.text !=
                                                          tutorDataMap[
                                                              'lastname'] ||
                                                      tutormiddleName.text !=
                                                          tutorDataMap[
                                                              'middleName'] ||
                                                      newage !=
                                                          int.parse(
                                                              tutorDataMap[
                                                                  'age']) ||
                                                      country.text !=
                                                          tutorDataMap[
                                                              'country'] ||
                                                      city.text !=
                                                          tutorDataMap[
                                                              'city'] ||
                                                      birthcountry.text !=
                                                          tutorDataMap[
                                                              'birthPlace'] ||
                                                      birthcity.text !=
                                                          tutorDataMap[
                                                              'birthCity'] ||
                                                      timezone.text !=
                                                          tutorDataMap[
                                                              'timezone'] ||
                                                      contactnumber.text !=
                                                          tutorDataMap[
                                                              'contact'] ||
                                                      areListsEqual == false) {
                                                    setState(() {
                                                      allowUpdate = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      allowUpdate = false;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 370,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 10, 5),
                                          decoration: BoxDecoration(
                                            // color:
                                            //     const Color.fromRGBO(55, 116, 135, 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Timezone',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: kColorLight),
                                            ),
                                          ),
                                        ),
                                        Card(          color: Colors.white,

                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 5,
                                          child: SizedBox(
                                            width: 370,
                                            height: 45,
                                            child: TypeAheadFormField<String>(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                style: const TextStyle(
                                                    color: kColorGrey),
                                                controller: timezone,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Select your Timezone',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.grey),
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12,
                                                          horizontal: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Rounded border
                                                    borderSide: BorderSide
                                                        .none, // No outline border
                                                  ),
                                                  suffixIcon: const Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                              ),
                                              suggestionsCallback:
                                                  (String pattern) {
                                                return timezonesList.where(
                                                    (timezone) => timezone
                                                        .toLowerCase()
                                                        .contains(pattern
                                                            .toLowerCase()));
                                              },
                                              itemBuilder:
                                                  (context, String suggestion) {
                                                return ListTile(
                                                  title: Text(
                                                    suggestion,
                                                    style: const TextStyle(
                                                        color: kColorGrey),
                                                  ),
                                                );
                                              },
                                              onSuggestionSelected:
                                                  (String suggestion) {
                                                setState(() {
                                                  timezone.text = suggestion;
                                                  bool areListsEqual =
                                                      listEquals(
                                                    newlanguages,
                                                    (tutorDataMap['language']
                                                            as List<dynamic>)
                                                        .cast<dynamic>(),
                                                  );
                                                  if (filename != '' ||
                                                      tutorfirstname.text !=
                                                          tutorDataMap[
                                                              'firstName'] ||
                                                      tutorlastname.text !=
                                                          tutorDataMap[
                                                              'lastname'] ||
                                                      tutormiddleName.text !=
                                                          tutorDataMap[
                                                              'middleName'] ||
                                                      newage !=
                                                          int.parse(
                                                              tutorDataMap[
                                                                  'age']) ||
                                                      country.text !=
                                                          tutorDataMap[
                                                              'country'] ||
                                                      city.text !=
                                                          tutorDataMap[
                                                              'city'] ||
                                                      birthcountry.text !=
                                                          tutorDataMap[
                                                              'birthPlace'] ||
                                                      birthcity.text !=
                                                          tutorDataMap[
                                                              'birthCity'] ||
                                                      timezone.text !=
                                                          tutorDataMap[
                                                              'timezone'] ||
                                                      contactnumber.text !=
                                                          tutorDataMap[
                                                              'contact'] ||
                                                      areListsEqual == false) {
                                                    setState(() {
                                                      allowUpdate = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      allowUpdate = false;
                                                    });
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 300,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 10, 5),
                                          decoration: BoxDecoration(
                                            // color:
                                            //     const Color.fromRGBO(55, 116, 135, 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Contact Number',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: kColorLight),
                                            ),
                                          ),
                                        ),
                                        Card(          color: Colors.white,

                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 5,
                                          child: SizedBox(
                                            width: 300,
                                            height: 45,
                                            child: TextFormField(
                                              controller: contactnumber,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey,
                                                hintText: 'Contact Number',
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Rounded border
                                                  borderSide: BorderSide
                                                      .none, // No outline border
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: kColorGrey),
                                              onChanged: (value) {
                                                bool areListsEqual = listEquals(
                                                  newlanguages,
                                                  (tutorDataMap['language']
                                                          as List<dynamic>)
                                                      .cast<dynamic>(),
                                                );
                                                if (filename != '' ||
                                                    tutorfirstname.text !=
                                                        tutorDataMap[
                                                            'firstName'] ||
                                                    tutorlastname.text !=
                                                        tutorDataMap[
                                                            'lastname'] ||
                                                    tutormiddleName.text !=
                                                        tutorDataMap[
                                                            'middleName'] ||
                                                    newage !=
                                                        int.parse(tutorDataMap[
                                                            'age']) ||
                                                    country.text !=
                                                        tutorDataMap[
                                                            'country'] ||
                                                    city.text !=
                                                        tutorDataMap['city'] ||
                                                    birthcountry.text !=
                                                        tutorDataMap[
                                                            'birthPlace'] ||
                                                    birthcity.text !=
                                                        tutorDataMap[
                                                            'birthCity'] ||
                                                    timezone.text !=
                                                        tutorDataMap[
                                                            'timezone'] ||
                                                    contactnumber.text !=
                                                        tutorDataMap[
                                                            'contact'] ||
                                                    areListsEqual == false) {
                                                  setState(() {
                                                    allowUpdate = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    allowUpdate = false;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 680,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 10, 5),
                                        decoration: BoxDecoration(
                                          // color: const Color.fromRGBO(
                                          //     55, 116, 135, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Languages',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: kColorLight),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Card(          color: Colors.white,

                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 270,
                                              height: 45,
                                              child: TypeAheadFormField<
                                                  LanguageData>(
                                                // Specify LanguageData as the generic type
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  decoration: InputDecoration(
                                                    hintText: 'Add Language',
                                                    labelStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                    suffixIcon: const Icon(
                                                        Icons.arrow_drop_down),
                                                  ),
                                                ),
                                                suggestionsCallback:
                                                    (pattern) async {
                                                  final suggestions = widget
                                                      .names
                                                      .where((language) => language
                                                          .languageNamesStream
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()))
                                                      .toList(); // Return a list of LanguageData objects
                                                  return suggestions;
                                                },
                                                itemBuilder:
                                                    (context, suggestions) {
                                                  return ListTile(
                                                    title: Text(suggestions
                                                        .languageNamesStream), // Access the language name
                                                  );
                                                },
                                                onSuggestionSelected:
                                                    (suggestion) {
                                                  if (newlanguages.contains(
                                                      suggestion
                                                          .languageNamesStream)) {
                                                    null;
                                                  } else {
                                                    setState(() {
                                                      newlanguages.add(suggestion
                                                          .languageNamesStream
                                                          .toString()); // Add the LanguageData object to tlanguages
                                                    });
                                                  }
                                                  bool areListsEqual =
                                                      listEquals(
                                                    newlanguages,
                                                    (tutorDataMap['language']
                                                            as List<dynamic>)
                                                        .cast<dynamic>(),
                                                  );
                                                  if (filename != '' ||
                                                      tutorfirstname.text !=
                                                          tutorDataMap[
                                                              'firstName'] ||
                                                      tutorlastname.text !=
                                                          tutorDataMap[
                                                              'lastname'] ||
                                                      tutormiddleName.text !=
                                                          tutorDataMap[
                                                              'middleName'] ||
                                                      newage !=
                                                          int.parse(
                                                              tutorDataMap[
                                                                  'age']) ||
                                                      country.text !=
                                                          tutorDataMap[
                                                              'country'] ||
                                                      city.text !=
                                                          tutorDataMap[
                                                              'city'] ||
                                                      birthcountry.text !=
                                                          tutorDataMap[
                                                              'birthPlace'] ||
                                                      birthcity.text !=
                                                          tutorDataMap[
                                                              'birthCity'] ||
                                                      timezone.text !=
                                                          tutorDataMap[
                                                              'timezone'] ||
                                                      contactnumber.text !=
                                                          tutorDataMap[
                                                              'contact'] ||
                                                      areListsEqual == false) {
                                                    setState(() {
                                                      allowUpdate = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      allowUpdate = false;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Tooltip(
                                            message: 'Remove Language',
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: -4,
                                                      vertical: -4),
                                              icon: const Icon(Icons
                                                  .delete_outline_outlined),
                                              color: kCalendarColorB,
                                              iconSize: 30,
                                              onPressed: selectedindex == null
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        newlanguages.removeAt(
                                                            selectedindex!);
                                                      });
                                                    },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
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
                                              Container(
                                                width: 550,
                                                height: 45,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                child: ListView.builder(
                                                    controller:
                                                        updatescrollController1,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        newlanguages.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      bool isIndexEven =
                                                          index % 2 == 0;

                                                      String datalanguage =
                                                          newlanguages[index];
                                                      Color color =
                                                          vibrantColors[index %
                                                              vibrantColors
                                                                  .length]; // Cycle through colors

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 10),
                                                        child: Card(          color: Colors.white,

                                                          margin:
                                                              EdgeInsets.zero,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          elevation: 5,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    5, 0, 5, 0),
                                                            decoration: selectedindex ==
                                                                    index
                                                                ? const BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors
                                                                              .black12,
                                                                          offset: Offset(
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
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15)),
                                                                  )
                                                                : const BoxDecoration(
                                                                    boxShadow: [
                                                                        BoxShadow(
                                                                            color: Colors
                                                                                .black12,
                                                                            offset: Offset(0,
                                                                                4),
                                                                            blurRadius:
                                                                                5.0)
                                                                      ],
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            15)),
                                                                    color: Colors
                                                                        .white),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedindex ==
                                                                            index
                                                                        ? selectedindex =
                                                                            null
                                                                        : selectedindex =
                                                                            index;
                                                                  });
                                                                },
                                                                child: Center(
                                                                  child: Text(
                                                                    datalanguage,
                                                                    style: TextStyle(
                                                                        color: selectedindex ==
                                                                                index
                                                                            ? Colors.white
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
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : viewinfo(widget.tutordata)
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: model,
            child: Positioned(
              top: 17,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                   style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.transparent),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      elevation: WidgetStateProperty.all<double>(0),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.hovered)) {
                            return Colors.white
                                .withOpacity(0.3); // Hover color
                          }
                          return null; // Use the default color for other states
                        },
                      ),
                    ),
                    onPressed: () async {
                      // if (allowUpdate == false) {
                      // } else {
                      if (filename != '') {
                        data = await uploadTutorProfile(
                          tutorDataMap['userId'],
                          selectedImage,
                          filename,
                        );
                      }

                      String? result = await updatePersonalTutorInformation(
                          tutorDataMap['userId'],
                          country.text,
                          birthcountry.text,
                          birthcity.text,
                          city.text,
                          tutorfirstname.text,
                          tutormiddleName.text,
                          tutorlastname.text,
                          newlanguages,
                          tutorDataMap['userId'],
                          contactnumber.text,
                          newage.toString(),
                          timezone.text,
                          data == null || data!.isEmpty ? '' : data!);
                      if (result == 'success') {
                        filename = '';
                        selectedImage = Uint8List(0);
                        final provider = context.read<MyModel>();
                        provider.updateBoolValue(false);
                      } else {
                        filename = '';
                        CoolAlert.show(
                          context: context,
                          width: 200,
                          type: CoolAlertType.error,
                          text: result.toString(),
                        );
                      }

                      allowUpdate = false;
                      // }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(
                          color: kColorPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.transparent),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      elevation: WidgetStateProperty.all<double>(0),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.hovered)) {
                            return Colors.white
                                .withOpacity(0.3); // Hover color
                          }
                          return null; // Use the default color for other states
                        },
                      ),
                    ),
                    onPressed: () {
                      // bool areListsEqual = listEquals(
                      //   newlanguages,
                      //   (tutorDataMap['language']
                      //           as List<dynamic>)
                      //       .cast<dynamic>(),
                      // );
                      // if (filename != '' ||
                      //     tutorfirstname.text !=
                      //         tutorDataMap['firstName'] ||
                      //     tutorlastname.text !=
                      //         tutorDataMap['lastname'] ||
                      //     tutormiddleName.text !=
                      //         tutorDataMap['middleName'] ||
                      //     birthdate !=
                      //         DateTime.parse(tutorDataMap[
                      //             'birthdate']) ||
                      //     newage !=
                      //         int.parse(
                      //             tutorDataMap['age']) ||
                      //     country.text !=
                      //         tutorDataMap['country'] ||
                      //     city.text !=
                      //         tutorDataMap['city'] ||
                      //     birthcountry.text !=
                      //         tutorDataMap['birthPlace'] ||
                      //     birthcity.text !=
                      //         tutorDataMap['birthCity'] ||
                      //     timezone.text !=
                      //         tutorDataMap['timezone'] ||
                      //     contactnumber.text !=
                      //         tutorDataMap['contact'] ||
                      //     selectedDate !=
                      //         DateTime.parse(tutorDataMap[
                      //             'birthdate']) ||
                      //     areListsEqual == false) {
                      //   CoolAlert.show(
                      //     context: context,
                      //     barrierDismissible: false,
                      //     width: 200,
                      //     type: CoolAlertType.confirm,
                      //     text:
                      //         'You want to cancel update?',
                      //     confirmBtnText: 'Proceed',
                      //     confirmBtnColor:
                      //         Colors.greenAccent,
                      //     cancelBtnText: 'Go back',
                      //     showCancelBtn: true,
                      //     cancelBtnTextStyle:
                      //         const TextStyle(
                      //             color: Colors.red),
                      //     onCancelBtnTap: () {
                      //       Navigator.of(context).pop;
                      //     },
                      //     onConfirmBtnTap: () {
                      //       filename = '';
                      //       initializeWidget();
                      //       final provider =
                      //           context.read<MyModel>();
                      //       provider.updateBoolValue(false);
                      //     },
                      //   );
                      // } else {
                      filename = '';
                      initializeWidget();
                      final provider = context.read<MyModel>();
                      provider.updateBoolValue(false);
                      // }
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: kCalendarColorB, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget viewinfo(TutorInformation data) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      width: ResponsiveBuilder.isDesktop(context)
          ? size.width - 320
          : size.width - 30,
      padding: ResponsiveBuilder.isDesktop(context)
          ? const EdgeInsets.only(left: 250, right: 20)
          : ResponsiveBuilder.isTablet(context)
              ? const EdgeInsets.only(left: 100, right: 20)
              : const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Name:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text:
                      '${data.firstName}${data.middleName == '' ? ' ${data.lastname}' : ' ${data.middleName} ${data.lastname}'}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Date of Birth:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: DateFormat("MMMM dd, yyyy").format(data.birthdate),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                const TextSpan(
                  text: 'Age:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.age,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Gender:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.gender,
                  //  text: '${data.birthCity}, ${data.birthPlace}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Citizenship:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.citizenship.join(', '),
                  //  text: '${data.birthCity}, ${data.birthPlace}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Country of Residence:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: '${data.city}, ${data.country}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Timezone:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.timezone,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Contact:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.contact,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Languages:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.language.join(', '),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
        ],
      ),
    );
  }
}
