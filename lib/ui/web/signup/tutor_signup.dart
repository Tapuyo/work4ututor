// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_information_signup.dart';

class TutorSignup extends StatefulWidget {
  const TutorSignup({Key? key}) : super(key: key);

  @override
  State<TutorSignup> createState() => _TutorSignupState();
}

final formKey = GlobalKey<FormState>();
//textinputs
String tName = '';
String tLastName = '';
String tEmail = '';
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
      width: 370,
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.fromLTRB(200, 50, 200, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.black45,
          width: .5,
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              " Make yourself\navailable to students\nall over the world",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(25, 10, 20, 10),
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black),
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
                    height: 12,
                  ),
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: 'Surname',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your Surname' : null,
                      onChanged: (val) {
                        tLastName = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black),
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
                    height: 12,
                  ),
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      obscureText: obscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black),
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
                        tName = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      obscureText: obscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black),
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
                      validator: (val) =>
                          val != tPassword ? 'Password not Match' : null,
                      onChanged: (val) {
                        tName = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            width: 320,
            height: 70,
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.black),
                backgroundColor: Color.fromRGBO(103, 195, 208, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              onPressed: () {
                FirebaseFirestore.instance.collection('user').add(
                    {'email': tEmail, 'password': tPassword, 'role': 'Tutor'});
                FirebaseFirestore.instance.collection('tutor').add({
                  'firstName': tEmail,
                  'lastName': tPassword,
                  'userID': 'Tutor'
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TutorInfo()),
                );
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
    );
  }
}
