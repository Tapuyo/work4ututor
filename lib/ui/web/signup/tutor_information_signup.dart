// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print, unused_local_variable, unused_field, prefer_final_fields, unused_element, use_build_context_synchronously

import 'dart:math';

import 'package:country_pickers/country.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'dart:js' as js;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:quickalert/quickalert.dart';
import 'package:timezone/browser.dart' as tz;
import 'package:timezone/timezone.dart';
import '../../../components/nav_bar.dart';
import '../../../data_class/subject_teach_pricing.dart';
import '../../../services/getstudentinfo.dart';
import '../../../shared_components/alphacode3.dart';
import '../../auth/auth.dart';
import '../login/login.dart';
import '../terms/termpage.dart';
import '../tutor/tutor_dashboard/tutor_dashboard.dart';

class TutorInfo extends StatefulWidget {
  final String uid;
  final String email;
  const TutorInfo({Key? key, required this.uid, required this.email})
      : super(key: key);

  @override
  State<TutorInfo> createState() => _TutorInfoState();
}

class _TutorInfoState extends State<TutorInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
            child: InputInfo(
          uid: widget.uid,
          email: widget.email,
        )));
  }
}

class InputInfo extends StatefulWidget {
  final String uid;
  final String email;
  const InputInfo({super.key, required this.uid, required this.email});

  @override
  State<InputInfo> createState() => _InputInfoState();
}

class _InputInfoState extends State<InputInfo> {
  void main() {
    super.initState();
    _initData();
  }

// timezone
  var dtf = js.context['Intl'].callMethod('DateTimeFormat');
  var ops = js.context['Intl']
      .callMethod('DateTimeFormat')
      .callMethod('resolvedOptions');
  String? dropdownvalue;
  String? dropdownvaluesubject;
  bool select = false;

//tutor information
  Map<String, Location> _timeZones = {};
  String _selectedTimeZone = 'UTC';
  TextEditingController firstname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController price2 = TextEditingController();
  TextEditingController price3 = TextEditingController();
  TextEditingController preice5 = TextEditingController();
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'PH');
  TextEditingController phoneNumberController = TextEditingController();

  String selectedCountry = "";
  String tcontactNumber = "";
  String tCountry = "";
  TextEditingController tCity = TextEditingController();
  List<String> tTimezone = [];
  int age = 0;
  String contactNumber = "";
  var ulanguages = [
    'Filipino',
    'English',
    'Russian',
    'Chinese',
    'Japanese',
  ];
  var uSubjects = [
    'Others',
    'Math',
    'English',
    'Geometry',
    'Music',
    'Language',
  ];
  var tServices = [
    'Others',
  ];
  var tClasses = [
    'Others',
  ];
  String uID = "Upload your ID";
  String uPicture = "";
  List<String> uCertificates = [];
  List<String> tlanguages = [];
  List<SubjectTeach> tSubjects = [];
  String uCV = "";
  String uVideo = "";
  String tAbout = "";
  bool shareInfo = false;
  bool selection1 = false;
  bool selection2 = false;
  bool selection3 = false;
  bool selection4 = false;
  bool selection5 = false;
  bool onlineclas = false;
  bool inperson = false;
  int languageCount = 1;
  int subjectcount = 1;
  double subjecthieght = 250;
  double thieght = 45;

  //term
  bool termStatus = false;
  bool showme = false;
  bool showmecustom = false;

  DateTime selectedDate = DateTime.now();
  String bdate = "Date of Birth";
  String myage = "Age";
  String guardianbdate = "Date of Birth";
  String guardianage = "Age";

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(5000));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        bdate = DateFormat("MMMM dd, yyyy").format(selectedDate);
        calculateAge(picked);
      });
    }
  }

  void calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int currentage = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (currentage < 0) {
      print("Add notification here not valid date selection");
    } else {
      if (month2 > month1) {
        currentage--;
        setState(() {
          age = currentage;
          myage = age.toString();
        });
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          currentage--;
          setState(() {
            age = currentage;
            myage = age.toString();
          });
        } else if (day2 <= day1) {
          setState(() {
            age = currentage;
            myage = age.toString();
          });
        }
      } else if (month1 > month2) {
        setState(() {
          age = currentage;
          myage = age.toString();
        });
      }
    }
  }

  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];

  // Future<void> _initData() async {
  //   try {
  //     _availableTimezones = await FlutterNativeTimezone.getAvailableTimezones();
  //     _availableTimezones.sort();
  //     tTimezone = _availableTimezones;
  //     print(tTimezone.toString());
  //   } catch (e) {
  //     print('Could not get available timezones');
  //   }
  // }

  String tutorIDNumber = 'TTR*********';
  String applicantsID = '';
  final tutorformKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // Get a list of all time zones.
    _initData();
    _timeZones = tz.timeZoneDatabase.locations;
  }

  Future<void> _initData() async {
    try {
      _selectedTimeZone = await FlutterNativeTimezone
          .getLocalTimezone(); // Set local timezone here
    } catch (e) {
      print('Could not get the local timezone');
    }
    // try {
    //   _timezone = await FlutterNativeTimezone.getLocalTimezone();
    // } catch (e) {
    //   print('Could not get the local timezone');
    // }
    // try {
    //   _availableTimezones = await FlutterNativeTimezone.get();
    //   _availableTimezones.sort();
    // } catch (e) {
    //   print('Could not get available timezones');
    // }
    // if (mounted) {
    //   setState(() {});
    // }
  }

  final TextEditingController price2Controller = TextEditingController();
  final TextEditingController price3Controller = TextEditingController();
  final TextEditingController price5Controller = TextEditingController();
  final TextEditingController aboutme = TextEditingController();
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarLog(),
          Form(
            key: tutorformKey,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 130,
                      child: const Text(
                        "Subscribe with your information",
                        style: TextStyle(
                          // textStyle: Theme.of(context).textTheme.headlineMedium,
                          color: Color.fromRGBO(1, 118, 132, 1),
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                      alignment: Alignment.centerLeft,
                      width: 600,
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Container(
                                width: 350,
                                height: 350,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FadeInImage(
                                    fadeInDuration:
                                        const Duration(milliseconds: 500),
                                    placeholder: const AssetImage(
                                        "assets/images/login.png"), // Use AssetImage here
                                    image: NetworkImage(profileurl),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          "assets/images/login.png");
                                    },
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        String? downloadURL =
                                            await uploadTutorProfile(
                                                widget.uid);

                                        if (downloadURL != null) {
                                          // The upload was successful, and downloadURL contains the URL.
                                          print(
                                              "File uploaded successfully. URL: $downloadURL");
                                          setState(() {
                                            profileurl = downloadURL;
                                            updateTutorProfile(
                                                widget.uid, profileurl);
                                          });
                                        } else {
                                          // There was an error during file selection or upload.
                                          print("Error uploading file.");
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                        size: 25.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          Column(
                            children: [Container()],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                      alignment: Alignment.centerLeft,
                      width: 600,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Tutor Identification Number",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "(Auto Generated once Country is selected!)*",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 300,
                                height: 45,
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1)),
                                child: Row(
                                  children: [
                                    Text(
                                      tutorIDNumber.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Personal Information.",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Required*",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 190,
                                height: 45,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1)),
                                child: TextFormField(
                                  controller: firstname,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.grey,
                                    hintText: 'Firstname',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  validator: (val) => val!.isEmpty
                                      ? 'Enter an firstname'
                                      : null,
                                  // onChanged: (val) {
                                  //   setState(() {
                                  //     firstname.text = val;
                                  //   });
                                  // },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 190,
                                height: 45,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1)),
                                child: TextFormField(
                                  controller: middlename,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.grey,
                                    hintText: 'Middlename',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  validator: (val) => val!.isEmpty
                                      ? 'Enter an middlename'
                                      : null,
                                  // onChanged: (val) {
                                  //   setState(() {
                                  //     middlename.text = val;
                                  //   });
                                  // },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 190,
                                height: 45,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1)),
                                child: TextFormField(
                                  controller: lastname,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.grey,
                                    hintText: 'Lastname',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter an lastname' : null,
                                  // onChanged: (val) {
                                  //   setState(() {
                                  //     lastname.text = val;
                                  //   });
                                  // },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 400,
                                height: 45,
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1)),
                                child: Row(
                                  children: [
                                    Text(
                                      bdate.toString(),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      tooltip: "Date of Birth",
                                      hoverColor: Colors.transparent,
                                      icon: const Icon(
                                        EvaIcons.calendarOutline,
                                        color: Colors.blue,
                                        size: 25,
                                      ),
                                      onPressed: () {
                                        _selectDate();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 150,
                                height: 45,
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1)),
                                child: Row(
                                  children: [
                                    Text(
                                      myage.toString(),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
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
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  child: CountryPickerDropdown(
                                    initialValue: 'PH',
                                    itemBuilder: _buildDropdownItem,
                                    sortComparator: (Country a, Country b) =>
                                        a.isoCode.compareTo(b.isoCode),
                                    onValuePicked: (Country country) {
                                      final alpha3Code =
                                          getAlpha3Code(country.name);
                                      Random random = Random();

                                      DateTime datenow = DateTime.now();
                                      String currenttime =
                                          DateFormat('HHmmss').format(datenow);
                                      String randomNumber =
                                          random.nextInt(1000000).toString() +
                                              currenttime.toString();
                                      String currentyear =
                                          DateFormat('yyyyMMdd')
                                              .format(datenow);
                                      //todo please replace the random number with legnth of students enrolled
                                      setState(() {
                                        selectedCountry = country.name;
                                        tutorIDNumber =
                                            'TTR$alpha3Code$currentyear$currenttime';
                                        applicantsID =
                                            'Work$currentyear$currenttime';
                                      });
                                    },
                                    isExpanded: true,
                                  )
                                  // country.name
                                  ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 266,
                                height: 45,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1)),
                                child: TextFormField(
                                  controller: tCity,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.grey,
                                    hintText: 'City',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter your City' : null,
                                  // onChanged: (val) {
                                  //   tCity = val;
                                  // },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            Container(
                                width: 250,
                                height: 45,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1)),
                                child: DropdownButton<String>(
                                  value: _selectedTimeZone,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedTimeZone = newValue!;
                                    });
                                  },
                                  items: _timeZones.keys
                                      .map((String timeZoneName) {
                                    return DropdownMenuItem<String>(
                                      value: timeZoneName,
                                      child: Text(timeZoneName),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  underline: Container(),
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 280,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 159, 159,
                                      159), // Set your desired border color here
                                  width: .5, // Set the border width
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  setState(() {
                                    phoneNumber = number;
                                  });
                                },
                                selectorConfig: const SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                ignoreBlank: false,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputDecoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                initialValue: phoneNumber,
                                textFieldController: phoneNumberController,
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: tlanguages.isNotEmpty ? true : false,
                            child: Container(
                              width: 600,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tlanguages.length,
                                  itemBuilder: (context, index) {
                                    String language = tlanguages[index];
                                    return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(language),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () {
                                              setState(() {
                                                tlanguages.removeAt(index);
                                              });
                                            },
                                          ),
                                        ]);
                                  }),
                            ),
                          ),
                          Visibility(
                            visible: tlanguages.isNotEmpty ? true : false,
                            child: const SizedBox(
                              height: 5,
                            ),
                          ),
                          Container(
                              width: 600,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              child: LanguagePickerDropdown(
                                  itemBuilder: languageBuilder,
                                  onValuePicked: (Language language) {
                                    setState(() {
                                      tlanguages.add(language.name);
                                    });
                                  })),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: const [
                              Text(
                                "(You can select more than one language.)",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Subjects you teach and pricing.",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Required*",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: tSubjects.isNotEmpty,
                            child: SizedBox(
                              width: 600,
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: tSubjects.length,
                                itemBuilder: (context, index) {
                                  SubjectTeach subjectdata = tSubjects[index];
                                  // Set the initial values for the controllers
                                  // price2Controller.text = subjectdata.price2;
                                  // price3Controller.text = subjectdata.price3;
                                  // price5Controller.text = subjectdata.price5;

                                  // // Create TextEditingController instances for each TextFormField
                                  // TextEditingController price2Controller =
                                  //     TextEditingController(
                                  //         text: subjectdata.price2);
                                  // TextEditingController price3Controller =
                                  //     TextEditingController(
                                  //         text: subjectdata.price3);
                                  // TextEditingController price5Controller =
                                  //     TextEditingController(
                                  //         text: subjectdata.price5);

                                  return Column(
                                    children: [
                                      Container(
                                        width: 600,
                                        height: 45,
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(subjectdata.subjectname),
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              color: Colors.red,
                                              onPressed: () {
                                                setState(() {
                                                  tSubjects.removeAt(index);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 350,
                                                height: 45,
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 1)),
                                                child: const Text(
                                                    "Price for 2 classes"),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 45,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      242, 242, 242, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: TextFormField(
                                                  controller:
                                                      price2Controller, // Use the controller
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    fillColor: Colors.grey,
                                                    hintText: '',
                                                    hintStyle: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  validator: (val) {
                                                    if (val!.isEmpty) {
                                                      return 'Input price';
                                                    }
                                                    try {
                                                      double.parse(val);
                                                      return null; // Parsing succeeded, val is a valid double
                                                    } catch (e) {
                                                      return 'Invalid input, please enter a valid number';
                                                    }
                                                  },
                                                  onChanged: (val) {
                                                    // Update the subjectdata when the value changes
                                                    subjectdata.price2 = val;
                                                    print(tSubjects[index]
                                                        .price2);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 350,
                                                height: 45,
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 1)),
                                                child: const Text(
                                                    "Price for 3 classes"),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 45,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      242, 242, 242, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: TextFormField(
                                                  controller:
                                                      price3Controller, // Use the controller
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    fillColor: Colors.grey,
                                                    hintText: '',
                                                    hintStyle: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  validator: (val) {
                                                    if (val!.isEmpty) {
                                                      return 'Input price';
                                                    }
                                                    try {
                                                      double.parse(val);
                                                      return null; // Parsing succeeded, val is a valid double
                                                    } catch (e) {
                                                      return 'Invalid input, please enter a valid number';
                                                    }
                                                  },
                                                  onChanged: (val) {
                                                    // Update the subjectdata when the value changes
                                                    subjectdata.price3 = val;
                                                    print(tSubjects[index]
                                                        .price3);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 350,
                                                height: 45,
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 1)),
                                                child: const Text(
                                                    "Price for 5 classes"),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 45,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      242, 242, 242, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: TextFormField(
                                                  controller:
                                                      price5Controller, // Use the controller
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    fillColor: Colors.grey,
                                                    hintText: '',
                                                    hintStyle: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  validator: (val) {
                                                    if (val!.isEmpty) {
                                                      return 'Input price';
                                                    }
                                                    try {
                                                      double.parse(val);
                                                      return null; // Parsing succeeded, val is a valid double
                                                    } catch (e) {
                                                      return 'Invalid input, please enter a valid number';
                                                    }
                                                  },
                                                  onChanged: (val) {
                                                    // Update the subjectdata when the value changes
                                                    subjectdata.price5 = val;
                                                    print(tSubjects[index]
                                                        .price5);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 600,
                            height: 45,
                            child: Container(
                              width: 600,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                ),
                                value: dropdownvaluesubject,
                                hint: const Text("Select your subject"),
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                items: uSubjects.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    SubjectTeach data = SubjectTeach(
                                        subjectname: newValue!,
                                        price2: '',
                                        price3: '',
                                        price5: '');
                                    tSubjects.add(data);
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: const [
                              Text(
                                "(You can select more than one subject you teach.)",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: const [
                              Text(
                                "What services are you able to provide?",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Required, you can select morethan one.*",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text('Recovery Lessons'),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: selection1,
                                          value: selection1,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              selection1 = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 320,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text(
                                              'Kids with Learning Difficulties'),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: selection2,
                                          value: selection2,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              selection2 = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text('Pre Exam Classes'),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: selection3,
                                          value: selection3,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              selection3 = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text('Deaf Language'),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: selection4,
                                          value: selection4,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              selection4 = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text('Own Program'),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Type of classes you can offer.",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Required, you can select morethan one.*",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 250,
                                height: 45,
                                alignment: Alignment.centerLeft,
                                child: Theme(
                                  data: ThemeData(
                                    checkboxTheme: CheckboxThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: ListTileTheme(
                                    child: CheckboxListTile(
                                      title: const Text('Online Classes'),
                                      // subtitle: const Text(
                                      //     'A computer science portal for geeks.'),
                                      // secondary: const Icon(Icons.code),
                                      autofocus: false,
                                      activeColor: Colors.green,
                                      checkColor: Colors.white,
                                      selected: onlineclas,
                                      value: onlineclas,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (value) {
                                        setState(() {
                                          onlineclas = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 320,
                                height: 45,
                                alignment: Alignment.centerLeft,
                                child: Theme(
                                  data: ThemeData(
                                    checkboxTheme: CheckboxThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: ListTileTheme(
                                    child: CheckboxListTile(
                                      title: const Text('In Person Classes'),
                                      // subtitle: const Text(
                                      //     'A computer science portal for geeks.'),
                                      // secondary: const Icon(Icons.code),
                                      autofocus: false,
                                      activeColor: Colors.green,
                                      checkColor: Colors.white,
                                      selected: inperson,
                                      value: inperson,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (value) {
                                        setState(() {
                                          inperson = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Upload your documents.",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "ID and Picture required, CV, certification\nand presentation recommended*",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 400,
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  child: Text(uID)),
                              const Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                width: 150,
                                height: 55,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        const TextStyle(color: Colors.black),
                                    backgroundColor:
                                        const Color.fromRGBO(103, 195, 208, 1),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Color.fromRGBO(
                                            1, 118, 132, 1), // your color here
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    String? fileName =
                                        await uploadData(widget.uid);
                                    setState(() {
                                      uID = fileName!;
                                      print(fileName);
                                    });
                                  },
                                  child: const Text(
                                    'Upload File',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 400,
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  child: const Text("Upload your CV")),
                              const Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                width: 150,
                                height: 55,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        const TextStyle(color: Colors.black),
                                    backgroundColor:
                                        const Color.fromRGBO(103, 195, 208, 1),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Color.fromRGBO(
                                            1, 118, 132, 1), // your color here
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Upload File',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 400,
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  child:
                                      const Text("Upload your Certificates")),
                              const Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                width: 150,
                                height: 55,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        const TextStyle(color: Colors.black),
                                    backgroundColor:
                                        const Color.fromRGBO(103, 195, 208, 1),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Color.fromRGBO(
                                            1, 118, 132, 1), // your color here
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Upload File',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 400,
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  child: const Text(
                                      "Upload a video presentation")),
                              const Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                width: 150,
                                height: 55,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        const TextStyle(color: Colors.black),
                                    backgroundColor:
                                        const Color.fromRGBO(103, 195, 208, 1),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Color.fromRGBO(
                                            1, 118, 132, 1), // your color here
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Upload File',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Describe your skills, your approach, your teaching method, and tell',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'us why a student should choose you! (max 5000 characters)',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Required.*",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Container(
                            width: 600,
                            height: 350,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: TextFormField(
                              controller: aboutme,
                              textAlignVertical: TextAlignVertical.top,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText:
                                    'Describe your skills, your approach, your teaching method, and tell us why a student should you! (max 5000 characters)',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: CheckboxListTile(
                              title: const Text(
                                'Agree to Work4uTutor Terms & Condition and Privacy Policy.',
                                style: TextStyle(fontSize: 15),
                              ),
                              // subtitle: const Text(
                              //     'A computer science portal for geeks.'),
                              // secondary: const Icon(Icons.code),
                              autofocus: false,
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                              selected: termStatus,
                              value: termStatus,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  termStatus = value!;
                                });
                                setState(() {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (_) => const TermPage());
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            width: 380,
                            height: 75,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(color: Colors.black),
                                backgroundColor:
                                    const Color.fromRGBO(103, 195, 208, 1),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color.fromRGBO(
                                        1, 118, 132, 1), // your color here
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ),
                              onPressed: () => {
                                if (tutorformKey.currentState!.validate())
                                  {
                                    updateTutorInformation(
                                            widget.uid,
                                            tCity.text,
                                            selectedCountry,
                                            firstname.text,
                                            middlename.text,
                                            lastname.text,
                                            tlanguages,
                                            tutorIDNumber,
                                            widget.uid,
                                            phoneNumber.phoneNumber.toString(),
                                            DateTime.now(),
                                            age.toString(),
                                            selectedDate.toString(),
                                            _selectedTimeZone,
                                            applicantsID,
                                            tSubjects,
                                            'completed',
                                            aboutme.text)
                                        .then(
                                      (value) async {
                                        dynamic result =
                                            await _auth.signOutAnon();
                                        deleteAllData();
                                        setState(() {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.success,
                                            text: 'Sign up succesfully!',
                                            autoCloseDuration:
                                                const Duration(seconds: 3),
                                            showConfirmBtn: false,
                                          ).then((value) =>
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()),
                                              ));
                                        });
                                      },
                                    )
                                  }
                              },
                              child: const Text(
                                'Proceed Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Display all the Countries
  _buildCountryPickerDropdownSoloExpanded() {
    String valueme = "Select your Country";
    return CountryPickerDropdown(
      hint: const Text("Select your Country"),
      // initialValue: valueme,
      onValuePicked: (Country country) {
        valueme = country.toString();
        setState(() {
          _initData();
        });
      },
      itemBuilder: (Country country) {
        return Row(
          children: <Widget>[
            Expanded(child: Text(country.name)),
          ],
        );
      },
      itemHeight: 50,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }

  void deleteAllData() async {
    final box = await Hive.openBox('userID');
    await box.clear();
  }

  // ignore: prefer_function_declarations_over_variables
  final languageBuilder = (language) => Text(language.name);

  Widget _buildDropdownItem(Country country) => Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              const SizedBox(
                width: 8.0,
              ),
              Text(country.name),
            ],
          ),
        ],
      );
}
//Identifies the device timezone and datetime
// Future<void> setup() async {
//   // var dtf = js.context['Intl'].callMethod('DateTimeFormat');
//   // var ops = dtf.callMethod('resolvedOptions');
//   // print(ops['timeZone']);
//   tz.initializeTimeZone();
//   var response = tz.timeZoneDatabase;
//   Map data = jsonDecode(response as String);
//   // var istanbulTimeZone = tz.getLocation(ops['timeZone']);
//   // var now = tz.TZDateTime.now(istanbulTimeZone);
//   print(data);
// }
