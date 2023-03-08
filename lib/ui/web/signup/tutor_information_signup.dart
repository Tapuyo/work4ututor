import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:wokr4ututor/components/footer.dart';
import 'dart:js' as js;

import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wokr4ututor/services/services.dart';

void main() {
  tz.initializeTimeZones();
  setup();
}

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
// timezone
  var dtf = js.context['Intl'].callMethod('DateTimeFormat');
  var ops = js.context['Intl']
      .callMethod('DateTimeFormat')
      .callMethod('resolvedOptions');
  String? dropdownvalue;
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
    'Others',
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
  int languageCount = 1;
  double languagehieght = 250;
  double thieght = 45;

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
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: const Color.fromRGBO(1, 118, 132, 1),
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
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
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.black,
                                value: shareInfo,
                                onChanged: (value) {
                                  setState(() {
                                    shareInfo = value!;
                                  });
                                },
                              ),
                              Text(
                                "Share my personal information to any one.",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Colors.black87,
                                      fontFamily: 'RobotoMono',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 14,
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
                        Container(
                          width: 600,
                          height: thieght,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    primary: false,
                                    physics: NeverScrollableScrollPhysics(),
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
                                                  if (tlanguages.contains(
                                                      value.toString())) {
                                                    AlertDialog;
                                                  }  else {
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
                                primary: Colors.red,
                                onSurface: Colors.red,
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
                        Container(
                          width: 600,
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(242, 242, 242, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                            ),
                            value: dropdownvalue,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: tSubjects.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Visibility(
                          visible: tlanguages.length > 0 ? true : false,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      width: 350,
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            242, 242, 242, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Text("Fair for 2 classes")),
                                  const Spacer(),
                                  Container(
                                    width: 100,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          242, 242, 242, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'Timezone',
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter an Timezone'
                                          : null,
                                      onChanged: (val) {
                                        tTimezone = val;
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
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            242, 242, 242, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Text("Fair for 3 classes")),
                                  const Spacer(),
                                  Container(
                                    width: 100,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          242, 242, 242, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'Timezone',
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter an Timezone'
                                          : null,
                                      onChanged: (val) {
                                        tTimezone = val;
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
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            242, 242, 242, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Text("Fair for 5 classes")),
                                  const Spacer(),
                                  Container(
                                    width: 100,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          242, 242, 242, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'Timezone',
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter an Timezone'
                                          : null,
                                      onChanged: (val) {
                                        tTimezone = val;
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
                        ),
                        Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.red,
                                onSurface: Colors.red,
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
                              onPressed: () {},
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
                                  child: RadioListTile(
                                    title: const Text("Recovery Lessons"),
                                    value: false,
                                    groupValue: "male",
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Container(
                                  width: 320,
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  child: RadioListTile(
                                    title: const Text(
                                        "Kids with learning difficulties"),
                                    value: false,
                                    groupValue: "male",
                                    onChanged: (value) {
                                      setState(() {});
                                    },
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
                                  child: RadioListTile(
                                    title: const Text("Pre Exams Classes"),
                                    value: false,
                                    groupValue: "male",
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Container(
                                  width: 250,
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  child: RadioListTile(
                                    title: const Text("Deaf Language"),
                                    value: false,
                                    groupValue: "male",
                                    onChanged: (value) {
                                      setState(() {});
                                    },
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
                                  child: RadioListTile(
                                    title: const Text("Own Program"),
                                    value: false,
                                    groupValue: "male",
                                    onChanged: (value) {
                                      setState(() {});
                                    },
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
                              child: RadioListTile(
                                title: const Text("Online Classes"),
                                value: false,
                                groupValue: "male",
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            Container(
                              width: 320,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              child: RadioListTile(
                                title: const Text("In Person Classes"),
                                value: false,
                                groupValue: "male",
                                onChanged: (value) {
                                  setState(() {});
                                },
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
                                  'why a student should you! (max 5000 characters)',
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
                        const SizedBox(
                          height: 14,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 100,
                                height: 50,
                                child: Checkbox(
                                  onChanged: null,
                                  value: false,
                                ),
                              ),
                              Text(
                                "Terms and Conditions",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color:
                                          const Color.fromARGB(255, 12, 90, 85),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          width: 300,
                          height: 70,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(color: Colors.black),
                              backgroundColor:
                                  const Color.fromRGBO(55, 116, 135, 1),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color.fromRGBO(
                                      1, 118, 132, 1), // your color here
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () => {},
                            child: const Text(
                              'PAY NOW',
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
                  const CustomFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}

_buildCountryPickerDropdownSoloExpanded() {
  String valueme = "Select your Country";
  return CountryPickerDropdown(
    hint:const Text("Select your Country") ,
    onValuePicked: (Country country) {
      valueme = country.toString();
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

Future<void> setup() async {
  // var dtf = js.context['Intl'].callMethod('DateTimeFormat');
  // var ops = dtf.callMethod('resolvedOptions');
  // print(ops['timeZone']);
  tz.initializeTimeZones();
  // var istanbulTimeZone = tz.getLocation(ops['timeZone']);
  // var now = tz.TZDateTime.now(istanbulTimeZone);
  // print(now);
}
