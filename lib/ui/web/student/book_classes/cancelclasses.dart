// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import '../../../../services/bookingfunctions/setscheduletime.dart';
import '../../../../services/notificationfunctions/sendnotifications.dart';
import '../../../../utils/themes.dart';

@override
cancellclass(BuildContext context, String documentId) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => PopScope(
      canPop: true,
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
                            color: kColorGrey,
                          ),
                          label: const Text(
                            'Go back',
                            style: TextStyle(
                              color: kColorGrey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "You are trying to cancel class schedule.",
                        style: TextStyle(
                          // textStyle: Theme.of(context).textTheme.headlineMedium,
                          color: kColorGrey,

                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Text(
                        "Canceling your schedule 4 hours before the set schedule is free of charge. The charge for cancellation is 5% of the prize per class session.",
                        style: TextStyle(
                          // textStyle: Theme.of(context).textTheme.headlineMedium,
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        width: 300,
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: kColorPrimary,
                              size: 50,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 250,
                              child: Text(
                                "Would you like to continue your cancellation?",
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
                        height: 5,
                      ),
                      SizedBox(
                        width: 300,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: 150,
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
                                  String result = await updateStatus(
                                    documentId,
                                    'Cancelled',
                                  );

                                  if (result.toString() == "Success") {
                                    List<String> idList = [
                                      documentId,
                                    ];
                                    addNewNotification(
                                        'Cancelled Schedule', '', idList);
                                    result = "Succesfully cancelled";
                                    // CoolAlert.show(
                                    //         context: context,
                                    //         width: 200,
                                    //         type: CoolAlertType.success,
                                    //         title: 'Success...',
                                    //         text: result,
                                    //         autoCloseDuration:
                                    //             const Duration(seconds: 3))
                                    //     .then(
                                    //   (value) {
                                        Navigator.of(context).pop(true);
                                    //   },
                                    // );
                                  } else if (result
                                      .toString()
                                      .contains('completed')) {
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.warning,
                                      width: 200,
                                      text: result,
                                      backgroundColor: Colors.black,
                                    );
                                  } else if (result
                                      .toString()
                                      .contains('cancelled')) {
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.warning,
                                      width: 200,
                                      text: result,
                                      backgroundColor: Colors.black,
                                    );
                                  } else {
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      width: 200,
                                      text: result,
                                      backgroundColor: Colors.black,
                                    );
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
                              width: 150,
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
                                                                          Navigator.of(context).pop(true);

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
