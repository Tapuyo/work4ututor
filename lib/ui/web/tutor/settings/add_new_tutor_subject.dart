// ignore_for_file: prefer_final_fields, unused_field, unrelated_type_equality_checks, sized_box_for_whitespace, avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/subject_class.dart';
import '../../../../data_class/subject_teach_pricing.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../services/update_tutorinformations_services.dart';
import '../../../../shared_components/header_text.dart';
import '../../../../utils/themes.dart';

class AddNewSubject extends StatefulWidget {
  final List<SubjectTeach> tutorssubject;
  final TutorInformation tutorinfo;
  const AddNewSubject(
      {super.key, required this.tutorssubject, required this.tutorinfo});

  @override
  State<AddNewSubject> createState() => _AddNewSubjectState();
}

class _AddNewSubjectState extends State<AddNewSubject> {
  List<SubjectTeach> tSubjects = [];
  String? dropdownvaluesubject;
  List<String> uSubjects = [];
  bool containsSubject(List<SubjectTeach> tSubjects, String newValue) {
    return tSubjects.any((subject) => subject.subjectname == newValue);
  }

  @override
  Widget build(BuildContext context) {
    final subjectlist = Provider.of<List<Subjects>>(context);
    uSubjects = [
      'Others',
      ...subjectlist.map((subject) => subject.subjectName).toList()
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.1, 0),
              end: Alignment.centerRight,
              colors: secondaryHeadercolors, // Define this list of colors
            ),
          ),
        ),
        title: const HeaderText('Add New Subject to Teach'),
      ),
      body: ClipRect(
        child: Container(
            height: 400,
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: tSubjects.isNotEmpty,
                    child: SizedBox(
                      width: 500,
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tSubjects.length,
                        itemBuilder: (context, index) {
                          SubjectTeach subjectdata = tSubjects[index];
                          TextEditingController subjectnameController =
                              TextEditingController();
                          TextEditingController price2Controller =
                              TextEditingController(text: subjectdata.price2);
                          TextEditingController price3Controller =
                              TextEditingController(text: subjectdata.price3);
                          TextEditingController price5Controller =
                              TextEditingController(text: subjectdata.price5);

                          return subjectdata.subjectname == 'Others'
                              ? Column(
                                  children: [
                                    Container(
                                      width: 600,
                                      height: 45,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
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
                                            visualDensity: const VisualDensity(
                                                horizontal: -4, vertical: -4),
                                            icon: const Icon(
                                                Icons.delete_outline_outlined),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 580,
                                          height: 45,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: TextFormField(
                                              controller: subjectnameController,
                                              onChanged: (value) {
                                                subjectdata.subjectname = value;
                                                print(tSubjects[index]
                                                    .subjectname);
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                fillColor: Colors.grey,
                                                hintText:
                                                    '(Input subject name)',
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
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
                                                  prefixIcon:
                                                      Icon(Icons.attach_money),
                                                ),
                                                keyboardType:
                                                    const TextInputType
                                                            .numberWithOptions(
                                                        decimal: true),
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
                                                  print(
                                                      tSubjects[index].price2);
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
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
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
                                                  prefixIcon:
                                                      Icon(Icons.attach_money),
                                                ),
                                                keyboardType:
                                                    const TextInputType
                                                            .numberWithOptions(
                                                        decimal: true),
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
                                                  print(
                                                      tSubjects[index].price3);
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
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
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
                                                  prefixIcon:
                                                      Icon(Icons.attach_money),
                                                ),
                                                keyboardType:
                                                    const TextInputType
                                                            .numberWithOptions(
                                                        decimal: true),
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
                                                  print(
                                                      tSubjects[index].price5);
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
                                )
                              : Column(
                                  children: [
                                    Container(
                                      width: 600,
                                      height: 45,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
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
                                            visualDensity: const VisualDensity(
                                                horizontal: -4, vertical: -4),
                                            icon: const Icon(
                                                Icons.delete_outline_outlined),
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
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
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
                                                  prefixIcon:
                                                      Icon(Icons.attach_money),
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
                                                  print(
                                                      tSubjects[index].price2);
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
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
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
                                                  prefixIcon:
                                                      Icon(Icons.attach_money),
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
                                                  print(
                                                      tSubjects[index].price3);
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
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
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
                                                  prefixIcon:
                                                      Icon(Icons.attach_money),
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
                                                  print(
                                                      tSubjects[index].price5);
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
                  Visibility(
                    visible: tSubjects.isEmpty,
                    child: SizedBox(
                      width: 500,
                      height: 45,
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
                              dropdownvaluesubject = null;
                              SubjectTeach data = SubjectTeach(
                                  subjectname: newValue!,
                                  price2: '',
                                  price3: '',
                                  price5: '',
                                  subjectid: '');
                              bool containsNewValue = containsSubject(
                                  widget.tutorssubject, newValue);
                              if (containsNewValue) {
                                // ignore: use_build_context_synchronously
                                CoolAlert.show(
                                  context: context,
                                  width: 200,
                                  type: CoolAlertType.warning,
                                  title: 'Oopss..',
                                  text:
                                      'Subject already added, select another one.',
                                );
                              } else {
                                tSubjects.add(data);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 130,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorPrimary,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () async {
                  String? result =
                      await addSubjectTeach(widget.tutorinfo.userId, tSubjects);
                  if (result == 'success') {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  } else {
                    // ignore: use_build_context_synchronously
                    CoolAlert.show(
                      context: context,
                      width: 200,
                      type: CoolAlertType.error,
                      text: result.toString(),
                    );
                  }
                },
                child: const Text('Add Subject'),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 130,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: kColorPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
