// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/provider/user_id_provider.dart';
import 'package:wokr4ututor/services/services.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wokr4ututor/ui/web/login/forgotpassword.dart';
import 'package:wokr4ututor/ui/web/terms/termpage.dart';

import '../../../data_class/user_class.dart';
import '../../../shared_components/alphacode3.dart';
import '../../../utils/themes.dart';
import '../tutor/tutor_dashboard/tutor_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final AuthService _auth = AuthService();
final formKey = GlobalKey<FormState>();

String userPassword = '';
String userEmail = '';

String error = '';
bool obscure = true;

class _LoginPageState extends State<LoginPage> {
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
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/Student (12).png"),
        fit: BoxFit.cover,
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const <Widget>[
          CustomAppBar(),
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
                children: [
                  Text(
                    " Welcome Back!",
                    style: GoogleFonts.roboto(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      color: Color.fromRGBO(1, 118, 132, 1),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    " Have a great day ahead.",
                    style: GoogleFonts.roboto(
                      textStyle: Theme.of(context).textTheme.headlineSmall,
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        passwordResetDialog(context);
                      },
                      child: Text(
                        style: GoogleFonts.roboto(
                          color: const Color.fromRGBO(1, 118, 132, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        'Forgot your password?',
                      ),
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
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () async {
                  Users result = await _auth.signinwEmailandPassword(
                      // use this one //userEmail, userPassword);
                      'mjselma@gmail.com', '123456');
                  if (result == null) {
                    setState(() {
                      error = 'Could not sign in w/ those credential';
                      print(error);
                    });
                  } else {
                    setState(() {
                      print(result.uid);
                      final provider = context.read<UserIDProvider>();
                      provider.setUserID(result.uid);
                    });
                  }
                },
                child: Text(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  'Confirm Submission',
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
