// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/data_class/helpclass.dart';
import 'package:wokr4ututor/services/send_email.dart';

import '../../../utils/themes.dart';

import 'package:http/http.dart' as http;

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  HelpCategory? dropdownvalue;
  String? choosenCategory;
  String? _selectedValue;
  String? _selectedValue1;
  bool showdrop = false;
  List<HelpCategory> helpcategory = [];
  List<String> subjectlist = [];
  List<HelpCategory> datacategorylist = [];
  _runFilter(String? enteredKeyword) {
    print(enteredKeyword);
    print(helpcategory.length);
    List<HelpCategory> categorylist = [];
    categorylist = helpcategory
        .where((user) => user.categoryName.contains(enteredKeyword.toString()))
        .toList();
    print(categorylist);
    return categorylist;
  }

  List<String> _dropdownValues = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

  Future<List<String>> getSubjects(String category) async {
    List<String> subjects = [];
    await FirebaseFirestore.instance
        .collection('helpcategory')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                // debugPrint(doc.id);
                // debugPrint('This is i choose: $category');
                // debugPrint(doc['categoryName']);
                if (doc['categoryName'] == category) {
                  subjects = (doc['categoryList'] as List)
                      .map((item) => item as String)
                      .toList();
                  print('This is the subject: $subjects');
                }
              })
            });
    return subjects;
  }

  updateDropdownData(String data) {
    List<String> slist = [];
    setState(() {
      // Simulating data change

      // slist = getSubjects(data.toString());
      _selectedValue = null; // Reset selected value\
    });
    return slist;
  }

  //Textcontroller
  final messageController = TextEditingController();
  String messageinfo = '';

  //send email


  @override
  Widget build(BuildContext context) {
    final helpcategorylist = Provider.of<List<HelpCategory>>(context);
    helpcategory = helpcategorylist;
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black45,
            width: .1,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(5.0),
            topLeft: Radius.circular(5.0),
          ),
        ),
        width: size.width - 320,
        height: size.height - 75,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: size.width - 310,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorPrimary,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "HELP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 600,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  const Text(
                    "\"We are always here to help you. Feel free to get in touch with us, for any question you might have. A member of our team will reply to you within 24 hours.\"",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      // enabledBorder: InputBorder.none,
                      border: OutlineInputBorder(),
                    ),
                    value: dropdownvalue,
                    hint: const Text("Category"),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: helpcategory.map((HelpCategory items) {
                      return DropdownMenuItem<HelpCategory>(
                        value: items,
                        child: Text(items.categoryName),
                      );
                    }).toList(),
                    onChanged: (HelpCategory? value) async {
                      List<String> tempdata = [];
                      String? tempvalue;
                      choosenCategory = value?.categoryName.toString();
                      tempdata = await getSubjects(choosenCategory.toString());
                      setState(() {
                        _selectedValue = tempvalue;
                        dropdownvalue = value;
                        subjectlist = tempdata;
                      });
                      print('This is the subjectlist: $subjectlist');
                      print('This is the dropdownvalue: $choosenCategory');
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    value: _selectedValue,
                    hint: const Text("Subjects"),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      // enabledBorder: InputBorder.none,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedValue = value;
                        print('This is the _selectedValue: $_selectedValue');
                      });
                    },
                    items: subjectlist.map((String value) {
                      print(value);
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 600,
                    height: 350,
                    child: TextField(
                      controller: messageController,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your message....',
                      ),
                      onChanged: (value) {
                        setState(() {
                          messageinfo = messageController.text;
                        });
                        debugPrint(messageController.text);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Icon(
                                Icons.attach_file,
                                color: Colors.black,
                              ),
                              Text(
                                'Attach',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColorPrimary,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed:() {
                          SendEmailService.sendMail(email:'melvinselma4@gmail.com', message: messageController.text, name: 'MJ Amles', subject: '$choosenCategory($_selectedValue)');},
                          // (dropdownvalue?.categoryName == null ||
                          //         _selectedValue == null ||
                          //         messageinfo == '')
                          //     ? null
                          //     : () {
                          //         setState(() {
                          //           print('sending inquiry');
                          //         });
                          //       },
                          child: const Text('Send'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
