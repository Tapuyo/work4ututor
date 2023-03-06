// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_information_signup.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({Key? key}) : super(key: key);

  @override
  State<StudentSignup> createState() => _StudentSignupState();
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

class _StudentSignupState extends State<StudentSignup> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work4ututor',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SignScreen(),
    );
  }
}

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

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
          image: AssetImage("assets/images/Teacher (10).png"),
          fit: BoxFit.cover,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const <Widget>[
            CustomAppBar(),
            StudentSignUp(),
            // It will cover 1/3 of free spaces
          ],
        ),
      ),
    );
  }
}

class StudentSignUp extends StatelessWidget {
  const StudentSignUp({super.key});

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
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
            child: Text(
              " Ready to learn from\nour expert tutor's and enjoy\nfriendly classes.",
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
                    height: 15,
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
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.remove_red_eye_rounded),
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
                    height: 15,
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
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.remove_red_eye_rounded),
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
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
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
