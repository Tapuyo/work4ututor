// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/admin/admin_sharedcomponents/header_text.dart';
import '../../../../data_class/classesdataclass.dart';
import '../../../../data_class/subject_class.dart';
import '../../../../services/addrating.dart';
import '../../../../services/bookingfunctions/addnewbooking.dart';
import '../../../../services/bookingfunctions/paymenttransactions.dart';
import '../../../../utils/themes.dart';

class RateTutor extends StatefulWidget {
  final ClassesData? data;
  const RateTutor({
    super.key,
    required this.data,
  });

  @override
  State<RateTutor> createState() => _RateTutorState();
}

class _RateTutorState extends State<RateTutor> {
  final TextEditingController subjectnameController = TextEditingController();

  final TextEditingController numberofclassController = TextEditingController();
  final TextEditingController myMessage = TextEditingController();
  double ratingValue = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Stack(
        children: [
          SizedBox(
            width: 400,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/5836.png',
                    width: 250.0,
                    height: 125.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const HeaderText(
                  'Rate Tutor',
                ),
                const Divider(
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 5,
                ),
                RatingBar(
                    initialRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.only(left: 15),
                    itemSize: 50,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
                        half: const Icon(
                          Icons.star_half,
                          color: Colors.orange,
                        ),
                        empty: const Icon(
                          Icons.star_outline,
                          color: Colors.orange,
                        )),
                    onRatingUpdate: (value) {
                      ratingValue = value;
                    }),
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
                      hintText: 'Add Review',
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
                  height: 8,
                ),
                Center(
                  child: Container(
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
                        bool result = await addTutorRating(
                          widget.data!.classid,
                          ratingValue,
                          myMessage.text,
                          widget.data!.studentinfo.first.userID,
                          widget.data!.studentinfo.first.studentFirstname,
                          widget.data!.tutorinfo.first.userId,
                          widget.data!.tutorinfo.first.firstName,
                        );
                        if (result) {
                          setState(() {
                            CoolAlert.show(
                              context: context,
                              width: 200,
                              type: CoolAlertType.success,
                              title: 'Review Added',
                              text: 'Tutor review successful!',
                              autoCloseDuration: const Duration(seconds: 2),
                            ).then((value) => Navigator.of(context).pop());
                          });
                        } else {
                          CoolAlert.show(
                            context: context,
                            width: 200,
                            type: CoolAlertType.warning,
                            title: 'Oops...',
                            text: 'Error adding review, try again!',
                          );
                        }
                      },
                      child: const Text(
                        'Submit Rating',
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Icon(
                Icons.close,
                color: kColorPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
