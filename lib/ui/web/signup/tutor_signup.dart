// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wokr4ututor/components/dialog.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';

class TutorSignup extends StatefulWidget {
  const TutorSignup({Key? key}) : super(key: key);

  @override
  State<TutorSignup> createState() => _TutorSignupState();
}

final AuthService _auth = AuthService();
final formKey = GlobalKey<FormState>();
//textinputs
String tName = '';
String tLastName = '';
String tEmail = '';
String uType = "tutor";
String tPassword = '';
String tConPassword = '';

String error = '';
bool obscure = true;

class _TutorSignupState extends State<TutorSignup> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work4ututor',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CoverScreen(),
    );
  }
}

class CoverScreen extends StatefulWidget {
  const CoverScreen({super.key});

  @override
  State<CoverScreen> createState() => _CoverScreenState();
}

class _CoverScreenState extends State<CoverScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/Teacher (4).png"),
          fit: BoxFit.cover,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const <Widget>[
            CustomAppBar(),
            SignUp(),
            // It will cover 1/3 of free spaces
          ],
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.fromLTRB(200, 30, 200, 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.black45,
          width: .5,
        ),
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                " Make yourself\navailable to students\nall over the world",
                style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  color: Color.fromRGBO(1, 118, 132, 1),
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                children: [
                  SizedBox(
                    width: 380,
                    height: 60,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                        hintText: 'Name',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your Name' : null,
                      onChanged: (val) {
                        tName = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 380,
                    height: 60,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                        hintText: 'Lastname',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your Surname' : null,
                      onChanged: (val) {
                        tLastName = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 380,
                    height: 60,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                        hintText: 'Email',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        tEmail = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 380,
                    height: 60,
                    child: TextFormField(
                      obscureText: obscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                        hintText: 'Password',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(0),
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye_rounded),
                            iconSize: 20,
                          ),
                        ),
                        suffixIconColor: Colors.black,
                      ),
                      validator: (val) =>
                          val!.length < 6 ? 'Enter a 6+ valid password' : null,
                      onChanged: (val) {
                        tPassword = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 380,
                    height: 60,
                    child: TextFormField(
                      obscureText: obscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                        hintText: 'Confirm Password',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(0),
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye_rounded),
                            iconSize: 20,
                          ),
                        ),
                        suffixIconColor: Colors.black,
                      ),
                      validator: (val) => val != tPassword || val!.isEmpty
                          ? 'Password not Match'
                          : null,
                      onChanged: (val) {
                        tConPassword = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              width: 380,
              height: 75,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.black),
                  backgroundColor: Color.fromRGBO(103, 195, 208, 1),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color.fromRGBO(1, 118, 132, 1), // your color here
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    dynamic result = await _auth.registerwEmailandPassword(
                        tEmail, tPassword, "tutor", tName, tLastName);
                    if (result == null) {
                      setState(() {
                        error = 'Please supply a valid email';
                      });
                    } else {
                      setState(() {
                        if (result.toString().contains(
                            "The email address is already in use by another account")) {
                          result =
                              "The email address is already in use by another account!\nPlease check your inputs.";
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => DialogShow(result.toString()),
                          );
                        } else {
                          result =
                              "Account succesfully registered! Click okay to continue.";
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => DialogShow(result.toString()),
                          );
                        }
                      });
                    }
                  }
                },
                child: Text(
                  'Confirm Submission',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text(
                "By signing up, you agree to Work4uTutor\nTerms of Service and Privacy Policy",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Color.fromARGB(255, 59, 59, 59),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
