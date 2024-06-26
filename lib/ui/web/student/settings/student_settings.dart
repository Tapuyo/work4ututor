import 'package:flutter/material.dart';
import 'package:work4ututor/ui/web/student/settings/payments_history.dart';
import 'package:work4ututor/ui/web/student/settings/student_account.dart';
import 'package:work4ututor/ui/web/student/settings/student_information.dart';

import '../../../../utils/themes.dart';
import 'guardian_information.dart';

class StudentSettingsPage extends StatefulWidget {
  final String uID;
  const StudentSettingsPage({super.key, required this.uID});

  @override
  State<StudentSettingsPage> createState() => _StudentSettingsPageState();
}

class _StudentSettingsPageState extends State<StudentSettingsPage> {
  String settingsView = '/studentinfo';
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
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: settingsView == "/studentinfo"
                            ? kColorPrimary
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {
                        setState(() {
                          settingsView = "/studentinfo";
                        });
                      },
                      child: Text(
                        'Student Information',
                        style: TextStyle(
                            color: settingsView == "/studentinfo"
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: settingsView == "/guardianinfo"
                            ? kColorPrimary
                            : Colors.white,
                        disabledForegroundColor: Colors.blueGrey,
                        disabledBackgroundColor: Colors.blueGrey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {
                        setState(() {
                          settingsView = "/guardianinfo";
                        });
                      },
                      child: Text(
                        'Guardian Information',
                        style: TextStyle(
                            color: settingsView == "/guardianinfo"
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 200,
                  //   height: 50,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: settingsView == "/accounts"
                  //           ? kColorPrimary
                  //           : Colors.white,
                  //       disabledForegroundColor: Colors.blueGrey,
                  //       disabledBackgroundColor: Colors.blueGrey,
                  //       shape: const RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(5))),
                  //     ),
                  //     onPressed: () {
                  //       setState(() {
                  //         settingsView = "/accounts";
                  //       });
                  //     },
                  //     child: Text(
                  //       'Account Information',
                  //       style: TextStyle(
                  //           color: settingsView == "/accounts"
                  //               ? Colors.white
                  //               : Colors.black),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: settingsView == "/history"
                            ? kColorPrimary
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {
                        setState(() {
                          settingsView = "/history";
                        });
                      },
                      child: Text(
                        'Payments History',
                        style: TextStyle(
                            color: settingsView == "/history"
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
              child: Divider(color: Colors.grey),
            ),
            if (settingsView == "/guardianinfo") ...{
              GuardianInfoSettings(uID: widget.uID),
            } else if (settingsView == "/studentinfo") ...{
              StudentInformation(uID: widget.uID),
            } else if (settingsView == "/history") ...{
              PaymentsHistory(uID: widget.uID),
            } else if (settingsView == "/accounts") ...{
              StudentAccounts(uID: widget.uID),
            }
          ],
        ),
      ),
    );
  }
}
