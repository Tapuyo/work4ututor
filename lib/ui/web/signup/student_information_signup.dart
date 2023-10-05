// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_pickers/country.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart';
import 'dart:js' as js;

import '../../../components/nav_bar.dart';
import '../../../data_class/studentinfoclass.dart';
import '../../../services/getstudentinfo.dart';
import '../../../shared_components/alphacode3.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import '../../auth/auth.dart';
import '../login/login.dart';

class StudentInfo extends StatefulWidget {
  final String uid;
  final String email;
  const StudentInfo({Key? key, required this.uid, required this.email})
      : super(key: key);

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<StudentInfoClass>>.value(
          value: StudentInfoData(uid: widget.uid).getstudentinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
      ],
      child: StudentInfoBody(
        uid: widget.uid,
        email: widget.email,
      ),
    );
  }
}

class StudentInfoBody extends StatefulWidget {
  final String uid;
  final String email;
  const StudentInfoBody({Key? key, required this.uid, required this.email})
      : super(key: key);

  @override
  State<StudentInfoBody> createState() => _StudentInfoBodyState();
}

class _StudentInfoBodyState extends State<StudentInfoBody> {
  // void main() {
  //   super.initState();
  //   _initData();
  //   tz.initializeTimeZone();
  // }

  Map<String, Location> _timeZones = {};
  String _selectedTimeZone = 'UTC';
  var dtf = js.context['Intl'].callMethod('DateTimeFormat');
  var ops = js.context['Intl']
      .callMethod('DateTimeFormat')
      .callMethod('resolvedOptions');
  String? dropdownvalue;
  String? dropdownvaluesubject;
  bool select = false;

//student information
  TextEditingController firstname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController lastname = TextEditingController();
  String tcontactNumber = "";
  String selectedCountry = "";
  String tCity = "";
  String tTimezone = "";
  String contactNumber = "";
  String uID = "Upload your ID";
  String uPicture = "";
  List<String> uCertificates = [];
  List<String> tlanguages = [];
  String uCV = "";
  String uVideo = "";
  String tAbout = "";
  bool shareInfo = false;
  int age = 0;
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

  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'PH');
  TextEditingController phoneNumberController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateguardian = DateTime.now();
  String studentIDNumber = 'STU*********';
  String bdate = "Date of Birth";
  String myage = "Age";
  TextEditingController guardianfullname = TextEditingController();
  String guardianbdate = "Date of Birth";
  String guardianage = "Age";
  String guardianID = "";
  String guardianpPicture = "";
  TextEditingController guardiancontactnumber = TextEditingController();
  TextEditingController guardiansemail = TextEditingController();

  void _selectDate(String infodata) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(5000));
    if (picked != null && picked != selectedDate) {
      setState(() {
        if (infodata == 'student') {
          selectedDate = picked;
          bdate = selectedDate.toString();
        } else if (infodata == 'guardian') {
          selectedDateguardian = picked;
          guardianbdate = selectedDateguardian.toString();
        }
        bdate = DateFormat("MMMM dd, yyyy").format(selectedDate);
        calculateAge(picked, infodata);
      });
    }
  }

  void calculateAge(DateTime birthDate, String info) {
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
          if (info == 'student') {
            setState(() {
              age = currentage;
              myage = age.toString();
            });
          } else if (info == 'guardian') {
            guardianage = currentage.toString();
          }
        });
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          currentage--;
          setState(() {
            if (info == 'student') {
              setState(() {
                age = currentage;
                myage = age.toString();
              });
            } else if (info == 'guardian') {
              guardianage = currentage.toString();
            }
          });
        } else if (day2 <= day1) {
          setState(() {
            if (info == 'student') {
              setState(() {
                age = currentage;
                myage = age.toString();
              });
            } else if (info == 'guardian') {
              guardianage = currentage.toString();
            }
          });
        }
      } else if (month1 > month2) {
        setState(() {
          if (info == 'student') {
            setState(() {
              age = currentage;
              myage = age.toString();
            });
          } else if (info == 'guardian') {
            guardianage = currentage.toString();
          }
        });
      }
    }
  }

  //term
  bool termStatus = false;
  String profileurl = '';

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  List<String> timezonesList = [];
  @override
  void initState() {
    super.initState();
    _initData();
    getTimezones();
    // _timeZones = tz.timeZoneDatabase.locations;
  }

  Future<void> _initData() async {
    try {
      _selectedTimeZone = await FlutterNativeTimezone
          .getLocalTimezone(); // Set local timezone here
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getTimezones() async {
    final response =
        await http.get(Uri.parse('http://worldtimeapi.org/api/timezone'));

    if (response.statusCode == 200) {
      final List<dynamic> timezones = json.decode(response.body);
      if (timezones.isNotEmpty) {
        // Initialize Firestore
        final firestore = FirebaseFirestore.instance;

        // Add the timezonesList to the "timezones" collection
        // await firestore.collection('timezones').doc('timezone_document').set({
        //   'timezonesList': timezones,
        // });
        setState(() {
          timezonesList = List<String>.from(timezones);
        });
      } else {
        //to do
        // final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
        throw Exception('No timezones found');
      }
    } else {
      throw Exception('Failed to load timezones: ${response.statusCode}');
    }
  }

  String getLocalTimeZone() {
    final dateTime = DateTime.now();
    final timeZoneOffset = dateTime.timeZoneOffset;
    final hours = timeZoneOffset.inHours.abs();
    final minutes = timeZoneOffset.inMinutes.abs() % 60;
    final sign = timeZoneOffset.isNegative ? '-' : '+';

    final timeZoneName =
        html.window.navigator.language; // Get the local time zone name

    return '$timeZoneName (GMT$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')})';
  }

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
    // if (studentinfodata.isNotEmpty) {
    //   final studentdata = studentinfodata.first;
    //     firstname.text = studentdata.studentFirstname;
    //     middlename.text = studentdata.studentMiddlename;
    //     lastname.text = studentdata.studentLastname;
    //     studentIDNumber = studentdata.studentID == ''
    //         ? studentIDNumber
    //         : studentdata.studentID;
    //     profileurl = studentdata.profilelink;
    //     selectedDate = studentdata.dateofbirth == ''
    //         ? DateTime.now()
    //         : DateTime.parse(studentdata.dateofbirth);
    //     age = studentdata.age == '' ? 0 : int.parse(studentdata.age);
    //     selectedCountry = studentdata.country;
    //     tCity = studentdata.address;
    //     _selectedTimeZone =
    //         studentdata.timezone == '' ? 'UTC' : studentdata.timezone;
    //     tlanguages = studentdata.languages;
    // }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarLog(),
          Expanded(
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
                                  image: profileurl.isEmpty
                                      ? const NetworkImage(
                                          "https://img.icons8.com/fluency/48/null/no-image.png")
                                      : NetworkImage(profileurl),
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
                                          await uploadData(widget.uid);

                                      if (downloadURL != null) {
                                        // The upload was successful, and downloadURL contains the URL.
                                        print(
                                            "File uploaded successfully. URL: $downloadURL");
                                        setState(() {
                                          profileurl = downloadURL;
                                          updateProfile(widget.uid, profileurl);
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
                        Row(
                          children: const [
                            Text(
                              "Student Identification Number",
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
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
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
                                    studentIDNumber.toString(),
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
                              "Student Information.",
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
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter an firstname' : null,
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter an middlename' : null,
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                          height: 14,
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
                                      _selectDate('student');
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
                                        color: Colors.grey.shade300, width: 1)),
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
                                        DateFormat('yyyyMMdd').format(datenow);
                                    //todo please replace the random number with legnth of students enrolled
                                    setState(() {
                                      selectedCountry = country.name;
                                      studentIDNumber =
                                          'STU$alpha3Code$currentyear$currenttime';
                                    });
                                  },
                                  isExpanded: true,
                                )
                                // country.name
                                ),
                            const SizedBox(
                              width: 14,
                            ),
                            Container(
                              width: 266,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.grey,
                                  hintText: 'City',
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter your City' : null,
                                onChanged: (val) {
                                  tCity = val;
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
                                  items: timezonesList.map((timezone) {
                                    return DropdownMenuItem<String>(
                                      value: timezone,
                                      child: Text(timezone),
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
                                // autoValidateMode: AutovalidateMode.onUserInteraction,
                                inputDecoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                initialValue: phoneNumber,
                                textFieldController: phoneNumberController,
                              ),
                            ),
                          ],
                        ),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
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
                        Visibility(
                          visible: age < 18 && age > 0 ? true : false,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Guardians Information.",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Required.*",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 600,
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
                                  controller: guardianfullname,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.grey,
                                    hintText: 'Fullname',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter an Fullname' : null,
                                  // onChanged: (val) {
                                  //   guardianfullname = val;
                                  // },
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Row(
                                children: [
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
                                            color: Colors.grey.shade300,
                                            width: 1)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _selectDate('guardian');
                                          },
                                          child: Text(
                                            guardianbdate.toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
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
                                            _selectDate('guardian');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 150,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1)),
                                    child: Row(
                                      children: [
                                        Text(
                                          guardianage.toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ],
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
                                    width: 250,
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
                                    child: TextFormField(
                                      controller: guardiancontactnumber,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'Contact',
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter your Contact'
                                          : null,
                                      // onChanged: (val) {
                                      //   guardiancontactnumber = val;
                                      // },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 280,
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
                                    child: TextFormField(
                                      controller: guardiansemail,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'Email',
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter your email'
                                          : null,
                                      // onChanged: (val) {
                                      //   guardiansemail = val;
                                      // },
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
                                    "Upload Guardian documents.",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    width: 150,
                                    height: 55,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: const TextStyle(
                                            color: Colors.black),
                                        backgroundColor: const Color.fromRGBO(
                                            103, 195, 208, 1),
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: Color.fromRGBO(1, 118, 132,
                                                1), // your color here
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        String? fileName =
                                            await uploadData(widget.uid);
                                        setState(() {
                                          guardianID = fileName!;
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
                                      child: const Text(
                                          "Upload Guardian Picture")),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    width: 150,
                                    height: 55,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: const TextStyle(
                                            color: Colors.black),
                                        backgroundColor: const Color.fromRGBO(
                                            103, 195, 208, 1),
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: Color.fromRGBO(1, 118, 132,
                                                1), // your color here
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        String? fileName =
                                            await uploadData(widget.uid);
                                        setState(() {
                                          guardianpPicture = fileName!;
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: CheckboxListTile(
                            title: const Text(
                              'Agree to Work4uTutor Terms & Condition and Privacy Policy.',
                              style: TextStyle(fontSize: 12),
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
                              onPressed: () async {
                                print(
                                    '$studentIDNumber/$firstname/$middlename$lastname/$age/$selectedCountry/$tCity/$_selectedTimeZone$tlanguages');
                                if (age >= 18) {
                                  if (studentIDNumber.isNotEmpty &&
                                      studentIDNumber != 'STU*********' &&
                                      firstname.text.isNotEmpty &&
                                      middlename.text.isNotEmpty &&
                                      lastname.text.isNotEmpty &&
                                      age != 0 &&
                                      selectedCountry.isNotEmpty &&
                                      tCity.isNotEmpty &&
                                      _selectedTimeZone.isNotEmpty &&
                                      tlanguages.isNotEmpty) {
                                    updateStudentInfo(
                                            widget.uid,
                                            tCity,
                                            selectedCountry,
                                            firstname.text,
                                            middlename.text,
                                            lastname.text,
                                            tlanguages,
                                            studentIDNumber,
                                            widget.uid,
                                            phoneNumber.phoneNumber.toString(),
                                            profileurl,
                                            DateTime.now(),
                                            age.toString(),
                                            selectedDate.toString(),
                                            _selectedTimeZone,
                                            'completed')
                                        .then(
                                      (value) async {
                                        dynamic result =
                                            await _auth.signOutAnon();
                                        deleteAllData();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()),
                                        );
                                      },
                                    );
                                  } else {
                                    updateStudentInfo(
                                            widget.uid,
                                            tCity,
                                            selectedCountry,
                                            firstname.text,
                                            middlename.text,
                                            lastname.text,
                                            tlanguages,
                                            studentIDNumber,
                                            widget.uid,
                                            phoneNumber.phoneNumber.toString(),
                                            profileurl,
                                            DateTime.now(),
                                            age.toString(),
                                            selectedDate.toString(),
                                            _selectedTimeZone,
                                            'unfinished')
                                        .then(
                                      (value) async {
                                        dynamic result =
                                            await _auth.signOutAnon();
                                        deleteAllData();
                                        setState(() {
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: 'Sign up succesfully!',
                                            autoCloseDuration:
                                                const Duration(seconds: 1),
                                          ).then((value) =>
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()),
                                              ));
                                        });
                                      },
                                    );
                                  }
                                } else if (age < 18 && age != 0) {
                                  if (studentIDNumber.isNotEmpty &&
                                      studentIDNumber != 'STU*********' &&
                                      firstname.text.isNotEmpty &&
                                      middlename.text.isNotEmpty &&
                                      lastname.text.isNotEmpty &&
                                      age != 0 &&
                                      selectedCountry.isNotEmpty &&
                                      tCity.isNotEmpty &&
                                      _selectedTimeZone.isNotEmpty &&
                                      tlanguages.isNotEmpty &&
                                      guardianfullname.text.isNotEmpty &&
                                      // ignore: unrelated_type_equality_checks
                                      guardianage != 0 &&
                                      guardiancontactnumber.text.isNotEmpty &&
                                      guardianID.isNotEmpty &&
                                      guardianpPicture.isNotEmpty) {
                                    updateStudentInfowGuardian(
                                            widget.uid,
                                            tCity,
                                            selectedCountry,
                                            firstname.text,
                                            middlename.text,
                                            lastname.text,
                                            tlanguages,
                                            studentIDNumber,
                                            widget.uid,
                                            phoneNumber.phoneNumber.toString(),
                                            profileurl,
                                            DateTime.now(),
                                            age.toString(),
                                            selectedDate.toString(),
                                            _selectedTimeZone,
                                            guardianfullname.text,
                                            guardiancontactnumber.text,
                                            guardiansemail.text,
                                            guardianbdate,
                                            guardianage,
                                            'completed')
                                        .then(
                                      (value) async {
                                        dynamic result =
                                            await _auth.signOutAnon();
                                        deleteAllData();
                                        setState(() {
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: 'Sign up succesfully!',
                                            autoCloseDuration:
                                                const Duration(seconds: 1),
                                          ).then((value) =>
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()),
                                              ));
                                        });
                                      },
                                    );
                                  } else {
                                    updateStudentInfowGuardian(
                                            widget.uid,
                                            tCity,
                                            selectedCountry,
                                            firstname.text,
                                            middlename.text,
                                            lastname.text,
                                            tlanguages,
                                            studentIDNumber,
                                            widget.uid,
                                            phoneNumber.phoneNumber.toString(),
                                            profileurl,
                                            DateTime.now(),
                                            age.toString(),
                                            selectedDate.toString(),
                                            _selectedTimeZone,
                                            guardianfullname.text,
                                            guardiancontactnumber.text,
                                            guardiansemail.text,
                                            guardianbdate,
                                            guardianage,
                                            'unfinished')
                                        .then(
                                      (value) async {
                                        dynamic result =
                                            await _auth.signOutAnon();
                                        deleteAllData();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()),
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              child: Text(
                                age >= 18 &&
                                        studentIDNumber.isNotEmpty &&
                                        studentIDNumber != 'STU*********' &&
                                        firstname.text.isNotEmpty &&
                                        middlename.text.isNotEmpty &&
                                        lastname.text.isNotEmpty &&
                                        age != 0 &&
                                        selectedCountry.isNotEmpty &&
                                        tCity.isNotEmpty &&
                                        _selectedTimeZone.isNotEmpty &&
                                        tlanguages.isNotEmpty
                                    ? 'Proceed Now'
                                    : age >= 18 && studentIDNumber.isEmpty ||
                                            studentIDNumber == 'STU*********' ||
                                            firstname.text.isEmpty ||
                                            middlename.text.isEmpty ||
                                            lastname.text.isEmpty ||
                                            age == 0 ||
                                            selectedCountry.isEmpty ||
                                            tCity.isEmpty ||
                                            _selectedTimeZone.isEmpty ||
                                            tlanguages.isEmpty
                                        ? 'Save Temporarily'
                                        : age < 18 ||
                                                age == 0 &&
                                                    studentIDNumber.isEmpty ||
                                                studentIDNumber ==
                                                    'STU*********' ||
                                                firstname.text.isEmpty ||
                                                middlename.text.isEmpty ||
                                                lastname.text.isEmpty ||
                                                age == 0 ||
                                                selectedCountry.isEmpty ||
                                                tCity.isEmpty ||
                                                _selectedTimeZone.isEmpty ||
                                                tlanguages.isEmpty ||
                                                guardianfullname.text.isEmpty ||
                                                // ignore: unrelated_type_equality_checks
                                                guardianage == 0 ||
                                                guardiancontactnumber
                                                    .text.isEmpty ||
                                                guardiansemail.text.isEmpty ||
                                                guardianbdate.isEmpty
                                            ? 'Save Temporarily'
                                            : age >= 18 &&
                                                    studentIDNumber
                                                        .isNotEmpty &&
                                                    studentIDNumber !=
                                                        'STU*********' &&
                                                    firstname.text.isNotEmpty &&
                                                    middlename
                                                        .text.isNotEmpty &&
                                                    lastname.text.isNotEmpty &&
                                                    age != 0 &&
                                                    selectedCountry
                                                        .isNotEmpty &&
                                                    tCity.isNotEmpty &&
                                                    _selectedTimeZone
                                                        .isNotEmpty &&
                                                    tlanguages.isNotEmpty &&
                                                    guardianfullname
                                                        .text.isNotEmpty &&
                                                    // ignore: unrelated_type_equality_checks
                                                    guardianage == 0 &&
                                                    guardiancontactnumber
                                                        .text.isNotEmpty &&
                                                    guardiansemail
                                                        .text.isNotEmpty &&
                                                    guardianbdate.isNotEmpty
                                                ? 'Proceed Now'
                                                : 'Proceed Now',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                        ),
                      ],
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
