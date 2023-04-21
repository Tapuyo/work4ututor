import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/CameraPage.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/message_main.dart';

import '../../../../utils/themes.dart';
import '../calendar/tutor_schedule.dart';
import 'CameraView.dart';
import 'userlist.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
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
            // Container(
            //   height: 50,
            //   width: size.width - 310,
            //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     color: kColorPrimary,
            //     borderRadius: BorderRadius.circular(5.0),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         "MESSAGES",
            //         style: GoogleFonts.roboto(
            //           color: Colors.white,
            //           fontSize: 25,
            //           fontWeight: FontWeight.normal,
            //         ),
            //       ),
            //       const Spacer(),
            //     ],
            //   ),
            // ),
            Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: size.width > 1350 ? 4 : 5,
                      child: SizedBox(
                        height: size.height,
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: MouseRegion(
                            onHover: (event) {},
                            cursor: SystemMouseCursors.click,
                            child:UserList()
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
