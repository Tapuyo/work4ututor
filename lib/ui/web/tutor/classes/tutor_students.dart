import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wokr4ututor/utils/themes.dart';

class StudentsEnrolled extends StatefulWidget {
  const StudentsEnrolled({super.key});

  @override
  State<StudentsEnrolled> createState() => _StudentsEnrolledState();
}

class _StudentsEnrolledState extends State<StudentsEnrolled> {
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
                    "STUDENTS ENROLLED",
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
              height: size.height + 100,
              child: Card(
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  side: BorderSide(width: .1),
                ),
                child: Column(
                  children: [
                    Padding(
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
                            "Name",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            flex: 3,
                          ),
                          const Text(
                            "Date",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            flex: 3,
                          ),
                          const Text(
                            "Subject",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          const Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          const Text(
                            "Schedule",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          const Text(
                            "Meeting Link",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          const Text(
                            "Action",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Container(
                      width: size.width - 320,
                      height: size.height,
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
                                      SizedBox(
                                        width: 160,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20.0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Image.asset(
                                                'assets/images/login.png',
                                                width: 300.0,
                                                height: 100.0,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text(
                                              "Melvin Jhon",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 160,
                                        child: Text(
                                          DateFormat('MMMM dd, yyyy')
                                              .format(DateTime.now())
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          "Chemistry ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const SizedBox(
                                          width: 120,
                                          child: const Text('Completeted')),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                          width: 160,
                                          child:
                                              Text(DateTime.now().toString())),
                                      const Spacer(),
                                      SizedBox(
                                          width: 200,
                                          child:
                                              Text(DateTime.now().toString())),
                                      const Spacer(),
                                      SizedBox(
                                          width: 140,
                                          child:
                                              Text(DateTime.now().toString())),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
