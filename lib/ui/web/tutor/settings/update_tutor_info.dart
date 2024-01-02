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
    birthdate = DateTime.parse(tutorDataMap['birthdate']);
    newage = int.parse(tutorDataMap['age']);
    country.text = tutorDataMap['country'];
    city.text = tutorDataMap['city'];
    birthcountry.text = tutorDataMap['birthPlace'];
    birthcity.text = tutorDataMap['birthCity'];
    timezone.text = tutorDataMap['timezone'];
    contactnumber.text = tutorDataMap['contact'];
    selectedDate = DateTime.parse(tutorDataMap['birthdate']);
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
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      elevation: 5,
      child: Container(
        alignment: Alignment.topCenter,
        width: size.width - 320,
        height: size.height - 75,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Container(
                  width: size.width - 320,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: gradient,
                      stops: stops,
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 250.0, right: 20, top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(children: [
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
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10))),
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
                                                tutorDataMap['firstName'] ||
                                            tutorlastname.text !=
                                                tutorDataMap['lastname'] ||
                                            tutormiddleName.text !=
                                                tutorDataMap['middleName'] ||
                                            birthdate !=
                                                DateTime.parse(tutorDataMap[
                                                    'birthdate']) ||
                                            newage !=
                                                int.parse(
                                                    tutorDataMap['age']) ||
                                            country.text !=
                                                tutorDataMap['country'] ||
                                            city.text != tutorDataMap['city'] ||
                                            birthcountry.text !=
                                                tutorDataMap['birthPlace'] ||
                                            birthcity.text !=
                                                tutorDataMap['birthCity'] ||
                                            timezone.text !=
                                                tutorDataMap['timezone'] ||
                                            contactnumber.text !=
                                                tutorDataMap['contact'] ||
                                            selectedDate !=
                                                DateTime.parse(tutorDataMap[
                                                    'birthdate']) ||
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
                                        style: TextStyle(color: kColorPrimary),
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
                          const Spacer(),
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
                                    Colors.white, // Set the icon color to white
                              ),
                              label: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors
                                      .white, // Set the text color to white
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
                  padding: const EdgeInsets.only(left: 250.0, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 680,
                      child: Divider(
                        color: Colors.grey.shade500,
                        thickness: 1.0, // Adjust the thickness of the line
                      ),
                    ),
                  ),
                ),
                model
                    ? Container(
                        alignment: Alignment.center,
                        width: size.width - 320,
                        padding: const EdgeInsets.only(left: 250, right: 200),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 220,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'First Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 220,
                                      height: 45,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          enabled: false,
                                          controller: tutorfirstname,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            fillColor: Colors.grey.shade300,
                                            hintText: 'Firstname',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                          ),
                                          // validator: (val) => val!.isEmpty
                                          //     ? 'Enter a firstname'
                                          //     : null,
                                          onChanged: (value) {
                                            bool areListsEqual = listEquals(
                                              newlanguages,
                                              (tutorDataMap['language']
                                                      as List<dynamic>)
                                                  .cast<dynamic>(),
                                            );
                                            if (filename != '' ||
                                                tutorfirstname.text !=
                                                    tutorDataMap['firstName'] ||
                                                tutorlastname.text !=
                                                    tutorDataMap['lastname'] ||
                                                tutormiddleName.text !=
                                                    tutorDataMap[
                                                        'middleName'] ||
                                                birthdate !=
                                                    DateTime.parse(tutorDataMap[
                                                        'birthdate']) ||
                                                newage !=
                                                    int.parse(
                                                        tutorDataMap['age']) ||
                                                country.text !=
                                                    tutorDataMap['country'] ||
                                                city.text !=
                                                    tutorDataMap['city'] ||
                                                birthcountry.text !=
                                                    tutorDataMap[
                                                        'birthPlace'] ||
                                                birthcity.text !=
                                                    tutorDataMap['birthCity'] ||
                                                timezone.text !=
                                                    tutorDataMap['timezone'] ||
                                                contactnumber.text !=
                                                    tutorDataMap['contact'] ||
                                                selectedDate !=
                                                    DateTime.parse(tutorDataMap[
                                                        'birthdate']) ||
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
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 220,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Middle Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 220,
                                      height: 45,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          enabled: false,

                                          controller: tutormiddleName,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            fillColor: Colors.grey,
                                            hintText: '(Optional)',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                          ),
                                          // validator: (val) => val!.isEmpty
                                          //     ? 'Enter a middlename'
                                          //     : null,
                                          onChanged: (value) {
                                            bool areListsEqual = listEquals(
                                              newlanguages,
                                              (tutorDataMap['language']
                                                      as List<dynamic>)
                                                  .cast<dynamic>(),
                                            );
                                            if (filename != '' ||
                                                tutorfirstname.text !=
                                                    tutorDataMap['firstName'] ||
                                                tutorlastname.text !=
                                                    tutorDataMap['lastname'] ||
                                                tutormiddleName.text !=
                                                    tutorDataMap[
                                                        'middleName'] ||
                                                birthdate !=
                                                    DateTime.parse(tutorDataMap[
                                                        'birthdate']) ||
                                                newage !=
                                                    int.parse(
                                                        tutorDataMap['age']) ||
                                                country.text !=
                                                    tutorDataMap['country'] ||
                                                city.text !=
                                                    tutorDataMap['city'] ||
                                                birthcountry.text !=
                                                    tutorDataMap[
                                                        'birthPlace'] ||
                                                birthcity.text !=
                                                    tutorDataMap['birthCity'] ||
                                                timezone.text !=
                                                    tutorDataMap['timezone'] ||
                                                contactnumber.text !=
                                                    tutorDataMap['contact'] ||
                                                selectedDate !=
                                                    DateTime.parse(tutorDataMap[
                                                        'birthdate']) ||
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
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 220,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Last Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 220,
                                      height: 45,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          controller: tutorlastname,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            fillColor: Colors.grey,
                                            hintText: 'Lastname',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                          ),
                                          onChanged: (value) {
                                            bool areListsEqual = listEquals(
                                              newlanguages,
                                              (tutorDataMap['language']
                                                      as List<dynamic>)
                                                  .cast<dynamic>(),
                                            );
                                            if (filename != '' ||
                                                tutorfirstname.text !=
                                                    tutorDataMap['firstName'] ||
                                                tutorlastname.text !=
                                                    tutorDataMap['lastname'] ||
                                                tutormiddleName.text !=
                                                    tutorDataMap[
                                                        'middleName'] ||
                                                birthdate !=
                                                    DateTime.parse(tutorDataMap[
                                                        'birthdate']) ||
                                                newage !=
                                                    int.parse(
                                                        tutorDataMap['age']) ||
                                                country.text !=
                                                    tutorDataMap['country'] ||
                                                city.text !=
                                                    tutorDataMap['city'] ||
                                                birthcountry.text !=
                                                    tutorDataMap[
                                                        'birthPlace'] ||
                                                birthcity.text !=
                                                    tutorDataMap['birthCity'] ||
                                                timezone.text !=
                                                    tutorDataMap['timezone'] ||
                                                contactnumber.text !=
                                                    tutorDataMap['contact'] ||
                                                selectedDate !=
                                                    DateTime.parse(tutorDataMap[
                                                        'birthdate']) ||
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 400,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Date of Birth',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 400,
                                      height: 45,
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: Row(
                                        children: [
                                          Text(
                                            DateFormat("MMMM dd, yyyy")
                                                .format(birthdate),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            tooltip: 'Select Date',
                                            hoverColor: Colors.transparent,
                                            icon: const Icon(
                                              EvaIcons.calendarOutline,
                                              color: Colors.blue,
                                              size: 25,
                                            ),
                                            onPressed: () {
                                              _selectDate();
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
                                                  birthdate !=
                                                      DateTime.parse(
                                                          tutorDataMap[
                                                              'birthdate']) ||
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
                                                  selectedDate !=
                                                      DateTime.parse(
                                                          tutorDataMap[
                                                              'birthdate']) ||
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 270,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Age',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 270,
                                      height: 45,
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: Row(
                                        children: [
                                          Text(
                                            newage.toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 370,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Country of Residence',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 370,
                                      height: 45,
                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          controller: country,
                                          decoration: const InputDecoration(
                                            hintText: 'Select a Country',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(),
                                            suffixIcon:
                                                Icon(Icons.arrow_drop_down),
                                          ),
                                        ),
                                        suggestionsCallback: (String pattern) {
                                          return widget.countryNames.where(
                                              (country) => country
                                                  .toLowerCase()
                                                  .contains(
                                                      pattern.toLowerCase()));
                                        },
                                        itemBuilder:
                                            (context, String suggestion) {
                                          return ListTile(
                                            title: Text(suggestion),
                                          );
                                        },
                                        onSuggestionSelected:
                                            (String suggestion) {
                                          country.text = suggestion;
                                          bool areListsEqual = listEquals(
                                            newlanguages,
                                            (tutorDataMap['language']
                                                    as List<dynamic>)
                                                .cast<dynamic>(),
                                          );
                                          if (filename != '' ||
                                              tutorfirstname.text !=
                                                  tutorDataMap['firstName'] ||
                                              tutorlastname.text !=
                                                  tutorDataMap['lastname'] ||
                                              tutormiddleName.text !=
                                                  tutorDataMap['middleName'] ||
                                              birthdate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
                                              newage !=
                                                  int.parse(
                                                      tutorDataMap['age']) ||
                                              country.text !=
                                                  tutorDataMap['country'] ||
                                              city.text !=
                                                  tutorDataMap['city'] ||
                                              birthcountry.text !=
                                                  tutorDataMap['birthPlace'] ||
                                              birthcity.text !=
                                                  tutorDataMap['birthCity'] ||
                                              timezone.text !=
                                                  tutorDataMap['timezone'] ||
                                              contactnumber.text !=
                                                  tutorDataMap['contact'] ||
                                              selectedDate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
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
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 300,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'City of Residence',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 45,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: TextFormField(
                                        controller: city,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Colors.grey,
                                          hintText: 'City',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                        onChanged: (value) {
                                          bool areListsEqual = listEquals(
                                            newlanguages,
                                            (tutorDataMap['language']
                                                    as List<dynamic>)
                                                .cast<dynamic>(),
                                          );
                                          if (filename != '' ||
                                              tutorfirstname.text !=
                                                  tutorDataMap['firstName'] ||
                                              tutorlastname.text !=
                                                  tutorDataMap['lastname'] ||
                                              tutormiddleName.text !=
                                                  tutorDataMap['middleName'] ||
                                              birthdate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
                                              newage !=
                                                  int.parse(
                                                      tutorDataMap['age']) ||
                                              country.text !=
                                                  tutorDataMap['country'] ||
                                              city.text !=
                                                  tutorDataMap['city'] ||
                                              birthcountry.text !=
                                                  tutorDataMap['birthPlace'] ||
                                              birthcity.text !=
                                                  tutorDataMap['birthCity'] ||
                                              timezone.text !=
                                                  tutorDataMap['timezone'] ||
                                              contactnumber.text !=
                                                  tutorDataMap['contact'] ||
                                              selectedDate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 370,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Country of Birth',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 370,
                                      height: 45,

                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          controller: birthcountry,
                                          decoration: const InputDecoration(
                                            hintText: 'Select a Country',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(),
                                            suffixIcon:
                                                Icon(Icons.arrow_drop_down),
                                          ),
                                        ),
                                        suggestionsCallback: (String pattern) {
                                          return widget.countryNames.where(
                                              (country) => country
                                                  .toLowerCase()
                                                  .contains(
                                                      pattern.toLowerCase()));
                                        },
                                        itemBuilder:
                                            (context, String suggestion) {
                                          return ListTile(
                                            title: Text(suggestion),
                                          );
                                        },
                                        onSuggestionSelected:
                                            (String suggestion) {
                                          birthcountry.text = suggestion;
                                          bool areListsEqual = listEquals(
                                            newlanguages,
                                            (tutorDataMap['language']
                                                    as List<dynamic>)
                                                .cast<dynamic>(),
                                          );
                                          if (filename != '' ||
                                              tutorfirstname.text !=
                                                  tutorDataMap['firstName'] ||
                                              tutorlastname.text !=
                                                  tutorDataMap['lastname'] ||
                                              tutormiddleName.text !=
                                                  tutorDataMap['middleName'] ||
                                              birthdate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
                                              newage !=
                                                  int.parse(
                                                      tutorDataMap['age']) ||
                                              country.text !=
                                                  tutorDataMap['country'] ||
                                              city.text !=
                                                  tutorDataMap['city'] ||
                                              birthcountry.text !=
                                                  tutorDataMap['birthPlace'] ||
                                              birthcity.text !=
                                                  tutorDataMap['birthCity'] ||
                                              timezone.text !=
                                                  tutorDataMap['timezone'] ||
                                              contactnumber.text !=
                                                  tutorDataMap['contact'] ||
                                              selectedDate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
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
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 300,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'City of Birth',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 45,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: TextFormField(
                                        controller: birthcity,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Colors.grey,
                                          hintText: 'City',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                        onChanged: (value) {
                                          bool areListsEqual = listEquals(
                                            newlanguages,
                                            (tutorDataMap['language']
                                                    as List<dynamic>)
                                                .cast<dynamic>(),
                                          );
                                          if (filename != '' ||
                                              tutorfirstname.text !=
                                                  tutorDataMap['firstName'] ||
                                              tutorlastname.text !=
                                                  tutorDataMap['lastname'] ||
                                              tutormiddleName.text !=
                                                  tutorDataMap['middleName'] ||
                                              birthdate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
                                              newage !=
                                                  int.parse(
                                                      tutorDataMap['age']) ||
                                              country.text !=
                                                  tutorDataMap['country'] ||
                                              city.text !=
                                                  tutorDataMap['city'] ||
                                              birthcountry.text !=
                                                  tutorDataMap['birthPlace'] ||
                                              birthcity.text !=
                                                  tutorDataMap['birthCity'] ||
                                              timezone.text !=
                                                  tutorDataMap['timezone'] ||
                                              contactnumber.text !=
                                                  tutorDataMap['contact'] ||
                                              selectedDate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
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
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 370,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(55, 116, 135, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Timezone',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 370,
                                    height: 45,
                                    child: TypeAheadFormField<String>(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: timezone,
                                        decoration: const InputDecoration(
                                          hintText: 'Select your Timezone',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(),
                                          suffixIcon:
                                              Icon(Icons.arrow_drop_down),
                                        ),
                                      ),
                                      suggestionsCallback: (String pattern) {
                                        return timezonesList.where((timezone) =>
                                            timezone.toLowerCase().contains(
                                                pattern.toLowerCase()));
                                      },
                                      itemBuilder:
                                          (context, String suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      onSuggestionSelected:
                                          (String suggestion) {
                                        setState(() {
                                          timezone.text = suggestion;
                                          bool areListsEqual = listEquals(
                                            newlanguages,
                                            (tutorDataMap['language']
                                                    as List<dynamic>)
                                                .cast<dynamic>(),
                                          );
                                          if (filename != '' ||
                                              tutorfirstname.text !=
                                                  tutorDataMap['firstName'] ||
                                              tutorlastname.text !=
                                                  tutorDataMap['lastname'] ||
                                              tutormiddleName.text !=
                                                  tutorDataMap['middleName'] ||
                                              birthdate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
                                              newage !=
                                                  int.parse(
                                                      tutorDataMap['age']) ||
                                              country.text !=
                                                  tutorDataMap['country'] ||
                                              city.text !=
                                                  tutorDataMap['city'] ||
                                              birthcountry.text !=
                                                  tutorDataMap['birthPlace'] ||
                                              birthcity.text !=
                                                  tutorDataMap['birthCity'] ||
                                              timezone.text !=
                                                  tutorDataMap['timezone'] ||
                                              contactnumber.text !=
                                                  tutorDataMap['contact'] ||
                                              selectedDate !=
                                                  DateTime.parse(tutorDataMap[
                                                      'birthdate']) ||
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
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 300,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(55, 116, 135, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Contact Number',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 300,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey, width: 1)),
                                    child: TextFormField(
                                      controller: contactnumber,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'Contact Number',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                      onChanged: (value) {
                                        bool areListsEqual = listEquals(
                                          newlanguages,
                                          (tutorDataMap['language']
                                                  as List<dynamic>)
                                              .cast<dynamic>(),
                                        );
                                        if (filename != '' ||
                                            tutorfirstname.text !=
                                                tutorDataMap['firstName'] ||
                                            tutorlastname.text !=
                                                tutorDataMap['lastname'] ||
                                            tutormiddleName.text !=
                                                tutorDataMap['middleName'] ||
                                            birthdate !=
                                                DateTime.parse(tutorDataMap[
                                                    'birthdate']) ||
                                            newage !=
                                                int.parse(
                                                    tutorDataMap['age']) ||
                                            country.text !=
                                                tutorDataMap['country'] ||
                                            city.text != tutorDataMap['city'] ||
                                            birthcountry.text !=
                                                tutorDataMap['birthPlace'] ||
                                            birthcity.text !=
                                                tutorDataMap['birthCity'] ||
                                            timezone.text !=
                                                tutorDataMap['timezone'] ||
                                            contactnumber.text !=
                                                tutorDataMap['contact'] ||
                                            selectedDate !=
                                                DateTime.parse(tutorDataMap[
                                                    'birthdate']) ||
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
                                ],
                              ),
                            ]),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 680,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            55, 116, 135, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Languages',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 400,
                                            height: 45,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: newlanguages.length,
                                                itemBuilder: (context, index) {
                                                  String datalanguage =
                                                      newlanguages[index];
                                                  Color color = vibrantColors[
                                                      index %
                                                          vibrantColors
                                                              .length]; // Cycle through colors

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    15)),
                                                        color: color,
                                                      ),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(datalanguage),
                                                            IconButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              visualDensity:
                                                                  const VisualDensity(
                                                                      horizontal:
                                                                          -4,
                                                                      vertical:
                                                                          -4),
                                                              icon: const Icon(Icons
                                                                  .delete_outline_outlined),
                                                              color: Colors.red,
                                                              iconSize: 15,
                                                              onPressed: () {
                                                                setState(() {
                                                                  newlanguages
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                            ),
                                                          ]),
                                                    ),
                                                  );
                                                }),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: 270,
                                            height: 45,
                                            child: TypeAheadFormField<
                                                LanguageData>(
                                              // Specify LanguageData as the generic type
                                              textFieldConfiguration:
                                                  const TextFieldConfiguration(
                                                decoration: InputDecoration(
                                                  hintText: 'Add Language',
                                                  border: OutlineInputBorder(),
                                                  suffixIcon: Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                              ),
                                              suggestionsCallback:
                                                  (pattern) async {
                                                final suggestions = widget.names
                                                    .where((language) =>
                                                        language
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
                                                    birthdate !=
                                                        DateTime.parse(
                                                            tutorDataMap[
                                                                'birthdate']) ||
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
                                                    selectedDate !=
                                                        DateTime.parse(
                                                            tutorDataMap[
                                                                'birthdate']) ||
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
                                        ],
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 130,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kColorPrimary,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                      onPressed: allowUpdate == false
                                          ? null
                                          : () async {
                                              CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  barrierDismissible: false,
                                                  type: CoolAlertType.loading,
                                                  text:
                                                      'Updating your data....');
                                              if (filename != '') {
                                                data = await uploadTutorProfile(
                                                  tutorDataMap['userId'],
                                                  selectedImage,
                                                  filename,
                                                );
                                              }

                                              String? result =
                                                  await updatePersonalTutorInformation(
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
                                                      birthdate.toString(),
                                                      timezone.text,
                                                      data == null ||
                                                              data!.isEmpty
                                                          ? ''
                                                          : data!);
                                              if (result == 'success') {
                                                setState(() {
                                                  CoolAlert.show(
                                                    context: context,
                                                    width: 200,
                                                    type: CoolAlertType.success,
                                                    text: 'Update Successful!',
                                                    autoCloseDuration:
                                                        const Duration(
                                                            seconds: 1),
                                                  ).then(
                                                    (value) {
                                                      filename = '';
                                                      selectedImage =
                                                          Uint8List(0);
                                                      final provider = context
                                                          .read<MyModel>();
                                                      provider.updateBoolValue(
                                                          false);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  );
                                                });
                                              } else {
                                                filename = '';
                                                // ignore: use_build_context_synchronously
                                                CoolAlert.show(
                                                  context: context,
                                                  width: 200,
                                                  type: CoolAlertType.error,
                                                  text: result.toString(),
                                                );
                                              }
                                            },
                                      child: const Text('Update'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 130,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                      onPressed: () {
                                        bool areListsEqual = listEquals(
                                          newlanguages,
                                          (tutorDataMap['language']
                                                  as List<dynamic>)
                                              .cast<dynamic>(),
                                        );
                                        if (filename != '' ||
                                            tutorfirstname.text !=
                                                tutorDataMap['firstName'] ||
                                            tutorlastname.text !=
                                                tutorDataMap['lastname'] ||
                                            tutormiddleName.text !=
                                                tutorDataMap['middleName'] ||
                                            birthdate !=
                                                DateTime.parse(tutorDataMap[
                                                    'birthdate']) ||
                                            newage !=
                                                int.parse(
                                                    tutorDataMap['age']) ||
                                            country.text !=
                                                tutorDataMap['country'] ||
                                            city.text != tutorDataMap['city'] ||
                                            birthcountry.text !=
                                                tutorDataMap['birthPlace'] ||
                                            birthcity.text !=
                                                tutorDataMap['birthCity'] ||
                                            timezone.text !=
                                                tutorDataMap['timezone'] ||
                                            contactnumber.text !=
                                                tutorDataMap['contact'] ||
                                            selectedDate !=
                                                DateTime.parse(tutorDataMap[
                                                    'birthdate']) ||
                                            areListsEqual == false) {
                                          CoolAlert.show(
                                            context: context,
                                            barrierDismissible: false,
                                            width: 200,
                                            type: CoolAlertType.confirm,
                                            text: 'You want to cancel update?',
                                            confirmBtnText: 'Proceed',
                                            confirmBtnColor: Colors.greenAccent,
                                            cancelBtnText: 'Go back',
                                            showCancelBtn: true,
                                            cancelBtnTextStyle: const TextStyle(
                                                color: Colors.red),
                                            onCancelBtnTap: () {
                                              Navigator.of(context).pop;
                                            },
                                            onConfirmBtnTap: () {
                                              filename = '';
                                              initializeWidget();
                                              final provider =
                                                  context.read<MyModel>();
                                              provider.updateBoolValue(false);
                                            },
                                          );
                                        } else {
                                          filename = '';
                                          initializeWidget();
                                          final provider =
                                              context.read<MyModel>();
                                          provider.updateBoolValue(false);
                                        }
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: kColorPrimary),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    : viewinfo(widget.tutordata)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget viewinfo(TutorInformation data) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      width: size.width - 320,
      padding: const EdgeInsets.only(left: 250, right: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text:
                      '${data.firstName}${data.middleName == '' ? ' ${data.lastname}' : ' ${data.middleName} ${data.lastname}'}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Birthdate:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: DateFormat("MMMM dd, yyyy")
                      .format(DateTime.parse(data.birthdate)),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const TextSpan(text: '     '),
                const TextSpan(
                  text: 'Age:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.age,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Country of Residence:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: '${data.city}, ${data.country}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Country of Birth:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: '${data.birthCity}, ${data.birthPlace}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Timezone:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.timezone,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Contact:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.contact,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Languages:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.language.join(','),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
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
