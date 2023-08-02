// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_null_comparison

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';
import 'package:wokr4ututor/ui/web/login/forgotpassword.dart';
import 'package:wokr4ututor/ui/web/terms/termpage.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_dashboard/tutor_dashboard.dart';

import '../../../data_class/user_class.dart';
import '../../../shared_components/alphacode3.dart';
import '../../../utils/themes.dart';
import '../student/main_dashboard/student_dashboard.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

final AuthService _auth = AuthService();
final formKey = GlobalKey<FormState>();

String userPassword = '';
String userEmail = '';

String error = '';
bool obscure = true;

class _AdminLoginPageState extends State<AdminLoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work4ututor',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          // appBar: null,
          body: Center(
        child: Column(
          children: const <Widget>[
            LogScreen(),
            // It will cover 1/3 of free spaces
          ],
        ),
      )),
    );
  }
}

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          SigniN(),
          // It will cover 1/3 of free spaces
        ],
      ),
    );
  }
}

class SigniN extends StatefulWidget {
  const SigniN({super.key});

  @override
  State<SigniN> createState() => _SigniNState();
}

class _SigniNState extends State<SigniN> {
  bool isLoading = false;

  void _handleButtonPress() {
    setState(() {
      isLoading = true;
    });

    // Simulating an asynchronous operation
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(200, 30, 200, 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                // color: const Color.fromRGBO(1, 118, 132, 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                'assets/images/login.png',
                width: 300.0,
                height: 100.0,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: const [
                  Text(
                    "ADMINISTRATIVE LOGIN",
                    style: TextStyle(
                      // textStyle: Theme.of(context).textTheme.headlineMedium,
                      color: Color.fromRGBO(1, 118, 132, 1),
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Text(
                  //   " Have a great day ahead.",
                  //   style: TextStyle(
                  //     // textStyle: Theme.of(context).textTheme.headlineMedium,
                  //     color: Colors.black87,
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.normal,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
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
                        userEmail = val;
                        final alpha3Code = getAlpha3Code(val);
                        print(alpha3Code);
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
                        suffixIcon: IconButton(
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          icon: Icon(Icons.remove_red_eye_rounded),
                        ),
                        suffixIconColor: Colors.black,
                      ),
                      validator: (val) =>
                          val!.length < 6 ? 'Enter a 6+ valid password' : null,
                      onChanged: (val) {
                        userPassword = val;
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
                  backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromRGBO(1, 118, 132, 1), // your color here
                      width: .2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () async {
                  isLoading ? null : _handleButtonPress;
                  Users? result = await _auth.signinwEmailandPassword(
                      userEmail, userPassword);
                  // 'mjselma@gmail.com',
                  // '123456');
                  if (result == null) {
                    setState(() {
                      error = 'Could not sign in w/ those credential';
                      print(error);
                    });
                  } else {
                    setState(() {
                      print(result.uid);
                      print(result.role);
                      _auth.adduserInfo({
                        "userID": result.uid,
                        "role": result.role,
                        "userStatus": ''
                      });
                    });
                    if (result.role == 'tutor') {
                      setState(() {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DashboardPage(uID: result.uid.toString())),
                        );
                      });

                      StudentDashboardPage(uID: result.uid.toString());
                    } else if (result.role == 'student') {
                      setState(() {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentDashboardPage(
                                  uID: result.uid.toString())),
                        );
                      });
                    }
                  }
                },
                child: isLoading
                    ? CircularProgressIndicator() // Display progress indicator
                    : Text(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        'Continue Log In',
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
      ),
    );
  }
}
