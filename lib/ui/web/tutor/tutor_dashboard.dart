import 'package:flutter/material.dart';
import 'package:wokr4ututor/components/dashboard_header.dart';

import '../../../components/nav_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
   Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:   <Widget>[
            const DashboardHeader(),
            const SizedBox(height: 5,),
            Row(
              children: const [
                DashboardMenu(),
              ],
            ),
            // It will cover 1/3 of free spaces
          ],
        ),
      ),
    );
  }
}