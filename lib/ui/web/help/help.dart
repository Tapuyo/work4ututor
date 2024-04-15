// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../data_class/helpclass.dart';
import '../../../services/send_email.dart';
import '../../../shared_components/responsive_builder.dart';
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
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   border: Border.all(
        //     color: Colors.black45,
        //     width: .1,
        //   ),
        //   borderRadius: const BorderRadius.only(
        //     topRight: Radius.circular(5.0),
        //     topLeft: Radius.circular(5.0),
        //   ),
        // ),
        width: size.width - 300,
        height: size.height - 75,
        child: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
              elevation: 4,
              child: Container(
                height: 50,
                width: ResponsiveBuilder.isDesktop(context)
                    ? size.width - 300
                    : size.width - 30,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(-0.1, 0),
                    end: Alignment.centerRight,
                    colors: secondaryHeadercolors,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Help",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
              elevation: 4,
              child: Container(
                alignment: Alignment.topCenter,
                height: size.height - 143,
                child: Container(
                  width: 600,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      const Text(
                        "\"We are always here to help you. Feel free to get in touch with us, for any question you might have. A member of our team will reply to you within 24 hours.\"",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: kColorGrey),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 5,
                        child: DropdownButtonFormField(
                          iconEnabledColor: kColorPrimary,
                          decoration: const InputDecoration(
                            // enabledBorder: InputBorder.none,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          value: dropdownvalue,
                          hint: const Text("Category",
                              style: TextStyle(color: Colors.grey)),
                          isExpanded: true,
                          style: const TextStyle(color: Colors.grey),
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
                            tempdata =
                                await getSubjects(choosenCategory.toString());
                            setState(() {
                              _selectedValue = tempvalue;
                              dropdownvalue = value;
                              subjectlist = tempdata;
                            });
                            print('This is the subjectlist: $subjectlist');
                            print(
                                'This is the dropdownvalue: $choosenCategory');
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 5,
                        child: DropdownButtonFormField(
                          iconEnabledColor: kColorPrimary,
                          value: _selectedValue,
                          hint: const Text(
                            "Subjects",
                            style: TextStyle(color: Colors.grey),
                          ),
                          isExpanded: true,
                          style: const TextStyle(color: Colors.grey),
                          decoration: const InputDecoration(
                            // enabledBorder: InputBorder.none,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedValue = value;
                              print(
                                  'This is the _selectedValue: $_selectedValue');
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 5,
                        child: Container(
                          width: 600,
                          height: 300,
                          child: TextField(
                            controller: messageController,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: null,
                            style: const TextStyle(color: Colors.grey),
                            expands: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: 'Enter your message....',
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.grey)),
                            onChanged: (value) {
                              setState(() {
                                messageinfo = messageController.text;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  elevation: 0),
                              onPressed: () {},
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.attach_file,
                                    color: kColorPrimary,
                                  ),
                                  Text(
                                    'Attach',
                                    style: TextStyle(
                                        color: kColorPrimary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: IconButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  elevation: 0),
                              onPressed: (choosenCategory == null ||
                                      _selectedValue == null ||
                                      messageinfo == '')
                                  ? () {
                                      CoolAlert.show(
                                          context: context,
                                          width: 200,
                                          type: CoolAlertType.error,
                                          titleTextStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                          title: 'Provide missing fields!',
                                          confirmBtnColor: kColorPrimary);
                                    }
                                  : () {
                                      SendEmailService.sendMail(
                                          email: 'melvinselma4@gmail.com',
                                          message: messageController.text,
                                          name: 'MJ Amles',
                                          subject:
                                              '$choosenCategory($_selectedValue)');
                                      setState(() {
                                        messageController.text == '';
                                        choosenCategory = null;
                                        _selectedValue = null;
                                      });
                                      CoolAlert.show(
                                          context: context,
                                          width: 200,
                                          type: CoolAlertType.success,
                                          title: 'Message Sent!',
                                          titleTextStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          autoCloseDuration:
                                              const Duration(seconds: 2),
                                          confirmBtnColor: kColorPrimary);
                                    },
                              icon: const Icon(
                                Icons.send_outlined,
                                color: kColorPrimary,
                                size: 30,
                              ),
                              // label:
                              // //  const Text(
                              // //   'Send',
                              // //   style: TextStyle(
                              // //       color: kColorPrimary,
                              // //       fontWeight: FontWeight.bold),
                              // // ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
