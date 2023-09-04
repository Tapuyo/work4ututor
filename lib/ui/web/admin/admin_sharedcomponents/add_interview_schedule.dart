import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/header_text.dart';

import '../../../../utils/themes.dart';

class AddSchedule extends StatefulWidget {
  final Map<String, dynamic> onDataReceived;

  const AddSchedule({Key? key, required this.onDataReceived}) : super(key: key);
  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  DateTime? _fromselectedDate;
  DateTime? _toselectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorPrimary,
        title: const HeaderText('Add Interview Schedule'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kSpacing,
                ),
                const HeaderText('Applicant ID'),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 400,
                  height: 80,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintStyle:
                          const TextStyle(color: Colors.black, fontSize: 25),
                      hintText: widget.onDataReceived['applicationID'],
                    ),
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      //add reset email here
                    },
                  ),
                ),
                const HeaderText('Enter meeting link'),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 400,
                  height: 80,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintStyle:
                          const TextStyle(color: Colors.black, fontSize: 25),
                      hintText: '',
                    ),
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      //add reset email here
                    },
                  ),
                ),
                const HeaderText('Schedule of meeting'),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black45,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 95,
                            child: Text(
                              _fromselectedDate == null
                                  ? 'Date'
                                  : DateFormat.yMMMMd()
                                      .format(_fromselectedDate!),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // _pickDateDialog();
                            },
                            child: const Icon(
                              EvaIcons.calendar,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width:10),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black45,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 95,
                            child: Text(
                              _fromselectedDate == null
                                  ? 'Time'
                                  : DateFormat.yMMMMd()
                                      .format(_fromselectedDate!),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // _pickDateDialog();
                            },
                            child: const Icon(
                              EvaIcons.clock,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: 360,
                  height: 75,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.black),
                      backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color:
                              Color.fromRGBO(1, 118, 132, 1), // your color here
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () async {
                      // if (formKey.currentState!.validate()) {
                      //   dynamic result = await _auth.signinwEmailandPassword(
                      //       userEmail, userPassword);
                      //   if (result == null) {
                      //     setState(() {
                      //       error = 'Could not sign in w/ those credential';
                      //       print(error);
                      //     });
                      //   }
                      // }
                    },
                    child: const Text(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      'Save and Send Schedule',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
