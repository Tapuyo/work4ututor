import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:wokr4ututor/components/footer.dart';
import 'dart:js' as js;

import 'package:wokr4ututor/components/nav_bar.dart';

void main() {
  tz.initializeTimeZones();
  setup();
}

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
  String dropdownvalue = 'Item 1';
  bool select = false;

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  String value = '';
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
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: const Color.fromARGB(255, 9, 93, 116),
                            fontFamily: 'Avenir',
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
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const SizedBox(
                                child: Checkbox(
                                  onChanged: null,
                                  value: false,
                                ),
                              ),
                              Text(
                                "Share my personal information to everyone.",
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
                              hintText: 'Language Spoken',
                              hintStyle: TextStyle(color: Colors.black),
                            ),
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
                          height: 50,
                          child: DropdownButton(
                            value: dropdownvalue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items.map((String items) {
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
                              hintText: 'Country of Residence',
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
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
                          child: _buildCountryPickerDropdownSoloExpanded(),
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
                              hintText: 'City',
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
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
                          ),
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
                              hintText: 'Language Spoken',
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
                                borderRadius: BorderRadius.circular(24.0),
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

_buildCountryPickerDropdownSoloExpanded() {
  return CountryPickerDropdown(
    onValuePicked: (Country country) {},
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
