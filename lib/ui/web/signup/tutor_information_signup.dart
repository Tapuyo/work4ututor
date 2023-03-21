// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print, unused_local_variable

import 'dart:convert';

import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:js' as js;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/services/services.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_dashboard.dart';

import '../../../components/dialog.dart';


class TutorInfo extends StatefulWidget {
  const TutorInfo({Key? key}) : super(key: key);

  @override
  State<TutorInfo> createState() => _TutorInfoState();
}

class _TutorInfoState extends State<TutorInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work4ututor',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(appBar: null, body: Center(child: InputInfo())),
    );
  }
}

class InputInfo extends StatefulWidget {
  const InputInfo({super.key});

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
  String tcontactNumber = "";
  String tCountry = "";
  String tCity = "";
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
  List<String> tSubjects = [];
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

   Future<void> _initData() async {
    
    try {
      _availableTimezones = await FlutterNativeTimezone.getAvailableTimezones();
      _availableTimezones.sort();
      tTimezone = _availableTimezones;
      print(tTimezone.toString());
    } catch (e) {
      print('Could not get available timezones');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
           CustomAppBarLog(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 130,
                    child: Text(
                      "Subcribe with your information",
                      style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                        color: const Color.fromRGBO(1, 118, 132, 1),
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
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Text(
                              "Personal Information.",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "Required*",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'RobotoMono',
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
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(242, 242, 242, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.grey,
                              hintText: 'Contact Number',
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an Contact Number' : null,
                            onChanged: (val) {
                              tcontactNumber = val;
                            },
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
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
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
                                      Icons.calendar_month_outlined,
                                      color: Colors.blue,
                                      size: 33,
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
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
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
                        CheckboxListTile(
                          title: const Text(
                            'Share my personal information to any user.',
                            style: TextStyle(fontSize: 15),
                          ),
                          // subtitle: const Text(
                          //     'A computer science portal for geeks.'),
                          // secondary: const Icon(Icons.code),
                          autofocus: false,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          selected: selection5,
                          value: selection5,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              selection5 = value!;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Container(
                              width: 300,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: _buildCountryPickerDropdownSoloExpanded(),
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
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
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
                        Container(
                                            width: 600,
                                            height: 45,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  242, 242, 242, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                enabledBorder: InputBorder.none,
                                              ),
                                              value: dropdownvalue,
                                              hint: const Text(
                                                  "Timezone"),
                                              isExpanded: true,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              items: tTimezone
                                                  .map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                setState(() {
                                                  tTimezone.clear();
                                                  tTimezone.add(val.toString());
                                                  dropdownvalue = val.toString();
                                                });
                                              },
                                            ),
                                          ),
                        const SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                          width: 600,
                          height: thieght,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    primary: false,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: languageCount,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                            width: 600,
                                            height: 45,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  242, 242, 242, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                enabledBorder: InputBorder.none,
                                              ),
                                              value: dropdownvalue,
                                              hint: const Text(
                                                  "Select your language"),
                                              isExpanded: true,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              items: ulanguages
                                                  .map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  print(value);
                                                  if (tlanguages[index] ==
                                                      (value.toString())) {
                                                  } else {
                                                    tlanguages
                                                        .add(value.toString());
                                                  }
                                                  print(tlanguages);
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                disabledBackgroundColor: Colors.red,
                                shape: const BeveledRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                // ignore: prefer_const_constructors
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  languageCount++;
                                  thieght = 45;
                                  thieght = (thieght * languageCount) +
                                      (14 * languageCount);
                                  print(languageCount);
                                });
                              },
                              child: const Text('Add more language'),
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
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "Required*",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'RobotoMono',
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
                        SizedBox(
                          width: 600,
                          height: subjecthieght,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  primary: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: subjectcount,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: 600,
                                          height: 45,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                242, 242, 242, 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: DropdownButtonFormField(
                                            decoration: const InputDecoration(
                                              enabledBorder: InputBorder.none,
                                            ),
                                            value: dropdownvaluesubject,
                                            hint: const Text(
                                                "Select your subject"),
                                            isExpanded: true,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            items:
                                                uSubjects.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                if (newValue == "Others") {
                                                        addsubject(context);
                                                }else if (newValue == "Language") {
                                                        chooseLanguage(context);
                                                }
                                                if (tSubjects.isEmpty) {
                                                  subjectcount == 1;
                                                  tSubjects
                                                      .add(newValue.toString());
                                                  print(tSubjects);
                                                } else {
                                                  tSubjects
                                                      .add(newValue.toString());
                                                  print(tSubjects);
                                                }
                                              });
                                            },
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: const Text(
                                                        "Price for 2 classes")),
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
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      fillColor: Colors.grey,
                                                      hintText: '',
                                                      hintStyle: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    validator: (val) =>
                                                        val!.isEmpty
                                                            ? 'Input price'
                                                            : null,
                                                    onChanged: (val) {
                                                      // tTimezone = val;
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: const Text(
                                                        "Price for 3 classes")),
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
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      fillColor: Colors.grey,
                                                      hintText: '',
                                                      hintStyle: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    validator: (val) =>
                                                        val!.isEmpty
                                                            ? 'Input price'
                                                            : null,
                                                    onChanged: (val) {
                                                      // tTimezone = val;
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: const Text(
                                                        "Price for 5 classes")),
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
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      fillColor: Colors.grey,
                                                      hintText: '',
                                                      hintStyle: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    validator: (val) =>
                                                        val!.isEmpty
                                                            ? 'Input price'
                                                            : null,
                                                    onChanged: (val) {
                                                      // tTimezone = val;
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
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                disabledBackgroundColor: Colors.red,
                                shape: const BeveledRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                // ignore: prefer_const_constructors
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  // if (subjectcount != tSubjects.length) {
                                  // subjecthieght = 250;
                                  // subjecthieght =
                                  //     (subjecthieght * subjectcount);
                                  // print(tSubjects.length);
                                  // } else {
                                  subjectcount++;
                                  subjecthieght = 250;
                                  subjecthieght =
                                      (subjecthieght * subjectcount);
                                  print(tSubjects.length);
                                  // }
                                });
                              },
                              child: const Text('Add more subject'),
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
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "Required, you can select morethan one.*",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'RobotoMono',
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
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "Required, you can select morethan one.*",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'RobotoMono',
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
                                fontFamily: 'RobotoMono',
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
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'RobotoMono',
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
                                  color: const Color.fromRGBO(242, 242, 242, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
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
                                  String fileName = await uploadData();
                                  setState(() {
                                    uID = fileName;
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
                                  color: const Color.fromRGBO(242, 242, 242, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text("Upload your Picture")),
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
                                  color: const Color.fromRGBO(242, 242, 242, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
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
                                  color: const Color.fromRGBO(242, 242, 242, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text("Upload your Certificates")),
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
                                  color: const Color.fromRGBO(242, 242, 242, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child:
                                    const Text("Upload a video presentation")),
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
                                  'Describe your skills, your approach, your teaching method, and tell us',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'RobotoMono',
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
                                  'why a student should choose you! (max 5000 characters)',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'RobotoMono',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "Required.*",
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'RobotoMono',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
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
                            color: const Color.fromRGBO(242, 242, 242, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
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
                              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage(uid: "" ,name: "Angelo Jordans",)),
                ),
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
