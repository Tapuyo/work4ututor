import 'package:dotted_border/dotted_border.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/header_text.dart';

import '../../../../utils/themes.dart';

class RejectedInfo extends StatefulWidget {
  final Map<String, dynamic> onDataReceived;

  const RejectedInfo({Key? key, required this.onDataReceived})
      : super(key: key);
  @override
  State<RejectedInfo> createState() => _RejectedInfoState();
}

class _RejectedInfoState extends State<RejectedInfo> {
  DateTime? _fromselectedDate;
  DateTime? _toselectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorPrimary,
        title: const HeaderText('Applicants Rejection Form'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kSpacing,
                ),
                const HeaderText('Please input reason for rejection'),
                const SizedBox(
                  height: 5,
                ),
                DottedBorder(
                  child: SizedBox(
                    width: 400,
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        // controller: _textEditingController,
                        onChanged: (value) {
                          setState(() {
                            // _enteredText = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.grey,
                          hintText: 'Your reason here',
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        maxLines: null, // Allow multiple lines
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    width: 360,
                    height: 75,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.black),
                        backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color:
                                Color.fromRGBO(1, 118, 132, 1), // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        // if (formKey.currentState!.validate()) {
                        //   dynamic result = await _auth.signinwEmailandPassword(
                        //       userEmail, userPassword);
                        //   if (result == null) {
                        //     setState(() {
                        //       error = 'Could not sign in w/ those credential';
                        //       print(error);
                        //     });
                        //   }
                        // }
                      },
                      child: const Text(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        'Save and Send Schedule',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
