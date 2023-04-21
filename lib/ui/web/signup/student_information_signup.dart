// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print

import 'dart:math';

import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:js' as js;

import 'package:wokr4ututor/components/nav_bar.dart';

import '../../../services/services.dart';
import '../../../shared_components/alphacode3.dart';

// void main() {
//   tz.initializeTimeZones();
//   setup();
// }

class StudentInfo extends StatefulWidget {
  const StudentInfo({Key? key}) : super(key: key);

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
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
  String tTimezone = "";
  String contactNumber = "";
  var ulanguages = [
    'Filipino',
    'English',
    'Russian',
    'Chinese',
    'Japanese',
  ];
  var tSubjects = [
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

  DateTime selectedDate = DateTime.now();
  String studentIDNumber = 'STU*********';
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

  //term
  bool termStatus = false;
  @override
  Widget build(BuildContext context) {
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
                        Row(
                          children: const [
                            Text(
                              "Student Identification Number",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                             Text(
                              "(Auto Generated once Country is selected!)*",
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
                              width: 200,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                              decoration: BoxDecoration(
                                color:  const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    studentIDNumber.toString(),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
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
                              hintText: 'Fullname',
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an Fullname' : null,
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
                          selected: shareInfo,
                          value: shareInfo,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              shareInfo = value!;
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
                              child: CountryPickerDropdown(
                                onValuePicked: (Country country) {
                                  final alpha3Code =
                                      getAlpha3Code(country.name);
                                  Random random = Random();
                                  int randomNumber =
                                      random.nextInt(1000000) + 1;
                                       String currentyear = DateFormat('yyyy').format(DateTime.now());
                                  //todo please replace the random number with legnth of students enrolled
                                  setState(() {
                                    studentIDNumber =
                                        'STU$alpha3Code$currentyear$randomNumber';
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
                              ),
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
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(242, 242, 242, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.grey,
                              hintText: 'Timezone',
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an Timezone' : null,
                            onChanged: (val) {
                              tTimezone = val;
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
                                                  if (tlanguages.isNotEmpty) {
                                                    if (tlanguages[index] ==
                                                        (value.toString())) {
                                                    } else {
                                                      tlanguages.add(
                                                          value.toString());
                                                    }
                                                    print(tlanguages);
                                                  } else {
                                                    tlanguages
                                                        .add(value.toString());
                                                  }
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
                              "Upload Students documents.",
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
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 600,
                                height: 45,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(242, 242, 242, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.grey,
                                    hintText: 'Fullname',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter an Fullname' : null,
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
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          242, 242, 242, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          guardianbdate.toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          242, 242, 242, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
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
                              Container(
                                width: 600,
                                height: 45,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(242, 242, 242, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.grey,
                                    hintText: 'Contact',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  validator: (val) => val!.isEmpty
                                      ? 'Enter your Contact'
                                      : null,
                                  onChanged: (val) {
                                    tcontactNumber = val;
                                  },
                                ),
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
                                      fontFamily: 'RobotoMono',
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
                                        color: const Color.fromRGBO(
                                            242, 242, 242, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
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
                                        color: const Color.fromRGBO(
                                            242, 242, 242, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
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
                            onPressed: () => {},
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
}


// Future<void> setup() async {
//   // var dtf = js.context['Intl'].callMethod('DateTimeFormat');
//   // var ops = dtf.callMethod('resolvedOptions');
//   // print(ops['timeZone']);
//   tz.initializeTimeZones();
//   // var istanbulTimeZone = tz.getLocation(ops['timeZone']);
//   // var now = tz.TZDateTime.now(istanbulTimeZone);
//   // print(now);
// }
