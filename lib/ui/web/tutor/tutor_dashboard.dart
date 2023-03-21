import 'package:flutter/material.dart';
import 'package:wokr4ututor/components/dashboard_header.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_schedule.dart';

import '../../../components/nav_bar.dart';

class DashboardPage extends StatefulWidget {
   final String uid;
  final String name; 
  const DashboardPage({Key? key, required this.uid, required this.name}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
   Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             const DashboardHeader(uid: "",name: "Angelo Jordans",),
            const SizedBox(height: 2,),
            Row(
              children:  const <Widget>[
                DashboardMenu(),
              //   SizedBox(width: 5,),
              //   TableBasicsExample1(),
              //  SizedBox(width: 5,),
              ],
            ),
            // It will cover 1/3 of free spaces
          ],
        ),
      ),
    );
  }
}