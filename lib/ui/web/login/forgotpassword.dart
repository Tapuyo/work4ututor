import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../signup/tutor_information_signup.dart';

  @override
  void passwordResetDialog (BuildContext context) {
   showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
            title: null,
            titlePadding: const EdgeInsets.all(0),
            content: null,
            actions: <Widget>[
              Center(
              child: Column(
                children: [
                   Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.red,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
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
                    Text(
                    "You are trying to update\nyour password!",
                    style: GoogleFonts.roboto(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      color: const Color.fromRGBO(1, 118, 132, 1),
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                      height: 10,
                    ),
                  Text(
                    "An password reset link will be sent to your email,\nopen the link and reset your password!",
                    style: GoogleFonts.roboto(
                      textStyle: Theme.of(context).textTheme.headlineSmall,
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                      height: 10,
                    ),
                  Text(
                    "Input your email here!",
                    style: GoogleFonts.roboto(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      color: const Color.fromRGBO(1, 118, 132, 1),
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                      height: 10,
                    ),
                  SizedBox(
                    width: 400,
                    height: 80,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: const TextStyle(color: Colors.black, fontSize: 25),
                        hintText: 'Email',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        //add reset email here
                      },
                    ),
                  ),
                  
            const SizedBox(
                      height: 10,
                    ),
                    Container(
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
                  'Send Reset Link',
                ),
              ),
            ),
                ],
              ),
            ),
            ],
          ),
    ),
                          );
  }