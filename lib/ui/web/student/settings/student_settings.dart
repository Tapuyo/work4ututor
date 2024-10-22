import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/student/settings/student_information.dart';
import 'package:work4ututor/ui/web/student/settings/transactionspaginated.dart';

import '../../../../data_class/studentinfoclass.dart';
import '../../../../services/getlanguages.dart';
import '../../../../shared_components/responsive_builder.dart';
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
  List<String> countryNames = [];
  List<LanguageData> names = [];

  @override
  Widget build(BuildContext context) {
    countryNames = Provider.of<List<String>>(context);
    names = Provider.of<List<LanguageData>>(context);
    final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
    final guardianinfo = Provider.of<List<StudentGuardianClass>>(context);

    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Card(
                      color: Colors.white,

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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Settings",
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
          SizedBox(
            width: ResponsiveBuilder.isDesktop(context)
                ? size.width - 300
                : size.width - 30,
            // color: Colors.white,
            height: size.height - 135,
            child:
            //  guardianinfo.isEmpty
            //     ? const Center(child: CircularProgressIndicator())
            //     :
                 Align(
                    alignment: Alignment.topLeft,
                    child: DefaultTabController(
                      length: calculateAge(DateFormat('MMMM dd, yyyy')
                                  .parse(studentinfodata.first.dateofbirth)) >=
                              18
                          ? 2
                          : 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TabBar(
                              padding: const EdgeInsets.only(right: 5),
                              indicator: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 4),
                                      blurRadius: 5.0)
                                ],
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                  colors: buttonFocuscolors,
                                ),
                                color: Colors.deepPurple.shade300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              indicatorColor: kColorPrimary,
                              // isScrollable: true,
                              tabs: calculateAge(DateFormat('MMMM dd, yyyy')
                                          .parse(studentinfodata
                                              .first.dateofbirth)) >=
                                      18
                                  ? [
                                      Tab(
                                        icon: const Icon(
                                            Icons.account_box_rounded),
                                        text:
                                            ResponsiveBuilder.isMobile(context)
                                                ? 'Student'
                                                : 'Student Informations',
                                        iconMargin:
                                            const EdgeInsets.only(bottom: 3),
                                      ),
                                      Tab(
                                        icon:
                                            const Icon(Icons.payment_outlined),
                                        text:
                                            ResponsiveBuilder.isMobile(context)
                                                ? 'Payment'
                                                : 'Payments History',
                                        iconMargin:
                                            const EdgeInsets.only(bottom: 3),
                                      ),
                                    ]
                                  : [
                                      Tab(
                                        icon: const Icon(
                                            Icons.account_box_rounded),
                                        text:
                                            ResponsiveBuilder.isMobile(context)
                                                ? 'Student'
                                                : 'Student Informations',
                                        iconMargin:
                                            const EdgeInsets.only(bottom: 3),
                                      ),
                                      Tab(
                                        icon: const Icon(
                                            Icons.insert_drive_file_outlined),
                                        text:
                                            ResponsiveBuilder.isMobile(context)
                                                ? 'Guardian'
                                                : 'Guardian Informations',
                                        iconMargin:
                                            const EdgeInsets.only(bottom: 3),
                                      ),
                                      Tab(
                                        icon:
                                            const Icon(Icons.payment_outlined),
                                        text:
                                            ResponsiveBuilder.isMobile(context)
                                                ? 'Payment'
                                                : 'Payments History',
                                        iconMargin:
                                            const EdgeInsets.only(bottom: 3),
                                      ),
                                    ],

                              unselectedLabelColor: Colors.grey,
                              labelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.normal),
                              labelColor: Colors.white,
                              unselectedLabelStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: TabBarView(
                                clipBehavior: Clip.antiAlias,
                                children: calculateAge(
                                            DateFormat('MMMM dd, yyyy').parse(
                                                studentinfodata
                                                    .first.dateofbirth)) >=
                                        18
                                    ? [
                                        StudentInformation(
                                          uID: widget.uID,
                                          countryNames: countryNames,
                                          names: names,
                                        ),
                                        WithdrawalTable(userID: widget.uID,),
                                      ]
                                    : [
                                        StudentInformation(
                                          uID: widget.uID,
                                          countryNames: countryNames,
                                          names: names,
                                        ),
                                        GuardianInfoSettings(
                                          uID: widget.uID,
                                          guardianinfo: guardianinfo.first,
                                        ),
                                        // PaymentsHistory(uID: widget.uID),
                                        WithdrawalTable(userID: widget.uID,),
                                      ]),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          // Container(
          //   height: 50,
          //   width: size.width - 310,
          //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     color: Colors.transparent,
          //     borderRadius: BorderRadius.circular(5.0),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       SizedBox(
          //         width: 200,
          //         height: 50,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: settingsView == "/studentinfo"
          //                 ? kColorPrimary
          //                 : Colors.white,
          //             shape: const RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.all(Radius.circular(5))),
          //           ),
          //           onPressed: () {
          //             setState(() {
          //               settingsView = "/studentinfo";
          //             });
          //           },
          //           child: Text(
          //             'Student Information',
          //             style: TextStyle(
          //                 color: settingsView == "/studentinfo"
          //                     ? Colors.white
          //                     : Colors.black),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 200,
          //         height: 50,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: settingsView == "/guardianinfo"
          //                 ? kColorPrimary
          //                 : Colors.white,
          //             disabledForegroundColor: Colors.blueGrey,
          //             disabledBackgroundColor: Colors.blueGrey,
          //             shape: const RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.all(Radius.circular(5))),
          //           ),
          //           onPressed: () {
          //             setState(() {
          //               settingsView = "/guardianinfo";
          //             });
          //           },
          //           child: Text(
          //             'Guardian Information',
          //             style: TextStyle(
          //                 color: settingsView == "/guardianinfo"
          //                     ? Colors.white
          //                     : Colors.black),
          //           ),
          //         ),
          //       ),
          //       // SizedBox(
          //       //   width: 200,
          //       //   height: 50,
          //       //   child: ElevatedButton(
          //       //     style: ElevatedButton.styleFrom(
          //       //       backgroundColor: settingsView == "/accounts"
          //       //           ? kColorPrimary
          //       //           : Colors.white,
          //       //       disabledForegroundColor: Colors.blueGrey,
          //       //       disabledBackgroundColor: Colors.blueGrey,
          //       //       shape: const RoundedRectangleBorder(
          //       //           borderRadius: BorderRadius.all(Radius.circular(5))),
          //       //     ),
          //       //     onPressed: () {
          //       //       setState(() {
          //       //         settingsView = "/accounts";
          //       //       });
          //       //     },
          //       //     child: Text(
          //       //       'Account Information',
          //       //       style: TextStyle(
          //       //           color: settingsView == "/accounts"
          //       //               ? Colors.white
          //       //               : Colors.black),
          //       //     ),
          //       //   ),
          //       // ),
          //       SizedBox(
          //         width: 200,
          //         height: 50,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: settingsView == "/history"
          //                 ? kColorPrimary
          //                 : Colors.white,
          //             shape: const RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.all(Radius.circular(5))),
          //           ),
          //           onPressed: () {
          //             setState(() {
          //               settingsView = "/history";
          //             });
          //           },
          //           child: Text(
          //             'Payments History',
          //             style: TextStyle(
          //                 color: settingsView == "/history"
          //                     ? Colors.white
          //                     : Colors.black),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          //   child: Divider(color: Colors.grey),
          // ),
          // if (settingsView == "/guardianinfo") ...{
          //   GuardianInfoSettings(uID: widget.uID),
          // } else if (settingsView == "/studentinfo") ...{
          //   StudentInformation(uID: widget.uID),
          // } else if (settingsView == "/history") ...{
          //   PaymentsHistory(uID: widget.uID),
          // } else if (settingsView == "/accounts") ...{
          //   StudentAccounts(uID: widget.uID),
          // }
        ],
      ),
    );
  }

  int calculateAge(DateTime birthdate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;

    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month &&
            currentDate.day < birthdate.day)) {
      age--;
    }

    return age;
  }
}
