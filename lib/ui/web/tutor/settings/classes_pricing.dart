// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/data_class/subject_teach_pricing.dart';
import 'package:work4ututor/provider/update_tutor_provider.dart';

import '../../../../data_class/tutor_info_class.dart';
import '../../../../services/update_tutorinformations_services.dart';
import '../../../../utils/themes.dart';
import 'add_new_tutor_subject.dart';

class ClassesPricing extends StatefulWidget {
  final String uID;
  const ClassesPricing({super.key, required this.uID});

  @override
  State<ClassesPricing> createState() => _ClassesPricingState();
}

class _ClassesPricingState extends State<ClassesPricing> {
  void toggleTextFieldEnabled(int index) {
    setState(() {
      textFieldEnabled[index] = !textFieldEnabled[index];
    });
  }

  List<bool> textFieldEnabled = [];

  void initializeWidget() {}
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    List<SubjectTeach> tutorinfodata = Provider.of<List<SubjectTeach>>(context);
    List<TutorInformation> tutorinfo =
        Provider.of<List<TutorInformation>>(context);
    print(tutorinfo.length);
    // textFieldEnabled = List.generate(tutorinfodata.length, (index) => false);
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    final bool model =
        context.select((TutorInformationPricing p) => p.updateDisplay);
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), // Adjust the radius as needed
          topRight: Radius.circular(10.0), // Adjust the radius as needed
        ),
      ),
      child: Container(
        alignment: Alignment.topCenter,
        width: size.width - 290,
        height: size.height - 140,
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          var height = MediaQuery.of(context).size.height;
                          var width = MediaQuery.of(context).size.width;
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Adjust the radius as needed
                            ),
                            contentPadding: EdgeInsets.zero,
                            content: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Same radius as above
                              child: Container(
                                color: Colors
                                    .white, // Set the background color of the circular content

                                child: Stack(
                                  children: <Widget>[
                                    SizedBox(
                                      height: height,
                                      width: 800,
                                      child: AddNewSubject(
                                        tutorssubject: tutorinfodata,
                                        tutorinfo: tutorinfo.first,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pop(false); // Close the dialog
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.add,
                    color: kColorPrimary, // Set the icon color to white
                  ),
                  label: const Text(
                    'Add Subject',
                    style: TextStyle(
                        color: kColorPrimary,
                        fontWeight:
                            FontWeight.bold // Set the text color to white
                        ),
                  ),
                ),
              ),
            ),
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: true),
              child: SizedBox(
                width: size.width - 290,
                height: size.height - 250,
                child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    controller: _scrollController,
                    shrinkWrap: true,
                    // controller:
                    //     updatescrollController, // Assign the ScrollController to the ListView
                    scrollDirection: Axis.vertical,
                    itemCount: (tutorinfodata.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      final int firstColumnIndex = index * 2;
                      final int? secondColumnIndex =
                          firstColumnIndex + 1 < tutorinfodata.length
                              ? firstColumnIndex + 1
                              : null;
                      final subject = tutorinfodata[firstColumnIndex];
                      textFieldEnabled.add(false);
                      TextEditingController price2Controller =
                          TextEditingController(text: subject.price2);
                      TextEditingController price3Controller =
                          TextEditingController(text: subject.price3);
                      TextEditingController price5Controller =
                          TextEditingController(text: subject.price5);
                      SubjectTeach? subject2;
                      textFieldEnabled.add(false);
                      TextEditingController price2Controller2 =
                          TextEditingController();
                      TextEditingController price3Controller2 =
                          TextEditingController();
                      TextEditingController price5Controller2 =
                          TextEditingController();
                      if (secondColumnIndex != null) {
                        subject2 = tutorinfodata[secondColumnIndex];
                        textFieldEnabled.add(false);
                        price2Controller2 =
                            TextEditingController(text: subject2.price2);
                        price3Controller2 =
                            TextEditingController(text: subject2.price3);
                        price5Controller2 =
                            TextEditingController(text: subject2.price5);
                      }

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              margin: EdgeInsets.zero,
                              elevation: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 50,
                                    width: (size.width - 360) / 2,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment(-0.1, 0),
                                        end: Alignment.centerRight,
                                        colors: secondaryHeadercolors,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            subject.subjectname,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white),
                                          ),
                                          const Spacer(),
                                          // textFieldEnabled[firstColumnIndex]
                                          //     ? Row(
                                          //         children: [
                                          //           Tooltip(
                                          //             message:
                                          //                 'Cancel Update', // The hint text
                                          //             child: IconButton(
                                          //               icon: const Icon(Icons
                                          //                   .cancel_outlined),
                                          //               color: Colors
                                          //                   .redAccent, // Replace with your desired icon
                                          //               onPressed: () {
                                          //                 toggleTextFieldEnabled(
                                          //                     firstColumnIndex);
                                          //               },
                                          //             ),
                                          //           ),
                                          //           Tooltip(
                                          //             message:
                                          //                 'Save Update', // The hint text
                                          //             child: IconButton(
                                          //               icon: const Icon(
                                          //                   Icons.save_outlined),
                                          //               color: Colors
                                          //                   .white, // Replace with your desired icon
                                          //               onPressed: () async {
                                          //                 String? result =
                                          //                     await updateSubjectTeach(
                                          //                         tutorinfo.first
                                          //                             .userId,
                                          //                         subject
                                          //                             .subjectid,
                                          //                         price2Controller
                                          //                             .text,
                                          //                         price3Controller
                                          //                             .text,
                                          //                         price5Controller
                                          //                             .text);
                                          //                 if (result ==
                                          //                     'success') {
                                          //                   setState(() {
                                          //                     CoolAlert.show(
                                          //                       context: context,
                                          //                       width: 200,
                                          //                       type:
                                          //                           CoolAlertType
                                          //                               .success,
                                          //                       text:
                                          //                           'Update Successful!',
                                          //                       autoCloseDuration:
                                          //                           const Duration(
                                          //                               seconds:
                                          //                                   1),
                                          //                     ).then(
                                          //                       (value) {
                                          //                         toggleTextFieldEnabled(
                                          //                             firstColumnIndex);
                                          //                       },
                                          //                     );
                                          //                   });
                                          //                 } else {
                                          //                   CoolAlert.show(
                                          //                     context: context,
                                          //                     width: 200,
                                          //                     type: CoolAlertType
                                          //                         .error,
                                          //                     text: result
                                          //                         .toString(),
                                          //                   );
                                          //                 }
                                          //               },
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       )
                                          //     :
                                          Row(
                                            children: [
                                              Visibility(
                                                visible: textFieldEnabled[
                                                        firstColumnIndex] ==
                                                    false,
                                                child: Tooltip(
                                                  message:
                                                      'Update Subject', // The hint text
                                                  child: IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    color: Colors
                                                        .white, // Replace with your desired icon
                                                    onPressed: () {
                                                      toggleTextFieldEnabled(
                                                          firstColumnIndex);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Tooltip(
                                                message:
                                                    'Delete Subject', // The hint text
                                                child: IconButton(
                                                    icon: const Icon(
                                                        Icons.delete_outline),
                                                    color: Colors
                                                        .redAccent, // Replace with your desired icon
                                                    onPressed: () async {
                                                      CoolAlert.show(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        width: 200,
                                                        type: CoolAlertType
                                                            .confirm,
                                                        text:
                                                            'You want to delete this subject?',
                                                        confirmBtnText:
                                                            'Proceed',
                                                        confirmBtnColor:
                                                            Colors.greenAccent,
                                                        cancelBtnText:
                                                            'Go back',
                                                        showCancelBtn: true,
                                                        cancelBtnTextStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.red),
                                                        onCancelBtnTap: () {
                                                          Navigator.of(context)
                                                              .pop;
                                                        },
                                                        onConfirmBtnTap:
                                                            () async {
                                                          String? result =
                                                              await deleteSubjectTeach(
                                                            tutorinfo
                                                                .first.userId,
                                                            subject.subjectid,
                                                          );
                                                          if (result ==
                                                              'success') {
                                                            setState(() {
                                                              CoolAlert.show(
                                                                context:
                                                                    context,
                                                                width: 200,
                                                                type:
                                                                    CoolAlertType
                                                                        .success,
                                                                text:
                                                                    'Successfuly Deleted!',
                                                                autoCloseDuration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                              );
                                                            });
                                                          } else {
                                                            CoolAlert.show(
                                                              context: context,
                                                              width: 200,
                                                              type:
                                                                  CoolAlertType
                                                                      .error,
                                                              text: result
                                                                  .toString(),
                                                            );
                                                          }
                                                        },
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: (size.width - 360) / 2,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        20.0,
                                        5,
                                        20.0,
                                        20.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  height: 45,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: const Text(
                                                    '# of Classes',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: kColorLight,
                                                        fontSize: 15,),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  width: 100,
                                                  height: 45,
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: const Text(
                                                    'Prices',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: kColorLight,
                                                        fontSize: 15,),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                    height: 45,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    // decoration: BoxDecoration(
                                                    //   color: const Color.fromRGBO(
                                                    //       242, 242, 242, 1),
                                                    //   borderRadius:
                                                    //       BorderRadius.circular(5),
                                                    // ),
                                                    child: const Text(
                                                      "2 classes",
                                                  style:  TextStyle(
                                                        color: kColorGrey,
                                                        fontSize: 15,),
                                                    )),
                                              ),
                                              const Spacer(),
                                              Flexible(
                                                child: Container(
                                                  width: 100,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: textFieldEnabled[
                                                              firstColumnIndex]
                                                          ? Border.all(
                                                              color: Colors.grey
                                                                  .shade300)
                                                          : null),
                                                  child: TextFormField(
                                                    enabled: textFieldEnabled[
                                                        firstColumnIndex],
                                                    controller:
                                                        price2Controller,
                                                    style: const TextStyle(
                                                        color: kColorGrey),
                                                    keyboardType:
                                                        const TextInputType
                                                                .numberWithOptions(
                                                            decimal: true),
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons.attach_money),
                                                      border: InputBorder.none,
                                                      fillColor: textFieldEnabled[
                                                              firstColumnIndex]
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      hintText: '',
                                                      hintStyle:
                                                          const TextStyle(
                                                              color:
                                                                  kColorGrey),
                                                    ),
                                                    validator: (val) =>
                                                        val!.isEmpty
                                                            ? 'Input price'
                                                            : null,
                                                    onChanged: (val) {
                                                      // tTimezone = val;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                    height: 45,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    // decoration: BoxDecoration(
                                                    //   color: const Color.fromRGBO(
                                                    //       242, 242, 242, 1),
                                                    //   borderRadius:
                                                    //       BorderRadius.circular(5),
                                                    // ),
                                                    child: const Text(
                                                        "3 classes",style:  TextStyle(
                                                        color: kColorGrey,
                                                        fontSize: 15,),)),
                                              ),
                                              const Spacer(),
                                              Flexible(
                                                child: Container(
                                                  width: 100,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: textFieldEnabled[
                                                              firstColumnIndex]
                                                          ? Border.all(
                                                              color: Colors.grey
                                                                  .shade300)
                                                          : null),
                                                  child: TextFormField(
                                                    keyboardType:
                                                        const TextInputType
                                                                .numberWithOptions(
                                                            decimal: true),
                                                    enabled: textFieldEnabled[
                                                        firstColumnIndex],
                                                        style: const TextStyle(
                                                        color: kColorGrey),
                                                    controller:
                                                        price3Controller,
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons.attach_money),
                                                      border: InputBorder.none,
                                                      fillColor: textFieldEnabled[
                                                              firstColumnIndex]
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      hintText: '',
                                                      hintStyle:
                                                          const TextStyle(
                                                              color:
                                                                  kColorGrey),
                                                    ),
                                                    validator: (val) =>
                                                        val!.isEmpty
                                                            ? 'Input price'
                                                            : null,
                                                    onChanged: (val) {
                                                      // tTimezone = val;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                    height: 45,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    // decoration: BoxDecoration(
                                                    //   color: const Color.fromRGBO(
                                                    //       242, 242, 242, 1),
                                                    //   borderRadius:
                                                    //       BorderRadius.circular(5),
                                                    // ),
                                                    child: const Text(
                                                        "5 classes", style:  TextStyle(
                                                        color: kColorGrey,
                                                        fontSize: 15,),)),
                                              ),
                                              const Spacer(),
                                              Flexible(
                                                child: Container(
                                                  width: 100,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: textFieldEnabled[
                                                              firstColumnIndex]
                                                          ? Border.all(
                                                              color: Colors.grey
                                                                  .shade300)
                                                          : null),
                                                  child: TextFormField(
                                                    keyboardType:
                                                        const TextInputType
                                                                .numberWithOptions(
                                                            decimal: true),
                                                    enabled: textFieldEnabled[
                                                        firstColumnIndex],
                                                        style: const TextStyle(
                                                        color: kColorGrey),
                                                    controller:
                                                        price5Controller,
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons.attach_money),
                                                      border: InputBorder.none,
                                                      fillColor: textFieldEnabled[
                                                              firstColumnIndex]
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      hintText: '',
                                                      hintStyle:
                                                          const TextStyle(
                                                              color:
                                                                  kColorGrey),
                                                    ),
                                                    validator: (val) =>
                                                        val!.isEmpty
                                                            ? 'Input price'
                                                            : null,
                                                    onChanged: (val) {
                                                      // tTimezone = val;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: textFieldEnabled[firstColumnIndex],
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0, left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: SizedBox(
                                              width: 100,
                                              height: 40,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    elevation: 0),
                                                onPressed: () async {
                                                  String? result =
                                                      await updateSubjectTeach(
                                                          tutorinfo
                                                              .first.userId,
                                                          subject.subjectid,
                                                          price2Controller.text,
                                                          price3Controller.text,
                                                          price5Controller
                                                              .text);
                                                  if (result == 'success') {
                                                    setState(() {
                                                      CoolAlert.show(
                                                        context: context,
                                                        width: 200,
                                                        type: CoolAlertType
                                                            .success,
                                                        text:
                                                            'Update Successful!',
                                                        autoCloseDuration:
                                                            const Duration(
                                                                seconds: 1),
                                                      ).then(
                                                        (value) {
                                                          toggleTextFieldEnabled(
                                                              firstColumnIndex);
                                                        },
                                                      );
                                                    });
                                                  } else {
                                                    CoolAlert.show(
                                                      context: context,
                                                      width: 200,
                                                      type: CoolAlertType.error,
                                                      text: result.toString(),
                                                    );
                                                  }
                                                },
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      color: kColorPrimary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: SizedBox(
                                              width: 100,
                                              height: 40,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    elevation: 0),
                                                onPressed: () {
                                                  toggleTextFieldEnabled(
                                                      firstColumnIndex);
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: kCalendarColorB,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (secondColumnIndex != null)
                              Card(
                                margin: EdgeInsets.zero,
                                elevation: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: (size.width - 360) / 2,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment(-0.1, 0),
                                          end: Alignment.centerRight,
                                          colors: secondaryHeadercolors,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Text(
                                              subject2!.subjectname,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white),
                                            ),
                                            const Spacer(),
                                            // textFieldEnabled[secondColumnIndex]
                                            //     ? Row(
                                            //         children: [
                                            //           Tooltip(
                                            //             message:
                                            //                 'Cancel Update', // The hint text
                                            //             child: IconButton(
                                            //               icon: const Icon(Icons
                                            //                   .cancel_outlined),
                                            //               color: Colors
                                            //                   .redAccent, // Replace with your desired icon
                                            //               onPressed: () {
                                            //                 toggleTextFieldEnabled(
                                            //                     secondColumnIndex);
                                            //               },
                                            //             ),
                                            //           ),
                                            //           Tooltip(
                                            //             message:
                                            //                 'Save Update', // The hint text
                                            //             child: IconButton(
                                            //               icon: const Icon(Icons
                                            //                   .save_outlined),
                                            //               color: Colors
                                            //                   .white, // Replace with your desired icon
                                            //               onPressed: () async {
                                            //                 String? result =
                                            //                     await updateSubjectTeach(
                                            //                         tutorinfo
                                            //                             .first
                                            //                             .userId,
                                            //                         subject2!
                                            //                             .subjectid,
                                            //                         price2Controller2
                                            //                             .text,
                                            //                         price3Controller2
                                            //                             .text,
                                            //                         price5Controller2
                                            //                             .text);
                                            //                 if (result ==
                                            //                     'success') {
                                            //                   setState(() {
                                            //                     CoolAlert.show(
                                            //                       context:
                                            //                           context,
                                            //                       width: 200,
                                            //                       type:
                                            //                           CoolAlertType
                                            //                               .success,
                                            //                       text:
                                            //                           'Update Successful!',
                                            //                       autoCloseDuration:
                                            //                           const Duration(
                                            //                               seconds:
                                            //                                   1),
                                            //                     ).then(
                                            //                       (value) {
                                            //                         toggleTextFieldEnabled(
                                            //                             secondColumnIndex);
                                            //                       },
                                            //                     );
                                            //                   });
                                            //                 } else {
                                            //                   CoolAlert.show(
                                            //                     context: context,
                                            //                     width: 200,
                                            //                     type:
                                            //                         CoolAlertType
                                            //                             .error,
                                            //                     text: result
                                            //                         .toString(),
                                            //                   );
                                            //                 }
                                            //               },
                                            //             ),
                                            //           ),
                                            //         ],
                                            //       )
                                            //     :
                                            Row(
                                              children: [
                                                Visibility(
                                                  visible: textFieldEnabled[
                                                          secondColumnIndex] ==
                                                      false,
                                                  child: Tooltip(
                                                    message:
                                                        'Update Subject', // The hint text
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.edit),
                                                      color: Colors
                                                          .white, // Replace with your desired icon
                                                      onPressed: () {
                                                        toggleTextFieldEnabled(
                                                            secondColumnIndex);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message:
                                                      'Delete Subject', // The hint text
                                                  child: IconButton(
                                                      icon: const Icon(
                                                          Icons.delete_outline),
                                                      color: Colors
                                                          .redAccent, // Replace with your desired icon
                                                      onPressed: () async {
                                                        CoolAlert.show(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          width: 200,
                                                          type: CoolAlertType
                                                              .confirm,
                                                          text:
                                                              'You want to delete this subject?',
                                                          confirmBtnText:
                                                              'Proceed',
                                                          confirmBtnColor:
                                                              Colors
                                                                  .greenAccent,
                                                          cancelBtnText:
                                                              'Go back',
                                                          showCancelBtn: true,
                                                          cancelBtnTextStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                          onCancelBtnTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop;
                                                          },
                                                          onConfirmBtnTap:
                                                              () async {
                                                            String? result =
                                                                await deleteSubjectTeach(
                                                              tutorinfo
                                                                  .first.userId,
                                                              subject2!
                                                                  .subjectid,
                                                            );
                                                            if (result ==
                                                                'success') {
                                                              setState(() {
                                                                CoolAlert.show(
                                                                  context:
                                                                      context,
                                                                  width: 200,
                                                                  type: CoolAlertType
                                                                      .success,
                                                                  text:
                                                                      'Successfuly Deleted!',
                                                                  autoCloseDuration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                );
                                                              });
                                                            } else {
                                                              CoolAlert.show(
                                                                context:
                                                                    context,
                                                                width: 200,
                                                                type:
                                                                    CoolAlertType
                                                                        .error,
                                                                text: result
                                                                    .toString(),
                                                              );
                                                            }
                                                          },
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: (size.width - 360) / 2,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20.0,
                                          5,
                                          20.0,
                                          20.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    height: 45,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: const Text(
                                                      '# of Classes',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: kColorLight,
                                                        fontSize: 15,),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width: 100,
                                                    height: 45,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: const Text(
                                                      'Prices',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: kColorLight,
                                                        fontSize: 15,),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      // decoration: BoxDecoration(
                                                      //   color: const Color
                                                      //           .fromRGBO(
                                                      //       242, 242, 242, 1),
                                                      //   borderRadius:
                                                      //       BorderRadius
                                                      //           .circular(5),
                                                      // ),
                                                      child: const Text(
                                                          "2 classes", style:  TextStyle(
                                                        color: kColorGrey,
                                                        fontSize: 15,),)),
                                                ),
                                                const Spacer(),
                                                Flexible(
                                                  child: Container(
                                                    width: 100,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: textFieldEnabled[
                                                                secondColumnIndex]
                                                            ? Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300)
                                                            : null),
                                                    child: TextFormField(
                                                      enabled: textFieldEnabled[
                                                          secondColumnIndex],
                                                          style: const TextStyle(
                                                        color: kColorGrey),
                                                      controller:
                                                          price2Controller2,
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: const Icon(
                                                            Icons.attach_money),
                                                        border:
                                                            InputBorder.none,
                                                        fillColor: textFieldEnabled[
                                                                secondColumnIndex]
                                                            ? Colors.grey
                                                            : Colors.white,
                                                        hintText: '',
                                                        hintStyle:
                                                            const TextStyle(
                                                                color:
                                                                    kColorGrey),
                                                      ),
                                                      keyboardType:
                                                          const TextInputType
                                                                  .numberWithOptions(
                                                              decimal: true),
                                                      validator: (val) =>
                                                          val!.isEmpty
                                                              ? 'Input price'
                                                              : null,
                                                      onChanged: (val) {
                                                        // tTimezone = val;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: const Text(
                                                          "3 classes", style:  TextStyle(
                                                        color: kColorGrey,
                                                        fontSize: 15,),)),
                                                ),
                                                const Spacer(),
                                                Flexible(
                                                  child: Container(
                                                    width: 100,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: textFieldEnabled[
                                                                secondColumnIndex]
                                                            ? Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300)
                                                            : null),
                                                    child: TextFormField(
                                                      enabled: textFieldEnabled[
                                                          secondColumnIndex],
                                                          style: const TextStyle(
                                                        color: kColorGrey),
                                                      controller:
                                                          price3Controller2,
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: const Icon(
                                                            Icons.attach_money),
                                                        border:
                                                            InputBorder.none,
                                                        fillColor: textFieldEnabled[
                                                                secondColumnIndex]
                                                            ? Colors.grey
                                                            : Colors.white,
                                                        hintText: '',
                                                        hintStyle:
                                                            const TextStyle(
                                                                color: kColorGrey),
                                                      ),
                                                      keyboardType:
                                                          const TextInputType
                                                                  .numberWithOptions(
                                                              decimal: true),
                                                      validator: (val) =>
                                                          val!.isEmpty
                                                              ? 'Input price'
                                                              : null,
                                                      onChanged: (val) {
                                                        // tTimezone = val;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: const Text(
                                                          "5 classes", style:  TextStyle(
                                                        color: kColorGrey,
                                                        fontSize: 15,),)),
                                                ),
                                                const Spacer(),
                                                Flexible(
                                                  child: Container(
                                                    width: 100,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: textFieldEnabled[
                                                                secondColumnIndex]
                                                            ? Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300)
                                                            : null),
                                                    child: TextFormField(
                                                      enabled: textFieldEnabled[
                                                          secondColumnIndex],
                                                      controller:
                                                          price5Controller2,
                                                          style: const TextStyle(
                                                        color: kColorGrey),
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: const Icon(
                                                            Icons.attach_money),
                                                        border:
                                                            InputBorder.none,
                                                        fillColor: textFieldEnabled[
                                                                secondColumnIndex]
                                                            ? Colors.grey
                                                            : Colors.white,
                                                        hintText: '',
                                                        hintStyle:
                                                            const TextStyle(
                                                                color: kColorGrey),
                                                      ),
                                                      keyboardType:
                                                          const TextInputType
                                                                  .numberWithOptions(
                                                              decimal: true),
                                                      validator: (val) =>
                                                          val!.isEmpty
                                                              ? 'Input price'
                                                              : null,
                                                      onChanged: (val) {
                                                        // tTimezone = val;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          textFieldEnabled[secondColumnIndex],
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10.0, left: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: SizedBox(
                                                width: 100,
                                                height: 40,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      elevation: 0),
                                                  onPressed: () async {
                                                    String? result =
                                                        await updateSubjectTeach(
                                                            tutorinfo
                                                                .first.userId,
                                                            subject2!.subjectid,
                                                            price2Controller2
                                                                .text,
                                                            price3Controller2
                                                                .text,
                                                            price5Controller2
                                                                .text);
                                                    if (result == 'success') {
                                                      setState(() {
                                                        CoolAlert.show(
                                                          context: context,
                                                          width: 200,
                                                          type: CoolAlertType
                                                              .success,
                                                          text:
                                                              'Update Successful!',
                                                          autoCloseDuration:
                                                              const Duration(
                                                                  seconds: 1),
                                                        ).then(
                                                          (value) {
                                                            toggleTextFieldEnabled(
                                                                secondColumnIndex);
                                                          },
                                                        );
                                                      });
                                                    } else {
                                                      CoolAlert.show(
                                                        context: context,
                                                        width: 200,
                                                        type:
                                                            CoolAlertType.error,
                                                        text: result.toString(),
                                                      );
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Save',
                                                    style: TextStyle(
                                                        color: kColorPrimary,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: SizedBox(
                                                width: 100,
                                                height: 40,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      elevation: 0),
                                                  onPressed: () {
                                                    toggleTextFieldEnabled(
                                                        secondColumnIndex);
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: kCalendarColorB,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
