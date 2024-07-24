import 'package:flutter/material.dart';
import 'package:work4ututor/ui/web/tutor/settings/personal_information.dart';

import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';
import 'classes_pricing.dart';
import 'payments_withdrawals.dart';
import 'tutor_information.dart';

class SettingsPage extends StatefulWidget {
  final String uID;
  const SettingsPage({super.key, required this.uID});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String settingsView = '/personalinfo';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
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
          // Container(
          //   width: ResponsiveBuilder.isDesktop(context)
          //       ? size.width - 300
          //       : size.width - 30,
          //   padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     color: Colors.transparent,
          //     borderRadius: BorderRadius.circular(5.0),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Container(
          //         width: 200,
          //         height: 50,
          //         decoration: settingsView != "/personalinfo"
          //             ? BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(15),
          //               )
          //             : BoxDecoration(
          //                 boxShadow: const [
          //                   BoxShadow(
          //                       color: Colors.black26,
          //                       offset: Offset(0, 4),
          //                       blurRadius: 5.0)
          //                 ],
          //                 gradient: const LinearGradient(
          //                   begin: Alignment.topCenter,
          //                   end: Alignment.bottomCenter,
          //                   stops: [0.0, 1.0],
          //                   colors: buttonFocuscolors,
          //                 ),
          //                 color: Colors.deepPurple.shade300,
          //                 borderRadius: BorderRadius.circular(20),
          //               ),
          //         child: ElevatedButton(
          //           style: ButtonStyle(
          //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //               RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(15.0),
          //               ),
          //             ),
          //             minimumSize:
          //                 MaterialStateProperty.all(const Size(200, 50)),
          //             backgroundColor:
          //                 MaterialStateProperty.all(Colors.transparent),
          //             // elevation: MaterialStateProperty.all(3),
          //             shadowColor:
          //                 MaterialStateProperty.all(Colors.transparent),
          //           ),
          //           onPressed: () {
          //             setState(() {
          //               settingsView = "/personalinfo";
          //             });
          //           },
          //           child: Text(
          //             'Personal Information',
          //             style: TextStyle(
          //                 color: settingsView == "/personalinfo"
          //                     ? Colors.white
          //                     : kColorGrey),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         width: 200,
          //         height: 50,
          //         decoration: settingsView != "/tutorinfo"
          //             ? BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(20),
          //               )
          //             : BoxDecoration(
          //                 boxShadow: const [
          //                   BoxShadow(
          //                       color: Colors.black26,
          //                       offset: Offset(0, 4),
          //                       blurRadius: 5.0)
          //                 ],
          //                 gradient: const LinearGradient(
          //                   begin: Alignment.topCenter,
          //                   end: Alignment.bottomCenter,
          //                   stops: [0.0, 1.0],
          //                   colors: buttonFocuscolors,
          //                 ),
          //                 color: Colors.deepPurple.shade300,
          //                 borderRadius: BorderRadius.circular(20),
          //               ),
          //         child: ElevatedButton(
          //           style: ButtonStyle(
          //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //               RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(20.0),
          //               ),
          //             ),
          //             minimumSize:
          //                 MaterialStateProperty.all(const Size(200, 50)),
          //             backgroundColor:
          //                 MaterialStateProperty.all(Colors.transparent),
          //             // elevation: MaterialStateProperty.all(3),
          //             shadowColor:
          //                 MaterialStateProperty.all(Colors.transparent),
          //           ),
          //           onPressed: () {
          //             setState(() {
          //               settingsView = "/tutorinfo";
          //             });
          //           },
          //           child: Text(
          //             'Tutor Information',
          //             style: TextStyle(
          //                 color: settingsView == "/tutorinfo"
          //                     ? Colors.white
          //                     : kColorGrey),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         width: 200,
          //         height: 50,
          //         decoration: settingsView != "/classespricing"
          //             ? BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(20),
          //               )
          //             : BoxDecoration(
          //                 boxShadow: const [
          //                   BoxShadow(
          //                       color: Colors.black26,
          //                       offset: Offset(0, 4),
          //                       blurRadius: 5.0)
          //                 ],
          //                 gradient: const LinearGradient(
          //                   begin: Alignment.topCenter,
          //                   end: Alignment.bottomCenter,
          //                   stops: [0.0, 1.0],
          //                   colors: buttonFocuscolors,
          //                 ),
          //                 color: Colors.deepPurple.shade300,
          //                 borderRadius: BorderRadius.circular(20),
          //               ),
          //         child: ElevatedButton(
          //           style: ButtonStyle(
          //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //               RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(20.0),
          //               ),
          //             ),
          //             minimumSize:
          //                 MaterialStateProperty.all(const Size(200, 50)),
          //             backgroundColor:
          //                 MaterialStateProperty.all(Colors.transparent),
          //             // elevation: MaterialStateProperty.all(3),
          //             shadowColor:
          //                 MaterialStateProperty.all(Colors.transparent),
          //           ),
          //           onPressed: () {
          //             setState(() {
          //               settingsView = "/classespricing";
          //             });
          //           },
          //           child: Text(
          //             'Classes and Pricing',
          //             style: TextStyle(
          //                 color: settingsView == "/classespricing"
          //                     ? Colors.white
          //                     : kColorGrey),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         width: 200,
          //         height: 50,
          //         decoration: settingsView != "/withdrawals"
          //             ? BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(20),
          //               )
          //             : BoxDecoration(
          //                 boxShadow: const [
          //                   BoxShadow(
          //                       color: Colors.black26,
          //                       offset: Offset(0, 4),
          //                       blurRadius: 5.0)
          //                 ],
          //                 gradient: const LinearGradient(
          //                   begin: Alignment.topCenter,
          //                   end: Alignment.bottomCenter,
          //                   stops: [0.0, 1.0],
          //                   colors: buttonFocuscolors,
          //                 ),
          //                 color: Colors.deepPurple.shade300,
          //                 borderRadius: BorderRadius.circular(20),
          //               ),
          //         child: ElevatedButton(
          //           style: ButtonStyle(
          //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //               RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(20.0),
          //               ),
          //             ),
          //             minimumSize:
          //                 MaterialStateProperty.all(const Size(200, 50)),
          //             backgroundColor:
          //                 MaterialStateProperty.all(Colors.transparent),
          //             // elevation: MaterialStateProperty.all(3),
          //             shadowColor:
          //                 MaterialStateProperty.all(Colors.transparent),
          //           ),
          //           onPressed: () {
          //             setState(() {
          //               settingsView = "/withdrawals";
          //             });
          //           },
          //           child: Text(
          //             'Payments & Withdrawals',
          //             style: TextStyle(
          //                 color: settingsView == "/withdrawals"
          //                     ? Colors.white
          //                     : kColorGrey),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: ResponsiveBuilder.isDesktop(context)
                ? size.width - 300
                : size.width - 30,
            // color: Colors.white,
            height: size.height - 135,
            child: Align(
              alignment: Alignment.topLeft,
              child: DefaultTabController(
                length: 4,
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
                        tabs: [
                          Tab(
                            icon: const Icon(Icons.account_box_rounded),
                            text: ResponsiveBuilder.isMobile(context)
                                ? 'Personal'
                                : 'Personal Informations',
                            iconMargin: const EdgeInsets.only(bottom: 3),
                          ),
                          Tab(
                            icon: const Icon(Icons.insert_drive_file_outlined),
                            text: ResponsiveBuilder.isMobile(context)
                                ? 'Tutor'
                                : 'Tutor Informations',
                            iconMargin: const EdgeInsets.only(bottom: 3),
                          ),
                          Tab(
                            icon: const Icon(Icons.subject_outlined),
                            text: ResponsiveBuilder.isMobile(context)
                                ? 'Classes'
                                : 'Classes & Pricing',
                            iconMargin: const EdgeInsets.only(bottom: 3),
                          ),
                          Tab(
                            icon: const Icon(Icons.payment_outlined),
                            text: ResponsiveBuilder.isMobile(context)
                                ? 'Payment'
                                : 'Payments & Withdrawals',
                            iconMargin: const EdgeInsets.only(bottom: 3),
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
                      child:
                          TabBarView(clipBehavior: Clip.antiAlias, children: [
                        const PersonalInformation(),
                        const TutorInfoSettings(),
                        ClassesPricing(
                          uID: widget.uID,
                        ),
                        PaymentsWithdrwals(userID: widget.uID),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // if (settingsView == "/personalinfo") ...{
          //   const PersonalInformation(),
          // } else if (settingsView == "/tutorinfo") ...{
          //   const TutorInfoSettings(),
          // } else if (settingsView == "/classespricing") ...{
          //   ClassesPricing(
          //     uID: widget.uID,
          //   ),
          // } else if (settingsView == "/withdrawals") ...{
          //   const PaymentsWithdrwals(),
          // }
        ],
      ),
    );
  }
}
