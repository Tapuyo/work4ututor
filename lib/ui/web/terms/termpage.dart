import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Container(
          alignment: Alignment.center,
          width: 600,
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Container(
                    width: 600,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Color.fromRGBO(1, 118, 132, 1),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Terms & Condition",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 600,
                          height: 450,
                          child: SfPdfViewer.asset(
                              'assets/images/Terms and Conditions Work4uTutor.pdf'),
                        ),
                        CheckboxListTile(
                          title: const Text(
                            'I agree to conduct all the lesson in accordance to work4u terms and condition.',
                            style: TextStyle(fontSize: 12),
                          ),
                          // subtitle: const Text(
                          //     'A computer science portal for geeks.'),
                          // secondary: const Icon(Icons.code),
                          autofocus: false,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          selected: selection1,
                          value: selection1,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              selection1 = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                            'I agree not to share any inappropriate, offensive, abusive, or containing nudity contents to students and tutors.',
                            style: TextStyle(fontSize: 12),
                          ),
                          // subtitle: const Text(
                          //     'A computer science portal for geeks.'),
                          // secondary: const Icon(Icons.code),
                          autofocus: false,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          selected: selection2,
                          value: selection2,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              selection2 = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                            'I agree that work4ututor wont have any responsibility on this and i will be the sole responsible for the content deliver during the lessons.',
                            style: TextStyle(fontSize: 12),
                          ),
                          // subtitle: const Text(
                          //     'A computer science portal for geeks.'),
                          // secondary: const Icon(Icons.code),
                          autofocus: false,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          selected: selection3,
                          value: selection3,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              selection3 = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                            'I am aware that work4ututor will seek legal action and report to the appropriate authorities in case breach of this terms and condition.',
                            style: TextStyle(fontSize: 12),
                          ),
                          // subtitle: const Text(
                          //     'A computer science portal for geeks.'),
                          // secondary: const Icon(Icons.code),
                          autofocus: false,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          selected: selection4,
                          value: selection4,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              selection4 = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 12.0,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close, color: Colors.black),
                    ),
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
