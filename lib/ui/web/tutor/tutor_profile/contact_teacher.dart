import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../utils/themes.dart';

class ContactTeacher extends StatefulWidget {
  const ContactTeacher({super.key});

  @override
  State<ContactTeacher> createState() => _ContactTeacherState();
}

class _ContactTeacherState extends State<ContactTeacher> {
  DateTime _selectedDate = DateTime.now();

  final TextEditingController _typeAheadController3 = TextEditingController();

  final TextEditingController _typeAheadController4 = TextEditingController();
  List<String> provided = [
    '4',
    '6',
    '7',
    '8',
    '9',
  ];
  List<String> subjects = [
    'Math',
    'English',
    'Geometry',
    'Music',
    'Language',
  ];
  final int startHour = 0;
  final int endHour = 24;
  String dateselected = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        width: 400,
        height: 450,
        child: Column(
          children: [
            Container(
              width: 400,
              height: 120,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/5836.png',
                      width: 250.0,
                      height: 120.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Custom Classes',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Select your subject and how many classes you want and ask for the pricing.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 50,
              width: 220,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'WHAT SUBJECT WOULD YOU LIKE TO AVAIL',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              width: 220,
              padding: const EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: TypeAheadField(
                hideOnEmpty: false,
                textFieldConfiguration: TextFieldConfiguration(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  autofocus: false,
                  controller: _typeAheadController3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Subject',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return subjects.where((item) =>
                      item.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.toString(),
                    ),
                  );
                },
                onSuggestionSelected: (selectedItem) {
                  print('Selected item: $selectedItem');
                  setState(() {
                    _typeAheadController3.text = selectedItem.toString();
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 60,
              width: 220,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'HOW MANY CLASSES WOULD YOU LIKE TO RECIEVE',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              width: 220,
              padding: const EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: TypeAheadField(
                hideOnEmpty: false,
                textFieldConfiguration: TextFieldConfiguration(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  autofocus: false,
                  controller: _typeAheadController4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Number of Classes',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return provided.where((item) =>
                      item.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.toString(),
                    ),
                  );
                },
                onSuggestionSelected: (selectedItem) {
                  print('Selected item: $selectedItem');
                  setState(() {
                    _typeAheadController4.text = selectedItem.toString();
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorLight,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
                onPressed: () {
                  //  showDialog<DateTime>(
                  //     context: context,
                  //     builder:
                  //         (BuildContext context) {
                  //       return const ContactTeacher();
                  //     },
                  //   ).then((selectedDate) {
                  //     if (selectedDate != null) {
                  //       // Do something with the selected date
                  //     }
                  //   });
                },
                child: const Text(
                  'Send Inquiry',
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
