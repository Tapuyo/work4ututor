import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../data_class/classesdataclass.dart';
import '../../../../utils/themes.dart';
import '../tutor_profile/book_lesson.dart';
import '../tutor_profile/contact_teacher.dart';
import '../tutor_profile/view_file.dart';
import '../tutor_profile/viewschedule.dart';

class ViewClassInfo extends StatefulWidget {
  const ViewClassInfo({super.key});

  @override
  State<ViewClassInfo> createState() => _ViewClassInfoState();
}

class _ViewClassInfoState extends State<ViewClassInfo> {
  final List<ClassesData> _tiles = [
    ClassesData(title: 'Class 1', fields: ['Field 1', 'Field 2', 'Field 3']),
    ClassesData(title: 'Class 2', fields: ['Field A', 'Field B', 'Field C']),
    ClassesData(title: 'Class 3', fields: ['Field X', 'Field Y', 'Field Z']),
  ];

  bool _expanded = false;
  bool viewClassState = false;
  @override
  Widget build(BuildContext context) {
    bool selection5 = false;
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    const double fillPercent = 30; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.topCenter,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: gradient,
        //     stops: stops,
        //     end: Alignment.bottomCenter,
        //     begin: Alignment.topCenter,
        //   ),
        // ),
        width: size.width - 320,
        height: size.height + 900,
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Container(
                width: size.width - 320,
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    stops: stops,
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 10,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                        onTap: () {
                                          showDialog<DateTime>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const ViewFile();
                                            },
                                          ).then((selectedDate) {
                                            if (selectedDate != null) {
                                              // Do something with the selected date
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 250,
                                          width: 250,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.transparent,
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/sample.jpg'),
                                                  fit: BoxFit.cover)),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: MediaQuery.of(context).size.height,
                      // child: const VerticalDivider(
                      //   thickness: 1,
                      // ),
                    ),
                    Flexible(
                      flex: 20,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Marian Rivera, 28',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: const [
                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            'USA, Manchester',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 20,
                                        // ),
                                        // Text(
                                        //   'Contact #: +123456789',
                                        //   style: TextStyle(
                                        //       fontSize: 25,
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.w500),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: const [
                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            'Chemistry',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 20,
                                        // ),
                                        // Text(
                                        //   'Email: email@yahoo.com',
                                        //   style: TextStyle(
                                        //       fontSize: 25,
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.w500),
                                        // ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 680,
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 20,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              viewClassState == true
                                                  ? Colors.white
                                                  : kColorPrimary,
                                          disabledForegroundColor:
                                              Colors.blueGrey,
                                          disabledBackgroundColor:
                                              Colors.blueGrey,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            viewClassState = false;
                                          });
                                        },
                                        child: Text(
                                          'Class Info',
                                          style: TextStyle(
                                              color: viewClassState == true
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              viewClassState == false
                                                  ? Colors.white
                                                  : kColorPrimary,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            viewClassState = true;
                                          });
                                        },
                                        child: Text(
                                          'Materials',
                                          style: TextStyle(
                                              color: viewClassState == false
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                  child: Divider(color: Colors.grey),
                                ),
                                viewClassState == false
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            decoration: const BoxDecoration(
                                                color: kColorPrimary),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'About Class',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "Student enrolled in your Chemistry Class for 3 sessions. 1 hour per session.\nSchedule:",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "1 session  February 20, 2023 8:00 AM (Done)\n2 session  February 21, 2023 8:00 AM (Done)\n3 session  February 22, 2023 8:00 AM (Done)",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 40,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            decoration: const BoxDecoration(
                                                color: kColorPrimary),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Add Grade',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              width: 600,
                                              height: 50,
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.top,
                                                maxLines: null,
                                                expands: true,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'eg. 100',
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 40,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            decoration: const BoxDecoration(
                                                color: kColorPrimary),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Write down your comment',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(
                                            height: 200,
                                            child: TextField(
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              maxLines: null,
                                              expands: true,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText:
                                                    'Enter your message....',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: SizedBox(
                                              width: 130,
                                              height: 40,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kColorPrimary,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                ),
                                                onPressed: () {},
                                                child: const Text('SAVE'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Container(
                                            width: 600,
                                            height: 600,
                                            child: ListView.builder(
                                              itemCount: _tiles.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Card(
                                                  child: ExpansionTile(
                                                    title: Text(
                                                        _tiles[index].title),
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                                'Files:'),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              width: 160,
                                                              height: 40,
                                                              child:
                                                                  ElevatedButton
                                                                      .icon(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15))),
                                                                ),
                                                                onPressed:
                                                                    () {},
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .attach_file_outlined,
                                                                  color:
                                                                      kColorPrimary,
                                                                ),
                                                                label:
                                                                    const Text(
                                                                  'Add Files',
                                                                  style: TextStyle(
                                                                      color:
                                                                          kColorPrimary),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                50, 10, 50, 10),
                                                        child: TextFormField(
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Add notes here',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(),
                                                              gapPadding: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  50,
                                                                  0,
                                                                  50,
                                                                  10),
                                                          child: SizedBox(
                                                            width: 100,
                                                            height: 40,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                minimumSize:
                                                                    Size.zero,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                backgroundColor:
                                                                    kColorPrimary,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15))),
                                                              ),
                                                              onPressed: () {},
                                                              // icon: const Icon(Icons.attach_file_outlined, color: kColorPrimary,),
                                                              child: const Text(
                                                                'Save',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                                'Class Video Meeting:'),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              width: 180,
                                                              height: 40,
                                                              child:
                                                                  ElevatedButton
                                                                      .icon(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15))),
                                                                ),
                                                                onPressed:
                                                                    () {},
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .video_camera_back_outlined,
                                                                  color:
                                                                      kColorPrimary,
                                                                ),
                                                                label:
                                                                    const Text(
                                                                  'Set up Class Link',
                                                                  style: TextStyle(
                                                                      color:
                                                                          kColorPrimary),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                50, 10, 50, 10),
                                                        child: TextFormField(
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Meeting link...',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(),
                                                              gapPadding: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                          padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                50, 10, 50, 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: SizedBox(
                                                            width: 150,
                                                            height: 40,
                                                            child: ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    kColorPrimary,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(
                                                                                20))),
                                                              ),
                                                              onPressed: () {},
                                                              child: const Text(
                                                                  'Join Class Link'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // Padding(
                                                      //   padding:
                                                      //       const EdgeInsets.all(
                                                      //           16.0),
                                                      //   child: Column(
                                                      //     crossAxisAlignment:
                                                      //         CrossAxisAlignment
                                                      //             .start,
                                                      //     children: _tiles[index]
                                                      //         .fields
                                                      //         .map((field) =>
                                                      //             TextFormField(
                                                      //               decoration:
                                                      //                   InputDecoration(
                                                      //                 labelText:
                                                      //                     field,
                                                      //                 border:
                                                      //                     OutlineInputBorder(),
                                                      //               ),
                                                      //             ))
                                                      //         .toList(),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                        // child: VerticalDivider(),
                      ),
                      Flexible(
                          flex: 13,
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), //<-- SEE HERE
                                ),
                                elevation: 1,
                                child: Container(
                                  width: 380,
                                  height: 300,
                                  padding: const EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Class Session',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )),
                                      ),
                                      Container(
                                        width: 350,
                                        height: 180,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 10, 30, 10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200),
                                        child: ListView.builder(
                                          itemCount: 3,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            int classCount = index + 1;
                                            return Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      '$classCount Class Session'),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 160,
                                                    height: 40,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15))),
                                                      ),
                                                      onPressed: () {},
                                                      child: const Text(
                                                        'Complete Session',
                                                        style: TextStyle(
                                                            color:
                                                                kColorPrimary),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: 380,
                                        height: 65,
                                        alignment: Alignment.center,
                                        // padding:
                                        // const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: .1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(EvaIcons.clockOutline),
                                            Text('50 minutes per class session')
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 380,
                                height: 100,
                                alignment: Alignment.center,
                                // padding:
                                // const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: .1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'A class by',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50, 5, 50, 5),
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.black12,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        title: const Text(
                                          "MJ Selma",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: const Text("Chemistry",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        onTap: () {
                                          // Navigate to user profile page
                                          // Navigator.pushNamed(context, '/profile',
                                          //     arguments: {'username': users[index]['name']});
                                          //  final provider =
                                          //           context.read<ChatDisplayProvider>();
                                          //       provider.setOpenMessage(true);
                                        },
                                      ),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: const [
                                    //     Icon(EvaIcons.clockOutline),
                                    //     Text('50 minutes per class session')
                                    //   ],
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
