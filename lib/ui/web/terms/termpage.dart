// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:work4ututor/ui/web/admin/admin_sharedcomponents/header_text.dart';
import 'package:work4ututor/utils/themes.dart';

/// Represents Homepage for Navigation
class TermPage extends StatefulWidget {
  const TermPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TermPage createState() => _TermPage();
}

class _TermPage extends State<TermPage> {
  PdfViewerController? _pdfViewerController;
  bool selection1 = false;
  bool selection2 = false;
  bool selection3 = false;
  bool selection4 = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kColorPrimary,
        title: const HeaderText('Terms & Condition'),
      ),
      body: Container(
        height: height,
        alignment: Alignment.center,
        child: Column(
          children: [
            ClipRect(
              child: Column(
                children: [
                  SizedBox(
                    height: height - 110,
                    child: SfPdfViewer.asset(
                      'assets/images/Terms and Conditions Work4uTutor.pdf',
                      initialZoomLevel: 1.5,
                    ),
                  ),
                  //   Column(
                  //     children: [
                  //       Transform.scale(
                  //         scale: 0.8,
                  //         child: CheckboxListTile(
                  //           title: const Text(
                  //             'I agree to conduct all the lesson in accordance to work4u terms and condition.',
                  //             style: TextStyle(fontSize: 12),
                  //           ),
                  //           // subtitle: const Text(
                  //           //     'A computer science portal for geeks.'),
                  //           // secondary: const Icon(Icons.code),
                  //           autofocus: false,
                  //           activeColor: Colors.green,
                  //           checkColor: Colors.white,
                  //           selected: selection1,
                  //           value: selection1,
                  //           controlAffinity: ListTileControlAffinity.leading,
                  //           visualDensity: const VisualDensity(
                  //               horizontal: -4,
                  //               vertical: -4), // Adjust the values as needed

                  //           onChanged: (value) {
                  //             setState(() {
                  //               selection1 = value!;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //       Row(
                  //         children: [
                  //           Transform.scale(
                  //             scale: 0.8, // Adjust the scale factor as needed
                  //             child: Checkbox(
                  //               checkColor: Colors.white,
                  //               value: selection1,
                  //               onChanged: (bool? value) {
                  //                 setState(() {
                  //                   selection1 = value!;
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //           const Text(
                  //             'I agree to conduct all the lesson in accordance to work4u terms and condition.',
                  //             style: TextStyle(fontSize: 12),
                  //           ),
                  //         ],
                  //       ),
                  //       CheckboxListTile(
                  //         title: const Text(
                  //           'I agree not to share any inappropriate, offensive, abusive, or containing nudity contents to students and tutors.',
                  //           style: TextStyle(fontSize: 12),
                  //         ),
                  //         // subtitle: const Text(
                  //         //     'A computer science portal for geeks.'),
                  //         // secondary: const Icon(Icons.code),
                  //         autofocus: false,
                  //         activeColor: Colors.green,
                  //         checkColor: Colors.white,
                  //         selected: selection2,
                  //         value: selection2,
                  //         controlAffinity: ListTileControlAffinity.leading,
                  //         visualDensity:
                  //             const VisualDensity(horizontal: -4, vertical: -4),
                  //         onChanged: (value) {
                  //           setState(() {
                  //             selection2 = value!;
                  //           });
                  //         },
                  //       ),
                  //       CheckboxListTile(
                  //         title: const Text(
                  //           'I agree that work4ututor wont have any responsibility on this and i will be the sole responsible for the content deliver during the lessons.',
                  //           style: TextStyle(fontSize: 12),
                  //         ),
                  //         // subtitle: const Text(
                  //         //     'A computer science portal for geeks.'),
                  //         // secondary: const Icon(Icons.code),
                  //         autofocus: false,
                  //         activeColor: Colors.green,
                  //         checkColor: Colors.white,
                  //         selected: selection3,
                  //         value: selection3,
                  //         controlAffinity: ListTileControlAffinity.leading,
                  //         visualDensity:
                  //             const VisualDensity(horizontal: -4, vertical: -4),
                  //         onChanged: (value) {
                  //           setState(() {
                  //             selection3 = value!;
                  //           });
                  //         },
                  //       ),
                  //       CheckboxListTile(
                  //         title: const Text(
                  //           'I am aware that work4ututor will seek legal action and report to the appropriate authorities in case breach of this terms and condition.',
                  //           style: TextStyle(fontSize: 12),
                  //         ),
                  //         // subtitle: const Text(
                  //         //     'A computer science portal for geeks.'),
                  //         // secondary: const Icon(Icons.code),
                  //         autofocus: false,
                  //         activeColor: Colors.green,
                  //         checkColor: Colors.white,
                  //         selected: selection4,
                  //         value: selection4,
                  //         controlAffinity: ListTileControlAffinity.leading,
                  //         visualDensity:
                  //             const VisualDensity(horizontal: -4, vertical: -4),
                  //         onChanged: (value) {
                  //           setState(() {
                  //             selection4 = value!;
                  //           });
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         // Add your code for the "Accept" button here
                  //         // For example, you can show a message or perform an action.
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         foregroundColor: Colors.white,
                  //         backgroundColor:
                  //             Theme.of(context).primaryColor, // Text color
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 20, vertical: 15),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //       child: const Text(
                  //         'Accept',
                  //         style: TextStyle(fontSize: 18),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //         height: 20), // Adding some space between buttons
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         // Add your code for the "Decline" button here
                  //         // For example, you can show a message or perform an action.
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         foregroundColor: Colors.white,
                  //         backgroundColor: Theme.of(context)
                  //             .colorScheme
                  //             .secondary, // Text color
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 20, vertical: 15),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //       child: const Text(
                  //         'Decline',
                  //         style: TextStyle(fontSize: 18),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: kColorPrimary, // Text color
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Accept',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: kColorPrimary,
              backgroundColor: Colors.white, // Text color
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Decline',
              style: TextStyle(fontSize: 16, color: kColorPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
