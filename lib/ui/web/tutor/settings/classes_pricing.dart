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
  const ClassesPricing({super.key});

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
    // textFieldEnabled = List.generate(tutorinfodata.length, (index) => false);
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    final bool model =
        context.select((TutorInformationPricing p) => p.updateDisplay);
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          elevation: 5,
          child: Container(
            width: size.width - 320,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: background,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 250.0,
                  right: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  var height =
                                      MediaQuery.of(context).size.height;
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
                                              child: const AddNewSubject(),
                                            ),
                                            Positioned(
                                              top: 10.0,
                                              right: 10.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop(
                                                      false); // Close the dialog
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
                            color: Colors.white, // Set the icon color to white
                          ),
                          label: const Text(
                            'Add Subject',
                            style: TextStyle(
                              color:
                                  Colors.white, // Set the text color to white
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
          child: Container(
            alignment: Alignment.topCenter,
            width: size.width - 320,
            height: size.height - 75,
            child: SizedBox(
              width: 600,
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  // controller:
                  //     updatescrollController, // Assign the ScrollController to the ListView
                  scrollDirection: Axis.vertical,
                  itemCount: tutorinfodata.length,
                  itemBuilder: (context, index) {
                    final subject = tutorinfodata[index];
                    textFieldEnabled.add(false);
                    TextEditingController price2Controller =
                        TextEditingController(text: subject.price2);
                    TextEditingController price3Controller =
                        TextEditingController(text: subject.price3);
                    TextEditingController price5Controller =
                        TextEditingController(text: subject.price5);
                    return Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 600,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(55, 116, 135, 1),
                                borderRadius: BorderRadius.circular(5),
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
                                    textFieldEnabled[index]
                                        ? Row(
                                            children: [
                                              Tooltip(
                                                message:
                                                    'Cancel Update', // The hint text
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.cancel_outlined),
                                                  color: Colors
                                                      .redAccent, // Replace with your desired icon
                                                  onPressed: () {
                                                    toggleTextFieldEnabled(
                                                        index);
                                                  },
                                                ),
                                              ),
                                              Tooltip(
                                                message:
                                                    'Save Update', // The hint text
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.save_outlined),
                                                  color: Colors
                                                      .white, // Replace with your desired icon
                                                  onPressed: () async {
                                                    String? result =
                                                        await updateSubjectTeach(
                                                            tutorinfo
                                                                .first.userId,
                                                            subject.subjectid,
                                                            price2Controller
                                                                .text,
                                                            price3Controller
                                                                .text,
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
                                                                index);
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
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
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
                                              Tooltip(
                                                message:
                                                    'Update Subject', // The hint text
                                                child: IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  color: Colors
                                                      .white, // Replace with your desired icon
                                                  onPressed: () {
                                                    toggleTextFieldEnabled(
                                                        index);
                                                  },
                                                ),
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
                              width: 600,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 350,
                                          height: 45,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                242, 242, 242, 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                              "Price for 2 classes")),
                                      const Spacer(),
                                      Container(
                                        width: 100,
                                        height: 45,
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              242, 242, 242, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: TextFormField(
                                          enabled: textFieldEnabled[index],
                                          controller: price2Controller,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            fillColor: textFieldEnabled[index]
                                                ? Colors.grey
                                                : Colors.white,
                                            hintText: '',
                                            hintStyle: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          validator: (val) => val!.isEmpty
                                              ? 'Input price'
                                              : null,
                                          onChanged: (val) {
                                            // tTimezone = val;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          width: 350,
                                          height: 45,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                242, 242, 242, 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                              "Price for 3 classes")),
                                      const Spacer(),
                                      Container(
                                        width: 100,
                                        height: 45,
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              242, 242, 242, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: TextFormField(
                                          enabled: textFieldEnabled[index],
                                          controller: price3Controller,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            fillColor: textFieldEnabled[index]
                                                ? Colors.grey
                                                : Colors.white,
                                            hintText: '',
                                            hintStyle: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          validator: (val) => val!.isEmpty
                                              ? 'Input price'
                                              : null,
                                          onChanged: (val) {
                                            // tTimezone = val;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          width: 350,
                                          height: 45,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                242, 242, 242, 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                              "Price for 5 classes")),
                                      const Spacer(),
                                      Container(
                                        width: 100,
                                        height: 45,
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              242, 242, 242, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: TextFormField(
                                          enabled: textFieldEnabled[index],
                                          controller: price5Controller,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            fillColor: textFieldEnabled[index]
                                                ? Colors.grey
                                                : Colors.white,
                                            hintText: '',
                                            hintStyle: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          validator: (val) => val!.isEmpty
                                              ? 'Input price'
                                              : null,
                                          onChanged: (val) {
                                            // tTimezone = val;
                                          },
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
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
