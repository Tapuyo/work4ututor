import 'package:flutter/material.dart';

import '../../../../services/cancelaccount.dart';

@override
accountCancelationDialog(BuildContext context) {
  TextEditingController conreason = TextEditingController();
  TextEditingController conemail = TextEditingController();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Container(
          alignment: Alignment.center,
          width: 500,
          height: 600,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                'assets/images/notification.png',
                width: 300.0,
                height: 100.0,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "You are trying to cancel\nyour account!",
                style: TextStyle(
                  // textStyle: Theme.of(context).textTheme.headlineMedium,
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                width: 400,
                child: Text(
                  "Reason for cancelation",
                  style: TextStyle(
                    // textStyle: Theme.of(context).textTheme.headlineMedium,
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                height: 150,
                child: TextField(
                  controller: conreason,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your reason',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 400,
                child: Text(
                  "Input email to verify your account",
                  style: TextStyle(
                    // textStyle: Theme.of(context).textTheme.headlineMedium,
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                height: 60,
                child: TextFormField(
                  controller: conemail,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    // hintStyle:
                    //     const TextStyle(color: Colors.black, fontSize: 25),
                    hintText: 'Email',
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    //add reset email here
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      width: 150,
                      height: 70,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(color: Colors.black),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.red, // your color here
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          'Cancel',
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      width: 240,
                      height: 70,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(color: Colors.black),
                          backgroundColor: const Color.fromRGBO(1, 118, 132, 1),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Color.fromRGBO(
                                  1, 118, 132, 1), // your color here
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () async {
                          if (conreason.text.isNotEmpty &&
                              conemail.text.isNotEmpty) {
                            updateUserStatus(
                                'wPPQMtnnC0g8gSQCIU7NXw9iHqu2',
                                'Cancelled',
                                conreason.text,
                                conemail.text,
                                'student');
                            Navigator.pop(context);
                          } else {
                            null;
                          }
                        },
                        child: const Text(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          'Procceed Cancellation',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
