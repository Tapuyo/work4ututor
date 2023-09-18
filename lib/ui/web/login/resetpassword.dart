// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_null_comparison, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/shared_components/responsive_builder.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';
import 'package:wokr4ututor/ui/web/login/login.dart';
import 'package:wokr4ututor/ui/web/signup/student_signup.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_signup.dart';
import 'package:wokr4ututor/ui/web/terms/termpage.dart';

import '../../../utils/themes.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  State<ResetPage> createState() => _ResetPageState();
}

final AuthService _auth = AuthService();
final formKey = GlobalKey<FormState>();

String userPassword = '';
String userEmail = '';

String error = '';
bool obscure = true;
final scafoldKey = GlobalKey<ScaffoldState>();

class _ResetPageState extends State<ResetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scafoldKey,
        drawer: ResponsiveBuilder.isDesktop(context)
            ? null
            : Drawer(
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 0),
                      width: 240,
                      child: Image.asset(
                        "assets/images/WORK4U_NO_BG.png",
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                      ),
                    ),
                   const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 45,
                      width: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color.fromRGBO(1, 118, 132, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          // ignore: prefer_const_constructors
                          textStyle: TextStyle(
                            color: Colors.black,
                            // fontFamily: 'Avenir',
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StudentSignup()),
                          );
                        },
                        child: const Text('BECOME A STUDENT'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 45,
                      width: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color.fromRGBO(1, 118, 132, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          // ignore: prefer_const_constructors
                          textStyle: TextStyle(
                            color: Colors.black,
                            // fontFamily: 'Avenir',
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TutorSignup()),
                          );
                        },
                        child: const Text('BECOME A TUTOR'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 45,
                      width: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color.fromRGBO(103, 195, 208, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          // ignore: prefer_const_constructors
                          textStyle: TextStyle(
                            color: Colors.black,
                            // fontFamily: 'Avenir',
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text('LOG IN'),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
        // bottomNavigationBar:
        //     (ResponsiveBuilder.isDesktop(context) || kIsWeb) ? null : null,
        
        body: SafeArea(
          child: Center(
            child: Column(
              children: const <Widget>[
                ResetScreen(),
                // It will cover 1/3 of free spaces
              ],
            ),
          ),
        ));
  }
}

class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key});

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
      child: ResponsiveBuilder(
        mobileBuilder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: kSpacing / 2),
                      child: ClipRRect(
                        child: SizedBox(
                          width: 240,
                          child: Image.asset(
                            "assets/images/WORK4U_NO_BG.png",
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: kSpacing / 2),
                      child: IconButton(
                        onPressed: () {
                          if (scafoldKey.currentState != null) {
                            scafoldKey.currentState!.openDrawer();
                          }
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kSpacing / 2),
                ResetView(),
                // It will cover 1/3 of free spaces
              ],
            ),
          );
        },
        tabletBuilder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: kSpacing / 2),
                      child: ClipRRect(
                        child: SizedBox(
                          width: 240,
                          child: Image.asset(
                            "assets/images/WORK4U_NO_BG.png",
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: kSpacing / 2),
                      child: IconButton(
                        onPressed: () {
                          if (scafoldKey.currentState != null) {
                            scafoldKey.currentState!.openDrawer();
                          }
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kSpacing / 2),
                ResetView(),
                // It will cover 1/3 of free spaces
              ],
            ),
          );
        },
        desktopBuilder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const <Widget>[
                CustomAppBar(),
                ResetView(),
                // It will cover 1/3 of free spaces
              ],
            ),
          );
        },
      ),
    );
  }
}

class ResetView extends StatefulWidget {
  const ResetView({super.key});

  @override
  State<ResetView> createState() => _ResetViewState();
}

class _ResetViewState extends State<ResetView> {
  bool isLoading = false;
  final emailcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

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
    return SafeArea(
      child: ResponsiveBuilder(
        mobileBuilder: (BuildContext context, BoxConstraints constraints) {
          return ClipRect(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 400,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                alignment: Alignment.center,
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
                              "Forget Password.",
                              style: TextStyle(
                                // textStyle: Theme.of(context).textTheme.headlineMedium,
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
                                controller: emailcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  hintText: 'Email',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (val) => val!.isEmpty && isEmail(val)
                                    ? 'Enter an email'
                                    : null,
                                onChanged: (val) {
                                  userEmail = val;
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
                            backgroundColor:
                                const Color.fromRGBO(103, 195, 208, 1),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Color.fromRGBO(
                                    1, 118, 132, 1), // your color here
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () async {
                            resetPassword();
                          },
                          child: isLoading
                              ? CircularProgressIndicator() // Display progress indicator
                              : Text(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  'Reset Password',
                                ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Color.fromARGB(255, 59, 59, 59),
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      'By signing up, you agree to Work4uTutor '),
                              TextSpan(
                                  text: 'Terms of Service',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
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
              ),
            ),
          );
        },
        tabletBuilder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: 400,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            alignment: Alignment.center,
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
                          "Forget Password.",
                          style: TextStyle(
                            // textStyle: Theme.of(context).textTheme.headlineMedium,
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
                            controller: emailcontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              hintText: 'Email',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) => val!.isEmpty && isEmail(val)
                                ? 'Enter an email'
                                : null,
                            onChanged: (val) {
                              userEmail = val;
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
                            color: Color.fromRGBO(
                                1, 118, 132, 1), // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        resetPassword();
                      },
                      child: isLoading
                          ? CircularProgressIndicator() // Display progress indicator
                          : Text(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              'Reset Password',
                            ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Color.fromARGB(255, 59, 59, 59),
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'By signing up, you agree to Work4uTutor '),
                          TextSpan(
                              text: 'Terms of Service',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
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
        },
        desktopBuilder: (BuildContext context, BoxConstraints constraints) {
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
                          "Forget Password.",
                          style: TextStyle(
                            // textStyle: Theme.of(context).textTheme.headlineMedium,
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
                            controller: emailcontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              hintText: 'Email',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) => val!.isEmpty && isEmail(val)
                                ? 'Enter an email'
                                : null,
                            onChanged: (val) {
                              userEmail = val;
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
                            color: Color.fromRGBO(
                                1, 118, 132, 1), // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        resetPassword();
                      },
                      child: isLoading
                          ? CircularProgressIndicator() // Display progress indicator
                          : Text(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              'Reset Password',
                            ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Color.fromARGB(255, 59, 59, 59),
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'By signing up, you agree to Work4uTutor '),
                          TextSpan(
                              text: 'Terms of Service',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
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
        },
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  Future resetPassword() async {
    // QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.loading,
    //   text: 'Admin Added Successfully!',
    //   showConfirmBtn: false,
    // );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailcontroller.text.trim());
      print('Password Reset email Sent');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Link sent Successfully!',
        autoCloseDuration: const Duration(seconds: 3),
        showConfirmBtn: false,
      ).then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          ));
      // Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      QuickAlert.show(
        context: context,
        headerBackgroundColor: Colors.redAccent,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.message,
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
    }
  }
}
