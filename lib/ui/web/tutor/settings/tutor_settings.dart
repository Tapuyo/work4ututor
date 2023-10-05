import 'package:flutter/material.dart';
import 'package:work4ututor/ui/web/tutor/settings/personal_information.dart';

import '../../../../utils/themes.dart';
import 'classes_pricing.dart';
import 'payments_withdrawals.dart';
import 'tutor_information.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String settingsView = '/personalinfo';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            elevation: 5,
            child: Container(
              height: 50,
              width: size.width - 310,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                        backgroundColor: settingsView == "/personalinfo"
                            ? kColorPrimary
                            : Colors.white,
                        disabledForegroundColor: Colors.blueGrey,
                        disabledBackgroundColor: Colors.blueGrey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {
                        setState(() {
                          settingsView = "/personalinfo";
                        });
                      },
                      child: Text(
                        'Personal Information',
                        style: TextStyle(
                            color: settingsView == "/personalinfo"
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
                        backgroundColor: settingsView == "/tutorinfo"
                            ? kColorPrimary
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {
                        setState(() {
                          settingsView = "/tutorinfo";
                        });
                      },
                      child: Text(
                        'Tutor Information',
                        style: TextStyle(
                            color: settingsView == "/tutorinfo"
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
                        backgroundColor: settingsView == "/classespricing"
                            ? kColorPrimary
                            : Colors.white,
                        disabledForegroundColor: Colors.blueGrey,
                        disabledBackgroundColor: Colors.blueGrey,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {
                        setState(() {
                          settingsView = "/classespricing";
                        });
                      },
                      child: Text(
                        'Classes and Pricing',
                        style: TextStyle(
                            color: settingsView == "/classespricing"
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
                        backgroundColor: settingsView == "/withdrawals"
                            ? kColorPrimary
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {
                        setState(() {
                          settingsView = "/withdrawals";
                        });
                      },
                      child: Text(
                        'Payments & Withdrawals',
                        style: TextStyle(
                            color: settingsView == "/withdrawals"
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (settingsView == "/personalinfo") ...{
            const PersonalInformation(),
          } else if (settingsView == "/tutorinfo") ...{
            const TutorInfoSettings(),
          } else if (settingsView == "/classespricing") ...{
            const ClassesPricing(),
          } else if (settingsView == "/withdrawals") ...{
            const PaymentsWithdrwals(),
          }
        ],
      ),
    );
  }
}
