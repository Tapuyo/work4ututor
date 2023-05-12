import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../../services/services.dart';
import '../../../../utils/themes.dart';

class TutorInfoSettings extends StatefulWidget {
  const TutorInfoSettings({super.key});

  @override
  State<TutorInfoSettings> createState() => _TutorInfoSettingsState();
}

String uID = "Upload your ID";
bool selection1 = false;
bool selection2 = false;
bool selection3 = false;
bool selection4 = false;
bool selection5 = false;
TextEditingController _aboutmecontroller=  TextEditingController();
class _TutorInfoSettingsState extends State<TutorInfoSettings> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _aboutmecontroller.text = 'Describe your skills, your approach, your teaching method, and tell us why a student should you! (max 5000 characters)';
    return Container(
      alignment: Alignment.center,
      width: size.width - 320,
      height: size.height - 75,
      padding: const EdgeInsets.only(left: 200, right: 200),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 600,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: const BoxDecoration(color: kColorPrimary),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Services Provided',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 600,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
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
              ),
              Container(
                height: 40,
                width: 600,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: const BoxDecoration(color: kColorPrimary),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Update Documents',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 600,
                child: Row(
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
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: 150,
                      height: 55,
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
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 600,
                child: Row(
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
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: 150,
                      height: 55,
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
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                width: 600,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: const BoxDecoration(color: kColorPrimary),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'About Me',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
               SizedBox(
                width: 600,
                height: 350,
                child: TextField(
                  controller: _aboutmecontroller,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        'Describe your skills, your approach, your teaching method, and tell us why a student should you! (max 5000 characters)',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 200, right: 200, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 130,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColorPrimary,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          ),
                          onPressed: () {},
                          child: const Text('Update'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
