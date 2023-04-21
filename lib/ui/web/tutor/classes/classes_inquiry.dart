import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/inquirydisplay_provider.dart';
import 'package:wokr4ututor/ui/web/tutor/classes/view_inquiry.dart';

import '../../../../utils/themes.dart';

class ClassInquiry extends StatefulWidget {
  const ClassInquiry({super.key});

  @override
  State<ClassInquiry> createState() => _ClassInquiryState();
}

class _ClassInquiryState extends State<ClassInquiry> {
  DateTime? _fromselectedDate;
  DateTime? _toselectedDate;
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _fromselectedDate = pickedDate;
      });
    });
  }

  void _topickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _toselectedDate = pickedDate;
      });
    });
  }

  bool select = false;

  String dropdownValue = 'English';
  Color buttonColor = kCalendarColorAB;
  @override
  Widget build(BuildContext context) {
    final bool display = context.select((InquiryDisplayProvider p) => p.openDisplay);
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
        height: size.height,
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
                    "CLASS INQUIRY",
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 12,
                    child: Container(
                      width: size.width - 320,
                      height: 50,
                      child: Card(
                        elevation: 0.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          side: BorderSide(width: .1),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Date Inquire:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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
                                          ? 'From'
                                          : DateFormat.yMMMMd()
                                              .format(_fromselectedDate!),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _pickDateDialog();
                                    },
                                    child: const Icon(
                                      Icons.calendar_month,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
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
                                      _toselectedDate == null
                                          ? 'To'
                                          : DateFormat.yMMMMd()
                                              .format(_toselectedDate!),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _pickDateDialog();
                                    },
                                    child: const Icon(
                                      Icons.calendar_month,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Subject:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              width: 150,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: DropdownButton<String>(
                                elevation: 10,
                                value: dropdownValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                underline: Container(),
                                items: <String>[
                                  'English',
                                  'Math',
                                  'Filipino',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      width: 110,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
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
                                onPressed: () {},
                                child: const Text('Search'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
            Container(
              width: size.width - 320,
              height: size.height - 101,
              child: Card(
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  side: BorderSide(width: .1),
                ),
                child: display != true ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        left: 10,
                        right: 10,
                        bottom: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            checkColor: Colors.black,
                            activeColor: Colors.green,
                            value: select,
                            onChanged: (value) {
                              setState(() {
                                select = value!;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.delete,
                                size: 25,
                                color: Colors.red,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.refresh,
                                size: 25,
                                color: Colors.grey,
                              )),
                          const Spacer(
                              // flex: 2,
                              ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      child: Divider(
                        height: 1,
                        thickness: 2,
                      ),
                    ),
                    Container(
                      width: size.width - 320,
                      height: size.height - 175,
                      child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                highlightColor: kCalendarColorFB,
                                splashColor: kColorPrimary,
                                focusColor: Colors.green.withOpacity(0.0),
                                hoverColor: Colors.grey[200],
                                onTap: () {
                                  final provider =
                                      context.read<InquiryDisplayProvider>();
                                  provider.setOpen(true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 10,
                                    right: 10,
                                    bottom: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.black,
                                        activeColor: Colors.red,
                                        value: select,
                                        onChanged: (value) {
                                          setState(() {
                                            select = value!;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const Text(
                                        "Melvin Jhon",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 2,
                                      ),
                                      // CircleAvatar(
                                      //   radius: 25.0,
                                      //   backgroundColor:
                                      //       Colors.transparent,
                                      //   child: Image.asset(
                                      //     'assets/images/login.png',
                                      //     width: 300.0,
                                      //     height: 100.0,
                                      //     fit: BoxFit.contain,
                                      //   ),
                                      // ),
                                      // const SizedBox(
                                      //   width: 10,
                                      // ),
                                      const Text(
                                        "Chemistry Class Inquiry-----",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const Text(
                                          'Melvin asked for 6 classes of chemistry subject....'),
                                      const Spacer(
                                        flex: 2,
                                      ),
                                      Text(DateTime.now().toString()),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ) : const ViewInquiry(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
