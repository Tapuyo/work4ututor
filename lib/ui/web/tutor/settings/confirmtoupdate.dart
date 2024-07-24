// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:work4ututor/ui/web/tutor/settings/payments_withdrawals.dart';

import '../../../../utils/themes.dart';

@override
confirmtoUpdate(BuildContext context, String tutorId) {
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
            padding: const EdgeInsets.fromLTRB(
              50.0,
              25.0,
              50.0,
              25.0,
            ),
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
                        "You are trying to add/update your account details.",
                        style: TextStyle(
                          // textStyle: Theme.of(context).textTheme.headlineMedium,
                          color: kColorGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Adding/Updating will hold 1 hour before you can claim your unclaimed payments.(Note: You need to input your email and password for confirmation.)",
                        style: TextStyle(
                          // textStyle: Theme.of(context).textTheme.headlineMedium,
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 300,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.info,
                              color: kColorLight,
                              size: 50,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 250,
                              child: Text(
                                "Would you like to continue adding/updating?",
                                style: TextStyle(
                                  // textStyle: Theme.of(context).textTheme.headlineMedium,
                                  color: kColorLight,
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
                                  backgroundColor: kColorLight,
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
                                  Navigator.pop(context);

                                  await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AddBankDetailsDialog(
                                          tutorId: tutorId,
                                        );
                                      });
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
                                  Navigator.pop(context);
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
                const Center(
                  child: SizedBox(
                    // height: 200,
                    width: 270,
                    // decoration: const BoxDecoration(
                    //   image: DecorationImage(
                    //       image: AssetImage(
                    //         'assets/images/8347.png',
                    //       ),
                    //       fit: BoxFit.cover),
                    // ),
                    child: Icon(
                      Icons.edit_calendar_outlined,
                      size: 250,
                      color: kColorLight,
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
