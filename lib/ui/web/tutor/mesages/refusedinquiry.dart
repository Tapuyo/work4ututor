// ignore_for_file: use_build_context_synchronously
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/services/sendinquiryproccess.dart';

import '../../../../data_class/chatmessageclass.dart';
import '../../../../data_class/subject_class.dart';
import '../../../../utils/themes.dart';

class RefusedInquiry extends StatefulWidget {
  final MessageContent messageinfo;
  final String currentID;
  const RefusedInquiry({
    super.key,
    required this.messageinfo,
    required this.currentID,
  });

  @override
  State<RefusedInquiry> createState() => _RefusedInquiryState();
}

class _RefusedInquiryState extends State<RefusedInquiry> {
  DateTime _selectedDate = DateTime.now();

  final TextEditingController _typeAheadController3 = TextEditingController();

  final TextEditingController _typeAheadController4 = TextEditingController();
  List<String> provided = [
    '4',
    '6',
    '7',
    '8',
    '9',
  ];
  List<String> subjects = [
    'Math',
    'English',
    'Geometry',
    'Music',
    'Language',
  ];
  final int startHour = 0;
  final int endHour = 24;
  String dateselected = '';
  final TextEditingController subjectnameController = TextEditingController();

  final TextEditingController numberofclassController = TextEditingController();
  final TextEditingController myMessage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final subjectlist = Provider.of<List<Subjects>>(context);
    print(subjectlist.length);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: 400,
        height: 340,
        child: Column(
          children: [
            SizedBox(
              width: 400,
              height: 100,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/5836.png',
                      width: 200.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Refuse Inquiry',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Please add a reason for refusing a class inquiry.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            // Row(
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Align(
            //           alignment: Alignment.centerLeft,
            //           child: Text(
            //             'Subject to Avail',
            //             textAlign: TextAlign.left,
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w600),
            //           ),
            //         ),
            //         Container(
            //           height: 40,
            //           width: 200,
            //           padding: const EdgeInsets.all(5),
            //           decoration: BoxDecoration(
            //             shape: BoxShape.rectangle,
            //             color: Colors.transparent,
            //             border: Border.all(
            //               color: Colors.black,
            //             ),
            //             borderRadius: const BorderRadius.all(
            //               Radius.circular(5),
            //             ),
            //           ),
            //           child: Align(
            //             alignment: Alignment.topCenter,
            //             child: TypeAheadField(
            //               hideOnEmpty: false,
            //               textFieldConfiguration: TextFieldConfiguration(
            //                 style: const TextStyle(
            //                   color: Colors.black,
            //                   fontSize: 15,
            //                 ),
            //                 autofocus: false,
            //                 controller: subjectnameController,
            //                 decoration: InputDecoration(
            //                   border: InputBorder.none,
            //                   hintText: 'Subject',
            //                   hintStyle: TextStyle(
            //                     color: Colors.grey.shade500,
            //                     fontSize: 15,
            //                   ),
            //                 ),
            //               ),
            //               suggestionsCallback: (pattern) {
            //                 return subjects.where((item) => item
            //                     .toLowerCase()
            //                     .contains(pattern.toLowerCase()));
            //               },
            //               itemBuilder: (context, suggestion) {
            //                 return ListTile(
            //                   title: Text(
            //                     suggestion.toString(),
            //                   ),
            //                 );
            //               },
            //               onSuggestionSelected: (selectedItem) {
            //                 setState(() {
            //                   subjectnameController.text =
            //                       selectedItem.toString();
            //                 });
            //               },
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Align(
            //           alignment: Alignment.centerLeft,
            //           child: Text(
            //             'Number of Classes',
            //             textAlign: TextAlign.left,
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w600),
            //           ),
            //         ),
            //         Container(
            //           height: 40,
            //           width: 150,
            //           padding: const EdgeInsets.all(5),
            //           decoration: BoxDecoration(
            //             shape: BoxShape.rectangle,
            //             color: Colors.transparent,
            //             border: Border.all(
            //               color: Colors.black,
            //             ),
            //             borderRadius: const BorderRadius.all(
            //               Radius.circular(5),
            //             ),
            //           ),
            //           child: Align(
            //             alignment: Alignment.topCenter,
            //             child: TypeAheadField(
            //               hideOnEmpty: false,
            //               textFieldConfiguration: TextFieldConfiguration(
            //                 style: const TextStyle(
            //                   color: Colors.black,
            //                   fontSize: 15,
            //                 ),
            //                 autofocus: false,
            //                 controller: numberofclassController,
            //                 decoration: InputDecoration(
            //                   border: InputBorder.none,
            //                   hintText: 'Ex. 2',
            //                   hintStyle: TextStyle(
            //                     color: Colors.grey.shade500,
            //                     fontSize: 15,
            //                   ),
            //                 ),
            //               ),
            //               suggestionsCallback: (pattern) {
            //                 return provided.where((item) => item
            //                     .toLowerCase()
            //                     .contains(pattern.toLowerCase()));
            //               },
            //               itemBuilder: (context, suggestion) {
            //                 return ListTile(
            //                   title: Text(
            //                     suggestion.toString(),
            //                   ),
            //                 );
            //               },
            //               onSuggestionSelected: (selectedItem) {
            //                 setState(() {
            //                   numberofclassController.text =
            //                       selectedItem.toString();
            //                 });
            //               },
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Reason for Refusal',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 400,
              height: 120,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: TextFormField(
                controller: myMessage,
                textAlignVertical: TextAlignVertical.top,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.grey,
                  hintText: 'Add Message',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    inherit: true,
                  ),
                  alignLabelWithHint: true,
                  hintMaxLines: 10,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorLight,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
                onPressed: () async {
                 String result = await declineInquiry(
                    widget.currentID,
                    subjectnameController.text,
                    myMessage.text,
                    widget.messageinfo.subjectID,
                    widget.messageinfo.noofclasses,
                    widget.messageinfo.messageID,
                  );
                  if (result == 'success') {
                    setState(() {
                      CoolAlert.show(
                        context: context,
                        width: 200,
                        type: CoolAlertType.success,
                        title: 'Offer Sent!',
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    });
                  } else {
                    CoolAlert.show(
                      context: context,
                      width: 200,
                      type: CoolAlertType.error,
                      title: 'Oops...',
                      text: result.toString(),
                      backgroundColor: Colors.black,
                    );
                  }
                },
                child: const Text(
                  'Send Refusal',
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
