import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../utils/themes.dart';

class ClassInquiry extends StatefulWidget {
  const ClassInquiry({super.key});

  @override
  State<ClassInquiry> createState() => _ClassInquiryState();
}

class _ClassInquiryState extends State<ClassInquiry> {
  DateTime? _selectedDate;
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
        _selectedDate = pickedDate;
      });
    });
  }

  bool select = false;
  @override
  Widget build(BuildContext context) {
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
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                onPressed: _pickDateDialog,
                                icon: const Icon(
                                  Icons.calendar_month,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(_selectedDate == null
                                ? 'From'
                                : DateFormat.yMMMd().format(_selectedDate!)),
                            Container(),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
            Container(
              width: size.width - 320,
              height: size.height,
              child: Card(
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  side: BorderSide(width: .1),
                ),
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          highlightColor: kCalendarColorFB,
                          splashColor: kColorPrimary,
                          focusColor: Colors.green.withOpacity(0.0),
                          hoverColor: kColorLight,
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 0.0,
                              left: 10,
                              right: 10,
                              bottom: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                       const SizedBox(
                          child:  Divider(
                            thickness: 1,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
