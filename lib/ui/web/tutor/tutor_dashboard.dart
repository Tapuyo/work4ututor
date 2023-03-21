import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/ui/web/tutor/book/book_main.dart';
import 'package:wokr4ututor/ui/web/tutor/classes/classes_main.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/message_main.dart';

import '../../../components/nav_bar.dart';

class DashboardPage extends HookWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context) {
    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    print(menuIndex);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  <Widget>[
                Column(
                  children: const [
                    DashboardMenu(),
                  ],
                ),
                // It will cover 1/3 of free spaces
              ],
            ),
            //Contains
           if(menuIndex == 0)...[
            const ClassesMain()
           ]else if(menuIndex == 1)...[
            const MessageMain()
           ]else if(menuIndex == 2)...[
            const BookMain()
           ]
           else...[
             const ClassesMain()
           ]
          ],
        ),
      ),
    );
  }

}