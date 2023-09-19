import 'package:flutter/material.dart';

import '../../../../services/cancelaccount.dart';
import '../../../../utils/themes.dart';

@override
rescheduleclass(BuildContext context) {
  TextEditingController conreason = TextEditingController();
  TextEditingController conemail = TextEditingController();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
        child: Container(
          alignment: Alignment.center,
          width: 700,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 12.0,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Go back',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "You are trying to reschedule a class.",
                        style: TextStyle(
                          // textStyle: Theme.of(context).textTheme.headlineMedium,
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Text(
                        "Rescheduling 4 hours before the set schedule is free of charge. The charge for rescheduling is 5% of the prize per class session.",
                        style: TextStyle(
                          // textStyle: Theme.of(context).textTheme.headlineMedium,
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.info,
                              color: kColorPrimary,
                              size: 50,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 250,
                              child: Text(
                                "Would you like to continue rescheduling?",
                                style: TextStyle(
                                  // textStyle: Theme.of(context).textTheme.headlineMedium,
                                  color: kColorPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: 180,
                              height: 50,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      const TextStyle(color: Colors.black),
                                  backgroundColor:
                                      const Color.fromRGBO(1, 118, 132, 1),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color.fromRGBO(
                                          1, 118, 132, 1), // your color here
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                                onPressed: () async {
                                  if (conreason.text.isNotEmpty &&
                                      conemail.text.isNotEmpty) {
                                    // updateUserStatus(
                                    //     'wPPQMtnnC0g8gSQCIU7NXw9iHqu2',
                                    //     'Cancelled',
                                    //     conreason.text,
                                    //     conemail.text,
                                    //     'student');
                                    Navigator.pop(context);
                                  } else {
                                    null;
                                  }
                                },
                                child: const Text(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  'Yes, please',
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 100,
                              child: TextButton(
                                child: const Text(
                                  "No, thanks",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: kColorPrimary,
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                onPressed: () {
                                  // // if (dateresult != 'Is Overdue') {
                                  // cancellclass(context, dateresult);
                                  // // } else {
                                  // //   html.window.alert(
                                  // //       'You will be charge to cancel');
                                  // // }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    height: 200,
                    width: 270,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/8347.png',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
