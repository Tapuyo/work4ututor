// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/ui/web/signup/student_information_signup.dart';

import '../../../utils/themes.dart';
import '../terms/termpage.dart';

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
String uType = "student";
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

class StudentSignUp extends StatefulWidget {
  const StudentSignUp({super.key});

  @override
  State<StudentSignUp> createState() => _StudentSignUpState();
}

class _StudentSignUpState extends State<StudentSignUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.fromLTRB(200, 50, 200, 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
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
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 25),
            child: Text(
              " Ready to learn from\nour expert tutor's and enjoy\nfriendly classes.",
              style: TextStyle(
                      // textStyle: Theme.of(context).textTheme.headlineMedium,
                      color: Color.fromRGBO(1, 118, 132, 1),
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(25, 10, 20, 10),
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
                          hoverColor:Colors.transparent,
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
                  height: 15,
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
                          hoverColor:Colors.transparent,
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
              onPressed: () {
                // addUser(tEmail, tPassword,uType);
                                  // if (formKey.currentState!.validate()) {
                    // dynamic result = await _auth.registerwEmailandPassword(
                    //     tEmail, tPassword, "tutor", tName, tLastName);
                    // if (result == null) {
                    //   setState(() {
                    //     error = 'Please supply a valid email';
                    //   });
                    // } else {
                    //   setState(() {
                    //     if (result.toString().contains(
                    //         "The email address is already in use by another account")) {
                    //       result =
                    //           "The email address is already in use by another account!\nPlease check your inputs.";
                    //       showDialog(
                    //         barrierDismissible: false,
                    //         context: context,
                    //         builder: (_) => DialogShow(result.toString()),
                    //       );
                    //     } else {
                    //       result =
                    //           "Account succesfully registered! Click okay to continue.";
                    //       showDialog(
                    //         barrierDismissible: false,
                    //         context: context,
                    //         builder: (_) => DialogShow(result.toString()),
                    //       );
                    //     }
                    //   });
                    // }
                    
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentInfo()),
                );
                  // }
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
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Color.fromARGB(255, 59, 59, 59),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                  children: <TextSpan>[
                    TextSpan(text: 'By signing up, you agree to Work4uTutor '),
                    TextSpan(
                        text: 'Terms of Service',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: kColorSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => TermPage());
                            });
                          }),
                    TextSpan(text: ' and that you have read our '),
                    TextSpan(
                        text: 'Privacy Policy',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: kColorSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => TermPage());
                            });
                          }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
