import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/components/dashboard_header.dart';
import 'package:wokr4ututor/components/students_navbar.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/ui/web/student/main_dashboard/students_classes.dart';
import 'package:wokr4ututor/ui/web/tutor/book/book_main.dart';
import 'package:wokr4ututor/ui/web/tutor/classes/classes_main.dart';
import 'package:wokr4ututor/ui/web/tutor/classes_inquiry.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/message_main.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/messages.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_performance.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_schedule.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_settings.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_students.dart';

import '../../help/help.dart';

class StudentDashboardPage extends HookWidget {
  const StudentDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const DashboardHeader(uid: "", name: ""),
          const SizedBox(
                  height: 5,
                ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: size.width ,
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    StudentsMenu(),
                    //Contains
                    if (menuIndex == 0) ...[
                      const StudentsMainDashboard()
                    ] else if (menuIndex == 1) ...[
                      const TableBasicsExample1()
                    ] else if (menuIndex == 2) ...[
                      const MessagePage()
                    ] else if (menuIndex == 3) ...[
                      const ClassInquiry()
                    ] else if (menuIndex == 4) ...[
                      const StudentsEnrolled()
                    ] else if (menuIndex == 5) ...[
                      const PerformancePage()
                    ] else if (menuIndex == 6) ...[
                      const SettingsPage()
                    ]else if (menuIndex == 7) ...[
                      const HelpPage()
                    ]  else ...[
                      const ClassesMain()
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
