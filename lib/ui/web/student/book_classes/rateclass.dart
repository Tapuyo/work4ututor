// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../data_class/classesdataclass.dart';
import '../../../../services/bookingfunctions/setscheduletime.dart';
import '../../../../utils/themes.dart';

class RateClass extends StatefulWidget {
  final ClassesData? data;
  final DateTime classSchedule;
  const RateClass({
    super.key,
    required this.data,
    required this.classSchedule,
  });

  @override
  State<RateClass> createState() => _RateClassState();
}

class _RateClassState extends State<RateClass> {
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
        children: <Widget>[
          SizedBox(
            width: 220,
            height: 220,
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
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Rate Your Tutor',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: kColorGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
                RatingBar(
                    initialRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                const Spacer(),
                Center(
                  child: TextButton(
                    child: const Text(
                      "Submit Rating",
                      style: TextStyle(
                          color: kColorPrimary,
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      String? result = await addRateClass(
                        widget.data!.classid,
                        widget.classSchedule,
                        ratingValue.toString(),
                      );
                      if (result == 'Success') {
                        adminNotification(
                                'classRating',
                                'Class rating below average, need action!',
                                widget.data!.classid,
                                [widget.data!.studentID, widget.data!.tutorID])
                            .then((value) {
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
